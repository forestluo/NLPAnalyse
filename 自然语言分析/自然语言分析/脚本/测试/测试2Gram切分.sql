USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

--SET @SqlContent = '他从马上跳下来';

-- 声明临时变量
DECLARE @SqlPosition INT;
DECLARE @SqlValue UString;

-- 打印结果
PRINT '测试基于NGram的切分> “' + @SqlContent + '”';

-- 设置初始值
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
		-- 打印结果
		PRINT '> ' + NCHAR(9) + @SqlValue; BREAK;
	END
	-- 获得当前字符
	SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, 2);

	-- 查询结果
	IF NOT EXISTS
		(SELECT * FROM dbo.Grammar2
		WHERE content = @SqlValue AND invalid = 0)
	BEGIN
		-- 打印结果
		PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 1);
	END
	ELSE
	BEGIN
		-- 检查当前位置
		IF @SqlPosition + 2 > LEN(@SqlContent)
		BEGIN
			-- 打印结果
			PRINT '> ' + NCHAR(9) + @SqlValue; BREAK;
		END

		-- 获得更长字符
		SET @SqlValue =
			SUBSTRING(@SqlContent, @SqlPosition, 3);
		-- 检查结果
		IF NOT EXISTS
			(SELECT * FROM dbo.Grammar2
			WHERE content = RIGHT(@SqlValue, 2) AND invalid = 0)
		BEGIN
			-- 修改位置
			SET @SqlPosition = @SqlPosition + 1;
			-- 打印结果
			PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 2);
		END
		ELSE
		BEGIN
			-- 对比结果
			IF dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 1) + '|' + RIGHT(@SqlValue, 2))
				>= dbo.GrammarGetAlphaValue(LEFT(@SqlValue, 2) + '|' + RIGHT(@SqlValue, 1))
			BEGIN
				-- 打印结果
				PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 1);
			END
			ELSE
			BEGIN
				-- 修改位置
				SET @SqlPosition = @SqlPosition + 1;
				-- 打印结果
				PRINT '> ' + NCHAR(9) + LEFT(@SqlValue, 2);
			END
		END
	END
END
