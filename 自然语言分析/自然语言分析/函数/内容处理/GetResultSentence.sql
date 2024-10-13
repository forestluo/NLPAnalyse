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
-- Create date: <2020��12��13��>
-- Description:	<�ӽ�����л�þ���>
-- =============================================

CREATE OR ALTER FUNCTION GetResultSentence
(
	-- Add the parameters for the function here
	@SqlResult XML,
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- ��������
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlName UChar;
	DECLARE @SqlValue UString;
	DECLARE @SqlSentence UString;

	-- ������
	IF @SqlResult IS NULL
		RETURN NULL;
	IF @SqlRule IS NULL OR
		LEN(@SqlRule) <= 0 RETURN NULL;
	
	-- ��ò�������
	SET @SqlCount = dbo.GetVarCount(@SqlRule);
	-- �����
	IF @SqlCount <= 0 OR @SqlCount > 26 SET @SqlCount = 26;
	-- ���ó�ʼֵ
	SET @SqlIndex = 0;
	SET @SqlSentence = @SqlRule;
	-- ѭ������
	WHILE @SqlIndex < @SqlCount
	BEGIN
		-- �޸ļ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ��ò�����
		SET @SqlName = dbo.GetLowercase(@SqlIndex);
		-- ��ò���ֵ
		SET @SqlValue = @SqlResult.value('(//result/var[@name=sql:variable("@SqlName")]/text())[1]', 'nvarchar(max)');
		-- �����
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- ���ý��
			SET @SqlSentence = REPLACE(@SqlSentence, '$' + dbo.GetLowercase(@SqlIndex), @SqlValue);
		END
	END
	-- ���ؽ��
	RETURN @SqlSentence;
END
GO

