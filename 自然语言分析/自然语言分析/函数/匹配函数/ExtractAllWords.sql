USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��1��31��>
-- Description:	<��ȡ�����е����дʻ�>
-- =============================================

CREATE OR ALTER FUNCTION ExtractAllWords
(	
	-- Add the parameters for the function here
	@SqlDictionary INT,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlFindResult XML;
	-- ������ʱ����
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractPhrases> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- ���ó�ʼֵ
	SET @SqlPosition = 0;
	-- ѭ�������α�
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- �޸�λ��
		SET @SqlPosition = @SqlPosition + 1;
		-- ��ѯ���
		SET @SqlFindResult = dbo.WMMFind(@SqlPosition, @SqlDictionary, @SqlContent);
		-- �����
		IF @SqlFindResult IS NOT NULL
		BEGIN
			-- �����
			IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
			BEGIN
				-- ��ý��
				SET @SqlStart = @SqlFindResult.value('(//result/@pos)[1]', 'INT');
				SET @SqlValue = @SqlFindResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
				-- �����
				IF @SqlPosition IS NOT NULL AND @SqlValue IS NOT NULL
				BEGIN
					-- ��������
					IF NOT EXISTS (SELECT * FROM @SqlTable WHERE position = @SqlStart AND value = @SqlValue)
					INSERT INTO @SqlTable (expression, value, length , position) VALUES ('�ִ�', @SqlValue, LEN(@SqlValue), @SqlStart);
				END
			END
		END
	END

	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<exp id="' + CONVERT(NVARCHAR(MAX),id) + '" type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN dbo.ClearMatchTable(CONVERT(XML, '<result id="1">' + @SqlResult + '</result>'));
END
GO
