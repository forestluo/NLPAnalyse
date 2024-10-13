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
-- Create date: <2020��12��10��>
-- Description:	<��ù���ķ���>
-- =============================================

CREATE OR ALTER FUNCTION ParseRuleGetClassification
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlClassification UString = NULL;
	-- ������
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) < = 0 RETURN NULL;
	-- ��ѯ
	SELECT @SqlClassification = [classification]
		FROM dbo.ParseRule WHERE [rule] = @SqlRule;
	-- ���ؽ��
	RETURN @SqlClassification;
END
GO

