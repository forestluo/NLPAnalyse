USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

SET @SqlContent = '欧高峰论坛';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

PRINT '检测多层解析叠加状况> 进入正常状态！';

DECLARE @SqlResult XML;
DECLARE @SqlTable UMatchTable;

-------------------------------------------------------------------------------
--
-- 加载数量词正则规则
--
-------------------------------------------------------------------------------

DECLARE @SqlID INT;
DECLARE @SqlRule UString;
DECLARE @SqlValue UString;
DECLARE @SqlAttribute UString;

DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

SET @SqlValue = dbo.LatinConvert(@SqlContent);

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT
		Nodes.value('(@rid)[1]','int') AS nodeID,
		Nodes.value('(./regular/text())[1]', 'nvarchar(max)') AS nodeRule,
		Nodes.value('(./attribute/text())[1]', 'nvarchar(max)') AS nodeAttribute
		FROM @SqlRules.nodes('//result/rule') AS N(Nodes); 
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 实现XML转义
	SET @SqlRule = dbo.XMLUnescape(@SqlRule);
	-- 将Rule转换成半角
	SET @SqlRule = dbo.LatinConvert(@SqlRule);
	-- 将结果插入到新的记录表中
	INSERT INTO @SqlTable
		(expression, value, length , position)
		SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(@SqlRule, @SqlValue, 1);
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor;

-------------------------------------------------------------------------------
--
-- 正向最大切分（完全重复的仅保留一项）
--
-------------------------------------------------------------------------------

-- 正向最大切分
SET @SqlResult = dbo.FMMSplitAll(1, @SqlContent);
-- 插入到临时表中
INSERT INTO @SqlTable
	(expression, position, value, length)
	SELECT
		'FMM',
		ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
		Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
		ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
		FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

-------------------------------------------------------------------------------
--
-- 逆向最大切分（完全重复的仅保留一项）
--
-------------------------------------------------------------------------------

-- 逆向最大切分
SET @SqlResult = dbo.BMMSplitAll(1, @SqlContent);
-- 插入到临时表中
INSERT INTO @SqlTable
	(expression, position, value, length)
	SELECT
		'BMM',
		ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
		Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
		ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
		FROM @SqlResult.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;

-------------------------------------------------------------------------------
--
-- 加载结构分析
--
-------------------------------------------------------------------------------

DECLARE @SqlXML XML;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT rid, [rule]
		FROM dbo.ParseRule
		WHERE classification IN ('结构');
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 获得解析结果
	SET @SqlXML = dbo.MatchStructs(@SqlRule, @SqlContent);
	-- 检查结果
	IF @SqlXML IS NOT NULL AND
		ISNULL(@SqlXML.value('(//result/@id)[1]', 'int'), 0) > 0
	BEGIN
		-- 插入数据
		INSERT INTO @SqlTable
			(expression, value, length, position)
			SELECT '结构', nodeValue, nodeLen, nodePos FROM
			(
				SELECT
					Nodes.value('(@pos)[1]', 'int') AS nodePos,
					Nodes.value('(@len)[1]', 'int') AS nodeLen,
					Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
					FROM @SqlXML.nodes('//result/row/matched') AS N(Nodes)
			) AS NodesTable;
	END
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor;

-------------------------------------------------------------------------------
--
-- 去除重复（完全重复的仅保留一项）
--
-------------------------------------------------------------------------------

DECLARE @SqlMatch INT;
DECLARE @SqlLength INT;
DECLARE @SqlPosition INT;

