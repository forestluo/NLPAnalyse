DECLARE @SqlContent UString = '“我们必须正视这个现实：全社会的资金配置，不仅不能说是最优，恐怕也不能说是次优，远远没有达到这个水平。要解决这些问题，在很大程度上就是证券行业和资本市场的责任了。 ”郭树清说。';

BEGIN
	-- 声明临时变量
	DECLARE @SqlXML XML;

	-- 声明临时变量
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
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 GOTO END_OF_FUNCTION;

	-- 设置初始值
	SET @SqlResult = '';
	SET @SqlXML = '<result id="1" start="1" end="0"><rule>&#x20;</rule></result>';

	-- 设置初始值
	SET @SqlRule = '';
	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlVarType = 0;

	-- 设置初始值
	SET @SqlPosition= 0;
	-- 循环处理
	WHILE @SqlIndex < 26 AND @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 计数器加一
		SET @SqlPosition = @SqlPosition + 1;
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsPunctuation(@SqlChar) = 1
		-- 标点符号
		BEGIN
			-- 检查标记位
			IF @SqlVarType <> 1
			BEGIN
				-- 检查标记位
				IF @SqlVarType = 2
				BEGIN
					-- 修改文本数值
					SET @SqlResult = @SqlResult + @SqlValue + '</var>';

					IF LEN(@SqlValue) <= 0
					BEGIN
						PRINT 'empty content';
						SET @SqlIndex = @SqlIndex - 1;
						SET @SqlCount = @SqlCount - 1;
						--SET @SqlRule = LEFT(@SqlRule, LEN(@SqlRule) - 2);
						SET @SqlRule = REPLACE(@SqlRule, '$' + @SqlName, '');
					END

					SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
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
				SET @SqlXML.modify('insert <pad id="256" pos="0">&#x20;</pad> as last into (//result[position()=1])[1]');
				SET @SqlXML.modify('replace value of (//result/pad[@id=256]/@id)[1] with sql:variable("@SqlCount")');
				SET @SqlXML.modify('replace value of (//result/pad[@id=sql:variable("@SqlCount")]/@pos)[1] with sql:variable("@SqlPosition")');
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
					SET @SqlResult = @SqlResult + @SqlValue + '</pad>';

					SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
				END
				-- 设置标记位
				SET @SqlVarType = 2;

				-- 设置初始值
				SET @SqlValue = '';
				-- 设置标签数量
				SET @SqlCount = @SqlCount + 1;
				SET @SqlIndex = @SqlIndex + 1;
				-- 获得参数名
				SET @SqlName =
					dbo.GetLowercase(@SqlIndex);
				-- 增加一个参数
				SET @SqlRule = @SqlRule + '$' + @SqlName;
				-- 增加节点
				SET @SqlResult = @SqlResult + '<var name="' + @SqlName + '" ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
				SET @SqlXML.modify('insert <var name="*" id="256" pos="0">&#x20;</var> as last into (//result[position()=1])[1]');
				SET @SqlXML.modify('replace value of (//result/var[@id=256]/@id)[1] with sql:variable("@SqlCount")');
				SET @SqlXML.modify('replace value of (//result/var[@id=sql:variable("@SqlCount")]/@name)[1] with sql:variable("@SqlName")');
				SET @SqlXML.modify('replace value of (//result/var[@id=sql:variable("@SqlCount")]/@pos)[1] with sql:variable("@SqlPosition")');
			END
			-- 增加一个字符
			SET @SqlValue = @SqlValue + @SqlChar;
		END
	END
	-- 检查标记位
	IF @SqlVarType = 1
	BEGIN
		-- 结尾位置
		SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- 修改文本数值
		SET @SqlResult = @SqlResult + @SqlValue + '</pad>';
		SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
	END
	ELSE IF @SqlVarType = 2
	BEGIN
		-- 结尾位置
		SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- 修改文本数值
		SET @SqlResult = @SqlResult + @SqlValue + '</var>';
		SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
	END
	
	-- 设置返回值
	SET @SqlResult = '<result id="1" start="1" end="'+
		CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
		'<rule>' + @SqlRule + '</rule>' + @SqlResult + '</result>';
	PRINT @SqlResult;

	SET @SqlXML = @SqlResult;
	-- 删除内容为空的pad节点
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
	-- 修改属性
	-- SET @SqlXML.modify('replace value of (//result/@end)[1] with sql:variable("@SqlPosition")');
	-- 修改文本数值
	-- SET @SqlXML.modify('replace value of (//result/rule[position()=1]/text())[1] with sql:variable("@SqlRule")');
	-- 返回结果
END
END_OF_FUNCTION:
GO
