USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��2��7��>
-- Description:	<�������ñ��ʽ���зָ�>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[FMMSplitContent]
(
	-- Add the parameters for the function here
	@SqlDictionary INT,
	@SqlContent UString,
	@SqlExpressions XML
)
RETURNS XML
AS
BEGIN
	
	-- ������ʱ����
	DECLARE @SqlXML XML;
	DECLARE @SqlIndex INT;
	DECLARE @SqlSplits XML;
	DECLARE @SqlResult UString;

	DECLARE @SqlID INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlPos INT;
	DECLARE @SqlFreq INT;
	DECLARE @SqlType UString;
	DECLARE @SqlName UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlAttribute UString;
	DECLARE @SqlClassification UString;

	-- ������
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		-- ���ؽ��
		RETURN CONVERT(XML, '<result id="-1">content is null</result>');

	-- ��÷��ؽ��
	SET @SqlXML = dbo.SplitContent(@SqlContent, @SqlExpressions);
	-- �����
	IF @SqlXML IS NULL OR
		ISNULL(@SqlXML.value('(//result/@id)[1]','int'),0) <= 0
		-- ���ؽ��
		RETURN CONVERT(XML, '<result id="-2">fail to split content</result>');

	-- ���ó�ʼֵ
	SET @SqlIndex = 0;
	SET @SqlResult = '';
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT
			ISNULL(Nodes.value('(@id)[1]','int'), 0) AS nodeID,
			Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
			Nodes.value('(@name)', 'nvarchar(max)') AS nodeName,
			Nodes.value('(@type)', 'nvarchar(max)') AS nodeAttribute,
			Nodes.value('(@pos)', 'int') AS nodePos,
			Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
			FROM @SqlXML.nodes('//result/*') AS N(Nodes) ORDER BY nodeID; 
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlAttribute, @SqlPos, @SqlValue;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �����
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- �������
			IF @SqlType = 'rule'
			BEGIN
				-- ����Rule�ڵ�
				SET @SqlResult = @SqlResult + '<rule>' + dbo.XMLEscape(@SqlValue) + '</rule>';
			END
			ELSE IF @SqlType = 'pad'
			BEGIN
				-- �޸ļ�����
				SET @SqlIndex = @SqlIndex + 1;
				-- ����Pad�ڵ�
				SET @SqlResult = @SqlResult +
					'<pad id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos) + '">' + dbo.XMLEscape(@SqlValue) + '</pad>';
			END
			ELSE IF @SqlType = 'exp'
			BEGIN
				-- �޸ļ�����
				SET @SqlIndex = @SqlIndex + 1;
				-- ����Exp�ڵ�
				SET @SqlResult = @SqlResult +
					'<exp id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '" ' +
					'type="' + @SqlAttribute + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos) + '">' + dbo.XMLEscape(@SqlValue) + '</exp>';
			END
			ELSE IF @SqlType = 'var'
			BEGIN
				-- �����зֽ��
				SET @SqlSplits = NULL;
				-- ����ս��
				IF dbo.IsTerminator(@SqlValue) <= 0
					-- ����зֽ��
					SET @SqlSplits = dbo.FMMSplitAll(@SqlDictionary, @SqlValue);
				-- �����
				IF @SqlSplits IS NULL OR
					ISNULL(@SqlSplits.value('(//result/@id)[1]', 'int'),0) <= 0
				BEGIN
					-- �޸ļ�����
					SET @SqlIndex = @SqlIndex + 1;
					-- ������ݱ�ʶ
					SET @SqlCID = dbo.ContentGetCID(@SqlValue);
					IF @SqlCID < 0 SET @SqlCID = 0;
					-- ��ô�Ƶ
					SET @SqlFreq = dbo.GetFreqCount(@SqlValue);
					-- ��÷���
					SET @SqlClassification = dbo.ContentGetClassification(@SqlValue);
					-- ����Var�ڵ�
					SET @SqlResult = @SqlResult +
						'<var id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '" ' +
						ISNULL('type="' + @SqlClassification + '" ', '') + 
						'term="' + CONVERT(NVARCHAR(MAX),
							CASE WHEN dbo.IsTerminator(@SqlValue) > 0 THEN 1 ELSE 0 END) + '" ' +
						'cid="' + CONVERT(NVARCHAR(MAX), @SqlCID) + '" ' +
						'freq="' + CONVERT(NVARCHAR(MAX), @SqlFreq) + '" ' +
						'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos) + '">' + dbo.XMLEscape(@SqlValue) + '</var>';
				END
				ELSE
				BEGIN
					-- ����Var�ڵ�
					SET @SqlResult = @SqlResult +
					(
						(
							SELECT '<var id="' + CONVERT(NVARCHAR(MAX), @SqlIndex + nodeID) + '" ' +
								'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos + nodePos - 1) + '" ' +
								'cid="' + CONVERT(NVARCHAR(MAX), nodeCid) + '" ' +
								'term="' + CONVERT(NVARCHAR(MAX), nodeTerm) + '" ' +
								'freq="' + CONVERT(NVARCHAR(MAX), nodeFreq) + '">' + dbo.XMLEscape(nodeValue) + '</var>'
							FROM
							(
								SELECT
									Nodes.value('(@id)[1]', 'int') AS nodeID,
									Nodes.value('(@pos)[1]', 'int') AS nodePos,
									Nodes.value('(@cid)[1]', 'int') AS nodeCid,
									Nodes.value('(@term)[1]', 'int') AS nodeTerm,
									Nodes.value('(@freq)[1]', 'int') AS nodeFreq,
									Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
									FROM @SqlSplits.nodes('//result/*') AS N(Nodes)
							) AS NodesTable WHERE nodeID IS NOT NULL ORDER BY nodeID FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)')						
					);
					-- �޸�������ֵ
					SET @SqlIndex = @SqlIndex + @SqlSplits.value('count(//result/*)', 'int');
				END
			END
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlAttribute, @SqlPos, @SqlValue;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1" met="FMM" ' +
		'length="' + CONVERT(NVARCHAR(MAX), LEN(@SqlContent)) + '" ' +
		'count="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' + @SqlResult + '</result>');
END
GO