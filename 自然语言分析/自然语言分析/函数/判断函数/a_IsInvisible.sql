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
-- Create date: <2021��2��28��>
-- Description:	<�Ƿ�Ϊ���ɼ��ַ�>
-- =============================================

CREATE OR ALTER FUNCTION IsInvisible
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- �����
	IF ASCII(@SqlChar) < 32 OR
		ASCII(@SqlChar) = 0x7F RETURN 1;
	-- ���ؽ��
	RETURN 0;
END
GO

