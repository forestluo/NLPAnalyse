USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��3��22��>
-- Description:	<�����﷨��¼��>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[������GrammarX]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ������
	IF OBJECT_ID('GrammarXLContentIndex') IS NOT NULL
		DROP INDEX dbo.GrammarXLContentIndex;
	IF OBJECT_ID('GrammarXRContentIndex') IS NOT NULL
		DROP INDEX dbo.GrammarXRContentIndex;

	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('GrammarX') IS NOT NULL
		DROP TABLE dbo.GrammarX;
	-- �������ݱ�
	CREATE TABLE dbo.GrammarX
	(
		-- ��ʶ
		gid						INT						IDENTITY(1,1)				NOT NULL,
		-- ��Ч���������ƣ�
		[invalid]				BIT						NOT NULL					DEFAULT 0,
		-- �ֵ䣨�˹����ƣ�
		[dictionary]			BIT						NOT NULL					DEFAULT 0,
		-- ʹ�ܣ��˹����ƣ�
		[enable]				INT						NOT NULL					DEFAULT 0,
		-- �ϲ�����
		[content]				NVARCHAR(16)			NOT NULL					PRIMARY KEY,
		-- �������
		[lcontent]				NVARCHAR(8)				NOT NULL					DEFAULT '',
		-- �Ҳ�����
		[rcontent]				NVARCHAR(8)				NOT NULL					DEFAULT '',
		-- ������
		[count]					INT						NOT NULL					DEFAULT 1,
		-- ���ϵ��
		[alpha]					FLOAT					NOT NULL					DEFAULT -1,
		-- ����λ
		[operations]			INT						NOT NULL					DEFAULT 0
	);

	-- ����������
	CREATE INDEX GrammarXLContentIndex ON dbo.GrammarX (lcontent);
	CREATE INDEX GrammarXRContentIndex ON dbo.GrammarX (rcontent);
END
