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
-- Create date: <2020��12��19��>
-- Description:	<�Ƿ�Ϊ���������ַ�>
-- =============================================

CREATE OR ALTER FUNCTION IsChineseChar
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- ���ؽ��
	IF UNICODE(@SqlChar) >= 0x4E00 AND
		UNICODE(@SqlChar) <= 0x9FA5 RETURN 1;
	RETURN 0;
END
GO

