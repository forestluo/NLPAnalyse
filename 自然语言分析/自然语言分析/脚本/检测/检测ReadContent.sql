USE [nldb]
GO

DECLARE @SqlTID INT;
SELECT @SqlTID = MAX(TID) FROM dbo.TextPool;
SET @SqlTID = ROUND(@SqlTID * RAND(), 0);
-- SET @SqlTID = 2746456;

DECLARE @SqlText UString;
SELECT @SqlText = content FROM dbo.TextPool WHERE tid = @SqlTID;

SET @SqlText = '当谈到红歌时，他坦然一笑：“其实红歌范围很广，积极健康的通俗歌曲咱都能唱，摇滚、Ｒ＆Ｂ也不在话下。”';

--PRINT 'Text Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlText));
--PRINT 'Text Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlText));

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlFilters XML;
-- 加载所有过滤规则
SET @SqlFilters = dbo.LoadFilterRules();
-- 检查结果
IF @SqlFilters IS NULL
BEGIN
	-- 打印提示
	PRINT '检测ReadContent> 无法加载过滤规则！'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlRegulars XML;
-- 加载所有正则规则
SET @SqlRegulars = dbo.LoadRegularRules();
-- 检查结果
IF @SqlRegulars IS NULL
BEGIN
	-- 打印提示
	PRINT '检测ReadContent> 无法加载正则规则！'; GOTO END_OF_EXECUTION;
END

-- 对原始内容进行预处理
-- 先执行转义
SET @SqlText = dbo.XMLUnescape(@SqlText);
-- 替换多余的标点
SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);
-- 打印消息
PRINT '检测ReadContent(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> {' + @SqlText + '}';

DECLARE @SqlExpressions XML;
-- 提取所有正则表达式
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);
-- 查看表达式
-- SELECT @SqlExpressions;

-- 剪除无效字符
SET @SqlText = dbo.LeftTrim(@SqlText);
-- 检查结果
IF @SqlText IS NULL OR LEN(@SqlText) <= 0
BEGIN
	-- 打印消息
	PRINT '检测ReadContent(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 无内容！'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '检测ReadContent> 进入正常状态！';

--PRINT 'Text Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlText));
--PRINT 'Text Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlText));
DECLARE @SqlContent UString = TRIM(@SqlText);
--PRINT 'Content Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlContent));
--PRINT 'Content Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlContent));

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
	DECLARE @SqlExpression UString;

	-- 检查变量
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- 返回结果
		PRINT '<result id="-1">content is null</result>'; GOTO END_OF_EXECUTION;
	END

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
		-- 检查当前表达式
		IF @SqlExpressions IS NOT NULL
		BEGIN
			-- 获得当前所处表达式
			SET @SqlExpression =
				dbo.IsInsideExpression(@SqlExpressions, @SqlPosition);
			-- 如果正好处于某个表达式开头的位置
			IF @SqlExpression IS NOT NULL
			BEGIN
				-- 检查标记位
				-- 正在处理VAR
				IF @SqlVarType = 2
				-- 继续按照VAR处理，跳过一定的内容
				BEGIN
					-- 设置内容
					SET @SqlValue = @SqlValue + @SqlExpression;
				END
				ELSE
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
					SET @SqlValue = @SqlExpression;
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
				-- 跳过表达式的内容
				SET @SqlPosition = @SqlPosition + LEN(@SqlExpression) - 1; CONTINUE;
			END
		END
		-- 获得当前字符
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsPunctuation(@SqlChar) = 1
		-- 标点符号
		BEGIN
			-- 检查索引值
			IF @SqlIndex >= 26 BREAK;
			-- 检查标记位
			IF @SqlVarType <> 1
			BEGIN
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
	-- PRINT @SqlResult;
	-- 设置返回值
	SET @SqlResult = '<result id="1" start="1" end="'+
		CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
		'<rule>' + @SqlRule + '</rule>' + @SqlResult + '</result>';
	-- PRINT @SqlResult;
	-- 转换成XML
	SET @SqlXML = CONVERT(XML, @SqlResult);
	-- 删除内容为空的var节点
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	-- 返回结果
	PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
END

END
ELSE
BEGIN

PRINT '检测ReadContent> 进入Debug状态！';

END

END_OF_EXECUTION:
/*你的SQL脚本结束*/
PRINT '检测ReadContent> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
