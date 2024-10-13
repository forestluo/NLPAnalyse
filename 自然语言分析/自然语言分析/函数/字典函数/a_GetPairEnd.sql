USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetPairEnd]    Script Date: 2020/12/6 10:02:54 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<获得成对分隔符的结尾>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetPairEnd]
(
	-- Add the parameters for the function here
	@SqlStart UChar
)
RETURNS UChar
AS
BEGIN
	-- 检查参数
	IF @SqlStart IS NOT NULL
	BEGIN
		IF @SqlStart = '“' RETURN '”';
		IF @SqlStart = '（' RETURN '）';
		IF @SqlStart = '‘' RETURN '’';
		IF @SqlStart = '《' RETURN '》';
		IF @SqlStart = '【' RETURN '】';
		IF @SqlStart = '〈' RETURN '〉';
	END
	-- 返回数值
	RETURN NULL;
END
GO

