USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月7日>
-- Description:	<依据标识内容分类>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ContentGetClassification]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlClassification UString;

	-- 先查内表
	SELECT TOP 1 @SqlClassification = classification
		FROM dbo.InnerContent WHERE content = @SqlContent;
	-- 检查结果
	IF @SqlClassification IS NOT NULL
		RETURN @SqlClassification;
	-- 再查外表
	SELECT TOP 1 @SqlClassification = classification
		FROM dbo.OuterContent WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlClassification;
END
