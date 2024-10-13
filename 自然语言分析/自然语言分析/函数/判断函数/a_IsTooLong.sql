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
-- Create date: <2020年12月13日>
-- Description:	<检查句子是否过长>
-- =============================================

CREATE OR ALTER FUNCTION IsTooLong
(
	-- Add the parameters for the function here
	@SqlSentence UString
)
RETURNS INT
AS
BEGIN
	-- 返回结果
	RETURN CASE WHEN LEN(@SqlSentence) > 450 THEN 1 ELSE 0 END;
END
GO

