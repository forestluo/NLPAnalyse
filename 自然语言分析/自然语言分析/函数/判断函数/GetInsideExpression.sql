USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetInsideExpression]    Script Date: 2020/12/6 10:35:55 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月6日>
-- Description:	<获得所在位置的表达式>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetInsideExpression]
(
	-- Add the parameters for the function here
	@SqlExpressions XML,
	@SqlPosition INT
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlType UString;
	DECLARE @SqlExpression UString;

	-- 检查参数
	IF @SqlExpressions IS NULL
		RETURN NULL;
	-- 返回查询结果
	SELECT TOP 1 @SqlType = nodeType, @SqlExpression = nodeExp
		FROM
		(
			SELECT
				Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
				Nodes.value('(@pos)[1]', 'int') AS nodePos,
				Nodes.value('(@len)[1]', 'int') AS nodeLen,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeExp
				FROM @SqlExpressions.nodes('//result/exp') AS N(Nodes)
		) AS NodesTable
		WHERE @SqlPosition >= nodePos AND @SqlPosition <= nodePos + nodeLen - 1;
	-- 返回数值
	RETURN CONVERT(XML, '<result id="1"><exp type="' + @SqlType + '">' + dbo.XMLEscape(@SqlExpression) + '</exp></result>');
END
GO

