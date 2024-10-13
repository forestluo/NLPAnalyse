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

DECLARE @SqlLAlpha FLOAT;
DECLARE @SqlRAlpha FLOAT;

DECLARE @SqlLDeviation FLOAT;
DECLARE @SqlRDeviation FLOAT;

DECLARE @SqlContent UString;
DECLARE @SqlLContent UString;
DECLARE @SqlRContent UString;

SET @SqlLoop = 10;

DO_IT_AGAIN:

SET @SqlTotal = GetDate();

-- 设置初始值
SET @SqlGID = 0;
-- 查询结果
SELECT TOP 1 @SqlGID = gid,
	@SqlAlpha = alpha, @SqlCount = count,
	@SqlContent = content,
	@SqlLContent = lcontent, @SqlRContent = rcontent
	FROM dbo.Grammar2 WHERE operations = 0 AND enable = 0;
-- 检查结果
IF @@ROWCOUNT <= 0
BEGIN
	UPDATE dbo.Grammar2 SET operations = 0; GOTO END_OF_EXECUTION;
END
-- 检查结果
IF @SqlAlpha < 0
BEGIN
	-- 计算Alpha数值
	SET @SqlAlpha = dbo.GrammarGetAlphaValue(@SqlLContent + '|' + @SqlRContent);
END

-- 打印结果
PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "'
	+ @SqlContent + '"="' + @SqlLContent + '"|"' + @SqlRContent
	+ '", alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ', count = ' + CONVERT(NVARCHAR(MAX), @SqlCount);

