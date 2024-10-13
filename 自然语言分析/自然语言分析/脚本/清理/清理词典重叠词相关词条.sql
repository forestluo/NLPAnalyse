USE [nldb]
GO

--  获得当前时间
DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- 声明临时变量
DECLARE @SqlCount1 INT;
DECLARE @SqlContent1 UString;

DECLARE @SqlCount2 INT;
DECLARE @SqlContent2 UString;

-- 声明游标
DECLARE SqlCursor1 CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT content, count 
	FROM
	(
		SELECT DISTINCT content,count FROM dbo.Dictionary
		WHERE enable = 1 AND count > 0 AND length > 1 AND dbo.ContentGetCID(content) <= 0
		AND classification NOT IN ('公司','公司缩写','名人','姓名','姓氏','日文名','新华字典','现代汉语词典','组织结构','成语')
	) AS T;
-- 打开游标
OPEN SqlCursor1;
-- 取第一条记录
FETCH NEXT FROM SqlCursor1 INTO @SqlContent1, @SqlCount1;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '清理词典重叠词相关词条> ' + @SqlContent1;
	
	SET @SqlDate = GetDate();
	-- 声明游标
	DECLARE SqlCursor2 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT content, count
		FROM
		(
			SELECT DISTINCT content, count FROM dbo.Dictionary WHERE count > 0 AND length > LEN(@SqlContent1)
		) AS T
		WHERE content like '%' + @SqlContent1 + '%';
	-- 打开游标
	OPEN SqlCursor2;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor2 INTO @SqlContent2, @SqlCount2;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查结果
		IF (@SqlCount2 * 1.0 / @SqlCount1) > 0.6
		BEGIN
			PRINT '清理词典重叠词相关词条> content(' + @SqlContent1 + '/' + @SqlContent2 + ') ' + 
				'比重(' + CONVERT(NVARCHAR(MAX),@SqlCount1) + ':' + CONVERT(NVARCHAR(MAX),@SqlCount2) + ')超出预期！';
			-- 删除内容
			EXEC dbo.ContentDeleteValue @SqlContent1;
		END
		-- 取第一条记录
		FETCH NEXT FROM SqlCursor2 INTO @SqlContent2, @SqlCount2;
	END
	-- 关闭游标
	CLOSE SqlCursor2;
	-- 释放游标
	DEALLOCATE SqlCursor2; 
	--  打印结果
	PRINT '清理词典重叠词相关词条> 耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));

	--  取下一条记录 
	FETCH NEXT FROM SqlCursor1 INTO @SqlContent1, @SqlCount1;
END

-- 关闭游标
CLOSE SqlCursor1;
-- 释放游标
DEALLOCATE SqlCursor1; 

--  打印结果
PRINT '清理词典重叠词相关词条> 耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
