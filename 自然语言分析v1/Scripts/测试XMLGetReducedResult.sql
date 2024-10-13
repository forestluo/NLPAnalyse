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
-- Add the parameters for the function here
DECLARE @SqlResult XML;
DECLARE @SqlReduceRule UString;

SET @SqlResult = dbo.XMLReadContent('雷:您是说哪一方面, 主公?');
SET @SqlReduceRule = '$a“$b”$c';

BEGIN
	-- 声明临时变量
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;

	DECLARE @SqlCRule UString;
	DECLARE @SqlCReduceRule UString;

	-- 检查参数
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	-- 检查参数
	IF @SqlReduceRule IS NULL OR
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION;
	-- 获得清理后的简化规则
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	PRINT 'ReduceRule = ' + @SqlReduceRule;
	
	-- 获得基本规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION;
	-- 获得清理后的原始规则
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);
	PRINT 'Rule = ' + @SqlRule;

	-- 检查匹配关系
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- 检查结果
	-- 两者之间不存在匹配关系
	-- 当然匹配关系也可能存在不止一处位置
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION;

	-- 声明临时变量
	DECLARE @SqlClassification UString;
	-- 获得化简规则的分类
	SET @SqlClassification =
		dbo.GetClassification(@SqlReduceRule);
	-- 单句必须从内容头部开始处理
	IF @SqlClassification = '单句' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION;

	-- 定义临时表
	DECLARE @SqlTable UParseTable;
	DECLARE @SqlResultTable UParseTable;

	-- 先将全部内容选择插入至临时表
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

	PRINT 'CRule = ' + @SqlCRule;
	PRINT 'CReduceRule = ' + @SqlCReduceRule;

	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlValue UString;

	DECLARE @SqlType INT;
	DECLARE @SqlID INT = 0;
	DECLARE @SqlIndex INT = 0;
	DECLARE @SqlCurrent INT = 0;

	-- 获得所有参量的数量
	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
