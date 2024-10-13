USE [nldb]
GO

DECLARE @SqlEID INT;
SET @SqlEID = 4;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

-- ���ع���
DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

-- ��õ���Ĺ���
DECLARE @SqlRule UString;
SET @SqlRule = dbo.GetParseRule(@SqlContent);
-- ���¹���
UPDATE dbo.ExternalContent SET [rule] = @SqlRule WHERE eid = @SqlEID;

PRINT '��ⵥ����״��> ����{' + @SqlRule + '}';
PRINT '��ⵥ����״��> ����{' + @SqlContent + '}';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

PRINT '��ⵥ����״��> ��������״̬��';

-- ��ȡ��������
DECLARE @SqlExpressions XML;
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent); 

-- ֱ�Ӷ�ȡ����
DECLARE @SqlResult XML
SET @SqlResult = dbo.ReadContent(@SqlContent, @SqlExpressions);

-- �Ա����ʾ����
SELECT *
FROM
(
SELECT
	@SqlEID AS nodeID,
	'ԭ��' AS nodeType,
	0 AS nodePos,
	LEN(@SqlContent) AS nodeLen,
	@SqlContent AS nodeValue
UNION
SELECT
	Nodes.value('(@id)[1]','int') AS nodeID,
	Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]', 'nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//result/*') AS N(Nodes)
) AS t ORDER BY nodePos;

-- ������ӵ����ݿ�
EXEC dbo.OuterAddSentence @SqlEID, @SqlContent;

END
ELSE
BEGIN

PRINT '��ⵥ����״��> ����Debug״̬��';

END

/*���SQL�ű�����*/
PRINT '��ⵥ����״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
