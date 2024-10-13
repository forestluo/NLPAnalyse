USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 1716761;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlRules XML;
DECLARE @SqlResult XML;
DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

PRINT '检测短语提取状况> 进入正常状态！';

SET @SqlResult = dbo.ExtractPhrases(@SqlContent);

-- PRINT '检测短语提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 内容{' + @SqlContent + '}';
-- PRINT '检测短语提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 结果{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

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

PRINT '检测短语提取状况> 进入Debug状态！';

SET @SqlRules = dbo.LoadPhraseRules();
SET @SqlResult = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- PRINT '检测短语提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 内容{' + @SqlContent + '}';
-- PRINT '检测短语提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 结果{' + CONVERT(NVARCHAR(MAX), @SqlResult) + '}';

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

/*你的SQL脚本结束*/
PRINT '检测短语提取状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
