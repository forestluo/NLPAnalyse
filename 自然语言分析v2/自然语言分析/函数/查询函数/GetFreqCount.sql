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
-- Create date: <2021��2��6��>
-- Description:	<������ݵĴ�Ƶ>
-- =============================================

CREATE OR ALTER FUNCTION GetFreqCount
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlCount INT = 0;
	-- ִ�в�ѯ���
	SELECT TOP 1 @SqlCount = [count]
		FROM dbo.Dictionary
		WHERE content = @SqlContent;
	-- ���ؽ��
	RETURN @SqlCount;
END
GO

