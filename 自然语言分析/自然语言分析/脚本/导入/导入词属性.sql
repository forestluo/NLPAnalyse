USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlRID INT;
DECLARE @SqlContent UString;
DECLARE @SqlAttribute UString;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT rid, [rule], attribute
	FROM dbo.LogicRule WHERE classification = '功能词';
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlContent, @SqlAttribute;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 处理内容
	SET @SqlContent =
		LEFT(@SqlContent, LEN(@SqlContent) - 1);
	SET @SqlContent =
		RIGHT(@SqlContent, LEN(@SqlContent) - 1);
	-- 检查结果
	IF CHARINDEX(@SqlAttribute, '|') > 0
	BEGIN
		-- 插入一条记录
		INSERT INTO dbo.WordAttribute
			(classification, length, content, attribute)
			VALUES ('功能词', LEN(@SqlContent), @SqlContent, @SqlAttribute);
	END
	ELSE
	BEGIN
		-- 插入多条记录
		INSERT INTO dbo.WordAttribute
			(classification, length, content, attribute)
			SELECT '功能词', LEN(@SqlContent), @SqlContent, * FROM dbo.RegExSplit('\|', @SqlAttribute, 1);
	END
	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlContent, @SqlAttribute;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());
