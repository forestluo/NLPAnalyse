USE [nldb]
GO

-- Add the parameters for the function here
DECLARE @SqlResult XML ;
DECLARE @SqlReduceRule UString;

-- 设置简化规则
SET @SqlReduceRule = '$a，$b';
-- 读取一段内容，生成相关结果
SET @SqlResult = dbo.XMLReadContent('　雷:您是说哪一方面, 主公?');
PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

BEGIN
	-- 声明临时变量
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;

	DECLARE @SqlCRule UString;
	DECLARE @SqlCReduceRule UString;
	DECLARE @SqlClassification UString;

	-- 检查参数
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	-- 检查参数
	IF @SqlReduceRule IS NULL OR
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION;
	-- 获得清理后的简化规则
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	
	PRINT 'Step 1';

	-- 获得基本规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION;
	-- 获得清理后的原始规则
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);

	PRINT 'Step 2';
	PRINT 'ReduceRule = ' + @SqlCReduceRule;
	PRINT 'Rule = ' + @SqlCRule;
	-- 检查匹配关系
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- 检查结果
	-- 两者之间不存在匹配关系
	-- 当然匹配关系也可能存在不止一处位置
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION;
	-- 获得化简规则的分类
	SET @SqlClassification =
		dbo.GetClassification(@SqlReduceRule);
	-- 单句必须从内容头部开始处理
	IF @SqlClassification = '单句' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION;

	PRINT 'Step 3';

	---- 声明临时变量
	--DECLARE @SqlCount INT;
	--DECLARE @SqlChar UChar;
	--DECLARE @SqlValue UString;

	-- 定义临时表
	DECLARE @SqlTable UParseTable;
	DECLARE @SqlResultTable UParseTable;

	-- 声明临时变量
	--DECLARE @SqlType INT;
	--DECLARE @SqlID INT = 0;
	--DECLARE @SqlIndex INT = 0;
	--DECLARE @SqlCurrent INT = 0;


	-- 先将内容选择插入至临时表
	INSERT INTO @SqlTable
		(id, type, name, pos, value)
		SELECT nodeID, nodeType, nodeName, nodePos, nodeValue FROM
		(
			SELECT
				Nodes.value('(@id)[1]','int') AS nodeID,
				Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
				Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
				Nodes.value('(@pos)[1]', 'int') AS nodePos,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
				FROM @SqlResult.nodes('//result/*') AS N(Nodes)
		) AS NodesTable WHERE nodeID IS NOT NULL ORDER BY nodeID;

	SELECT * FROM @SqlTable;

	DECLARE @SqlEndPosition INT;
	
	SET @SqlPosition = 1;
	SET @SqlEndPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition);

	WHILE @SqlPosition > 0
	BEGIN
		-- 拷贝前面的数值
		INSERT INTO @SqlResultTable
			SELECT * FROM @SqlTable
			WHERE id >= @SqlPosition AND id < @SqlEndPosition;

		-- SELECT * FROM @SqlResultTable;

		IF @SqlEndPosition = LEN(@SqlCRule) BREAK;

		-- 定义临时变量
		DECLARE @SqlValue UString;
		SET @SqlValue = 
			(SELECT ISNULL(value,'') + '' FROM @SqlTable
				WHERE id >= @SqlEndPosition AND id < @SqlEndPosition + LEN(@SqlCReduceRule) FOR XML PATH(''));
		PRINT 'Value = ' + @SqlValue;

		DECLARE @SqlID INT = 0;
		SELECT @SqlID = MAX(id) FROM @SqlResultTable;
		INSERT INTO @SqlResultTable
			(id, type, name, seg, pos, value)
			VALUES
			(@SqlID + 1, 'var', '*', 1, 0, @SqlValue);

		-- 设置位置
		SET @SqlPosition = @SqlEndPosition + LEN(@SqlCReduceRule);
		SET @SqlEndPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition);
		IF @SqlEndPosition <= 0 SET @SqlEndPosition = LEN(@SqlCRule);
	END

	

	--DECLARE @SqlID INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlSegment INT;
	DECLARE @SqlType UString;
	DECLARE @SqlName UString;
	--DECLARE @SqlValue UString;

	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlPosition = 1;
	-- 声明静态游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, type, name, value FROM @SqlResultTable
	-- 打开游标
	OPEN SqlCursor;
	-- 获取一行记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;
	-- 检查结果
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount + 1;
		-- 检查类型
		IF @SqlType = 'pad'
		BEGIN
			UPDATE @SqlResultTable
				SET id = @SqlCount, pos = @SqlPosition WHERE id = @SqlID;
		END
		ELSE IF @SqlType = 'var'
		BEGIN
			-- 设置计数器
			SET @SqlIndex = @SqlIndex + 1;
			
			UPDATE @SqlResultTable
				SET id = @SqlCount, pos = @SqlPosition, name = dbo.GetLowercase(@SqlIndex) WHERE id = @SqlID;
		END
		IF @SqlValue IS NOT NULL
			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
			
		-- 获取一行记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;

	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;
	
