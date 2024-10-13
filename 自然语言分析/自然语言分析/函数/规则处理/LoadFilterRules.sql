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
-- Description:	<�������й��˹���>
-- =============================================

CREATE OR ALTER FUNCTION LoadFilterRules 
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
				'<filter>' + [rule] + '</filter>' + 
				'<replace>' + [replace] + '</replace></rule>'
				FROM dbo.FilterRule
				WHERE [classification] = '�ַ��滻'
				ORDER BY rid FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

