USE [nldb]
GO

DECLARE @SqlRules XML;
-- �������й��˹���
SET @SqlRules = dbo.LoadFilterRules();

DECLARE @SqlContent UString;
SET @SqlContent = '����ͼ������м����ִ����뱾�����������������Դ�ϵ�����������Ϣ��ǿ�ҵؼ������ҿ��ϣ������ֶ������ĥ�»�Ϊ���鸽��������ÿҹ͵Ϯ���ϵ��޹������ڰѿ����������ˡ����ϻ���Դ��֮�ӣ���������Ϣ������������Ϣ�����޵Ŀ��ء���Դ���м�ɮ�£���ͼͨ�����������飬�������Ǽ��޹���ǿ�ң���ƾʲô�ֶζ���ֹ���ˡ�';

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlCount INT = 10000;
WHILE @SqlCount > 0
BEGIN
	SET @SqlCount = @SqlCount - 1;
	SET @SqlContent = dbo.XMLUnescape(@SqlContent);
	SET @SqlContent = dbo.FilterContent(@SqlContent,NULL);
END

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());
