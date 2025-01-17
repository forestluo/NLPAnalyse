USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表ExceptionLog]    Script Date: 2020/12/27 14:08:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<创建异常记录表>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[创建表ExceptionLog]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的表
	IF OBJECT_ID('ExceptionLog') IS NOT NULL
		DROP TABLE dbo.ExceptionLog;
	-- 创建数据表
	CREATE TABLE dbo.ExceptionLog
	(
		-- 编号
		eid						INT						IDENTITY(1,1)				NOT NULL,
		-- 时间					
		[time]					DATETIME				NOT NULL					DEFAULT GETDATE(),
		-- 错误号
		number					INT,
		-- 严重性
		serverity				INT,
		-- 错误状态号
		[state]					INT,
		-- 出现错误的存储过程或触发器的名称
		prodcedure				NVARCHAR(256),
		-- 导致错误的例程中的行号
		line					INT,
		-- 错误消息的完整文本
		[message]				NVARCHAR(MAX)
	);
END