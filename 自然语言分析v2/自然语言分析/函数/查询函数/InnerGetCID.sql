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
-- Create date: <2020年12月9日>
-- Description:	<是否存在于内部内容中>
-- =============================================

CREATE OR ALTER FUNCTION InnerGetCID
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCID INT = -1;
	-- 执行查询语句
	SELECT TOP 1 @SqlCID = cid
		FROM dbo.InnerContent
		WHERE content = @SqlContent;
	-- 返回结果
	RETURN CASE WHEN @SqlCID > 0 THEN @SqlCID ELSE 0 END;
END
GO

