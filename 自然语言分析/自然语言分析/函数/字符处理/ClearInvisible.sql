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
-- Create date: <2021��2��26��>
-- Description:	<�����ɼ��ַ�>
-- =============================================

CREATE OR ALTER FUNCTION ClearInvisible
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlChar UChar;
	DECLARE @SqlResult UString;

	DECLARE @SqlPosition INT = 0;

	-- ������
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;

	-- ���ó�ʼֵ
	SET @SqlResult = '';
	-- ѭ������
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- ���Ӽ�����
		SET @SqlPosition = @SqlPosition + 1;
		-- ����ַ�
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- �����
		IF dbo.IsInvisible(@SqlChar) = 0 SET @SqlResult = @SqlResult + @SqlChar;
	END
	-- ���ؽ��
	RETURN @SqlResult;
END
GO

