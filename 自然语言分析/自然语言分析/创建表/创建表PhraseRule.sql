USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表PhraseRule]    Script Date: 2020/12/12 13:40:26 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建短语规则表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表PhraseRule]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('PhraseRuleRIDIndex') IS NOT NULL
		DROP INDEX dbo.PhraseRuleRIDIndex;
	-- 删除之前的表
	IF OBJECT_ID('PhraseRule') IS NOT NULL
		DROP TABLE dbo.PhraseRule;
	-- 创建数据表
	CREATE TABLE dbo.PhraseRule
	(
		-- 编号
		rid						INT						UNIQUE						NOT NULL,
		-- 分类描述
		classification			NVARCHAR(64)			NULL,
		-- 关系描述
		[rule]					NVARCHAR(450)			PRIMARY KEY					NOT NULL,
		-- 属性
		attribute				NVARCHAR(64)			NULL,
		-- 规则要求
		requirements			NVARCHAR(MAX)			NULL,
	);
	-- 创建简单索引
	CREATE INDEX PhraseRuleRIDIndex ON dbo.PhraseRule (rid);
	
END