SET @SqlDate = GetDate();
-- 更新左侧平均数值
UPDATE dbo.Grammar2
-- 更新相关数据的Alpha数值
SET alpha =
dbo.GrammarGetAlphaValue(Grammar2.lcontent + '|' + Grammar2.rcontent)
FROM
(
	SELECT content
		FROM
		(
			SELECT content, invalid, enable
				FROM dbo.Grammar2
				WHERE lcontent = @SqlLContent
		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
) AS T WHERE Grammar2.content = T.content;
-- 计时结束
PRINT '清理无效的词汇> 更新Grammar2耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

SET @SqlDate = GetDate();
-- 更新右侧平均数值
UPDATE dbo.Grammar2
-- 更新相关数据的Alpha数值
SET alpha =
dbo.GrammarGetAlphaValue(Grammar2.lcontent + '|' + Grammar2.rcontent)
FROM
(
	SELECT content
		FROM
		(
			SELECT content, invalid, enable
				FROM dbo.Grammar2
				WHERE rcontent = @SqlRContent
		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
) AS T WHERE Grammar2.content = T.content;
-- 计时结束
PRINT '清理无效的词汇> 更新Grammar2耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

--SET @SqlDate = GetDate();
---- 更新左侧平均数值
--UPDATE dbo.Grammar3
---- 更新相关数据的Alpha数值
--SET alpha =
--dbo.GrammarGetAlphaValue(Grammar3.lcontent + '|' + Grammar3.rcontent)
--FROM
--(
--	SELECT gid
--		FROM
--		(
--			SELECT gid, invalid, enable
--				FROM dbo.Grammar3
--				WHERE lcontent = @SqlLContent
--		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
--) AS T WHERE Grammar3.gid = T.gid;
---- 计时结束
--PRINT '清理无效的词汇> 更新Grammar3耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

--SET @SqlDate = GetDate();
---- 更新右侧平均数值
--UPDATE dbo.Grammar3
---- 更新相关数据的Alpha数值
--SET alpha =
--dbo.GrammarGetAlphaValue(Grammar3.lcontent + '|' + Grammar3.rcontent)
--FROM
--(
--	SELECT gid
--		FROM
--		(
--			SELECT gid, invalid, enable
--				FROM dbo.Grammar3
--				WHERE rcontent = @SqlRContent
--		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
--) AS T WHERE Grammar3.gid = T.gid;
---- 计时结束
--PRINT '清理无效的词汇> 更新Grammar3耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

--SET @SqlDate = GetDate();
---- 更新左侧平均数值
--UPDATE dbo.Grammar4
---- 更新相关数据的Alpha数值
--SET alpha =
--dbo.GrammarGetAlphaValue(Grammar4.lcontent + '|' + Grammar4.rcontent)
--FROM
--(
--	SELECT gid
--		FROM
--		(
--			SELECT gid, invalid, enable
--				FROM dbo.Grammar4
--				WHERE lcontent = @SqlLContent
--		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
--) AS T WHERE Grammar4.gid = T.gid;
---- 计时结束
--PRINT '清理无效的词汇> 更新Grammar4耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

--SET @SqlDate = GetDate();
---- 更新右侧平均数值
--UPDATE dbo.Grammar4
---- 更新相关数据的Alpha数值
--SET alpha =
--dbo.GrammarGetAlphaValue(Grammar4.lcontent + '|' + Grammar4.rcontent)
--FROM
--(
--	SELECT gid
--		FROM
--		(
--			SELECT gid, count, invalid, enable
--				FROM dbo.Grammar4
--				WHERE rcontent = @SqlRContent
--		) AS S WHERE NOT (S.invalid = 1 AND S.enable = 0)
--) AS T WHERE Grammar4.gid = T.gid;
---- 计时结束
--PRINT '清理无效的词汇> 更新Grammar4耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

SET @SqlDate = GetDate();
-- 获得右侧平均相关系数
SELECT @SqlRAlpha = Average, @SqlRDeviation = Deviation
FROM dbo.GrammarGetAlphaDeviation(1, @SqlLContent, @SqlRContent);
-- 计时结束
PRINT '清理无效的词汇> 计算RAlpha和RDeviation耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

SET @SqlDate = GetDate();
-- 获得左侧平均相关系数
SELECT @SqlLAlpha = Average, @SqlLDeviation = Deviation
FROM dbo.GrammarGetAlphaDeviation(-1, @SqlRContent, @SqlLContent);
-- 计时结束
PRINT '清理无效的词汇> 计算LAlpha和LDeviation耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

-- 打印结果
PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlContent + '".(alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ',count = ' + CONVERT(NVARCHAR(MAX), @SqlCount) + ')';
PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlLContent + '".(ralpha = ' + CONVERT(NVARCHAR(MAX), @SqlRAlpha) + ',deviation = ' + CONVERT(NVARCHAR(MAX), @SqlRDeviation) + ')';
PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlRContent + '".(lalpha = ' + CONVERT(NVARCHAR(MAX), @SqlLAlpha) + ',deviation = ' + CONVERT(NVARCHAR(MAX), @SqlLDeviation) + ')';

-- 检查结果
IF @SqlLAlpha < 0 OR @SqlRAlpha < 0 OR
	(@SqlAlpha > 2 * @SqlLAlpha AND @SqlAlpha > 2 * @SqlRAlpha)
BEGIN
	-- 打印结果
	PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> 需要设置无效标记！';

	SET @SqlDate = GetDate();
	-- 更新数据
	UPDATE dbo.Grammar2 SET invalid = 1 WHERE content = @SqlContent;
	--UPDATE dbo.Grammar3 SET invalid = 1 WHERE lcontent = @SqlContent;
	--UPDATE dbo.Grammar3 SET invalid = 1 WHERE rcontent = @SqlContent;
	--UPDATE dbo.Grammar4 SET invalid = 1 WHERE lcontent = @SqlContent;
	--UPDATE dbo.Grammar4 SET invalid = 1 WHERE rcontent = @SqlContent;
	-- 计时结束
	PRINT '清理无效的词汇> 设置无效标记耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	
	-- 打印结果
	PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> 无效标记已经设置！';
END
ELSE
BEGIN
	-- 打印结果
	PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> 暂不需要设置无效标记！';
END
-- 计时结束
PRINT '清理无效的词汇> 相关数据计算耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlTotal, GetDate())) + '毫秒';

-- 更新数据
UPDATE dbo.Grammar2
SET alpha = @SqlAlpha,
operations = 1 WHERE content = @SqlContent;

-- 检查循环计数器
SET @SqlLoop = @SqlLoop - 1; IF @SqlLoop > 0 GOTO DO_IT_AGAIN;

-- 打印结果
PRINT '清理无效的词汇(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> 相关操作已经全部完成！';

END_OF_EXECUTION:

SET NOCOUNT OFF;
