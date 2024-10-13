USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
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
-- Author:		<罗堃>
-- Create date: <2020年12月9日>
-- Description:	<获得规则的标识号>
-- =============================================
CREATE OR ALTER FUNCTION ParseRuleGetRID
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlRID INT = -1;
	-- 检查参数
	IF @SqlRule IS NULL RETURN 0;
	-- 执行查询语句
	SELECT TOP 1 @SqlRID = rid
		FROM dbo.ParseRule WHERE [rule] = @SqlRule;
	-- 返回结果
	RETURN @SqlRID;
END
GO

