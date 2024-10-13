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
-- Create date: <2021��3��5��>
-- Description:	<��ö���ʵ����ϵ��>
-- =============================================

CREATE OR ALTER FUNCTION GrammarGetAlphaValue
(
	-- Add the parameters for the function here
	@SqlInput UString
)
RETURNS FLOAT
AS
BEGIN

	-- ������ʱ����
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlValue FLOAT;
	DECLARE @SqlContent UString;

	-- ������
	IF @SqlInput IS NULL OR
		LEN(@SqlInput) <= 0 RETURN -1.0;

	-- ���ó�ʼֵ
	SET @SqlIndex = 0;
	SET @SqlValue = 0.0;
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT [Match] AS content
		FROM dbo.RegExSplit('[|]', @SqlInput, 1)
		WHERE [Match] IS NOT NULL AND LEN([Match]) > 0
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �޸ļ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ��ô�Ƶ
		SET @SqlCount = 0;
		-- ��鳤��
		IF LEN(@SqlContent) = 1
			-- ��ѯ���
			SELECT @SqlCount = count FROM dbo.Grammar1
				WHERE content = @SqlContent
		ELSE IF LEN(@SqlContent) = 2
			-- ��ѯ���
			SELECT @SqlCount = count FROM dbo.Grammar2
				WHERE content = @SqlContent
		ELSE
			-- ��ѯ���
			SELECT @SqlCount = count FROM dbo.GrammarX
				WHERE content = @SqlContent
		-- �����
		IF @SqlCount <= 0 BREAK;
		-- �������
		SET @SqlValue = @SqlValue + 1.0 / @SqlCount;
		-- ȡ��һ����¼ 
		FETCH NEXT FROM SqlCursor INTO @SqlContent;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;
	-- �����
	IF @SqlIndex <= 0 OR
		@SqlCount <= 0 RETURN -1.0;
	-- ���ý��
	SET @SqlValue = 1.0 * @SqlIndex / @SqlValue;

	-- �����������
	SET @SqlContent = REPLACE(@SqlInput, '|', '');
	-- ��ô�Ƶ
	SET @SqlCount = 0;
	-- ��鳤��
	IF LEN(@SqlContent) = 1
		-- ��ѯ���
		SELECT @SqlCount = count FROM dbo.Grammar1
			WHERE content = @SqlContent
	ELSE IF LEN(@SqlContent) = 2
		-- ��ѯ���
		SELECT @SqlCount = count FROM dbo.Grammar2
			WHERE content = @SqlContent
	ELSE
		-- ��ѯ���
		SELECT @SqlCount = count FROM dbo.GrammarX
			WHERE content = @SqlContent
	-- �����
	IF @SqlCount <= 0 SET @SqlCount = 1;

	-- ���ؽ��
	RETURN @SqlValue / @SqlCount;
END
GO

