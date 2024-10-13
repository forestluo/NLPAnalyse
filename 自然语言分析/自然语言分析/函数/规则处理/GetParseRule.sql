USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetParseRule]    Script Date: 2020/12/6 10:22:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<把句子转换成规则>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetParseRule]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlReplaced INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlRule UString;

	-- 检查参数
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 RETURN NULL;

	-- 设置初始值
	SET @SqlRule = '';
	SET @SqlIndex = 0;
	SET @SqlReplaced = 0;

	-- 设置初始值
	SET @SqlPosition= 0;
	-- 循环处理
	-- 最多转换26个参数
	WHILE @SqlPosition < LEN(@SqlContent) AND @SqlIndex < 26
	BEGIN
		-- 计数器加一
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 是标点符号
		IF dbo.IsPunctuation(@SqlChar) = 1
		BEGIN
			-- 清理标记位
			SET @SqlReplaced = 0;
			-- 增加一个标点
			SET @SqlRule = @SqlRule + @SqlChar;
		END
		ELSE
		BEGIN
			-- 检查标记位
			IF @SqlReplaced = 0
			BEGIN
				-- 设置标记位
				SET @SqlReplaced = 1;
				-- 参数编号加一
				SET @SqlIndex = @SqlIndex + 1;
				-- 增加一个参数
				SET @SqlRule = @SqlRule + '$' + dbo.GetLowercase(@SqlIndex);
			END
		END
	END
	-- 返回规则
	RETURN @SqlRule;
END
GO

