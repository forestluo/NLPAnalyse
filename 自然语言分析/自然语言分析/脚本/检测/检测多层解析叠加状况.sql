USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

SET @SqlContent = 'ŷ�߷���̳';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

IF @SqlDebug = 0
BEGIN

PRINT '������������״��> ��������״̬��';

DECLARE @SqlResult XML;
DECLARE @SqlTable UMatchTable;

-------------------------------------------------------------------------------
--
-- �����������������
--
-------------------------------------------------------------------------------

DECLARE @SqlID INT;
DECLARE @SqlRule UString;
DECLARE @SqlValue UString;
DECLARE @SqlAttribute UString;

DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

SET @SqlValue = dbo.LatinConvert(@SqlContent);

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
	-- ʵ��XMLת��
	SET @SqlRule = dbo.XMLUnescape(@SqlRule);
	-- ��Ruleת���ɰ��
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- ��������뵽�µļ�¼����
	INSERT INTO @SqlTable
		(expression, value, length , position)
		SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(@SqlRule, @SqlValue, 1);
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor;

-------------------------------------------------------------------------------
--
-- ��������з֣���ȫ�ظ��Ľ�����һ�
--
-------------------------------------------------------------------------------

-- ��������з�
SET @SqlResult = dbo.FMMSplitAll(1, @SqlContent);
-- ���뵽��ʱ����
INSERT INTO @SqlTable
	(expression, position, value, length)
	SELECT
		'FMM',
		ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
		Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
		ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
		FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

-------------------------------------------------------------------------------
--
-- ��������з֣���ȫ�ظ��Ľ�����һ�
--
-------------------------------------------------------------------------------

-- ��������з�
SET @SqlResult = dbo.BMMSplitAll(1, @SqlContent);
-- ���뵽��ʱ����
INSERT INTO @SqlTable
	(expression, position, value, length)
	SELECT
		'BMM',
		ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
		Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
		ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
		FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

-------------------------------------------------------------------------------
--
-- ���ؽṹ����
--
-------------------------------------------------------------------------------

DECLARE @SqlXML XML;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT rid, [rule]
		FROM dbo.ParseRule
		WHERE classification IN ('�ṹ');
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��ý������
	SET @SqlXML = dbo.MatchStructs(@SqlRule, @SqlContent);
	-- �����
	IF @SqlXML IS NOT NULL AND
		ISNULL(@SqlXML.value('(//result/@id)[1]', 'int'), 0) > 0
	BEGIN
		-- ��������
		INSERT INTO @SqlTable
			(expression, value, length, position)
			SELECT '�ṹ', nodeValue, nodeLen, nodePos FROM
			(
				SELECT
					Nodes.value('(@pos)[1]', 'int') AS nodePos,
					Nodes.value('(@len)[1]', 'int') AS nodeLen,
					Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
					FROM @SqlXML.nodes('//result/row/matched') AS N(Nodes)
			) AS NodesTable;
	END
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor;

-------------------------------------------------------------------------------
--
-- ȥ���ظ�����ȫ�ظ��Ľ�����һ�
--
-------------------------------------------------------------------------------

DECLARE @SqlMatch INT;
DECLARE @SqlLength INT;
DECLARE @SqlPosition INT;

---- ���ó�ʼֵ
--SET @SqlMatch = 1;
---- ѭ������
--WHILE @SqlMatch > 0
--BEGIN
--	-- ���ó�ʼֵ
--	SET @SqlMatch = 0;
--	-- �������ͬʱ����ʱ�Ż�����໥�ص�����
--	-- �����໥�ص��Ľ������������ȥ�̣�
--	-- �����α�
--	DECLARE SqlCursor CURSOR
--		STATIC FORWARD_ONLY LOCAL FOR
--		SELECT id, length, position	FROM @SqlTable ORDER BY length;
--	-- ���α�
--	OPEN SqlCursor;
--	-- ȡ��һ����¼
--	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
--	-- ѭ�������α�
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		-- �����
--		IF EXISTS
--			(SELECT * FROM @SqlTable WHERE
--				@SqlID <> id AND
--				@SqlPosition = position AND
--				(@SqlPosition + @SqlLength = position + length))
--		BEGIN
--			-- ���ñ��λ
--			SET @SqlMatch = 1;
--			-- ɾ������������������
--			DELETE FROM @SqlTable WHERE id = @SqlID;
--			-- ���´�ǰ������������
--			UPDATE @SqlTable
--				SET expression = 'F&B'
--				WHERE
--				@SqlID <> id AND
--				@SqlPosition = position AND
--				(@SqlPosition + @SqlLength = position + length);
--		END
--		-- ȡ��һ����¼
--		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
--	END
--	-- �ر��α�
--	CLOSE SqlCursor;
--	-- �ͷ��α�
--	DEALLOCATE SqlCursor;
--END

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

SELECT *,dbo.GetFreqCount(value) AS freq FROM @SqlTable ORDER BY position;

-------------------------------------------------------------------------------
--
-- �ϲ��໥�ص�����Ŀ
--
-------------------------------------------------------------------------------

DECLARE @SqlMID INT;

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
				-- expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
				expression = @SqlAttribute + '+' + expression
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

-------------------------------------------------------------------------------
--
-- �鿴���
--
-------------------------------------------------------------------------------

SELECT *
FROM
(
SELECT
	@SqlEID AS id,
	'ԭ��' AS expression,
	0 AS position,
	LEN(@SqlContent) AS length,
	@SqlContent AS value,
	0 AS freq
UNION
SELECT id,expression,position,length,value,dbo.GetFreqCount(value) FROM @SqlTable
) AS T
ORDER BY position, expression;

END
ELSE
BEGIN

PRINT '������������״��> ����Debug״̬��';

END

/*���SQL�ű�����*/
PRINT '������������״��> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
