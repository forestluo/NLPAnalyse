USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月19日>
-- Description:	<创建歧义记录表>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表Ambiguity]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- 创建数据表

	-- 删除之前的索引
	IF OBJECT_ID('InnerAmbiguityEIDIndex') IS NOT NULL
		DROP INDEX dbo.InnerAmbiguityDIDIndex;

	-- 删除之前的表
	IF OBJECT_ID('Ambiguity') IS NOT NULL
		DROP TABLE dbo.Ambiguity;
	-- 创建数据表
	CREATE TABLE dbo.Ambiguity
	(
		-- 标识
		aid						INT						IDENTITY(1,1)				NOT NULL,
		-- 编号
		eid						INT						NOT NULL,
		-- 位置
		[position]				INT						NOT NULL					DEFAULT 0,
		-- 长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 内容
		[content]				NVARCHAR(450)			NOT NULL,
		-- FMM内容
		[fmm_content]			NVARCHAR(450)			NOT NULL,
		-- BMM内容
		[bmm_content]			NVARCHAR(450)			NOT NULL,
		-- 词频
		freq					INT						NOT NULL					DEFAULT 0,
		-- FMM词频
		fmm_freq				INT						NOT NULL					DEFAULT 0,
		-- BMM词频
		bmm_freq				INT						NOT NULL					DEFAULT 0,
		-- 选择标志
		operation				INT						NOT NULL					DEFAULT 0
	);

	-- 创建简单索引
	CREATE INDEX InnerAmbiguityDIDIndex ON dbo.Ambiguity (eid);
END
