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
-- Create date: <2020年12月23日>
-- Description:	<加载所有结构解析规则>
-- =============================================

CREATE OR ALTER FUNCTION LoadParseRules
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;
	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<rule id="' + CONVERT(NVARCHAR(MAX), rid) + '">' +
				'<parse>' + [rule] + '</parse>' +
				'<abb>' + abbreviation + '</abb>' +
				'<class>' + classification + '</class>' +
				'<count>' + CONVERT(NVARCHAR(MAX), parameter_count) + '</count>' +
				'<remark>' + dbo.XMLEscape(xml_remark) + '</remark></rule>'
				FROM dbo.ParseRule WHERE classification IS NOT NULL
				ORDER BY dbo.GetParseRuleLevel(classification),
				minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC
				FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

