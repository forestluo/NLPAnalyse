USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[������Dictionary]    Script Date: 2020/12/27 12:18:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��27��>
-- Description:	<�����ı��ʵ��>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[������Dictionary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ������
	IF OBJECT_ID('DictionaryDIDIndex') IS NOT NULL
		DROP INDEX dbo.DictionaryDIDIndex;
	IF OBJECT_ID('DictionaryContentIndex') IS NOT NULL
		DROP INDEX dbo.DictionaryContentIndex;
	IF OBJECT_ID('DictionaryClassificationIndex') IS NOT NULL
		DROP INDEX dbo.DictionaryClassificationIndex;
	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('Dictionary') IS NOT NULL
		DROP TABLE dbo.Dictionary;
	-- �������ݱ�
	CREATE TABLE dbo.Dictionary
	(
		-- ���
		did						INT						IDENTITY(1,1)				NOT NULL,
		-- ʹ��
		[enable]				BIT						NOT NULL					DEFAULT 1,
		-- ��������
		[classification]		NVARCHAR(64)			NULL,
		-- ������
		[count]					INT						NOT NULL					DEFAULT 0,
		-- ���ݳ���
		[length]				INT						NOT NULL					DEFAULT 0,
		-- ��������
		content					NVARCHAR(450)			NOT NULL,
		-- ��ע
		remark					NVARCHAR(MAX)			NULL,
		-- ����
		[operations]			INT						NOT NULL					DEFAULT 0
	);
	-- ����������
	CREATE INDEX DictionaryDIDIndex ON dbo.Dictionary (did);
	CREATE INDEX DictionaryContentIndex ON dbo.Dictionary (content);
	CREATE INDEX DictionaryClassificationIndex ON dbo.Dictionary (classification);
END
