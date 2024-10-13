USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[RecoverParameters]    Script Date: 2020/12/6 10:45:19 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月5日>
-- Description:	<恢复规则内的参数名>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[RecoverParameters]
(
	-- Add the parameters for the stored procedure here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlRecovered UString;

	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN NULL;
	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlPosition = 0;
	SET @SqlRecovered = '';
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlRule)
	BEGIN
		-- 设置计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得一个字符
		SET @SqlChar = SUBSTRING(@SqlRule, @SqlPosition, 1);
		-- 检查数据
		IF @SqlChar = '$'
		BEGIN
			-- 设置计数器
			SET @SqlIndex = @SqlIndex + 1;
			-- 增加一个字符
			SET @SqlRecovered = @SqlRecovered +
				'$' + dbo.GetLowercase(@SqlIndex);
		END
		ELSE
		BEGIN
			-- 增加一个字符
			SET @SqlRecovered = @SqlRecovered + @SqlChar;
		END
	END
	-- 返回结果
	RETURN @SqlRecovered;
END
GO

