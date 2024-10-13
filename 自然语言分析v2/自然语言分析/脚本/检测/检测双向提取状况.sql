USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 550;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

PRINT '���˫����ȡ״��> ��������״̬��';

-- PRINT '��������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ����{' + @SqlContent + '}';

DECLARE @SqlValue UString;
SET @SqlValue = '';

DECLARE @SqlIndex INT;
SET @SqlIndex = CHARINDEX('��', @SqlContent);
-- �����
WHILE @SqlIndex > 0
BEGIN

DECLARE @SqlFMMResult XML;
SET @SqlFMMResult = dbo.FMMFind(@SqlIndex, 1, @SqlContent);

SET @SqlValue = @SqlValue + CONVERT(NVARCHAR(MAX), @SqlFMMResult);

DECLARE @SqlBMMResult XML;
SET @SqlBMMResult = dbo.BMMFind(@SqlIndex, 1, @SqlContent);

SET @SqlValue = @SqlValue + CONVERT(NVARCHAR(MAX), @SqlBMMResult);

SET @SqlIndex = CHARINDEX('��', @SqlContent, @SqlIndex + 1);

END

DECLARE @SqlResult XML;
SET @SqlResult = @SqlValue;

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
	Nodes.value('(@id)[1]', 'int') AS nodeID,
	Nodes.value('(@met)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]','nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

PRINT '��������ȡ״��> ����Debug״̬��';

END

/*���SQL�ű�����*/
PRINT '��������ȡ״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
