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
-- Create date: <2020��12��14��>
-- Description:	<��������滻������>
-- =============================================

CREATE OR ALTER FUNCTION FilterContent
(
	-- Add the parameters for the function here
	@SqlRules XML,
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlReplaced INT;
	DECLARE @SqlFilter UString;
	DECLARE @SqlReplace UString;

	-- ������
	IF @SqlRules IS NULL RETURN NULL;
	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN NULL;

	-- �������հ�Ϊ��ͨ�հ�
	SET @SqlContent = dbo.ClearBlankspace(@SqlContent, ' ');

	-- ѭ������
DOIT_AGAIN:
	-- ���ó�ʼֵ
	SET @SqlReplaced = 0;
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT
			Nodes.value('(./filter/text())[1]', 'nvarchar(max)'),
			Nodes.value('(./replace/text())[1]','nvarchar(max)')
			FROM @SqlRules.nodes('//result/rule') AS N(Nodes)
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlFilter, @SqlReplace;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �滻����
		SET @SqlFilter = REPLACE(@SqlFilter, 'b', ' ');
		-- �����
		IF CHARINDEX(@SqlFilter, @SqlContent) > 0
		BEGIN
			-- ���ñ��
			SET @SqlReplaced = 1;
			-- �����
			IF @SqlReplace IS NULL OR
				LEN(@SqlReplace) <= 0
			BEGIN
				-- ɾ���ַ���
				SET @SqlContent = REPLACE(@SqlContent, @SqlFilter, '');
			END
			ELSE
			BEGIN
				-- �滻����
				SET @SqlReplace = REPLACE(@SqlReplace, 'b', ' ');
				-- �滻�ַ���
				SET @SqlContent = REPLACE(@SqlContent, @SqlFilter, @SqlReplace);
			END
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlFilter, @SqlReplace;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor; 
	-- �����
	IF @SqlReplaced = 1 GOTO DOIT_AGAIN;
	-- ���ؽ��
	RETURN @SqlContent;
END
GO

