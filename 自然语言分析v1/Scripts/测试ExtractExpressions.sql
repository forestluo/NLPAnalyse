DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = NULL;

SET @SqlContent = ' 2018��9��13�� 9��20�� 9�� 13�� 430064';

BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlMatch INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlType UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractExpression> ��Ч���룡';
		GOTO END_OF_FUNCTION;
	END
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- �����α�
	IF @SqlClassification IS NULL
		OR LEN(@SqlClassification) <= 0
	BEGIN
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT rid, parse_rule, classification FROM dbo.LogicRule
				WHERE LEFT(classification, 2) = '����' ORDER BY controllable_priority DESC;
	END
	ELSE
	BEGIN
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT rid, parse_rule, classification FROM dbo.LogicRule
				WHERE classification = @SqlClassification ORDER BY controllable_priority DESC;
	END
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlType;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ��������
		IF LEFT(@SqlType, 2) = '����'
			SET @SqlType = RIGHT(@SqlType, LEN(@SqlType) - 2);
		-- ��������뵽�µļ�¼����
		INSERT INTO @SqlTable
			(expression, value, length , position)
			SELECT @SqlType, Match, MatchLength, MatchIndex
				FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlType;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;

	-- ������
	IF @SqlClassification IS NULL
		OR LEN(@SqlClassification) <= 0
	BEGIN
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
	END

	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<exp type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position + 1) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	PRINT '<result id="1">' + @SqlResult + '</result>';
END
END_OF_FUNCTION:
GO

