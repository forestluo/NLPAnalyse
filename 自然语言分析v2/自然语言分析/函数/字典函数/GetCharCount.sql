USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCharCount]    Script Date: 2020/12/12 13:18:40 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<获得字符的统计数目>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetCharCount]
(
	-- Add the parameters for the function here
	@SqlContent UString, @SqlChar UChar
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlPosition INT;

	-- 检查参数
	IF @SqlChar IS NULL
		OR LEN(@SqlChar) <= 0 RETURN -1;
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 RETURN -2;

	-- 设置初始值
	SET @SqlCount = 0;
	SET @SqlPosition = 0;
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 设置位置
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得字符
		IF @SqlChar =
			SUBSTRING(@SqlContent, @SqlPosition, 1)	SET @SqlCount = @SqlCount + 1;
	END
	-- 返回结果
	RETURN @SqlCount;
END
