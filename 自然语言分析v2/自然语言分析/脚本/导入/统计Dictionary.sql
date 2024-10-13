USE [nldb]
GO

SET NOCOUNT ON;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlDID INT;
DECLARE @SqlContent UString;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content FROM dbo.Dictionary WHERE operations = 0
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SqlDate = GetDate();
	-- 打印结果
	PRINT '统计Dictionary(did=' + CONVERT(NVARCHAR(MAX),@SqlDID) + ')> “' + @SqlContent + '”';
	-- 检查内容
	IF dbo.IsChineseString(@SqlContent) = 1
	BEGIN
		---- 检查长度
		--IF LEN(@SqlContent) >= 1
		--BEGIN
		--	-- 进行统计
		--	EXEC dbo.GrammarStatistics 1, @SqlContent;
		--END
		---- 检查长度
		--IF LEN(@SqlContent) >= 2
		--BEGIN
		--	-- 进行统计
		--	EXEC dbo.GrammarStatistics 2, @SqlContent;
		--END
		-- 检查长度
		IF LEN(@SqlContent) >= 3
		BEGIN
			-- 进行统计
			EXEC dbo.GrammarStatistics 3, @SqlContent;
		END
		---- 检查长度
		--IF LEN(@SqlContent) >= 4
		--BEGIN
		--	-- 进行统计
		--	EXEC dbo.GrammarStatistics 4, @SqlContent;
		--END
	END
	-- 打印结果
	PRINT '统计Dictionary(did=' + CONVERT(NVARCHAR(MAX),@SqlDID) + ')> 耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒';
	-- 更新记录
	UPDATE dbo.Dictionary
	SET operations = 1 WHERE did = @SqlDID;
	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

SET NOCOUNT OFF;