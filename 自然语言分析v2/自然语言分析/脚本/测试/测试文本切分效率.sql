USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlTID INT;
DECLARE @SqlResult XML;
DECLARE @SqlCount INT = 1000;
DECLARE @SqlContent UString = '��ˣ���������ֽ�����һ���Բ׶��ĸ������֡���һ֧���ӵ����й�ְ�����κ��������ػ򹫹���ҵ������ͼ�����߼���ְ�ƺ�ְλ�����ǾͿ��Կ���һ�ַ��򣬸������ַ��򣬲�ȡ�����ж������ǽ������Ĺ�ϵ�������ֱ�Ӳ����ж����ˣ����ǵ�ָ��Ȩ����С�����ǵ����������ࣻ�����ٵ�ֱ�Ӳ����ж����ˣ����ǵ�ָ��Ȩ���������ǵ�����Ҳ�����٣��������ӵײ�����������Ǹ��ˣ��Ǹ������ٵ�ֱ�Ӳ����ж������ط���ʩ�';

-- �����С���
SELECT @SqlTID = MIN(tid) FROM [nldb].dbo.[TextPool];

WHILE @SqlCount > 0
BEGIN
	SET @SqlTID = @SqlTID + 1;
	SET @SqlCount = @SqlCount - 1;
	SELECT TOP 1 @SqlResult = dbo.XMLCutSentence(content) FROM [nldb].dbo.[TextPool] WHERE tid = @SqlTID;
END

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());
