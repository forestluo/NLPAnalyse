USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ParseContent]    Script Date: 2020/12/6 10:44:30 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月29日>
-- Description:	<依据规则解析内容>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ParseContent]
(
	-- Add the parameters for the function here
	@SqlRule UString,
	@SqlContent UString,
	@SqlAllowPunctuation INT = 0
)
RETURNS XML
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlXML XML;
	-- 将规则转换成XML
	SET @SqlXML = dbo.ConvertRule(@SqlRule);
	-- 依据XML进行解析处理
	RETURN dbo.XMLParseContent(@SqlXML, @SqlContent, @SqlAllowPunctuation);
END
GO

