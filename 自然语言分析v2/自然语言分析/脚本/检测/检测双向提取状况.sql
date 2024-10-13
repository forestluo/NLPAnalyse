USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
--SET @SqlEID = 550;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

PRINT '检测双向提取状况> 进入正常状态！';

-- PRINT '检测短语提取状况(eid=' + CONVERT(NVARCHAR(255),@SqlEID) + ')> 内容{' + @SqlContent + '}';

DECLARE @SqlValue UString;
SET @SqlValue = '';

DECLARE @SqlIndex INT;
SET @SqlIndex = CHARINDEX('的', @SqlContent);
-- 检查结果
WHILE @SqlIndex > 0
BEGIN

DECLARE @SqlFMMResult XML;
SET @SqlFMMResult = dbo.FMMFind(@SqlIndex, 1, @SqlContent);

SET @SqlValue = @SqlValue + CONVERT(NVARCHAR(MAX), @SqlFMMResult);

DECLARE @SqlBMMResult XML;
SET @SqlBMMResult = dbo.BMMFind(@SqlIndex, 1, @SqlContent);

SET @SqlValue = @SqlValue + CONVERT(NVARCHAR(MAX), @SqlBMMResult);

SET @SqlIndex = CHARINDEX('的', @SqlContent, @SqlIndex + 1);

END

DECLARE @SqlResult XML;
SET @SqlResult = @SqlValue;

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
	Nodes.value('(@met)[1]', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]','nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//*') AS N(Nodes)
) AS t ORDER BY nodePos;

END
ELSE
BEGIN

PRINT '检测短语提取状况> 进入Debug状态！';

END

/*你的SQL脚本结束*/
PRINT '检测短语提取状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
