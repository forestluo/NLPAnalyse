USE [nldb]
GO

DECLARE @SqlRules XML;
-- 加载所有正则规则
SET @SqlRules = dbo.LoadRegularRules();

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

SELECT TOP 1000 content, dbo.ExtractExpressions(@SqlRules, content) FROM TextPool

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());
