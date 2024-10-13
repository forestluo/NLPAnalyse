USE [nldb]
GO

DECLARE @SqlEID INT;
SET @SqlEID = 4;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE eid = @SqlEID;

-- 加载规则
DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

-- 获得单句的规则
DECLARE @SqlRule UString;
SET @SqlRule = dbo.GetParseRule(@SqlContent);
-- 更新规则
UPDATE dbo.ExternalContent SET [rule] = @SqlRule WHERE eid = @SqlEID;

PRINT '检测单句拆分状况> 规则{' + @SqlRule + '}';
PRINT '检测单句拆分状况> 内容{' + @SqlContent + '}';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

IF @SqlDebug = 0
BEGIN

PRINT '检测单句拆分状况> 处于正常状态！';

-- 提取数字内容
DECLARE @SqlExpressions XML;
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent); 

-- 直接读取内容
DECLARE @SqlResult XML
SET @SqlResult = dbo.ReadContent(@SqlContent, @SqlExpressions);

-- 以表格显示内容
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
	Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
	Nodes.value('(@pos)[1]', 'int') AS nodePos,
	LEN(Nodes.value('(text())[1]', 'nvarchar(max)')) AS nodeLen,
	Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
	FROM @SqlResult.nodes('//result/*') AS N(Nodes)
) AS t ORDER BY nodePos;

-- 加入句子到数据库
EXEC dbo.OuterAddSentence @SqlEID, @SqlContent;

END
ELSE
BEGIN

PRINT '检测单句拆分状况> 处于Debug状态！';

END

/*你的SQL脚本结束*/
PRINT '检测单句拆分状况> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
