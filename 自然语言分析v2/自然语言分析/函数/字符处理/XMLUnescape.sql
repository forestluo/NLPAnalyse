USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[XMLUnescape]    Script Date: 2020/12/6 9:53:31 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月4日>
-- Description:	<对字符进行转义还原>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[XMLUnescape]
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlLength INT;
	DECLARE @SqlUnicode INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlEndPosition INT;
	DECLARE @SqlEscaped UString;

	-- 将字符串转义还原
	SET @SqlValue = REPLACE(@SqlValue, '&lt;', '<');
	SET @SqlValue = REPLACE(@SqlValue, '&gt;', '>');
	SET @SqlValue = REPLACE(@SqlValue, '&nbsp;', ' ');
	SET @SqlValue = REPLACE(@SqlValue, '&quot;', '"');

	-- 获得第一个匹配的转义数值
	SET @SqlPosition = PATINDEX('%&#%[0-9];%', @SqlValue);
	-- 循环处理
	WHILE @SqlPosition >= 1
	BEGIN
		-- 找到结尾位置
		SET @SqlEndPosition =
			CHARINDEX(';', @SqlValue, @SqlPosition + 2);
		-- 检查结果
		IF @SqlEndPosition IS NULL
			OR @SqlEndPosition <= 0 BREAK;
		-- 获得长度
		SET @SqlLength = @SqlEndPosition - @SqlPosition - 2;
		-- 检查长度
		IF @SqlLength > 4 BREAK;
		-- 获得转义字符串
		SET @SqlEscaped =
			SUBSTRING(@SqlValue, @SqlPosition + 2, @SqlLength);
		-- 检查是否为数字
		IF PATINDEX('%[^0-9]%', @SqlEscaped) >= 1 BREAK;
		-- 转换成半角
		SET @SqlEscaped = dbo.LatinConvert(@SqlEscaped);
		-- 获得转义数值
		SET @SqlUnicode = CONVERT(INT, @SqlEscaped);
		-- 获得字符
		SET @SqlChar = NCHAR(@SqlUnicode);
		-- 替换
		SET @SqlValue = REPLACE(@SqlValue, '&#' + @SqlEscaped + ';', @SqlChar);
		-- 获得新位置
		SET @SqlPosition = PATINDEX('%&#%[0-9];%', @SqlValue);
	END

	-- 最后处理该转义
	SET @SqlValue = REPLACE(@SqlValue, '&amp;', '&');
	-- 将字符串转义还原
	RETURN @SqlValue;
END
GO