SELECT * FROM @SqlResultTable;

		SET @SqlValue = 
			(SELECT '<' + type + ' ' + 
				'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
				IsNull('name="' + name + '" ','') +
				'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' +
				value + '</' + type + '>'
				FROM @SqlResultTable
				FOR XML PATH(''));
		PRINT 'Value = ' + dbo.HTMLUnescape(@SqlValue);


--	-- 获得所有参量的数量
--	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
--DOIT_AGAIN:
--	-- 设置初始值
--	SET @SqlType = 0;
--	-- 循环处理
--	WHILE @SqlCurrent < @SqlPosition - 1
--	BEGIN
--		-- 设置计数器
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- 获得当前字符
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- 检查当前字符
--		IF @SqlChar <> '$'
--		BEGIN
--			-- 检查类型
--			IF @SqlType <> 1
--			BEGIN
--				-- 设置类型
--				SET @SqlType = 1;
--				-- 设置初始值
--				SET @SqlValue = '';
--			END
--			-- 增加一个字符
--			SET @SqlValue = @SqlValue + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- 检查类型
--			IF @SqlType <> 2
--			BEGIN
--				-- 设置类型
--				SET @SqlType = 2;
--				-- 检查结果
--				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--				BEGIN
--					-- 设置ID
--					SET @SqlID = @SqlID + 1;
--					-- 增加一个分隔符
--					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--				END
--			END
--			-- 设置索引值
--			SET @SqlIndex = @SqlIndex + 1;
--			-- 获得参数名
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- 获得参数内容
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- 检查结果
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			BEGIN
--				-- 设置ID
--				SET @SqlID = @SqlID + 1;
--				-- 增加一个变量
--				INSERT INTO @SqlResultTable (id , type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
--			END
--		END
--	END
--	-- 检查类型
--	IF @SqlType = 1
--	BEGIN
--		-- 检查结果
--		-- 增加一个分隔符
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--		BEGIN
--			-- 设置ID
--			SET @SqlID = @SqlID + 1;
--			-- 增加一个分隔符
--			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--		END
--	END

--	SELECT * FROM @SqlResultTable;

--	-- 声明临时变量
--	DECLARE @SqlSegment UString = '';
--	-- 设置初始值
--	SET @SqlPosition =
--		@SqlPosition + LEN(@SqlCReduceRule);
--	-- 循环处理
--	WHILE @SqlCurrent < @SqlPosition - 1
--	BEGIN
--		-- 设置计数器
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- 获得当前字符
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- 检查当前字符
--		IF @SqlChar <> '$'
--		BEGIN
--			-- 增加一个字符
--			SET @SqlSegment = @SqlSegment + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- 设置索引值
--			SET @SqlIndex = @SqlIndex + 1;
--			-- 获得参数名
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- 获得参数内容
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- 检查结果
--			-- 增加一个变量
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
--		END
--	END
--	-- 检查结果
--	-- 增加一个变量
--	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
--	BEGIN
--		-- 设置ID
--		SET @SqlID = @SqlID + 1;
--		-- 增加一个变量
--		INSERT INTO @SqlResultTable (id , type, seg, name, value) VALUES (@SqlID, 'var', 1, '*', @SqlSegment);
--	END

--	-- 检查下一处位置
--	IF CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition) > 0
--	BEGIN
--		-- 设置新位置
--		SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition); GOTO DOIT_AGAIN;
--	END

--	SELECT * FROM @SqlResultTable;

