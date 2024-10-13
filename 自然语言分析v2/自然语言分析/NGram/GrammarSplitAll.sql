USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��3��22��>
-- Description:	<����NGram�ָ�����>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GrammarSplitAll]
(
	-- Add the parameters for the stored procedure here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ����
	SET @SqlContent = TRIM(@SqlContent);
	-- ������
	IF @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	--  ���ó�ʼֵ
	SET @SqlResult = '';
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
			-- ��������
			INSERT INTO @SqlTable
				(length, value, position)
				VALUES (LEN(@SqlValue), @SqlValue, @SqlPosition); BREAK;
		END
		-- ��õ�ǰ�ַ�
		SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, 2);

		-- ��ѯ���
		IF NOT EXISTS
			(SELECT * FROM dbo.Grammar2
			WHERE content = @SqlValue AND invalid = 0)
		BEGIN
			-- ��������
			INSERT INTO @SqlTable
				(length, value, position)
				VALUES (1, LEFT(@SqlValue, 1), @SqlPosition);
		END
		ELSE
		BEGIN
			-- ��鵱ǰλ��
			IF @SqlPosition + 2 > LEN(@SqlContent)
			BEGIN
				-- ��������
				INSERT INTO @SqlTable
					(length, value, position)
					VALUES (LEN(@SqlValue), @SqlValue, @SqlPosition); BREAK;
			END

			-- ��ø����ַ�
			SET @SqlValue =
				SUBSTRING(@SqlContent, @SqlPosition, 3);
			-- �����
			IF NOT EXISTS
				(SELECT * FROM dbo.Grammar2
				WHERE content = RIGHT(@SqlValue, 2) AND invalid = 0)
			BEGIN
				-- ��������
				INSERT INTO @SqlTable
					(length, value, position)
					VALUES (2, LEFT(@SqlValue, 2), @SqlPosition);
				-- �޸�λ��
				SET @SqlPosition = @SqlPosition + 1;
			END
			ELSE
			BEGIN
				-- �ԱȽ��
				IF dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 1) + '|' + RIGHT(@SqlValue, 2))
					>= dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 2) + '|' + RIGHT(@SqlValue, 1))
				BEGIN
					-- ��������
					INSERT INTO @SqlTable
						(length, value, position)
						VALUES (1, LEFT(@SqlValue, 1), @SqlPosition);
				END
				ELSE
				BEGIN
					-- ��������
					INSERT INTO @SqlTable
						(length, value, position)
						VALUES (2, LEFT(@SqlValue, 2), @SqlPosition);
					-- �޸�λ��
					SET @SqlPosition = @SqlPosition + 1;
				END
			END
		END
	END

	-- ƴ������
	SET @SqlResult = 
	(
		(
			SELECT '<var id="' + CONVERT(NVARCHAR(MAX), id) + '"' + 
				' pos="' + CONVERT(NVARCHAR(MAX), position) + '"' +
				' len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</var>'
			FROM @SqlTable FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- �������
	SELECT @SqlPosition = COUNT(*) FROM @SqlTable;
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1" met="G2S" count="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' + @SqlResult + '</result>');
END