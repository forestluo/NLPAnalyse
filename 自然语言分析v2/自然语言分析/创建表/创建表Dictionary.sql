USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表Dictionary]    Script Date: 2020/12/27 12:18:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<创建文本词典表>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表Dictionary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- 创建数据表

	-- 删除之前的索引
	IF OBJECT_ID('InnerDictionaryDIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerDictionaryDIDIndex;
	IF OBJECT_ID('InnerDictionaryContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerDictionaryContentIndex;
	IF OBJECT_ID('InnerDictionaryClassificationIndex') IS NOT NULL
		DROP INDEX dbo.InnerDictionaryClassificationIndex;
	-- 删除之前的表
	IF OBJECT_ID('Dictionary') IS NOT NULL
		DROP TABLE dbo.Dictionary;
	-- 创建数据表
	CREATE TABLE dbo.Dictionary
	(
		-- 编号
		did						INT						IDENTITY(1,1)				NOT NULL,
		-- 使能
		[enable]				BIT						NOT NULL					DEFAULT 1,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		content					NVARCHAR(450)			NOT NULL,
		-- 备注
		remark					NVARCHAR(MAX)			NULL,
		-- 操作
		[operations]			INT						NOT NULL					DEFAULT 0
	);
	-- 创建简单索引
	CREATE INDEX InnerDictionaryDIDIndex ON dbo.Dictionary (did);
	CREATE INDEX InnerDictionaryContentIndex ON dbo.Dictionary (content);
	CREATE INDEX InnerDictionaryClassificationIndex ON dbo.Dictionary (classification);
END
