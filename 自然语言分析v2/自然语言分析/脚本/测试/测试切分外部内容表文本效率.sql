USE [nldb2]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

EXEC dbo.[�з��ⲿ���ݱ��ı�] 10;

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());

-- SELECT TOP 1000 * FROM OuterContent WHERE type = 2
-- SELECT TOP 1000 * FROM OuterContent WHERE type < 0