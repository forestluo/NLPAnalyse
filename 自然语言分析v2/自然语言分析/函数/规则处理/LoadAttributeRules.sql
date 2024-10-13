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
-- Create date: <2021��1��25��>
-- Description:	<�������й��ܴʹ���>
-- =============================================

CREATE OR ALTER FUNCTION LoadAttributeRules 
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlResult UString;
	-- ƴ������
	SET @SqlResult =
	(
		(
			SELECT content + '|'
				FROM
				(
					SELECT DISTINCT(content) AS content
						FROM dbo.WordAttribute WHERE classification = '���ܴ�'
				) AS T
				ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- �滻
	-- SET @SqlResult = REPLACE(@SqlResult, '(', '');
	-- SET @SqlResult = REPLACE(@SqlResult, ')', '');
	SET @SqlResult = LEFT(@SqlResult, LEN(@SqlResult) - 1);
	-- �γ�XML
	SET @SqlResult = '<rule>' + 
		'<regular>' + @SqlResult + '</regular>'
		+ '<attribute>���ܴ�</attribute></rule>';
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
