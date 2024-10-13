USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月10日>
-- Description:	<获得较大的相关系数值>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetMaxAlpha]
(
	-- Add the parameters for the function here
	@SqlAlpha1 FLOAT,
	@SqlAlpha2 FLOAT
)
RETURNS FLOAT
AS
BEGIN
	-- 返回数值
	RETURN CASE WHEN @SqlAlpha1 > @SqlAlpha2 THEN @SqlAlpha1 ELSE @SqlAlpha2 END;
END
GO

