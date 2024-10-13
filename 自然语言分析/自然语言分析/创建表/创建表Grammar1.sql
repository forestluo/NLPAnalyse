USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月11日>
-- Description:	<创建语法记录表>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表Grammar1]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	-- 创建数据表

	-- 删除之前的表
	IF OBJECT_ID('Grammar1') IS NOT NULL
		DROP TABLE dbo.Grammar1;
	-- 创建数据表
	CREATE TABLE dbo.Grammar1
	(
		-- 标识
		gid						INT						IDENTITY(1,1)				NOT NULL,
		-- 无效（机器控制）
		[invalid]				BIT						NOT NULL					DEFAULT 0,
		-- 字典（人工控制）
		[dictionary]			BIT						NOT NULL					DEFAULT 0,
		-- 使能（人工控制）
		[enable]				INT						NOT NULL					DEFAULT 0,
		-- 繁体
		[traditional]			BIT						NOT NULL					DEFAULT 0,
		-- 内容
		[content]				NVARCHAR(16)			NOT NULL					PRIMARY KEY,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 1,
		-- 操作位
		[operations]			INT						NOT NULL					DEFAULT 0
	);
END
