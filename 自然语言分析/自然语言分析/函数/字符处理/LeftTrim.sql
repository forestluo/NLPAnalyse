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
-- Create date: <2020��12��12��>
-- Description:	<����������Ч�ַ�>
-- =============================================

CREATE OR ALTER FUNCTION LeftTrim
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlChar UChar;
	DECLARE @SqlPosition INT;

	-- ������
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 RETURN NULL;

	-- ���ó�ʼֵ
	SET @SqlPosition = 0;
	-- ѭ������
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- �õ��ַ�
		SET @SqlChar =
			SUBSTRING(@SqlContent,
				@SqlPosition + 1, 1);
		-- ����ַ�
		IF dbo.IsPairEnd(@SqlChar) = 0 AND
			dbo.IsBlankspace(@SqlChar) = 0 AND
			dbo.IsMajorSplitter(@SqlChar) = 0 AND
			dbo.IsMinorSplitter(@SqlChar) = 0 BREAK;
		-- ����λ��
		SET @SqlPosition = @SqlPosition + 1;
	END
	-- ���λ��
	IF @SqlPosition > 0
	BEGIN
		-- ��������
		SET @SqlContent = RIGHT(@SqlContent, LEN(@SqlContent) - @SqlPosition);
	END
	-- ���ؽ��
	RETURN @SqlContent;
END
GO

