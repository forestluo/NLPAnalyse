USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetLowercase]    Script Date: 2020/12/6 9:51:33 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<获得小写字母>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetLowercase]
(
	-- Add the parameters for the function here
	@SqlIndex INT
)
RETURNS UChar
AS
BEGIN
	-- 返回结果值
	-- Index（从1至26）
	RETURN CHAR(96 + @SqlIndex);
END
GO

