USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlCount INT = 1000;
WHILE @SqlCount > 0
BEGIN
	SET @SqlCount = @SqlCount - 1;
	IF NOT EXISTS (SELECT TOP 1 * FROM Dictionary WHERE content = '永城煤电控股集团先帅百货有限责任公司') BREAK;
END

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());
