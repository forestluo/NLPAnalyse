USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表ExternalContent]    Script Date: 2020/12/9 12:18:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<创建文本内容表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表ExternalContent]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('ExternalContentEIDIndex') IS NOT NULL
		DROP INDEX dbo.ExternalContentEIDIndex;
	IF OBJECT_ID('ExternalContentClassificationIndex') IS NOT NULL
		DROP INDEX dbo.ExternalContentClassificationIndex;
	IF OBJECT_ID('ExternalContentTypeIndex') IS NOT NULL
		DROP INDEX dbo.ExternalContentTypeIndex;

	-- 删除之前的表
	IF OBJECT_ID('ExternalContent') IS NOT NULL
		DROP TABLE dbo.ExternalContent;
	-- 创建数据表
	CREATE TABLE dbo.ExternalContent
	(
		-- 编号
		eid						INT						IDENTITY(1,1)				NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 语料编号
		[tid]					INT						NOT NULL					DEFAULT 0,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		content					NVARCHAR(450)			PRIMARY KEY					NOT NULL,
		-- 类型
		[type]					INT						NOT NULL					DEFAULT 0,
		-- 解析规则
		[rule]					NVARCHAR(256)			NULL,
	);

	-- 创建简单索引
	CREATE INDEX ExternalContentEIDIndex ON dbo.ExternalContent (eid);
	CREATE INDEX ExternalContentClassificationIndex ON dbo.ExternalContent ([classification]);
	CREATE INDEX ExternalContentTypeIndex ON dbo.ExternalContent ([type]);

END
