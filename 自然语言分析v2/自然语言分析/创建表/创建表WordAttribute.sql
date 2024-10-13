USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[������WordAttribute]    Script Date: 2021/1/28 12:18:49 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��1��28��>
-- Description:	<�����ı��ʵ��>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[������WordAttribute]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- �������ݱ�

	-- ɾ��֮ǰ������
	IF OBJECT_ID('InnerWordAttributeWIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeWIDIndex;
	IF OBJECT_ID('InnerWordAttributeContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeContentIndex;
	IF OBJECT_ID('InnerWordAttributeClassificationIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeClassificationIndex;
	-- ɾ��֮ǰ�ı�
	IF OBJECT_ID('WordAttribute') IS NOT NULL
		DROP TABLE dbo.WordAttribute;
	-- �������ݱ�
	CREATE TABLE dbo.WordAttribute
	(
		-- ���
		wid						INT						IDENTITY(1,1)				NOT NULL,
		-- ��������
		[classification]		NVARCHAR(64)			NULL,
		-- ������
		[count]					INT						NOT NULL					DEFAULT 0,
		-- ���ݳ���
		[length]				INT						NOT NULL					DEFAULT 0,
		-- ��������
		content					NVARCHAR(450)			NOT NULL,
		-- ����
		attribute				NVARCHAR(32)			NOT NULL,
		-- �����ռ�
		collections				NVARCHAR(450)			NULL
	);
	-- ����������
	CREATE INDEX InnerWordAttributeDIDIndex ON dbo.WordAttribute (wid);
	CREATE INDEX InnerWordAttributeContentIndex ON dbo.WordAttribute (content);
	CREATE INDEX InnerWordAttributeClassificationIndex ON dbo.WordAttribute (classification);
END
