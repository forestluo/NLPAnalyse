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
-- Create date: <2021��3��1��>
-- Description:	<��������ʵ����ϵ��>
-- =============================================

CREATE OR ALTER FUNCTION GetTriAlphaValue
(
	-- Add the parameters for the function here
	@SqlLeft UString,
	@SqlMiddle UString,
	@SqlRight UString
)
RETURNS FLOAT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlValue FLOAT;
	
	DECLARE @SqlLeftCount INT;
	DECLARE @SqlRightCount INT;
	DECLARE @SqlMiddleCount INT;
	DECLARE @SqlCombinateCount INT;

	-- ������
	IF @SqlLeft IS NULL OR
		LEN(@SqlLeft) <= 0 RETURN -1;
	IF @SqlMiddle IS NULL OR
		LEN(@SqlMiddle) <= 0 RETURN -1;
	IF @SqlRight IS NULL OR
		LEN(@SqlRight) <= 0 RETURN -1;

	-- ������ʵĸ���
	SET @SqlLeftCount =
		dbo.GetFreqCount(@SqlLeft);
	-- �����
	IF @SqlLeftCount <= 0 RETURN -1;
	
	-- ������ʵĸ���
	SET @SqlMiddleCount =
		dbo.GetFreqCount(@SqlMiddle);
	-- �����
	IF @SqlMiddleCount <= 0 RETURN -1;

	-- ����Ҳ�ʵĴ�Ƶ
	SET @SqlRightCount =
		dbo.GetFreqCount(@SqlRight);
	-- �����
	IF  @SqlRightCount <= 0 RETURN -1;

	-- ��úϲ��ʵĴ�Ƶ
	SET @SqlCombinateCount =
		dbo.GetFreqCount(@SqlLeft + @SqlMiddle + @SqlRight);
	-- ���ӹ�
	IF @SqlCombinateCount <= 0 RETURN -1;

	-- ������
	SET @SqlValue = @SqlLeftCount * 1.0 * @SqlMiddleCount * @SqlRightCount;
	SET @SqlValue = @SqlValue / (@SqlLeftCount * 1.0 * @SqlMiddleCount +
			@SqlLeftCount * 1.0 * @SqlRightCount + @SqlMiddleCount * 1.0 * @SqlRightCount);
	SET @SqlValue = @SqlValue / @SqlCombinateCount;
	-- ���ؽ��
	RETURN 3.0 * @SqlValue;
END
GO

