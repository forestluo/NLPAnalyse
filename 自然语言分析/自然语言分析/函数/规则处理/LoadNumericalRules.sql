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
-- Description:	<���������ʽ�������>
-- =============================================

CREATE OR ALTER FUNCTION LoadNumericalRules
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlResult UString;

	DECLARE @SqlRID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlAttribute UString;

	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<rule rid="' + CONVERT(NVARCHAR(MAX), rid) + '">' +
				ISNULL('<regular>' + dbo.XMLEscape([rule]) + '</regular>','') +
				ISNULL('<attribute>' + dbo.XMLEscape([attribute]) + '</attribute>', '') + '</rule>'
				FROM dbo.PhraseRule
				WHERE [classification] = '����'
				ORDER BY rid DESC FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);

	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule], [attribute]
		FROM dbo.PhraseRule WHERE [classification] IN ('����', '������')
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlAttribute;

	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ʵ���滻
		SET @SqlRule = dbo.RecoverRegularRule(@SqlRule);
		-- ƴ��
		SET @SqlResult = @SqlResult +
			'<rule rid="' + CONVERT(NVARCHAR(MAX), @SqlRID) + '">' +
				ISNULL('<regular>' + dbo.XMLEscape(@SqlRule) + '</regular>','') +
				ISNULL('<attribute>' + dbo.XMLEscape(@SqlAttribute) + '</attribute>', '') + '</rule>'
		-- ȡ��һ����¼ 
		FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlAttribute;
	END

	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor; 

	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

