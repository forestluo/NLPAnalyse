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
CREATE OR ALTER PROCEDURE [dbo].[������Grammar1]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('Grammar1') IS NOT NULL
		DROP TABLE dbo.Grammar1;
	-- �������ݱ�
	CREATE TABLE dbo.Grammar1
	(
		-- ��ʶ
		gid						INT						IDENTITY(1,1)				NOT NULL,
		-- ��Ч���������ƣ�
		[invalid]				BIT						NOT NULL					DEFAULT 0,
		-- �ֵ䣨�˹����ƣ�
		[dictionary]			BIT						NOT NULL					DEFAULT 0,
		-- ʹ�ܣ��˹����ƣ�
		[enable]				INT						NOT NULL					DEFAULT 0,
		-- ����
		[traditional]			BIT						NOT NULL					DEFAULT 0,
		-- ����
		[content]				NVARCHAR(16)			NOT NULL					PRIMARY KEY,
		-- ������
		[count]					INT						NOT NULL					DEFAULT 1,
		-- ����λ
		[operations]			INT						NOT NULL					DEFAULT 0
	);
END
