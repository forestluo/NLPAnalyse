USE [nldb2]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

EXEC dbo.[切分外部内容表文本] 10;

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());

-- SELECT TOP 1000 * FROM OuterContent WHERE type = 2
-- SELECT TOP 1000 * FROM OuterContent WHERE type < 0