---- 设置初始值
--SET @SqlMatch = 1;
---- 循环处理
--WHILE @SqlMatch > 0
--BEGIN
--	-- 设置初始值
--	SET @SqlMatch = 0;
--	-- 多个正则同时处理时才会出现相互重叠问题
--	-- 清理相互重叠的解析结果（保长去短）
--	-- 声明游标
--	DECLARE SqlCursor CURSOR
--		STATIC FORWARD_ONLY LOCAL FOR
--		SELECT id, length, position	FROM @SqlTable ORDER BY length;
--	-- 打开游标
--	OPEN SqlCursor;
--	-- 取第一条记录
--	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
--	-- 循环处理游标
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		-- 检查结果
--		IF EXISTS
--			(SELECT * FROM @SqlTable WHERE
--				@SqlID <> id AND
--				@SqlPosition = position AND
--				(@SqlPosition + @SqlLength = position + length))
--		BEGIN
--			-- 设置标记位
--			SET @SqlMatch = 1;
--			-- 删除该条被包括的数据
--			DELETE FROM @SqlTable WHERE id = @SqlID;
--			-- 更新此前被包括的数据
--			UPDATE @SqlTable
--				SET expression = 'F&B'
--				WHERE
--				@SqlID <> id AND
--				@SqlPosition = position AND
--				(@SqlPosition + @SqlLength = position + length);
--		END
--		-- 取下一条记录
--		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
--	END
--	-- 关闭游标
--	CLOSE SqlCursor;
--	-- 释放游标
--	DEALLOCATE SqlCursor;
--END

-- 设置初始值
SET @SqlMatch = 1;
-- 循环处理
WHILE @SqlMatch > 0
BEGIN
	-- 设置初始值
	SET @SqlMatch = 0;
	-- 多个正则同时处理时才会出现相互重叠问题
	-- 清理相互重叠的解析结果（保长去短）
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT id, length, position	FROM @SqlTable ORDER BY length;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查结果
		IF EXISTS
			(SELECT * FROM @SqlTable WHERE
				@SqlID <> id AND
				@SqlPosition >= position AND
				(@SqlPosition + @SqlLength <= position + length))
		BEGIN
			-- 设置标记位
			SET @SqlMatch = 1;
			-- 删除该条被包括的数据
			DELETE FROM @SqlTable WHERE id = @SqlID;
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;
END

SELECT *,dbo.GetFreqCount(value) AS freq FROM @SqlTable ORDER BY position;

-------------------------------------------------------------------------------
--
-- 合并相互重叠的项目
--
-------------------------------------------------------------------------------

DECLARE @SqlMID INT;

-- 设置初始值
SET @SqlMatch = 1;
-- 循环处理
WHILE @SqlMatch > 0
BEGIN
	-- 设置初始值
	SET @SqlMatch = 0;
	-- 多个正则同时处理时才会出现相互重叠问题
	-- 清理相互重叠的解析结果（融合搭界）
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置初始值
		SET @SqlMID = -1;
		-- 查询记录
		SELECT TOP 1 @SqlMID = id FROM @SqlTable WHERE
			@SqlID <> id AND
			@SqlPosition < position AND
			(@SqlPosition + @SqlLength > position) AND
			(@SqlPosition + @SqlLength < position + length) ORDER BY position
		-- 检查结果
		IF @SqlMID > 0
		BEGIN
			-- 设置标记位
			SET @SqlMatch = 1;
			-- 更新数据
			UPDATE @SqlTable SET
				position = @SqlPosition,
				length = position - @SqlPosition + length,
				value = LEFT(@SqlValue, position - @SqlPosition) + value,
				-- expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
				expression = @SqlAttribute + '+' + expression
				WHERE id = @SqlMID;
			-- 删除该条被包括的数据
			DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;
END

-------------------------------------------------------------------------------
--
-- 查看结果
--
-------------------------------------------------------------------------------

SELECT *
FROM
(
SELECT
	@SqlEID AS id,
	'原句' AS expression,
	0 AS position,
	LEN(@SqlContent) AS length,
	@SqlContent AS value,
	0 AS freq
UNION
SELECT id,expression,position,length,value,dbo.GetFreqCount(value) FROM @SqlTable
) AS T
ORDER BY position, expression;

END
ELSE
BEGIN

PRINT '检测多层解析叠加状况> 进入Debug状态！';

END

/*你的SQL脚本结束*/
PRINT '检测多层解析叠加状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
