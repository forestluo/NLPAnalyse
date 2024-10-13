USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 760588;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

DECLARE @SqlResult XML;
SET @SqlResult = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- PRINT '�����������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ����{' + @SqlContent + '}';
-- PRINT '�����������ȡ״��(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> ���{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

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

-- ������ת���ɰ��
SET @SqlContent = dbo.LatinConvert(@SqlContent);

DECLARE @SqlID INT;
DECLARE @SqlRule UString;
DECLARE @SqlAttribute UString;
DECLARE @SqlTable UMatchTable;
-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT
		Nodes.value('(@rid)[1]','int') AS nodeID,
		Nodes.value('(./regular/text())[1]', 'nvarchar(max)') AS nodeRule,
		Nodes.value('(./attribute/text())[1]', 'nvarchar(max)') AS nodeAttribute
		FROM @SqlRules.nodes('//result/rule') AS N(Nodes); 
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��������뵽�µļ�¼����
	INSERT INTO @SqlTable
		(expression, value, length , position)
		SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor;

-- ��ʾ��������
SELECT * FROM @SqlTable;

-- ��ʾ��������
-- SELECT * FROM @SqlTable;

DECLARE @SqlMatch INT;
DECLARE @SqlLength INT;
DECLARE @SqlPosition INT;

-- ���ó�ʼֵ
SET @SqlMatch = 1;
-- ѭ������
WHILE @SqlMatch > 0
BEGIN
	-- ���ó�ʼֵ
	SET @SqlMatch = 0;
	-- �������ͬʱ����ʱ�Ż�����໥�ص�����
	-- �����໥�ص��Ľ������������ȥ�̣�
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT id, length, position	FROM @SqlTable ORDER BY length;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �����
		IF EXISTS
			(SELECT * FROM @SqlTable WHERE
				@SqlID <> id AND
				@SqlPosition >= position AND
				(@SqlPosition + @SqlLength <= position + length))
		BEGIN
			-- ���ñ��λ
			SET @SqlMatch = 1;
			-- ɾ������������������
			DELETE FROM @SqlTable WHERE id = @SqlID;
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;
END

-- ��ʾ��������
SELECT * FROM @SqlTable;

DECLARE @SqlMID INT;
DECLARE @SqlValue UString;

-- ���ó�ʼֵ
SET @SqlMatch = 1;
-- ѭ������
WHILE @SqlMatch > 0
BEGIN
	-- ���ó�ʼֵ
	SET @SqlMatch = 0;
	-- �������ͬʱ����ʱ�Ż�����໥�ص�����
	-- �����໥�ص��Ľ���������ںϴ�磩
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ���ó�ʼֵ
		SET @SqlMID = -1;
		-- ��ѯ��¼
		SELECT TOP 1 @SqlMID = id FROM @SqlTable WHERE
			@SqlID <> id AND
			@SqlPosition < position AND
			(@SqlPosition + @SqlLength > position) AND
			(@SqlPosition + @SqlLength < position + length) ORDER BY position
		-- �����
		IF @SqlMID > 0
		BEGIN
			-- ���ñ��λ
			SET @SqlMatch = 1;
			-- ��������
			UPDATE @SqlTable SET
				position = @SqlPosition,
				length = position - @SqlPosition + length,
				value = LEFT(@SqlValue, position - @SqlPosition) + value,
				expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
				WHERE id = @SqlMID;
			-- ɾ������������������
			DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;
END

-- ��ʾ��������
SELECT * FROM @SqlTable;

END

/*���SQL�ű�����*/
PRINT '�����������ȡ״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
