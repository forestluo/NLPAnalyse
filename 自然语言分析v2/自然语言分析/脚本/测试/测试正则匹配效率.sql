USE [nldb]
GO

DECLARE @SqlRules XML;
-- ���������������
SET @SqlRules = dbo.LoadRegularRules();

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

SELECT TOP 1000 content, dbo.ExtractExpressions(@SqlRules, content) FROM TextPool

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());
