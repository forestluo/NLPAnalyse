USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表WordAttribute]    Script Date: 2021/1/28 12:18:49 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月28日>
-- Description:	<创建文本词典表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表WordAttribute]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- 创建数据表

	-- 删除之前的索引
	IF OBJECT_ID('InnerWordAttributeWIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeWIDIndex;
	IF OBJECT_ID('InnerWordAttributeContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeContentIndex;
	IF OBJECT_ID('InnerWordAttributeClassificationIndex') IS NOT NULL
		DROP INDEX dbo.InnerWordAttributeClassificationIndex;
	-- 删除之前的表
	IF OBJECT_ID('WordAttribute') IS NOT NULL
		DROP TABLE dbo.WordAttribute;
	-- 创建数据表
	CREATE TABLE dbo.WordAttribute
	(
		-- 编号
		wid						INT						IDENTITY(1,1)				NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		content					NVARCHAR(450)			NOT NULL,
		-- 属性
		attribute				NVARCHAR(32)			NOT NULL,
		-- 搭配收集
		collections				NVARCHAR(450)			NULL
	);
	-- 创建简单索引
	CREATE INDEX InnerWordAttributeDIDIndex ON dbo.WordAttribute (wid);
	CREATE INDEX InnerWordAttributeContentIndex ON dbo.WordAttribute (content);
	CREATE INDEX InnerWordAttributeClassificationIndex ON dbo.WordAttribute (classification);
END
