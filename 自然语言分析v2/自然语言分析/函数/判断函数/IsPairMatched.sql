USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsPairMatched]    Script Date: 2020/12/6 10:36:35 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<是否能匹配为成对分隔符>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[IsPairMatched]
(
	-- Add the parameters for the function here
	@SqlStart UChar, @SqlEnd UChar
)
RETURNS INT
AS
BEGIN
	-- 检查参数
	IF @SqlStart IS NOT NULL
		AND @SqlEnd IS NOT NULL
	BEGIN
		IF @SqlStart = '“' AND @SqlEnd = '”'
			RETURN 1;
		IF @SqlStart = '（' AND @SqlEnd = '）'
			RETURN 1;
		IF @SqlStart = '‘' AND @SqlEnd = '’'
			RETURN 1;
		IF @SqlStart = '《' AND @SqlEnd = '》'
			RETURN 1;
		IF @SqlStart = '【' AND @SqlEnd = '】'
			RETURN 1;
		IF @SqlStart = '〈' AND @SqlEnd = '〉'
			RETURN 1;
	END
	-- 返回数值
	RETURN 0;
END
GO

