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
-- Create date: <2020��12��23��>
-- Description:	<�������е���ṹ��������>
-- =============================================

CREATE OR ALTER FUNCTION LoadSentenceRules
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlResult UString;
	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<rule id="' + CONVERT(NVARCHAR(MAX), rid) + '">' +
				'<parse>' + [rule] + '</parse>' +
				'<abb>' + abbreviation + '</abb>' +
				'<count>' + CONVERT(NVARCHAR(MAX), parameter_count) + '</count>' +
				'<remark>' + dbo.XMLEscape(xml_remark) + '</remark></rule>'
				FROM dbo.ParseRule WHERE classification = '����'
				ORDER BY minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC
				FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

