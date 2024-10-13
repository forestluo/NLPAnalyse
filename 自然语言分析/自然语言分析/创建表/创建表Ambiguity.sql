USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��2��19��>
-- Description:	<���������¼��>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[������Ambiguity]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ������
	IF OBJECT_ID('InnerAmbiguityEIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerAmbiguityDIDIndex;

	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('Ambiguity') IS NOT NULL
		DROP TABLE dbo.Ambiguity;
	-- �������ݱ�
	CREATE TABLE dbo.Ambiguity
	(
		-- ��ʶ
		aid						INT						IDENTITY(1,1)				NOT NULL,
		-- ���
		eid						INT						NOT NULL,
		-- λ��
		[position]				INT						NOT NULL					DEFAULT 0,
		-- ����
		[length]				INT						NOT NULL					DEFAULT 0,
		-- ������
		[count]					INT						NOT NULL					DEFAULT 0,
		-- ����
		[content]				NVARCHAR(450)			NOT NULL,
		-- FMM����
		[fmm_content]			NVARCHAR(450)			NOT NULL,
		-- BMM����
		[bmm_content]			NVARCHAR(450)			NOT NULL,
		-- ��Ƶ
		freq					INT						NOT NULL					DEFAULT 0,
		-- FMM��Ƶ
		fmm_freq				INT						NOT NULL					DEFAULT 0,
		-- BMM��Ƶ
		bmm_freq				INT						NOT NULL					DEFAULT 0,
		-- ѡ���־
		operation				INT						NOT NULL					DEFAULT 0
	);

	-- ����������
	CREATE INDEX InnerAmbiguityDIDIndex ON dbo.Ambiguity (eid);
END
