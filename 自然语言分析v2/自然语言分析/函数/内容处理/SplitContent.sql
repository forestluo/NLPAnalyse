USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[SplitContent]    Script Date: 2021/2/6 10:56:29 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月6日>
-- Description:	<将内容用表达式进行分割>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[SplitContent]
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlExpressions XML
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlXML XML;
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlVarType INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlName UString;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;

	DECLARE @SqlExpression XML;
	DECLARE @SqlType UString;
	DECLARE @SqlExpValue UString;

	-- 检查变量
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-1">content is null</result>');

	-- 设置初始值
	SET @SqlRule = '';
	SET @SqlResult = '';
	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlVarType = 0;

	-- 设置初始值
	SET @SqlPosition= 0;
	-- 循环处理
	WHILE @SqlIndex <= 26 AND @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 计数器加一
		SET @SqlPosition = @SqlPosition + 1;
		-- 检查当前表达式
		IF @SqlExpressions IS NOT NULL
		BEGIN
			-- 获得当前所处表达式
			SET @SqlExpression =
				dbo.GetInsideExpression(@SqlExpressions, @SqlPosition);
			-- 如果正好处于某个表达式开头的位置
			IF @SqlExpression IS NOT NULL
			BEGIN
				-- 检查标记位
				-- 正在处理VAR
				IF @SqlVarType = 2
				-- 结束前面的VAR，并加入Expression
				BEGIN
					-- 修改文本数值
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</var>';
				END
				ELSE IF @SqlVarType = 1
				BEGIN
					-- 修改文本数值
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</pad>';
				END
				-- 设置初始值
				SET @SqlVarType = 0;

				-- 获得类型
				SET @SqlType = @SqlExpression.value('(//result/exp/@type)[1]', 'nvarchar(max)');
				-- 获得表达式内容
				SET @SqlExpValue = @SqlExpression.value('(//result/exp/text())[1]', 'nvarchar(max)');

				-- 设置标签数量
				SET @SqlCount = @SqlCount + 1;
				-- 增加节点
				SET @SqlResult = @SqlResult + '<exp ' +
					ISNULL('type="' + @SqlType + '" ', '') +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' + dbo.XMLEscape(@SqlExpValue) + '</exp>';

				-- 设置初始值
				SET @SqlValue = '';
				-- 相当于增加一个补丁
				SET @SqlRule = @SqlRule + ISNULL(@SqlExpValue, '');
				-- 跳过表达式的内容
				SET @SqlPosition = @SqlPosition + ISNULL(LEN(@SqlExpValue), 0) - 1; CONTINUE;
			END
		END
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsPunctuation(@SqlChar) = 1
		-- 标点符号
		BEGIN
			-- 检查索引值
			IF @SqlIndex >= 26 BREAK;
			-- 检查标记位
			IF @SqlVarType <> 1
			BEGIN
				-- 检查标记位
				IF @SqlVarType = 2
				BEGIN
					IF LEN(@SqlValue) <= 0
					BEGIN
						-- 设置标签值
						SET @SqlIndex = @SqlIndex - 1;
						SET @SqlCount = @SqlCount - 1;
						SET @SqlRule = REPLACE(@SqlRule, '$' + @SqlName, '');
					END
					-- 修改文本数值
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</var>';
				END
				-- 设置标记位
				SET @SqlVarType = 1;

				-- 设置初始值
				SET @SqlValue = '';
				-- 设置标签数量
				SET @SqlCount = @SqlCount + 1;
				-- 增加节点
				SET @SqlResult = @SqlResult + '<pad ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
			END
			-- 增加一个字符
			SET @SqlRule = @SqlRule + @SqlChar;
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		-- 文本内容
		BEGIN
			-- 检查标记位
			IF @SqlVarType <> 2
			BEGIN
				-- 检查标记
				IF @SqlVarType = 1
				BEGIN
					-- 修改文本数值
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</pad>';
				END
				-- 设置标记位
				SET @SqlVarType = 2;

				-- 设置初始值
				SET @SqlValue = '';
				-- 设置标签数量
				SET @SqlCount = @SqlCount + 1;
				SET @SqlIndex = @SqlIndex + 1;
				-- 获得参数名
				SET @SqlName = dbo.GetLowercase(@SqlIndex);
				-- 增加一个参数
				SET @SqlRule = @SqlRule + '$' + @SqlName;
				-- 增加节点
				SET @SqlResult = @SqlResult + '<var name="' + @SqlName + '" ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
			END
			-- 增加一个字符
			SET @SqlValue = @SqlValue + @SqlChar;
		END
	END
	-- 结尾位置
	SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
	-- 修改文本数值
	SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) +
		CASE @SqlVarType WHEN 1 THEN '</pad>' WHEN 2 THEN '</var>' ELSE '' END;
	-- 设置返回值
	SET @SqlResult = '<result id="1" start="1" end="'+
		CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
		'<rule>' + @SqlRule + '</rule>' + @SqlResult + '</result>';
	-- 转换成XML
	SET @SqlXML = CONVERT(XML, @SqlResult);
	-- 删除内容为空的var节点
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	-- 返回结果
	RETURN @SqlXML;
END
GO
