USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<使能或关闭字典词条>
-- =============================================

CREATE OR ALTER PROCEDURE DictionaryEnableItem 
(
	-- Add the parameters for the function here
	@SqlEnable INT,
	@SqlContent UString
)
AS
BEGIN
	-- 检查输入
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;
	-- 更新统计
	UPDATE dbo.Dictionary SET [enable] = @SqlEnable WHERE content = @SqlContent;
	-- 检查结果
	RETURN @@ROWCOUNT;
END
GO

