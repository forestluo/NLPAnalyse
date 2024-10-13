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
-- Description:	<��ȡ�����е���شʻ�>
-- =============================================

CREATE OR ALTER FUNCTION ExtractAttributeWords
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
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlFindResult XML;
	-- ������ʱ����
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractAttributeWords> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

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
		SET @SqlFindResult = dbo.WMMFind(@SqlPosition, @SqlDictionary, @SqlContent);
		-- �����
		IF @SqlFindResult IS NOT NULL
		BEGIN
			-- �����
			IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
			BEGIN
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
