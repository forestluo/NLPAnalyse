USE [nldb]
GO

-- 声明临时变量
DECLARE @SqlContent UString;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT DISTINCT(content) AS content
	FROM dbo.WordAttribute WHERE classification IN ('功能词','实词')
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '清理词典词条> ' + @SqlContent;
	
	--  获得当前时间
	SET @SqlDate = GetDate();

	--  更新词典
	UPDATE dbo.Dictionary SET [enable] = 0
		WHERE content like '%' + @SqlContent + '%';

	----  更新词典
	--UPDATE dbo.Dictionary SET [enable] = 0
	--WHERE content IN
	--(
	--	SELECT DISTINCT content FROM dbo.Dictionary WHERE content like @SqlContent + '%'
	--) AND content NOT IN (@SqlContent);
	
	----  更新词典
	--UPDATE dbo.Dictionary SET [enable] = 0
	--WHERE content IN
	--(
	--	SELECT DISTINCT content FROM dbo.Dictionary WHERE content like '%' + @SqlContent
	--) AND content NOT IN (@SqlContent);

	--  打印结果
	PRINT '清理词典词条> 耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
	--  取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
END

-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 
