USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月28日>
-- Description:	<创建语法记录表>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表Grammar]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- 创建数据表

	-- 删除之前的索引
	IF OBJECT_ID('InnerGramarContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarContentIndex;
	IF OBJECT_ID('InnerGramarLeftContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarLeftContentIndex;
	IF OBJECT_ID('InnerGramarRightContentIndex') IS NOT NULL
		DROP INDEX dbo.InnerGrammarRightContentIndex;

	-- 删除之前的表
	IF OBJECT_ID('Grammar') IS NOT NULL
		DROP TABLE dbo.Grammar;
	-- 创建数据表
	CREATE TABLE dbo.Grammar
	(
		-- 标识
		gid						INT						IDENTITY(1,1)				NOT NULL,
		-- 无效（机器控制）
		[invalid]				BIT						NOT NULL					DEFAULT 0,
		-- 使能（人工控制）
		[enable]				BIT						NOT NULL					DEFAULT 0,
		-- 合并内容
		[content]				NVARCHAR(16)			NOT NULL,
		-- 左侧内容
		[lcontent]				NVARCHAR(8)				NULL,
		-- 右侧内容
		[rcontent]				NVARCHAR(8)				NULL,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 相关系数					
		[alpha]					FLOAT					NOT NULL					DEFAULT -1,
		-- 相关系数					
		[lalpha]				FLOAT					NOT NULL					DEFAULT -1,
		-- 相关系数				
		[ralpha]				FLOAT					NOT NULL					DEFAULT -1,
		-- 操作位
		[operations]			INT						NOT NULL					DEFAULT 0
	);

	-- 创建简单索引
	CREATE INDEX InnerGrammarContentIndex ON dbo.Grammar (content);
	CREATE INDEX InnerGrammarLeftContentIndex ON dbo.Grammar (lcontent);
	CREATE INDEX InnerGrammarRightContentIndex ON dbo.Grammar (rcontent);
END
