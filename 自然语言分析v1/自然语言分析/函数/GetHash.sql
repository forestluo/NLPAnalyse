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
-- Create date: <2020年12月9日>
-- Description:	<返回>
-- =============================================
CREATE OR ALTER FUNCTION GetHash
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UHashBinary
AS
BEGIN
	-- 返回结果
	RETURN HASHBYTES('SHA2_256', @SqlValue);
END
GO

