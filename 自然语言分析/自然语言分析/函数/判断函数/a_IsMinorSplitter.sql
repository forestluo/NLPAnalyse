USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsMinorSplitter]    Script Date: 2020/12/6 10:35:05 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<是否为次要分隔符>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsMinorSplitter]
(
	-- Add the parameters for the function here
	@SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 判断主要分隔符
	IF @SqlChar IS NOT NULL AND
		@SqlChar IN ('、','—','…','·') RETURN 1;
	-- 返回数值
	RETURN 0;
END
GO

