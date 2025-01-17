USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ContentGetCID]    Script Date: 2020/12/10 10:36:50 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月10日>
-- Description:	<获得内容在内外部表中的CID>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ContentGetCID]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCID INT = -1;

	-- 检查参数
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0
		RETURN 0;
	-- 先查内表
	SELECT TOP 1 @SqlCID = cid
		FROM dbo.InnerContent
		WHERE content = @SqlContent;
	-- 检查结果
	IF @SqlCID > 0 RETURN @SqlCID;
	-- 再查外表
	SELECT TOP 1 @SqlCID = cid
		FROM dbo.OuterContent
		WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCID;
END
