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
-- Description:	<����ո������ַ�>
-- =============================================

CREATE OR ALTER FUNCTION ClearBlankspace
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlReplace UString = NULL
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlChar UChar;
	DECLARE @SqlResult UString;

	DECLARE @SqlPosition INT;

	-- ������
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;
	-- ������
	SET @SqlReplace = ISNULL(@SqlReplace, '');

	-- ���ó�ʼֵ
	SET @SqlResult = '';
	SET @SqlPosition = 0;
	-- ѭ������
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- ���Ӽ�����
		SET @SqlPosition = @SqlPosition + 1;
		-- �������һ���ַ�
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- �����
		SET @SqlResult = @SqlResult +
			CASE
				WHEN dbo.IsBlankspace(@SqlChar) <= 0 THEN @SqlChar ELSE @SqlReplace
			END;
	END
	-- ���ؽ��
	RETURN @SqlResult;
END
GO

