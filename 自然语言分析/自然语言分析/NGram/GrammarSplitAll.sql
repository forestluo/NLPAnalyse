USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月22日>
-- Description:	<基于NGram分割内容>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GrammarSplitAll]
(
	-- Add the parameters for the stored procedure here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 剪裁
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查参数
	IF @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	--  设置初始值
	SET @SqlResult = '';
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 修改位置
		SET @SqlPosition = @SqlPosition + 1;
		-- 检查当前位置
		IF @SqlPosition + 1 > LEN(@SqlContent)
		BEGIN
			-- 获得结果
			SET @SqlValue =
				SUBSTRING(@SqlContent, @SqlPosition, 1);
			-- 插入数据
			INSERT INTO @SqlTable
				(length, value, position)
				VALUES (LEN(@SqlValue), @SqlValue, @SqlPosition); BREAK;
		END
		-- 获得当前字符
		SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, 2);

		-- 查询结果
		IF NOT EXISTS
			(SELECT * FROM dbo.Grammar2
			WHERE content = @SqlValue AND invalid = 0)
		BEGIN
			-- 插入数据
			INSERT INTO @SqlTable
				(length, value, position)
				VALUES (1, LEFT(@SqlValue, 1), @SqlPosition);
		END
		ELSE
		BEGIN
			-- 检查当前位置
			IF @SqlPosition + 2 > LEN(@SqlContent)
			BEGIN
				-- 插入数据
				INSERT INTO @SqlTable
					(length, value, position)
					VALUES (LEN(@SqlValue), @SqlValue, @SqlPosition); BREAK;
			END

			-- 获得更长字符
			SET @SqlValue =
				SUBSTRING(@SqlContent, @SqlPosition, 3);
			-- 检查结果
			IF NOT EXISTS
				(SELECT * FROM dbo.Grammar2
				WHERE content = RIGHT(@SqlValue, 2) AND invalid = 0)
			BEGIN
				-- 插入数据
				INSERT INTO @SqlTable
					(length, value, position)
					VALUES (2, LEFT(@SqlValue, 2), @SqlPosition);
				-- 修改位置
				SET @SqlPosition = @SqlPosition + 1;
			END
			ELSE
			BEGIN
				-- 对比结果
				IF dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 1) + '|' + RIGHT(@SqlValue, 2))
					>= dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 2) + '|' + RIGHT(@SqlValue, 1))
				BEGIN
					-- 插入数据
					INSERT INTO @SqlTable
						(length, value, position)
						VALUES (1, LEFT(@SqlValue, 1), @SqlPosition);
				END
				ELSE
				BEGIN
					-- 插入数据
					INSERT INTO @SqlTable
						(length, value, position)
						VALUES (2, LEFT(@SqlValue, 2), @SqlPosition);
					-- 修改位置
					SET @SqlPosition = @SqlPosition + 1;
				END
			END
		END
	END

	-- 拼接内容
	SET @SqlResult = 
	(
		(
			SELECT '<var id="' + CONVERT(NVARCHAR(MAX), id) + '"' + 
				' pos="' + CONVERT(NVARCHAR(MAX), position) + '"' +
				' len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</var>'
			FROM @SqlTable FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- 获得总数
	SELECT @SqlPosition = COUNT(*) FROM @SqlTable;
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1" met="G2S" count="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' + @SqlResult + '</result>');
END