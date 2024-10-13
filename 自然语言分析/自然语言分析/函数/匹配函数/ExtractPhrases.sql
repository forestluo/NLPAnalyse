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
-- Create date: <2020��12��16��>
-- Description:	<��ȡ�����е����ж���>
-- =============================================

CREATE OR ALTER FUNCTION ExtractPhrases
(	
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlClassification UString;
	DECLARE @SqlAttribute UString;
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

	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule], [attribute], [classification]
			FROM dbo.PhraseRule
			WHERE classification IN ('����', '����', '������', '����', '����');
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute, @SqlClassification;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ʵ���滻
		SET @SqlRule = dbo.RecoverRegularRule(@SqlRule);
		-- ʵ��XMLת��
		SET @SqlRule = dbo.XMLUnescape(@SqlRule);
		-- ��Ruleת���ɰ��
		SET @SqlRule = dbo.LatinConvert(@SqlRule);
		-- ��������뵽�µļ�¼����
		INSERT INTO @SqlTable
			(expression, value, length , position)
			SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
				FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute, @SqlClassification;
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
