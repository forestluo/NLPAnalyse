USE [nldb]
GO
/****** Object:  UserDefinedFunction [dbo].[XMLUnescape]    Script Date: 2020/12/8 9:11:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月8日>
-- Description:	<对字符进行转义还原>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[HTMLUnescape]
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
	-- 将字符串转义还原
	SET @SqlValue = REPLACE(@SqlValue, '&quot;', '"');
	SET @SqlValue = REPLACE(@SqlValue, '&amp;', '&');
	SET @SqlValue = REPLACE(@SqlValue, '&lt;', '<');
	SET @SqlValue = REPLACE(@SqlValue, '&gt;', '>');
	-- 返回结果
	RETURN REPLACE(@SqlValue, '&nbsp;', ' ');
END
