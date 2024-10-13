USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月7日>
-- Description:	<将内容用表达式进行分割>
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
	
	-- 声明临时变量
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

	-- 检查参数
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-1">content is null</result>');

	-- 获得返回结果
	SET @SqlXML = dbo.SplitContent(@SqlContent, @SqlExpressions);
	-- 检查结果
	IF @SqlXML IS NULL OR
		ISNULL(@SqlXML.value('(//result/@id)[1]','int'),0) <= 0
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-2">fail to split content</result>');

	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlResult = '';
	-- 声明游标
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
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlAttribute, @SqlPos, @SqlValue;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查结果
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- 检查类型
			IF @SqlType = 'rule'
			BEGIN
				-- 增加Rule节点
				SET @SqlResult = @SqlResult + '<rule>' + dbo.XMLEscape(@SqlValue) + '</rule>';
			END
			ELSE IF @SqlType = 'pad'
			BEGIN
				-- 修改计数器
				SET @SqlIndex = @SqlIndex + 1;
				-- 增加Pad节点
				SET @SqlResult = @SqlResult +
					'<pad id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos) + '">' + dbo.XMLEscape(@SqlValue) + '</pad>';
			END
			ELSE IF @SqlType = 'exp'
			BEGIN
				-- 修改计数器
				SET @SqlIndex = @SqlIndex + 1;
				-- 增加Exp节点
				SET @SqlResult = @SqlResult +
					'<exp id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '" ' +
					'type="' + @SqlAttribute + '" ' +
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPos) + '">' + dbo.XMLEscape(@SqlValue) + '</exp>';
			END
			ELSE IF @SqlType = 'var'
			BEGIN
				-- 清理切分结果
				SET @SqlSplits = NULL;
				-- 检查终结符
				IF dbo.IsTerminator(@SqlValue) <= 0
					-- 获得切分结果
					SET @SqlSplits = dbo.FMMSplitAll(@SqlDictionary, @SqlValue);
				-- 检查结果
				IF @SqlSplits IS NULL OR
					ISNULL(@SqlSplits.value('(//result/@id)[1]', 'int'),0) <= 0
				BEGIN
					-- 修改计数器
					SET @SqlIndex = @SqlIndex + 1;
					-- 获得内容标识
					SET @SqlCID = dbo.ContentGetCID(@SqlValue);
					IF @SqlCID < 0 SET @SqlCID = 0;
					-- 获得词频
					SET @SqlFreq = dbo.GetFreqCount(@SqlValue);
					-- 获得分类
					SET @SqlClassification = dbo.ContentGetClassification(@SqlValue);
					-- 增加Var节点
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
					-- 增加Var节点
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
					-- 修改索引数值
					SET @SqlIndex = @SqlIndex + @SqlSplits.value('count(//result/*)', 'int');
				END
			END
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlAttribute, @SqlPos, @SqlValue;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1" met="FMM" ' +
		'length="' + CONVERT(NVARCHAR(MAX), LEN(@SqlContent)) + '" ' +
		'count="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' + @SqlResult + '</result>');
END
GO