USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

--SET @SqlContent = '��������������';

-- ������ʱ����
DECLARE @SqlPosition INT;
DECLARE @SqlValue UString;

-- ��ӡ���
PRINT '���Ի���NGram���з�> ��' + @SqlContent + '��';

-- ���ó�ʼֵ
SET @SqlPosition = 0;
-- ѭ������
WHILE @SqlPosition < LEN(@SqlContent)
BEGIN
	-- �޸�λ��
	SET @SqlPosition = @SqlPosition + 1;
	-- ��鵱ǰλ��
	IF @SqlPosition + 1 > LEN(@SqlContent)
	BEGIN
		-- ��ý��
		SET @SqlValue =
			SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- ��ӡ���
		PRINT '> ' + NCHAR(9) + @SqlValue; BREAK;
	END
	-- ��õ�ǰ�ַ�
	SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, 2);

	-- ��ѯ���
	IF NOT EXISTS
		(SELECT * FROM dbo.Grammar2
		WHERE content = @SqlValue AND invalid = 0)
	BEGIN
		-- ��ӡ���
		PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 1);
	END
	ELSE
	BEGIN
		-- ��鵱ǰλ��
		IF @SqlPosition + 2 > LEN(@SqlContent)
		BEGIN
			-- ��ӡ���
			PRINT '> ' + NCHAR(9) + @SqlValue; BREAK;
		END

		-- ��ø����ַ�
		SET @SqlValue =
			SUBSTRING(@SqlContent, @SqlPosition, 3);
		-- �����
		IF NOT EXISTS
			(SELECT * FROM dbo.Grammar2
			WHERE content = RIGHT(@SqlValue, 2) AND invalid = 0)
		BEGIN
			-- �޸�λ��
			SET @SqlPosition = @SqlPosition + 1;
			-- ��ӡ���
			PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 2);
		END
		ELSE
		BEGIN
			-- �ԱȽ��
			IF dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 1) + '|' + RIGHT(@SqlValue, 2))
				>= dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 2) + '|' + RIGHT(@SqlValue, 1))
			BEGIN
				-- ��ӡ���
				PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 1);
			END
			ELSE
			BEGIN
				-- �޸�λ��
				SET @SqlPosition = @SqlPosition + 1;
				-- ��ӡ���
				PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 2);
			END
		END
	END
END
