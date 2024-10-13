USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月5日>
-- Description:	<读取一定的中文内容，并转换成识别表>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[ReadChinese]
(
	-- Add the parameters for the function here
	@SqlContent UString
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

	-- 检查变量
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
		-- 返回结果
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

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
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsChineseChar(@SqlChar) = 0
		-- 标点符号
		BEGIN
			-- 检查标记位
			IF @SqlVarType <> 1
			BEGIN
				-- 检查索引值
				IF @SqlIndex >= 26 BREAK;
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
		'<rule>' + dbo.XMLEscape(@SqlRule) + '</rule>' + @SqlResult + '</result>';
	-- 转换成XML
	SET @SqlXML = CONVERT(XML, @SqlResult);
	-- 删除内容为空的var节点
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	-- 返回结果
	RETURN @SqlXML;
END
GO
