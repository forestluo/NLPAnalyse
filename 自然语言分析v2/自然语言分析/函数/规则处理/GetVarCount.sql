USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetVarCount]    Script Date: 2020/12/12 13:18:40 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月12日>
-- Description:	<获得参数的统计数目>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetVarCount]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 返回结果
	RETURN dbo.GetCharCount(@SqlContent, '$');
END
