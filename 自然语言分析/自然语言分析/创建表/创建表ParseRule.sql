USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表ParseRule]    Script Date: 2020/12/12 12:52:46 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建关系规则表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表ParseRule]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 取消常驻内存
	--EXEC sp_tableoption 'ParseRule','PINTABLE', 'FALSE';

	-- 删除之前的索引
	IF OBJECT_ID('ParseRuleRIDIndex') IS NOT NULL
		DROP INDEX dbo.ParseRuleRIDIndex;
	IF OBJECT_ID('ParseRuleClassificationIndex') IS NOT NULL
		DROP INDEX dbo.ParseRuleClassificationIndex;
	-- 删除之前的表
	IF OBJECT_ID('ParseRule') IS NOT NULL
		DROP TABLE dbo.ParseRule;
	-- 创建数据表
	CREATE TABLE dbo.ParseRule
	(
		-- 编号
		rid						INT						UNIQUE						NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 关系描述
		[rule]					NVARCHAR(450)			PRIMARY KEY					NOT NULL,
		-- 关系缩写
		abbreviation			NVARCHAR(256)			NOT NULL,
		-- XML描述
		xml_remark				NVARCHAR(MAX)			NULL,
		-- 是否为正则式
		normalized				BIT						NOT NULL					DEFAULT 0,
		-- 是否有固定结尾标志
		static_suffix			BIT						NOT NULL					DEFAULT 0,
		-- 是否有固定开头标志
		static_prefix			BIT						NOT NULL					DEFAULT 0,
		-- 满足规则的最短长度
		minimum_length			INT						NOT NULL					DEFAULT 0,
		-- 已使用的参数个数
		parameter_count			INT						NOT NULL					DEFAULT 0,
		-- 人工可控优先级
		controllable_priority	INT						NOT NULL					DEFAULT 0
	)
	-- 创建简单索引
	CREATE INDEX ParseRuleRIDIndex ON dbo.ParseRule (rid);
	CREATE INDEX ParseRuleClassificationIndex ON dbo.ParseRule (classification);
	
END
