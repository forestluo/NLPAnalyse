USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 1716761;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlRules XML;
DECLARE @SqlResult XML;
DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

PRINT '��������ȡ״��> ��������״̬��';

SET @SqlResult = dbo.ExtractPhrases(@SqlContent);

-- PRINT '��������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ����{' + @SqlContent + '}';
-- PRINT '��������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ���{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

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
	Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	Nodes.value('(@len)[1]', 'int') AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//result/*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

PRINT '��������ȡ״��> ����Debug״̬��';

SET @SqlRules = dbo.LoadPhraseRules();
SET @SqlResult = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- PRINT '��������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ����{' + @SqlContent + '}';
-- PRINT '��������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ���{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

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
	Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	Nodes.value('(@len)[1]', 'int') AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//result/*') AS N(Nodes)
) AS t ORDER BY nodePos;

END

/*���SQL�ű�����*/
PRINT '��������ȡ״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
