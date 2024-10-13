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
-- Create date: <2021��2��20��>
-- Description:	<��ԭ���вü�����������>
-- =============================================

CREATE OR ALTER FUNCTION CutAbbreviation
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlPosition INT,
	@SqlLength INT,
	@SqlCutLength INT
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlValue UString;

	-- ������
	IF @SqlContent IS NULL OR 
		LEN(@SqlContent) <= 0 RETURN NULL;
	-- ���ü�����
	IF @SqlCutLength < @SqlLength
		SET @SqlCutLength = 2 * @SqlLength;
	IF @SqlCutLength < 32 SET @SqlCutLength = 32;

	-- ���ÿ�ʼλ��
	SET @SqlStart = @SqlPosition + @SqlLength / 2 - @SqlCutLength / 2;
	-- �����
	IF @SqlStart < 0 SET @SqlStart = 1;
	-- ���ý���λ��
	SET @SqlEnd = @SqlPosition + @SqlLength / 2 + @SqlCutLength / 2;
	-- �����
	IF @SqlEnd > LEN(@SqlContent) SET @SqlEnd = LEN(@SqlContent);
	-- ��ȡ����
	SET @SqlValue = SUBSTRING(@SqlContent, @SqlStart, @SqlEnd - @SqlStart + 1);
	-- �����
	IF @SqlStart > 1 SET @SqlValue = '...' + @SqlValue;
	IF @SqlEnd < LEN(@SqlContent) SET @SqlValue = @SqlValue + '...';
	-- ���ؽ��
	RETURN @SqlValue;
END
GO

