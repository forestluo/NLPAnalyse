USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ConvertRule]    Script Date: 2020/12/6 10:52:22 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月29日>
-- Description:	<将匹配规则转换成XML对象>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ConvertRule]
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlType INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlName UChar;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;

	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0
		RETURN CONVERT(NVARCHAR(MAX), '<result id="-1"/>');
	-- 将规则内容进行转义处理
	SET @SqlRule = dbo.XMLEscape(@SqlRule);
	
	-- 设置初始值
	SET @SqlType = 0;
	SET @SqlCount = 0;
	SET @SqlResult = '';
	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlRule)
	BEGIN
		-- 修改计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlRule, @SqlPosition, 1);
		-- 检查当前字符
		IF @SqlChar <> '$'
		BEGIN
PADDINGS:
			-- 检查类型
			IF @SqlType <> 2
			BEGIN
				-- 设置类型
				SET @SqlType = 2;
				-- 设置初始值
				SET @SqlValue = '';
				-- 设置计数器
				SET @SqlCount = @SqlCount + 1;
			END
			-- 修改数值
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		BEGIN
			-- 检查位置
			IF @SqlPosition + 1 >
				LEN(@SqlRule) GOTO PADDINGS;
			-- 获得名称
			SET @SqlName =
				SUBSTRING(@SqlRule, @SqlPosition + 1, 1);
			-- 检查结果（参数名从a到z）
			IF dbo.IsLowercase(@SqlName) = 0 GOTO PADDINGS;

			-- 检查类型
			IF @SqlType <> 1
			BEGIN
				-- 检查类型
				IF @SqlType = 2
				BEGIN
					IF @SqlValue IS NULL
						OR LEN(@SqlValue) <= 0
					BEGIN
						-- 设置计数器
						SET @SqlCount = @SqlCount - 1;
					END
					ELSE
					BEGIN
						-- 修改结果
						SET @SqlResult = @SqlResult + '<pad id="' +
							CONVERT(NVARCHAR(MAX), @SqlCount) + '" pos="0">' + @SqlValue + '</pad>';
					END
				END
				-- 设置类型
				SET @SqlType = 1;
				-- 设置初始值
				SET @SqlValue = '';
			END
			-- 设置计数器
			SET @SqlCount = @SqlCount + 1;
			-- 修改计数器
			SET @SqlPosition = @SqlPosition + 1;
			-- 修改结果
			SET @SqlResult = @SqlResult +
				'<var name="'+ @SqlName + '" id="' +
				CONVERT(NVARCHAR(MAX), @SqlCount) + '" pos="0">$' + @SqlName + '</var>';
		END
	END
	-- 检查结果
	IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
	BEGIN
		-- 修改结果
		SET @SqlResult = @SqlResult + '<pad id="' +
			CONVERT(NVARCHAR(MAX), @SqlCount) + '" pos="0">' + @SqlValue + '</pad>';
	END
	-- 设置结果
	SET @SqlResult = '<result id="1" start="0" end="0">' + @SqlResult + '</result>';
	-- 返回结果
	RETURN CONVERT(XML, @SqlResult);
END
GO
