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
-- Description:	<�Ƿ�Ϊ���������ַ���>
-- =============================================

CREATE OR ALTER FUNCTION IsChineseString
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlPosition INT = 0;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN 0;
	-- ѭ������
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- �޸ļ�����
		SET @SqlPosition = @SqlPosition + 1;
		-- �����
		IF dbo.IsChineseChar(SUBSTRING(@SqlContent, @SqlPosition, 1)) = 0 RETURN 0;
	END
	-- ���ؽ��
	RETURN 1;
END
GO

