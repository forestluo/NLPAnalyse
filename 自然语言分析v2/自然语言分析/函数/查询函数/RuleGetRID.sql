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
-- Create date: <2020��12��9��>
-- Description:	<�������Ƿ����>
-- =============================================

CREATE OR ALTER FUNCTION RuleGetRID
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS INT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlRID INT = -1;
	-- ִ�в�ѯ���
	SELECT TOP 1 @SqlRID = rid
		FROM dbo.ParseRule WHERE [rule] = @SqlRule;
	-- �����
	IF @SqlRID > 0 RETURN @SqlRID;
	-- ִ�в�ѯ���
	SELECT TOP 1 @SqlRID = rid
		FROM dbo.PhraseRule WHERE [rule] = @SqlRule;
	-- �����
	IF @SqlRID > 0 RETURN @SqlRID;
	-- ִ�в�ѯ���
	SELECT TOP 1 @SqlRID = rid
		FROM dbo.FilterRule WHERE [rule] = @SqlRule;
	-- ���ؽ��
	RETURN CASE WHEN @SqlRID > 0 THEN @SqlRID ELSE 0 END;
END
GO
