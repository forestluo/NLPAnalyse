USE [nldb]
GO

DECLARE @SqlEID INT;
SELECT @SqlEID = MAX(EID) FROM dbo.ExternalContent;
SET @SqlEID = ROUND(@SqlEID * RAND(), 0);
-- SET @@SqlEID = 2746456;

DECLARE @SqlContent UString;
SELECT @SqlContent = content FROM dbo.ExternalContent WHERE tid = @SqlEID;

SET @SqlContent = '街霸&拳皇卡片大战';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

-- 装载所有数字规则
DECLARE @SqlRules XML;
SET @SqlRules = dbo.LoadNumericalRules();

-- 检查结果
IF @SqlRules IS NULL
BEGIN
	-- 打印提示
	PRINT '检测FMMSplitContent> 无法加载数字规则！'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlExpressions XML;	
-- 获得数字解析结果
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);

-- 检查结果
IF @SqlExpressions IS NULL
BEGIN
	-- 打印提示
	PRINT '检测FMMSplitContent> 无法加载数字解析结果！'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '检测FMMSplitContent> 进入正常状态！';

-------------------------------------------------------------------------------
--
-- 解析全部内容
--
-------------------------------------------------------------------------------

SELECT dbo.FMMSplitContent(1, @SqlContent, @SqlExpressions);

END
ELSE
BEGIN

PRINT '检测FMMSplitContent> 进入Debug状态！';

END

END_OF_EXECUTION:
/*你的SQL脚本结束*/
PRINT '检测FMMSplitContent> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));