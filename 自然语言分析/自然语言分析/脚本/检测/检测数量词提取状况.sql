USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 760588;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

DECLARE @SqlResult XML;
SET @SqlResult = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- PRINT '检测数量词提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 内容{' + @SqlContent + '}';
-- PRINT '检测数量词提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 结果{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

SELECT *
FROM
(
SELECT
	@SqlEID AS nodeID,
	'原句' AS nodeType,
	0 AS nodePos,
	LEN(@SqlContent) AS nodeLen,
	@SqlContent AS nodeValue
UNION
SELECT
	Nodes.value('(@id)[1]','int') AS nodeID,
	Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	Nodes.value('(@len)[1]', 'int') AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//result/*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

-- 将内容转换成半角
SET @SqlContent = dbo.LatinConvert(@SqlContent);

DECLARE @SqlID INT;
DECLARE @SqlRule UString;
DECLARE @SqlAttribute UString;
DECLARE @SqlTable UMatchTable;
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
	-- 将结果插入到新的记录表中
	INSERT INTO @SqlTable
		(expression, value, length , position)
		SELECT @SqlAttribute, Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlAttribute;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor;

-- 显示所有内容
SELECT * FROM @SqlTable;

-- 显示所有内容
-- SELECT * FROM @SqlTable;

DECLARE @SqlMatch INT;
DECLARE @SqlLength INT;
DECLARE @SqlPosition INT;

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

-- 显示所有内容
SELECT * FROM @SqlTable;

DECLARE @SqlMID INT;
DECLARE @SqlValue UString;

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
				expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
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

-- 显示所有内容
SELECT * FROM @SqlTable;

END

/*你的SQL脚本结束*/
PRINT '检测数量词提取状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
