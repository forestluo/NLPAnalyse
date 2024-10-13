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
-- Author:		<罗堃>
-- Create date: <2020年12月19日>
-- Description:	<是否为空格类型字符>
-- =============================================

CREATE OR ALTER FUNCTION IsBlankspace
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 检查结果
	IF dbo.IsInvisible(@SqlChar) = 1 RETURN 1;
	-- 返回结果
	RETURN CASE @SqlChar
		WHEN CHAR(32) THEN 1
		WHEN NCHAR(12288) THEN 1
		WHEN NCHAR(57348) THEN 1
		WHEN NCHAR(58841) THEN 1
		WHEN NCHAR(58853) THEN 1
		ELSE 0 END;
END
GO

