USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsInsideExpression]    Script Date: 2020/12/6 10:35:55 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<位置是否在一个表达式中>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsInsideExpression]
(
	-- Add the parameters for the function here
	@SqlExpressions XML,
	@SqlPosition INT
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlExpression UString;

	-- 检查参数
	IF @SqlExpressions IS NULL
		RETURN NULL;
	-- 返回查询结果
	SELECT TOP 1 @SqlExpression = nodeExp
		FROM
		(
			SELECT
				Nodes.value('(@pos)[1]', 'int') AS nodePos,
				Nodes.value('(@len)[1]', 'int') AS nodeLen,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeExp
				FROM @SqlExpressions.nodes('//result/exp') AS N(Nodes)
		) AS NodesTable
		WHERE @SqlPosition >= nodePos AND @SqlPosition <= nodePos + nodeLen - 1;
	-- 返回数值
	RETURN @SqlExpression;
END
GO

