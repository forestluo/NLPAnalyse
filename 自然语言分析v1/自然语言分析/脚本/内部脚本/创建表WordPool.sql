USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[创建表WordPool]    Script Date: 2020/12/9 16:03:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建分词池>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表WordPool]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('WordPoolWIDIndex') IS NOT NULL
		DROP INDEX dbo.WordPoolWIDIndex;
	-- 删除之前的表
	IF OBJECT_ID('WordPool') IS NOT NULL
		DROP TABLE dbo.WordPool;
	-- 创建数据表
	CREATE TABLE dbo.WordPool
	(
		-- 编号
		wid						INT						IDENTITY(1,1)				NOT NULL,
		-- 内容长度
		length					INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		word					NVARCHAR(MAX)			NOT NULL,
		-- 解析标志
		parsed					INT						NOT NULL					DEFAULT 0,
		-- 结果状态
		result					INT						NOT NULL					DEFAULT 0,
		-- 特殊标记
		remark					NVARCHAR(MAX)			NULL
	);
	-- 创建简单索引
	CREATE INDEX WordPoolWIDIndex ON dbo.WordPool (wid);
END
