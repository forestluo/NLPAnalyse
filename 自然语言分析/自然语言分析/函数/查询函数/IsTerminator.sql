USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsTerminator]    Script Date: 2020/12/6 10:42:06 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<是否为终结符号>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsTerminator]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 检查参数
	IF @SqlContent IS NULL RETURN 0;

	-- 声明临时变量
	DECLARE @SqlCID INT = -1;
	-- 执行查询语句
	SELECT @SqlCID = cid
		FROM dbo.InnerContent
		WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCID;
END
GO

