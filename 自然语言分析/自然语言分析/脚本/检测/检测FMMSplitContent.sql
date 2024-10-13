USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
-- SET @@SqlEID = 2746456;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE tid = @SqlEID;

SET @SqlContent = '�ְ�&ȭ�ʿ�Ƭ��ս';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

-- װ���������ֹ���
DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

-- �����
IF @SqlRules IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '���FMMSplitContent> �޷��������ֹ���'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlExpressions XML;	
-- ������ֽ������
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- �����
IF @SqlExpressions IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '���FMMSplitContent> �޷��������ֽ��������'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '���FMMSplitContent> ��������״̬��';

-------------------------------------------------------------------------------
--
-- ����ȫ������
--
-------------------------------------------------------------------------------

SELECT dbo.FMMSplitContent(1, @SqlContent, @SqlExpressions);

END
ELSE
BEGIN

PRINT '���FMMSplitContent> ����Debug״̬��';

END

END_OF_EXECUTION:
/*���SQL�ű�����*/
PRINT '���FMMSplitContent> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));