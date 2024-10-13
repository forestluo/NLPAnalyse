USE [nldb]
GO

SET NOCOUNT ON;

-- 声明临时变量
DECLARE @SqlGID INT;
DECLARE @SqlLoop INT;
DECLARE @SqlDate DATETIME;
DECLARE @SqlTotal DATETIME;

DECLARE @SqlCount INT;
DECLARE @SqlAlpha FLOAT;

DECLARE @SqlContent UString;

SET @SqlLoop = 10000;

DO_IT_AGAIN:

SET @SqlTotal = GetDate();

-- 查询结果
SELECT TOP 1 @SqlContent= content
FROM ( SELECT DISTINCT content FROM dbo.Grammar4 WHERE operations = 0 ) AS T1;
-- 检查结果
IF @@ROWCOUNT <= 0
BEGIN
	UPDATE dbo.Grammar4 SET operations = 0; GOTO END_OF_EXECUTION;
END

-- 打印结果
PRINT '清理无效的词汇> "' + @SqlContent + '"';

SET @SqlDate = GetDate();
-- 更新左侧平均数值
UPDATE dbo.Grammar4
-- 更新相关数据的Alpha数值
SET alpha =
dbo.GrammarGetAlphaValue(Grammar4.lcontent + '|' + Grammar4.rcontent)
FROM
(
	SELECT gid, content, lcontent, rcontent
		FROM
		(
			SELECT gid, content, lcontent, rcontent
				FROM dbo.Grammar4
				WHERE content = @SqlContent
		) AS T1 WHERE NOT (lcontent = '' AND rcontent = '')
) AS T2 WHERE Grammar4.gid = T2.gid;
-- 计时结束
PRINT '清理无效的词汇> 更新Grammar4耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

-- 获得内部最大相关系数的GID
-- 设置缺省数值
SET @SqlAlpha = - 1.0;
-- 查询结果
SELECT @SqlAlpha = MAX(alpha) FROM
(
	SELECT content, lcontent, rcontent, alpha
	FROM dbo.Grammar4 WHERE content = @SqlContent
) AS T1 WHERE NOT (lcontent = '' AND rcontent = '');
-- 打印结果
PRINT '清理无效的词汇> "' + @SqlContent + '".(max alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ')';

-- 设置无效标记
-- 更新结果
UPDATE dbo.Grammar4
SET invalid = 1, operations = 1
FROM
(
	SELECT gid, alpha
	FROM
	(
		SELECT gid, alpha, lcontent, rcontent
		FROM dbo.Grammar4
		WHERE content = @SqlContent
	) AS T1 WHERE NOT (lcontent = '' AND rcontent = '')
) AS T2 WHERE T2.alpha < @SqlAlpha AND Grammar4.gid = T2.gid;
-- 计时结束
PRINT '清理无效的词汇> 相关数据计算耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlTotal, GetDate())) + '毫秒';

-- 更新数据记录
UPDATE dbo.Grammar4
SET operations = 1 WHERE content = @SqlContent;
-- 检查循环计数器
SET @SqlLoop = @SqlLoop - 1; IF @SqlLoop > 0 GOTO DO_IT_AGAIN;

-- 打印结果
PRINT '清理无效的词汇> 相关操作已经全部完成！';

END_OF_EXECUTION:

SET NOCOUNT OFF;
