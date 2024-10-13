USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��2��28��>
-- Description:	<�����﷨��¼��>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[������Grammar]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ������
	IF OBJECT_ID('InnerGramarContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarContentIndex;
	IF OBJECT_ID('InnerGramarLeftContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarLeftContentIndex;
	IF OBJECT_ID('InnerGramarRightContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarRightContentIndex;

	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('Grammar') IS NOT NULL
		DROP TABLE dbo.Grammar;
	-- �������ݱ�
	CREATE TABLE dbo.Grammar
	(
		-- ��ʶ
		gid						INT						IDENTITY(1,1)				NOT NULL,
		-- ��Ч���������ƣ�
		[invalid]				BIT						NOT NULL					DEFAULT 0,
		-- ʹ�ܣ��˹����ƣ�
		[enable]				BIT						NOT NULL					DEFAULT 0,
		-- �ϲ�����
		[content]				NVARCHAR(16)			NOT NULL,
		-- �������
		[lcontent]				NVARCHAR(8)				NULL,
		-- �Ҳ�����
		[rcontent]				NVARCHAR(8)				NULL,
		-- ������
		[count]					INT						NOT NULL					DEFAULT 0,
		-- ���ϵ��					
		[alpha]					FLOAT					NOT NULL					DEFAULT -1,
		-- ���ϵ��					
		[lalpha]				FLOAT					NOT NULL					DEFAULT -1,
		-- ���ϵ��				
		[ralpha]				FLOAT					NOT NULL					DEFAULT -1,
		-- ����λ
		[operations]			INT						NOT NULL					DEFAULT 0
	);

	-- ����������
	CREATE INDEX InnerGrammarContentIndex ON dbo.Grammar (content);
	CREATE INDEX InnerGrammarLeftContentIndex ON dbo.Grammar (lcontent);
	CREATE INDEX InnerGrammarRightContentIndex ON dbo.Grammar (rcontent);
END
