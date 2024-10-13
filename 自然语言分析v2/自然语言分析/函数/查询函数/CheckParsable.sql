USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[CheckParsable]    Script Date: 2020/12/6 10:39:45 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<是否可以进行解析>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[CheckParsable]
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

	-- 检查变量
	IF @SqlValue IS NULL OR
		LEN(@SqlValue) <= 0 RETURN 0;
	-- 转为小写
	SET @SqlValue = LOWER(@SqlValue);
	-- 设置初始值
	SET @SqlPosition = 1;
	-- 循环处理
	WHILE @SqlPosition <= LEN(@SqlValue)
	BEGIN
		-- 获得一个字符
		SET @SqlChar =
			SUBSTRING(@SqlValue, @SqlPosition, 1);
		-- 设置计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 检查是否为标点符号
		-- 跳过可识别的标点符号
		IF dbo.IsPunctuation(@SqlChar) = 1 CONTINUE;
		-- 检查这个字符是否存在
		IF NOT EXISTS (SELECT TOP 1 *
			FROM dbo.InnerContent WHERE content = @SqlChar) RETURN 0;
	END
	-- 返回成功
	RETURN 1;
END
GO

