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
-- Create date: <2021��2��11��>
-- Description:	<��ȡ�����е�����������ʽ>
-- =============================================

CREATE OR ALTER FUNCTION MatchStructs
(	
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlXML XML;
	DECLARE @SqlResult XML;

	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;

	DECLARE @SqlRows UString;
	DECLARE @SqlOriginal UString;
	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0
	BEGIN
		-- PRINT 'MatchStructs> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-1">rule is null</result>');
	END
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'MatchStructs> ��Ч���룡';
		RETURN CONVERT(XML, '<result id="-2">content is null</result>');
	END

	-- ����ԭֵ
	SET @SqlOriginal = @SqlRule;
	-- ������ת����XML
	SET @SqlXML = dbo.ConvertRule(@SqlRule);
	-- �����
	IF @SqlXML IS NULL
		RETURN CONVERT(XML, '<result id="-3">fail to conver rule</result>');

	-- �������
	SET @SqlRule = dbo.ClearParameters(@SqlRule);
	-- �滻����
	SET @SqlRule = REPLACE(@SqlRule, '$', dbo.GetRegularString('parameter'));

	-- ��Ruleת���ɰ��
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- ������ת���ɰ��
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- ��������뵽�µļ�¼����
	INSERT INTO @SqlTable
		(value, length, position)
		SELECT Match, MatchLength, MatchIndex
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);

	-- ���ó�ʼֵ
	SET @SqlRows = '';
	SET @SqlIndex = 0;
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT value, length, position FROM @SqlTable;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlValue, @SqlLength, @SqlPosition;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ����XML���н�������
		SET @SqlResult = dbo.XMLParseContent(@SqlXML, @SqlValue, 0);
		-- �����
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0 GOTO NEXT_ROW;
		-- ��ý�β
		SET @SqlEnd = ISNULL(@SqlResult.value('(//result/@end)[1]', 'int'), 0);
		-- ��ÿ�ͷ
		SET @SqlStart = ISNULL(@SqlResult.value('(//result/@start)[1]', 'int'), 0);

		-- ��������ֵ
		SET @SqlIndex = @SqlIndex + 1;
		-- ƴ�ӽ��
		SET @SqlRows = @SqlRows +
		(
			'<row id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' +
				ISNULL('<matched pos="' + CONVERT(NVARCHAR(MAX), @SqlStart + @SqlPosition) + '" ' +
					'len="' + CONVERT(NVARCHAR(MAX), LEN(@SqlValue)) + '">' + @SqlValue + '</matched>', '') + 
			(
				SELECT '<' + nodeType + ' ' +
					'id="' + CONVERT(NVARCHAR(MAX), nodeID) + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), nodePos) + '" ' +
					'len="' + CONVERT(NVARCHAR(MAX), LEN(nodeValue)) + '" ' + 
					ISNULL('name="' + nodeName + '" ','') + '>' + nodeValue + '</' + nodeType + '>'
					FROM
					(
						SELECT
							Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
							Nodes.value('(@id)[1]', 'int') AS nodeID,
							Nodes.value('(@pos)[1]', 'int') + @SqlPosition AS nodePos,
							Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
							Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
							FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					) AS T FOR XML PATH(''), TYPE
			).value('.', 'nvarchar(max)') + '</row>'
		);
NEXT_ROW:
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlValue, @SqlLength, @SqlPosition;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;

	-- �����
	IF LEN(@SqlRows) <= 0 RETURN CONVERT(XML, '<result id="-4">no results</result>');
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1"><rule>' + @SqlOriginal + '</rule>' + @SqlRows + '</result>');
END
GO
