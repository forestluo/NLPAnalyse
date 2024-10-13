USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月6日>
-- Description:	<获得平均相关系数>
-- =============================================

CREATE OR ALTER FUNCTION GrammarGetAlphaAverage
(
	-- Add the parameters for the function here
	@SqlPosition INT,
	@SqlContent UString,
	@SqlException UString
)
RETURNS FLOAT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlValue FLOAT;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;

	-- 设置初始值
	SET @SqlValue = -1.0;
	-- 检查参数
	IF @SqlPosition < 0
	BEGIN
		-- 检查长度
		IF LEN(@SqlContent) = 1
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 2
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 3
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
	END
	ELSE IF @SqlPosition > 0
	BEGIN
		-- 检查长度
		IF LEN(@SqlContent) = 1
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 2
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 3
		BEGIN
			-- 检查参数
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- 查询结果
				SELECT
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
	END
	ELSE
	BEGIN
		-- 检查长度
		IF LEN(@SqlContent) = 1
			-- 设置结果
			SET @SqlValue = 1.0;
		ELSE IF LEN(@SqlContent) = 2
			-- 查询结果
			SELECT @SqlValue = alpha
			FROM
			(
				SELECT alpha, invalid, enable
					FROM dbo.Grammar2 WHERE content = @SqlContent
			) AS T WHERE NOT (invalid = 1 AND enable = 0);
		ELSE IF LEN(@SqlContent) = 3
			-- 查询结果
			SELECT @SqlValue = SUM(alpha * count) / SUM(count)
			FROM 
			(
				SELECT alpha, count, invalid, enable
					FROM dbo.Grammar3 WHERE content = @SqlContent
			) AS T WHERE count > 0 AND alpha > 0 AND NOT (invalid = 1 AND enable = 0);
		ELSE IF LEN(@SqlContent) = 4
			-- 查询结果
			SELECT @SqlValue = SUM(alpha * count) / SUM(count)
			FROM 
			(
				SELECT alpha, count, invalid, enable
					FROM dbo.Grammar4 WHERE content = @SqlContent
			) AS T WHERE count > 0 AND alpha > 0 AND NOT (invalid = 1 AND enable = 0);
	END
	-- 返回结果
	RETURN ISNULL(@SqlValue, -1.0);
END
GO

