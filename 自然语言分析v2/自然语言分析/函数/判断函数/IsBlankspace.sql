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
-- Description:	<�Ƿ�Ϊ�ո������ַ�>
-- =============================================

CREATE OR ALTER FUNCTION IsBlankspace
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- �����
	IF dbo.IsInvisible(@SqlChar) = 1 RETURN 1;
	-- ���ؽ��
	RETURN CASE @SqlChar
		WHEN CHAR(32) THEN 1
		WHEN NCHAR(12288) THEN 1
		WHEN NCHAR(57348) THEN 1
		WHEN NCHAR(58841) THEN 1
		WHEN NCHAR(58853) THEN 1
		ELSE 0 END;
END
GO

