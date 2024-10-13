USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsPunctuation]    Script Date: 2020/12/6 10:41:14 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<是否为标点符号>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsPunctuation]
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 检查参数
	IF dbo.IsMajorSplitter(@SqlChar) = 1
		OR dbo.IsPairSplitter(@SqlChar) = 1 RETURN 1;
	-- 返回数值
	RETURN 0;
END
GO

