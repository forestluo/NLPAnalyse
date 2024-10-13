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
-- Create date: <2021��2��7��>
-- Description:	<���ո����ַ��滻�������ַ�>
-- =============================================

CREATE OR ALTER FUNCTION EscapeBlankspace
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- ���ؽ��
	RETURN dbo.ClearBlankspace(@SqlContent, dbo.BlankspaceChar());
END
GO

