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
-- Description:	<��ȡ�����е�����������ʽ>
-- =============================================

CREATE OR ALTER FUNCTION ExtractExpressions
(	
	-- Add the parameters for the function here
	@SqlRules XML,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlAttribute UString;
	-- ������ʱ����
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlRules IS NULL
	BEGIN
		-- PRINT 'ExtractExpressions> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractExpressions> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-2"/>');
	END
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

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
				FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
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
