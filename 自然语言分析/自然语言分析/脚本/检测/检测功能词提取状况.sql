USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 455089;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

PRINT '检测功能词提取状况> 进入正常状态！';

DECLARE @SqlResult XML;
SET @SqlResult = dbo.ExtractAttributeWords(1, @SqlContent);

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
	Nodes.value('(@id)[1]', 'int') AS nodeID,
	Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]','nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

PRINT '检测功能词提取状况> 进入Debug状态！';

-- 声明临时变量
DECLARE @SqlID INT;
DECLARE @SqlPosition INT;
DECLARE @SqlRule UString;
DECLARE @SqlValue UString;
DECLARE @SqlFindResult XML;
DECLARE @SqlTable UMatchTable;

-- 拼接内容
SET @SqlRule =
(
	(
		SELECT content + '|'
			FROM
			(
				SELECT DISTINCT(content) AS content
					FROM dbo.WordAttribute WHERE classification = '功能词'
			) AS T
			ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
	).value('.', 'NVARCHAR(MAX)')
);
-- 修正结果
SET @SqlRule = '(' + LEFT(@SqlRule, LEN(@SqlRule) - 1) + ')';
-- 将结果插入到新的记录表中
INSERT INTO @SqlTable
	(expression, value, length , position)
	SELECT '功能词', Match, MatchLength, MatchIndex + 1
		FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);

SELECT * FROM @SqlTable;

-- 更新
-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT id, position, value FROM @SqlTable ORDER BY position;
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 查询结果
	SET @SqlFindResult = dbo.WMMFind(@SqlPosition, 1, @SqlContent);
	-- 检查结果
	IF @SqlFindResult IS NOT NULL
	BEGIN
		-- 检查结果
		IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
		BEGIN
			PRINT CONVERT(NVARCHAR(256), @SqlFindResult);
			-- 获得结果
			SET @SqlPosition = @SqlFindResult.value('(//result/@pos)[1]', 'INT');
			SET @SqlValue = @SqlFindResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
			-- 检查结果
			IF @SqlPosition IS NOT NULL AND @SqlValue IS NOT NULL
			BEGIN
				-- 更新数据
				UPDATE @SqlTable
				SET position = @SqlPosition, length = LEN(@SqlValue), value = @SqlValue WHERE id = @SqlID;
			END
		END
	END
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor;

SELECT * FROM @SqlTable;

END

/*你的SQL脚本结束*/
PRINT '检测功能词提取状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
