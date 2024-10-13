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
-- Author:		<�ވ�>
-- Create date: <2020��12��12��>
-- Description:	<��û��������������>
-- =============================================

CREATE OR ALTER FUNCTION FormatReduceRules
(
	-- Add the parameters for the function here
	@SqlTable UReduceTable READONLY
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlResult UString;
	-- ���ý��
	SET @SqlResult =
	(
		(
			SELECT '<rule id="' + CONVERT(NVARCHAR(MAX), id) + '"' +
				CASE id%2 WHEN 0 THEN ' sub="1"' ELSE '' END + '>' +
				parse_rule + '</rule>' FROM @SqlTable ORDER BY id FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN @SqlResult;
END
GO

