DECLARE @SqlResult XML;
DECLARE @SqlReduceRule UString;

-- 设置简化规则
SET @SqlReduceRule = '$a（$b）';
-- 读取一段内容，生成相关结果
SET @SqlResult = dbo.XMLReadContent('“阶梯电价改革总算是迈出了艰难的一步。但是电价改革完全交给市场还很遥远，需要一步步来。即便未来电价由市场决定，政府还是要监管。”林伯强对记者表示。');
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
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION
	-- 获得清理后的简化规则
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	PRINT 'ReduceRule = ' + @SqlReduceRule;
	PRINT 'CReduceRule = ' + @SqlCReduceRule;
	
	-- 获得基本规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION
	-- 获得清理后的原始规则
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);
	PRINT 'Rule = ' + @SqlRule;
	PRINT 'CRule = ' + @SqlCRule;

	---- 设置初始值
	--SET @SqlClassification = NULL;
	---- 获得化简规则的分类
	--SELECT @SqlClassification = classification
	--	FROM dbo.ParseRule WHERE parse_rule = @SqlRule;
	---- 检查结果
	---- 已经匹配到单句，无需进一步处理
	--PRINT 'Classification = ' + @SqlClassification;
	--IF @SqlClassification = '单句' GOTO END_OF_FUNCTION;

	-- 检查匹配关系
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- 检查结果
	-- 两者之间不存在匹配关系
	-- 当然匹配关系也可能存在不止一处位置
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
	-- 设置初始值
	SET @SqlClassification = NULL;
	-- 获得化简规则的分类
	SELECT @SqlClassification = classification
		FROM dbo.ParseRule WHERE parse_rule = @SqlReduceRule;
	-- 检查结果
	PRINT 'Classification = ' + @SqlClassification;
	-- 单句必须从内容头部开始处理
	IF @SqlClassification = '单句' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION

	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlValue UString;

	DECLARE @SqlType INT;
	DECLARE @SqlIndex INT = 0;
	DECLARE @SqlCurrent INT = 0;
	DECLARE @SqlReduced UString = '';

	-- 获得所有参量的数量
	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
	PRINT 'SqlCount = ' + CONVERT(NVARCHAR(MAX), @SqlCount);
	PRINT '----------------------';
DOIT_AGAIN:
	-- 设置初始值
	SET @SqlType = 0;
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX), @SqlCurrent);
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
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
					-- 增加一个分隔符
					SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
			END
			-- 设置索引值
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			PRINT 'SqlChar = ' + @SqlChar;
			-- 获得参数内容
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
		END
		PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
		PRINT '-----------------------------';
	END
	-- 检查类型
	IF @SqlType = 1
	BEGIN
		-- 检查结果
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			-- 增加一个分隔符
			SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
	END
	PRINT 'SqlReduced = ' + @SqlReduced;

	-- 声明临时变量
	DECLARE @SqlSegment UString = '';
	-- 设置初始值
	SET @SqlPosition =
		@SqlPosition + LEN(@SqlCReduceRule);
	PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX), @SqlCurrent);
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		PRINT 'SqlChar = ' + @SqlChar;
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
			PRINT 'SqlName = ' + @SqlChar;
			-- 获得参数内容
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
		END
	END
	-- 检查结果
	-- 增加一个变量
	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
		SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlSegment + '</var>';
	PRINT 'SqlReduced = ' + @SqlReduced;

	-- 再次检查索引值
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
	PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX),@SqlCurrent);
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX),@SqlPosition);
	-- 循环处理
	WHILE @SqlCurrent < @SqlPosition
	BEGIN
		-- 设置计数器
		SET @SqlCurrent = @SqlCurrent + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		PRINT 'SqlChar = ' + @SqlChar;
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
					SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
			END
			-- 设置索引值
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			PRINT 'Name = ' + @SqlChar;
			-- 获得参数内容
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- 检查结果
			-- 增加一个变量
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
		END
	END
	-- 检查类型
	IF @SqlType = 1
	BEGIN
		-- 检查结果
		-- 增加一个分隔符
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
	END
	PRINT 'SqlReduced = ' + @SqlReduced;

	SET @SqlCRule = REPLACE(@SqlCRule, @SqlCReduceRule, '$');
	-- 恢复参数名
	SET @SqlRule = dbo.RecoverParameters(@SqlCRule);
	SET @SqlIndex = 0;
	PRINT 'SqlRule = ' + @SqlRule;

	SET @SqlReduced = '<result id="1" start="1" end="0">' + @SqlReduced + '</result>';
	SET @SqlResult = @SqlReduced;

	-- 获得节点数量
	SET @SqlCount = @SqlResult.value('count(//result/*)', 'int');

	-- 声明临时变量
	DECLARE @SqlID INT = 0;
	DECLARE @SqlName UString;

	-- 设置初始值
	SET @SqlPosition = 1;
	-- 循环处理
	WHILE @SqlID < @SqlCount
	BEGIN
		-- 设置计数器
		SET @SqlID = @SqlID + 1;
		-- 更改节点参数
		SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@pos)[1] with sql:variable("@SqlPosition")');
		
		-- 获得节点内容
		SET @SqlValue = @SqlResult.value('(//result/*[position()=sql:variable("@SqlID")]/text())[1]', 'nvarchar(max)');
		-- 检查结果
		-- 修改位置
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlPosition = @SqlPosition + LEN(@SqlValue);

		-- 获得本地名称
		SET @SqlName = @SqlResult.value('local-name((//result/*[position()=sql:variable("@SqlID")])[1])', 'nvarchar(max)');
		-- 检查本地名称
		IF @SqlName = 'pad'
		BEGIN
			-- 更改节点参数
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@id)[1] with sql:variable("@SqlID")');
		END
		ELSE IF @SqlName = 'var'
		BEGIN
			-- 设置索引
			SET @SqlIndex = @SqlIndex + 1;
			-- 获得参数名
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- 更改节点参数
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@id)[1] with sql:variable("@SqlID")');
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@name)[1] with sql:variable("@SqlChar")');
		END
	END

	-- 增加一个节点
	SET @SqlResult.modify('insert <rule>&#x20;</rule> as first into (//result)[1]');
	-- 更改节点数值
	SET @SqlResult.modify('replace value of (//result/@end)[1] with sql:variable("@SqlPosition")');
	SET @SqlResult.modify('replace value of (//result/rule/text())[1] with sql:variable("@SqlRule")');

	PRINT CONVERT(NVARCHAR(MAX),@SqlResult);
END

END_OF_FUNCTION:
	PRINT '脚本结束！';