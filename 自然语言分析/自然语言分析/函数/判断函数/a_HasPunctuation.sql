USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[HasPunctuation]    Script Date: 2020/12/6 10:33:17 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<是否包含标点符号>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[HasPunctuation]
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlPosition INT;

	-- 检查参数
	IF @SqlValue IS NULL RETURN 0;
	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlValue)
	BEGIN
		-- 设置计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 截取字符
		SET @SqlChar =
			SUBSTRING(@SqlValue, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsPunctuation(@SqlChar) = 1 RETURN 1;
	END
	-- 返回结果
	RETURN 0;
END
GO