DOIT_AGAIN:
	-- 设置初始值
	SET @SqlType = 0;
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		-- 检查当前字符
		IF @SqlChar <> '$'
		BEGIN
			-- 检查类型
			IF @SqlType <> 1
			BEGIN
				-- 设置类型
				SET @SqlType = 1;
				-- 设置初始值
				SET @SqlValue = '';
			END
			-- 增加一个字符
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		BEGIN
			-- 检查类型
			IF @SqlType <> 2
			BEGIN
				-- 设置类型
				SET @SqlType = 2;
				-- 检查结果
				-- 增加一个分隔符
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				BEGIN
					SET @SqlID = @SqlID + 1;
					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
					--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
				END
			END
			-- 设置索引值
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- 获得参数内容
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			/*
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');*/
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				SET @SqlID = @SqlID + 1;
				INSERT INTO @SqlResultTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
				--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
			END
		END
	END
	-- 检查类型
	IF @SqlType = 1
	BEGIN
		-- 检查结果
		-- 增加一个分隔符
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			SET @SqlID = @SqlID + 1;
			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
			--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
		END
	END

	-- 声明临时变量
	DECLARE @SqlSegment UString = '';
	-- 设置初始值
	SET @SqlPosition =
		@SqlPosition + LEN(@SqlCReduceRule);
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		-- 检查当前字符
		IF @SqlChar <> '$'
		BEGIN
			-- 增加一个字符
			SET @SqlSegment = @SqlSegment + @SqlChar;
		END
		ELSE
		BEGIN
			-- 设置索引值
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- 获得参数内容
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			/*
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			*/
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
		END
	END
	-- 检查结果
	-- 增加一个变量
	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
	BEGIN
		SET @SqlID = @SqlID + 1;
		INSERT INTO @SqlResultTable (id, type, name, seg, value) VALUES (@SqlID, 'var', '*', 1, @SqlSegment);
		--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0" seg="1">' + @SqlSegment + '</var>';
	END

	-- 检查下一处位置
	IF CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition) > 0
	BEGIN
		-- 设置新位置
		SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition); GOTO DOIT_AGAIN;
	END

	-- 设置初始值
	SET @SqlType = 0;
	SET @SqlValue = '';
	-- 设置初始值
	SET @SqlPosition = LEN(@SqlCRule);
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		-- 检查当前字符
		IF @SqlChar <> '$'
		BEGIN
			-- 检查类型
			IF @SqlType <> 1
			BEGIN
				-- 设置类型
				SET @SqlType = 1;
				-- 设置初始值
				SET @SqlValue = '';
			END
			-- 增加一个字符
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		BEGIN
			-- 检查类型
			IF @SqlType <> 2
			BEGIN
				-- 设置类型
				SET @SqlType = 2;
				-- 检查结果
				-- 增加一个分隔符
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				BEGIN
					SET @SqlID = @SqlID + 1;
					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
					--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
				END
			END
			-- 设置索引值
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- 获得参数内容
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			-- 获得参数内容
			/*SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');*/
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				SET @SqlID = @SqlID + 1;
				INSERT INTO @SqlResultTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
				--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
			END
		END
	END
	-- 检查类型
	IF @SqlType = 1
	BEGIN
		-- 检查结果
		-- 增加一个分隔符
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			SET @SqlID = @SqlID + 1;
			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
			--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
		END
	END

	---- 声明临时变量
	DECLARE @SqlName UString;
	DECLARE @SqlTypeName UString;

	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlPosition = 1;
	-- 声明静态游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, type, name, value FROM @SqlResultTable
	-- 打开游标
	OPEN SqlCursor;
	-- 获取一行记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
	-- 检查结果
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount + 1;
		-- 检查类型
		IF @SqlTypeName = 'pad'
		BEGIN
			-- 更新编号和位置
			UPDATE @SqlResultTable
				SET pos = @SqlPosition WHERE id = @SqlID;
		END
		ELSE IF @SqlTypeName = 'var'
		BEGIN
			-- 设置计数器
			SET @SqlIndex = @SqlIndex + 1;
			-- 更新名称，编号和位置
			UPDATE @SqlResultTable
				SET pos = @SqlPosition,
					name = dbo.GetLowercase(@SqlIndex) WHERE id = @SqlID;
		END
		-- 检查内容
		IF @SqlValue IS NOT NULL
			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- 获取一行记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	SELECT * FROM @SqlResultTable;

	-- 声明临时变量
	DECLARE @SqlReduced UString;
	DECLARE @SqlEndPosition INT;
	-- 合并相关内容
	SET @SqlReduced = 
	(
		SELECT '<' + type + ' ' + 'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
		CASE seg WHEN 1 THEN 'seg="1" ' ELSE '' END +
		ISNULL('name="' + name + '" ','') +	'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' + value + '</' + type + '>'
		FROM @SqlResultTable FOR XML PATH('')
	);
	-- 转义
	SET @SqlReduced = dbo.XMLUnescape(@SqlReduced);
	-- 获得开始位置
	SELECT @SqlPosition = pos FROM @SqlResultTable
		WHERE id IN (SELECT MIN(id) FROM @SqlResultTable);
	-- 设置结束位置
	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlResultTable
		WHERE id IN (SELECT MAX(id) FROM @SqlResultTable);
	-- 修改结束位置
	-- 对可能存在转义内容的字符串求长度
	SET @SqlEndPosition = @SqlEndPosition + dbo.GetLength(@SqlValue);
	-- 增加规则
	SET @SqlReduced = '<rule>' +
		dbo.RecoverParameters(REPLACE(@SqlCRule, @SqlCReduceRule, '$')) + '</rule>' + @SqlReduced;
	-- 将结果记录插入到首个节点之中。
	SET @SqlReduced = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
				'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' + @SqlReduced + '</result>';
	-- 返回结果
	PRINT @SqlReduced;
END
END_OF_FUNCTION:
GO
