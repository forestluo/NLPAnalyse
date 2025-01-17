USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表InnerContent]    Script Date: 2020/12/9 12:18:49 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<创建文本内容表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表InnerContent]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('InnerContentCIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerContentCIDIndex;
	IF OBJECT_ID('InnerContentClassificationIndex') IS NOT NULL
		DROP INDEX dbo.InnerContentClassificationIndex;
	IF OBJECT_ID('InnerContentTypeIndex') IS NOT NULL
		DROP INDEX dbo.InnerContentTypeIndex;

	-- 删除之前的表
	IF OBJECT_ID('InnerContent') IS NOT NULL
		DROP TABLE dbo.InnerContent;
	-- 创建数据表
	CREATE TABLE dbo.InnerContent
	(
		-- 编号
		cid						INT						UNIQUE						NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 类型
		[type]					INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		content					NVARCHAR(450)			PRIMARY KEY					NOT NULL,
		-- 内容属性
		[attribute]				NVARCHAR(MAX)			NULL,
	);

	-- 创建简单索引
	CREATE INDEX InnerContentCIDIndex ON dbo.InnerContent (cid);
	CREATE INDEX InnerContentClassificationIndex ON dbo.InnerContent ([classification]);
	CREATE INDEX InnerContentTypeIndex ON dbo.InnerContent ([type]);

END
