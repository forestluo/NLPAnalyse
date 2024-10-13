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
-- Create date: <2020年12月11日>
-- Description:	<判断是否为小写字母>
-- =============================================

CREATE OR ALTER FUNCTION IsLowercase
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 检查结果
	IF ASCII(@SqlChar) >= 97 AND
		ASCII(@SqlChar) <= 122 RETURN 1;
	-- 返回结果
	RETURN 0;
END
GO

