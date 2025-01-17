USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表TextPool]    Script Date: 2020/12/9 16:02:16 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<创建文本池>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表TextPool]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('TextPoolTIDIndex') IS NOT NULL
		DROP INDEX dbo.TextPoolTIDIndex;
	IF OBJECT_ID('TextPool') IS NOT NULL
		DROP TABLE dbo.TextPool;
	-- 创建数据表
	CREATE TABLE dbo.TextPool
	(
		-- 编号
		tid						INT						IDENTITY(1,1)				NOT NULL,
		-- 内容分类
		[classification]		NVARCHAR(64)			NULL,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 内容描述
		content					NVARCHAR(MAX)			NOT NULL,
		-- 解析标志
		parsed					INT						NOT NULL					DEFAULT 0,
		-- 结果状态
		result					INT						NOT NULL					DEFAULT 0,
		-- 特殊标记
		remark					NVARCHAR(MAX)			NULL
	);
	-- 创建聚集索引
	CREATE INDEX TextPoolTIDIndex ON dbo.TextPool (tid);
END
