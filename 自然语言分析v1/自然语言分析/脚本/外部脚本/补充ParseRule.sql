USE [nldb]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��19��>
-- Description:	<��OuterContent���в���ParseRule>
-- =============================================
CREATE OR ALTER PROCEDURE [����ParseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlResult INT;
	DECLARE @SqlRule UString;

	-- ��ӡ����
	PRINT '����ParseRule> �������ݼ�¼��';

	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT DISTINCT(parse_rule)	FROM dbo.OuterContent
			WHERE parse_rule IS NOT NULL AND dbo.IsTerminateRule(parse_rule) = 0;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlRule;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ������
		IF dbo.GetParseRuleID(@SqlRule) <= 0
		BEGIN
			-- �������
			EXEC @SqlResult = dbo.AddSentenceRule @SqlRule;
			-- ��ӡ���
			PRINT '����ParseRule(rid=' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')> ' + @SqlRule;
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlRule;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor; 
	-- ���سɹ�
	PRINT '����ParseRule> ���в�����������ϣ�';
END
GO
