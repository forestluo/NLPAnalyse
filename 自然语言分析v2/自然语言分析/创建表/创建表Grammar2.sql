USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��3��11��>
-- Description:	<�����﷨��¼��>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[������Grammar2]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	---- ɾ��֮ǰ������
	IF OBJECT_ID('Grammar2LContentIndex') IS NOT NULL
		DROP INDEX dbo.Grammar2LContentIndex;
	IF OBJECT_ID('Grammar2RContentIndex') IS NOT NULL
		DROP INDEX dbo.Grammar2RContentIndex;

	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('Grammar2') IS NOT NULL
		DROP TABLE dbo.Grammar2;
	-- �������ݱ�
	CREATE TABLE dbo.Grammar2
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

	---- ����������
	CREATE INDEX Grammar2LContentIndex ON dbo.Grammar2 (lcontent);
	CREATE INDEX Grammar2RContentIndex ON dbo.Grammar2 (rcontent);
END
