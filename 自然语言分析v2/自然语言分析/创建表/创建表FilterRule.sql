USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表FilterRule]    Script Date: 2020/12/14 14:08:38 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建文本过滤规则表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表FilterRule]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的表
	IF OBJECT_ID('FilterRule') IS NOT NULL
		DROP TABLE dbo.FilterRule;
	-- 创建数据表
	CREATE TABLE dbo.FilterRule
	(
		-- 编号
		rid						INT						UNIQUE						NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 规则
		[rule]					NVARCHAR(256)			PRIMARY KEY					NOT NULL,
		-- 替代
		[replace]				NVARCHAR(256),
		-- 规则要求
		requirements			NVARCHAR(MAX)			NULL,
	);
END
GO