--	-- 设置初始值
--	SET @SqlType = 0;
--	SET @SqlValue = '';
--	-- 设置初始值
--	SET @SqlPosition = LEN(@SqlCRule);
--	-- 循环处理
--	WHILE @SqlCurrent < @SqlPosition
--	BEGIN
--		-- 设置计数器
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- 获得当前字符
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- 检查当前字符
--		IF @SqlChar <> '$'
--		BEGIN
--			-- 检查类型
--			IF @SqlType <> 1
--			BEGIN
--				-- 设置类型
--				SET @SqlType = 1;
--				-- 设置初始值
--				SET @SqlValue = '';
--			END
--			-- 增加一个字符
--			SET @SqlValue = @SqlValue + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- 检查类型
--			IF @SqlType <> 2
--			BEGIN
--				-- 设置类型
--				SET @SqlType = 2;
--				-- 检查结果
--				-- 增加一个分隔符
--				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--				BEGIN
--					-- 设置ID
--					SET @SqlID = @SqlID + 1;
--					-- 增加一个分隔符
--					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--				END
--			END
--			-- 设置索引值
--			SET @SqlIndex = @SqlIndex + 1;
--			-- 获得参数名
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- 获得参数内容
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- 检查结果
--			-- 增加一个变量
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			BEGIN
--				-- 设置ID
--				SET @SqlID = @SqlID + 1;
--				-- 增加一个变量
--				INSERT INTO @SqlResultTable (id , type, name, value) VALUES (@SqlID, 'var', @SqlChar, @SqlValue);
--			END
--		END
--	END
--	-- 检查类型
--	IF @SqlType = 1
--	BEGIN
--		-- 检查结果
--		-- 增加一个分隔符
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--		BEGIN
--			-- 设置ID
--			SET @SqlID = @SqlID + 1;
--			-- 增加一个分隔符
--			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--		END
--	END

--	-- 声明临时变量
--	DECLARE @SqlEndPosition INT;
--	DECLARE @SqlName UString;
--	DECLARE @SqlTypeName UString;
	DECLARE @SqlReduced UString = '';

--	-- 设置初始值
--	SET @SqlPosition = 1;
--	-- 声明静态游标
--	DECLARE SqlCursor CURSOR
--		STATIC FORWARD_ONLY LOCAL FOR 
--		SELECT id, type, name, value FROM @SqlResultTable
--		WHERE type = 'var' OR type = 'pad' ORDER BY id;
--	-- 打开游标
--	OPEN SqlCursor;
--	-- 获取一行记录
--	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
--	-- 检查结果
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		-- 更新位置
--		UPDATE @SqlResultTable
--			SET pos = @SqlPosition WHERE id = @SqlID;
--		-- 检查结果
--		-- 修改位置
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
--		-- 获得结果
--		SET @SqlReduced = @SqlReduced + '<' + @SqlTypeName + ' ' + 
--				'id="' + CONVERT(NVARCHAR(MAX), @SqlID) + '" ' +
--				IsNull('name="' + @SqlName + '" ','') +
--				'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
--				@SqlValue + '</' + @SqlType + '>';
--		-- 获取一行记录
--		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
--	END
--	-- 关闭游标
--	CLOSE SqlCursor;
--	-- 释放游标
--	DEALLOCATE SqlCursor;

--	-- 简化规则
--	SET @SqlCRule = REPLACE(@SqlCRule, @SqlCReduceRule, '$');
--	-- 恢复参数名
--	SET @SqlRule = dbo.RecoverParameters(@SqlCRule);

--	-- 获得开始位置
--	SELECT @SqlPosition = pos FROM @SqlResultTable
--		WHERE id IN (SELECT MIN(id) FROM @SqlResultTable);
--	-- 设置结束位置
--	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlResultTable
--		WHERE id IN (SELECT MAX(id) FROM @SqlResultTable);
--	-- 修改结束位置
--	-- 对可能存在转义内容的字符串求长度
--	SET @SqlEndPosition = @SqlEndPosition + dbo.GetLength(@SqlValue);

	-- 将结果记录插入到首个节点之中。
	--SET @SqlReduced = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
	--			'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' +
	--			'<rule>' + @SqlRule + '</rule>' + @SqlReduced + '</result>';
	-- 返回结果
	PRINT @SqlReduced;
END
END_OF_FUNCTION:
GO
