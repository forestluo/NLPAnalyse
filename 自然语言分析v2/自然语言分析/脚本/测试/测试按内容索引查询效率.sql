USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlCount INT = 1000;
WHILE @SqlCount > 0
BEGIN
	SET @SqlCount = @SqlCount - 1;
	IF NOT EXISTS (SELECT TOP 1 * FROM Dictionary WHERE content = '����ú��عɼ�����˧�ٻ��������ι�˾') BREAK;
END

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());
