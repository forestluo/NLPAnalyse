USE [nldb]
GO

SET NOCOUNT ON;

-- 声明临时变量
DECLARE @SqlGID INT;
DECLARE @SqlContent UString;

-- 关系系数
DECLARE @SqlAlpha FLOAT;
DECLARE @SqlLAlpha FLOAT;
DECLARE @SqlRAlpha FLOAT;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT gid, content
		FROM dbo.Grammar3 WHERE operations = 1;
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlGID, @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 打印结果
	PRINT '计算3Gram关系系数(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> “' + @SqlContent + '”';	

	-- 计算相关系数
	SET @SqlLAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 2) + '|' + RIGHT(@SqlContent, 1));
	SET @SqlRAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 1) + '|' + RIGHT(@SqlContent, 2));
	SET @SqlAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 1) + '|' + SUBSTRING(@SqlContent, 2, 1) + '|' + RIGHT(@SqlContent, 1));

	-- 更新结果
	IF @SqlLAlpha > @SqlRAlpha
	BEGIN
		-- 更新数据
		UPDATE dbo.Grammar3
			SET operations = 0,
				lcontent = LEFT(@SqlContent, 2),
				rcontent = RIGHT(@SqlContent, 1),
				alpha = @SqlAlpha,
				lalpha = @SqlLAlpha, ralpha = @SqlRAlpha WHERE gid = @SqlGID;
	END
	ELSE
	BEGIN
		-- 更新数据
		UPDATE dbo.Grammar3
			SET operations = 0,
				lcontent = LEFT(@SqlContent, 1),
				rcontent = RIGHT(@SqlContent, 2),
				alpha = @SqlAlpha,
				lalpha = @SqlLAlpha, ralpha = @SqlRAlpha WHERE gid = @SqlGID;
	END
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlGID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

SET NOCOUNT OFF;
