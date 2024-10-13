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

CREATE OR ALTER FUNCTION MatchExpressions
(	
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'MatchExpressions> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0
	BEGIN
		-- PRINT 'MatchExpressions> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-2"/>');
	END

	-- ��Ruleת���ɰ��
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- ��������뵽�µļ�¼����
	INSERT INTO @SqlTable
		(value, length , position)
		SELECT Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);

	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<exp pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'id="' + CONVERT(NVARCHAR(MAX), id) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
