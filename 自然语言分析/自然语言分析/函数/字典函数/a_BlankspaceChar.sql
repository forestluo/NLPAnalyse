USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月7日>
-- Description:	<获得空格替代值>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[BlankspaceChar]
(
)
RETURNS NCHAR
AS
BEGIN
	-- 返回结果值
	RETURN NCHAR(9633);
END
GO

