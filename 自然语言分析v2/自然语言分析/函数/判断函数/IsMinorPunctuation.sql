USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月7日>
-- Description:	<是否为次要标点符号>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsMinorPunctuation]
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 检查参数
	IF dbo.IsMinorSplitter(@SqlChar) = 1
		OR @SqlChar IN ('''', '"', '[', ']') RETURN 1;
	-- 返回数值
	RETURN 0;
END
GO

