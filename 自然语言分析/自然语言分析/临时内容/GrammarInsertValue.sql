USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月26日>
-- Description:	<加入内容全连通语法>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[GrammarInsertValue]
	-- Add the parameters for the stored procedure here
	@SqlMaxLength INT,
	@SqlContent UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;

	DECLARE @SqlAlpha FLOAT;
	DECLARE @SqlLeftLength INT;
	DECLARE @SqlRightLength INT;
	DECLARE @SqlLeftValue UString;
	DECLARE @SqlRightValue UString;

	-- 检查输入参数
	IF @SqlMaxLength < 1 RETURN 0;
	-- 检查输入参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN 0;

	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition <= LEN(@SqlContent) + 1
	BEGIN
		-- 检查位置
		-- 处于开头位置
		IF @SqlPosition = 0
		BEGIN
			-- 更新位置
			SET @SqlPosition = @SqlPosition + 1;

			---- 设置初始值
			--SET @SqlLength = 0;
			---- 循环处理
			--WHILE @SqlLength < @SqlMaxLength AND @SqlLength <= LEN(@SqlContent)
			--BEGIN
			--	-- 计数器
			--	SET @SqlLength = @SqlLength + 1;
			--	-- 获得字符串
			--	SET @SqlValue = LEFT(@SqlContent, @SqlLength);

			--	-- 更新记录
			--	UPDATE dbo.Grammar
			--		SET count = count + 1
			--		WHERE left_content IS NULL AND right_content = @SqlValue;
			--	-- 检查结果
			--	IF @@ROWCOUNT <= 0
			--		-- 插入新的记录
			--		INSERT dbo.Grammar (content, right_content)	VALUES (@SqlValue, @SqlValue);
			--END
		END
		-- 处于结尾位置
		ELSE IF @SqlPosition = LEN(@SqlContent) + 1
		BEGIN
			-- 更新位置
			SET @SqlPosition = @SqlPosition + 1;

			---- 设置初始值
			--SET @SqlLength = 0;
			---- 循环处理
			--WHILE @SqlLength < @SqlMaxLength AND @SqlLength <= LEN(@SqlContent)
			--BEGIN
			--	-- 计数器
			--	SET @SqlLength = @SqlLength + 1;
			--	-- 获得字符串
			--	SET @SqlValue = RIGHT(@SqlContent, @SqlLength);

			--	-- 更新记录
			--	UPDATE dbo.Grammar
			--		SET count = count + 1
			--		WHERE right_content IS NULL AND left_content = @SqlValue;
			--	-- 检查结果
			--	IF @@ROWCOUNT <= 0
			--		-- 插入新的记录
			--		INSERT dbo.Grammar (content, left_content) VALUES (@SqlValue, @SqlValue);
			--END
		END
		-- 处于中间位置
		ELSE
		BEGIN
			-- 设置初始值
			SET @SqlLeftLength = 0;
			-- 循环处理
			WHILE @SqlLeftLength < @SqlMaxLength AND @SqlLeftLength < LEN(@SqlContent)
			BEGIN
				-- 计数器
				SET @SqlLeftLength = @SqlLeftLength + 1;
				-- 获得字符串
				SET @SqlLeftValue = SUBSTRING(@SqlContent, @SqlPosition, @SqlLeftLength);

				-- 设置初始值
				SET @SqlRightLength = 0;
				-- 循环处理
				WHILE @SqlRightLength < @SqlMaxLength AND
					@SqlPosition + @SqlLeftLength + @SqlRightLength <= LEN(@SqlContent)
				BEGIN
					-- 计数器
					SET @SqlRightLength = @SqlRightLength + 1;
					-- 获得字符串
					SET @SqlRightValue =
						SUBSTRING(@SqlContent, @SqlPosition + @SqlLeftLength, @SqlRightLength);

					-- 更新记录
					UPDATE dbo.Grammar SET count = count + 1
						WHERE left_content = @SqlLeftValue AND right_content = @SqlRightValue;
					-- 检查结果
					IF @@ROWCOUNT <= 0
					BEGIN
						-- 获得相关系数
						-- SET @SqlAlpha = dbo.GetAlphaValue(@SqlLeftValue,@SqlRightValue);
						-- 检查结果
						-- IF @SqlAlpha > 0
						INSERT dbo.Grammar (count, content, left_content, right_content)
							VALUES (1, @SqlLeftValue + @SqlRightValue, @SqlLeftValue, @SqlRightValue);
					END
				END						
			END
			-- 更新位置
			SET @SqlPosition = @SqlPosition + 1;
		END
	END
END
GO
