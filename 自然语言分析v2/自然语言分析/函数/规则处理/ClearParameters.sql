USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ClearParameters]    Script Date: 2020/12/6 9:56:36 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月5日>
-- Description:	<清理规则中的参数名>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ClearParameters]
(
	-- Add the parameters for the stored procedure here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlCleared UString;

	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN NULL;
	-- 设置初始值
	SET @SqlCleared = '';
	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlRule)
	BEGIN
		-- 设置计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得一个字符
		SET @SqlChar =
			SUBSTRING(@SqlRule, @SqlPosition, 1);
		-- 检查数据
		-- 增加一个字符
		IF dbo.IsLowercase(@SqlChar) = 0
			SET @SqlCleared = @SqlCleared + @SqlChar;
	END
	-- 返回结果
	RETURN @SqlCleared;
END
GO

