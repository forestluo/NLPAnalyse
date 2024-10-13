USE [nldb]
GO

DECLARE @SqlResult XML;
DECLARE @SqlContent UString;

SET @SqlContent = '更多内容大家可以到“第一彩＂上关注实战方案。本期分析：双胆关注３６，组合关注３７ ３８ ６７ ６８，和值关注１６ １４点。跨度关注４ ６。本期关注十个差２．４的值，关注１４搭配今日二码组合。关注中位上出现３或６。关注个位上的号码出现７或８．在二码差方面重点关注１，３．所谓组选二码差就是开奖号码中，任意两个号码相减等于１的值或者３的值。 关注 ３３５ ６６１ ６６２ ６８０ １４６ １３４ １７１这样组选类型的号码，特别关注１４６展现，关注胆６的出现。定位方面：百位９３８５６十位４５８６９个位７２３８６做出实战方案，请到“第一彩”购彩，理性看待分析。以上分析仅供参考';

BEGIN
	-- 声明临时变量
	DECLARE @SqlCount INT;

	DECLARE @SqlRule UString;
	DECLARE @SqlMatchRule UString;
	DECLARE @SqlReduceRule UString;

	DECLARE @SqlSentence UString;
	DECLARE @SqlClassification UString;

	-- 声明临时表变量
	DECLARE @SqlTable UReduceTable;

	-- 检查参数
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- 返回结果
		SET @SqlResult = '<result id="-1">input is null</result>';
		GOTO END_OF_FUNCTION;
	END
	--------------------------------------------------------------------------------
	--
	-- 剪除内容左侧的字符。
	--
	--------------------------------------------------------------------------------
	-- 剪除无效字符
	SET @SqlContent = dbo.LeftTrim(@SqlContent);
	-- 检查结果
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- 返回结果
		SET @SqlResult = '<result id="-2">input is null after trimed</result>';
		GOTO END_OF_FUNCTION;
	END
	--------------------------------------------------------------------------------
	--
	-- 按照最大容量读取一段内容（其中能容纳一个齐头开始的句子）。
	--
	--------------------------------------------------------------------------------
	-- 读取一段内容，生成相关结果
	SET @SqlResult = dbo.XMLReadContent(@SqlContent);
	-- 检查结果
	IF @SqlResult IS NULL OR
		ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- 返回结果
		SET @SqlResult = '<result id="-2">fail to read content</result>';
		GOTO END_OF_FUNCTION;
	END
	-- 获得规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- 返回结果
		SET @SqlResult = '<result id="-3">fail to get rule</result>';
		GOTO END_OF_FUNCTION;
	END

	--------------------------------------------------------------------------------
	--
	-- 创建规则历史记录表。
	--
	--------------------------------------------------------------------------------
	-- 设置初始值
	SET @SqlCount = 0;
	SET @SqlSentence = @SqlContent;

	-- 循环处理
	WHILE @SqlResult IS NOT NULL AND @SqlRule IS NOT NULL
	BEGIN
		--------------------------------------------------------------------------------
		--
		-- 检查当前整体规则，类别不为空或者为自身均可以。
		--
		--------------------------------------------------------------------------------
		PRINT 'Rule = ' + @SqlRule;
		-- 检查当前规则状态
		SET @SqlClassification =
			dbo.GetClassification(@SqlRule);
		-- 检查结果
		-- 本内容自身就可以在规则库中匹配到
		IF @SqlRule IN ('$a', '$a，', '$a：') OR
			@SqlClassification IN ('拼接', '配对', '通用')
		BEGIN
			-- 设置计数器
			SET @SqlCount = @SqlCount + 1;
			-- 插入原始记录
			INSERT INTO @SqlTable
				(id, parse_rule) VALUES (@SqlCount, @SqlRule);
			-- 返回结果
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + 
				dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
		ELSE
		BEGIN
			-- 设置计数器
			SET @SqlCount = @SqlCount + 1;
			-- 插入原始记录
			INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlRule);
		END

		--------------------------------------------------------------------------------
		--
		-- 可以直接匹配。
		--
		--------------------------------------------------------------------------------
		PRINT 'MatchSentenceRule';
		-- 直接匹配单句
		SET @SqlMatchRule = dbo.MatchSentenceRule(@SqlRule);
		-- 检查结果
		IF @SqlMatchRule IS NOT NULL
		BEGIN
			PRINT 'Matche Rule = ' + @SqlMatchRule;
			PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
			-- 设置计数器
			SET @SqlCount = @SqlCount + 1;
			-- 插入原始记录
			INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlMatchRule);
			-- 要把所有的内容组装起来
			SET @SqlSentence = dbo.XMLGetSentence(@SqlResult, @SqlMatchRule);
			-- 返回结果
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END

		--------------------------------------------------------------------------------
		--
		-- 对规则进行简化，简化至可以直接识别为止。
		--
		--------------------------------------------------------------------------------
		PRINT 'GetReduceRule';
		-- 获取化简规则
		SET @SqlReduceRule = dbo.MatchReduceRule(@SqlRule);
		-- 检查结果
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0
		BEGIN
			-- 返回结果
			SET @SqlResult = '<result id="-7">fail to reduce' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
		PRINT 'Reduce Rule = ' + @SqlReduceRule;
		-- 设置计数器
		SET @SqlCount = @SqlCount + 1;
		-- 插入原始记录
		INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlReduceRule);

		-- 对结果进行化简
		SET @SqlResult = dbo.XMLGetReducedResult(@SqlResult, @SqlReduceRule);
		-- 检查结果
		-- 无法获得相应的简化结果
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
		BEGIN
			-- 返回结果
			SET @SqlResult = '<result id="-8">reduced result is null' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END

		--------------------------------------------------------------------------------
		--
		-- 用于简化的的规则本身就是单句（单句要求齐头开始解析）。
		--
		--------------------------------------------------------------------------------
		-- 检查类型
		SET @SqlClassification = dbo.GetClassification(@SqlReduceRule);
		-- 检查结果
		IF @SqlClassification = '单句'
		BEGIN
			-- 获得句子内容
			SET @SqlSentence =
				@SqlResult.value('(//result/var[@name="a"]/text())[1]', 'nvarchar(max)');
			-- 检查结果
			IF @SqlSentence IS NULL OR LEN(@SqlSentence) <= 0
			BEGIN
				-- 返回结果
				SET @SqlResult = '<result id="1">sentence is null' +
					dbo.FormatRules(@SqlTable) + '</result>';
				GOTO END_OF_FUNCTION;
			END
			-- 获得应当化简部分的内容
			SET @SqlSentence = dbo.XMLGetSentence(@SqlResult, @SqlReduceRule);
			-- 返回结果
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END

		--------------------------------------------------------------------------------
		--
		-- 获得简化后的规则。
		--
		--------------------------------------------------------------------------------
		-- 获得简化后的规则
		SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
		-- 检查结果
		IF @SqlRule IS NULL AND LEN(@SqlRule) <= 0
		BEGIN
			-- 返回结果
			SET @SqlResult = '<result id="-9">fail to reduce' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
	END
	-- 返回结果
	SET @SqlResult = '<result id="-10">something cannot be reduced' + dbo.FormatRules(@SqlTable) + '</result>';
END
END_OF_FUNCTION:
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
GO
