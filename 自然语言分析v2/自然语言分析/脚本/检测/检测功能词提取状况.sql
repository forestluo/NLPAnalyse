USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

PRINT '��⹦�ܴ���ȡ״��> ��������״̬��';

DECLARE @SqlResult XML;
SET @SqlResult = dbo.ExtractAttributeWords(1, @SqlContent);

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
	Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]','nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

PRINT '��⹦�ܴ���ȡ״��> ����Debug״̬��';

-- ������ʱ����
DECLARE @SqlID INT;
DECLARE @SqlPosition INT;
DECLARE @SqlRule UString;
DECLARE @SqlValue UString;
DECLARE @SqlFindResult XML;
DECLARE @SqlTable UMatchTable;

-- ƴ������
SET @SqlRule =
(
	(
		SELECT content + '|'
			FROM
			(
				SELECT DISTINCT(content) AS content
					FROM dbo.WordAttribute WHERE classification = '���ܴ�'
			) AS T
			ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)')
);
-- �������
SET @SqlRule = '(' + LEFT(@SqlRule, LEN(@SqlRule) - 1) + ')';
-- ��������뵽�µļ�¼����
INSERT INTO @SqlTable
	(expression, value, length , position)
	SELECT '���ܴ�', Match, MatchLength, MatchIndex + 1
		FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);

SELECT * FROM @SqlTable;

-- ����
-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT id, position, value FROM @SqlTable ORDER BY position;
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��ѯ���
	SET @SqlFindResult = dbo.WMMFind(@SqlPosition, 1, @SqlContent);
	-- �����
	IF @SqlFindResult IS NOT NULL
	BEGIN
		-- �����
		IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
		BEGIN
			PRINT CONVERT(NVARCHAR(256), @SqlFindResult);
			-- ��ý��
			SET @SqlPosition = @SqlFindResult.value('(//result/@pos)[1]', 'INT');
			SET @SqlValue = @SqlFindResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
			-- �����
			IF @SqlPosition IS NOT NULL AND @SqlValue IS NOT NULL
			BEGIN
				-- ��������
				UPDATE @SqlTable
				SET position = @SqlPosition, length = LEN(@SqlValue), value = @SqlValue WHERE id = @SqlID;
			END
		END
	END
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor;

SELECT * FROM @SqlTable;

END

/*���SQL�ű�����*/
PRINT '��⹦�ܴ���ȡ״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
