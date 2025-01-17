USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ContentGetValue]    Script Date: 2020/12/31 10:36:50 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月31日>
-- Description:	<依据标识获得内容>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ContentGetValue]
(
	-- Add the parameters for the function here
	@SqlCID INT
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlContent UString;

	-- 检查参数
	IF @SqlCID <= 0 RETURN NULL;
	-- 先查内表
	SELECT TOP 1 @SqlContent = content
		FROM dbo.InnerContent WHERE cid = @SqlCID;
	-- 检查结果
	IF @SqlContent IS NOT NULL
		RETURN @SqlContent;
	-- 再查外表
	SELECT TOP 1 @SqlContent = content
		FROM dbo.OuterContent WHERE cid = @SqlCID;
	-- 返回结果
	RETURN @SqlContent;
END
