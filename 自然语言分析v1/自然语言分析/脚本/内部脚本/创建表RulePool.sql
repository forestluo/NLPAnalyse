USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[创建表RulePool]    Script Date: 2020/12/12 12:36:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建文本池>
-- =============================================
CREATE OR ALTER  PROCEDURE [dbo].[创建表RulePool]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('RulePoolRIDIndex') IS NOT NULL
		DROP INDEX dbo.RulePoolRIDIndex;
	-- 删除之前的表
	IF OBJECT_ID('RulePool') IS NOT NULL
		DROP TABLE dbo.RulePool;
	-- 创建数据表
	CREATE TABLE dbo.RulePool
	(
		-- 编号
		rid						INT						IDENTITY(1,1)				NOT NULL,
		-- 解析规则
		parse_rule				NVARCHAR(256)			NOT NULL,
		-- 分类
		classification			NVARCHAR(32)			NULL,
		-- 解析标志
		parsed					INT						NOT NULL					DEFAULT 0,
		-- 结果状态
		result					INT						NOT NULL					DEFAULT 0,
		-- 特殊标记
		remark					NVARCHAR(256)			NULL
	);
	-- 创建简单索引
	CREATE INDEX RulePoolRIDIndex ON dbo.RulePool (rid);
END
