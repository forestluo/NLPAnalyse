USE [nldb]
GO

-- 声明临时变量
DECLARE @SqlCount INT;
DECLARE @SqlDate DATETIME;

-- 设置初始值
SET @SqlCount = 10;

SET @SqlDate = GetDate();
-- 统计全连通词频(长度1)
EXEC dbo.[统计全连通词频] @SqlCount, 1
-- 打印结果
PRINT '测试语料处理效率> 统计全连通词频(长度1)耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

SET @SqlDate = GetDate();
-- 统计全连通词频(长度2)
EXEC dbo.[统计全连通词频] @SqlCount, 2
-- 打印结果
PRINT '测试语料处理效率> 统计全连通词频(长度2)耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

--SET @SqlDate = GetDate();
---- 统计全连通词频(长度3)
--EXEC dbo.[统计全连通词频] @SqlCount, 3
---- 打印结果
--PRINT '测试语料处理效率> 统计全连通词频(长度3)耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

-- 处理受影响标记位
SET @SqlDate = GetDate();
-- 从(长度1选择更新长度2、长度3和长度4)
-- 更新标记位
UPDATE dbo.Grammar2
SET operations = 1
FROM
(
	SELECT content FROM dbo.Grammar1 WHERE operations = 1
) AS T WHERE Grammar2.lcontent = T.content

-- 更新标记位
UPDATE dbo.Grammar2
SET operations = 1
FROM
(
	SELECT content FROM dbo.Grammar1 WHERE operations = 1
) AS T WHERE Grammar2.rcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar3.lcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar3.rcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

---- 从(长度2选择更新长度3和长度4)
---- 更新标记位
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar3.lcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar3.rcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

---- 从(长度3选择更新长度4)
---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar3 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- 更新标记位
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar3 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

-- 将operation换算成invalid
UPDATE dbo.Grammar2 SET invalid = 0 WHERE operations = 1;
-- 打印结果
PRINT '测试语料处理效率> 更新所有受影响标记位耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

-- 批量更新相关系数
SET @SqlDate = GetDate();
-- 更新相关系数(长度2)
UPDATE dbo.Grammar2
SET alpha = dbo.GrammarGetAlphaValue(lcontent + '|' + rcontent)
WHERE operations = 1
-- 打印结果
PRINT '测试语料处理效率> 批量更新相关系数耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

DO_IT_AGAIN:

-- 批量更新相关系数
SET @SqlDate = GetDate();
-- 更新相关系数
UPDATE dbo.Grammar1
SET
ralpha = dbo.GrammarGetAlphaAverage(1,content,NULL),
lalpha = dbo.GrammarGetAlphaAverage(-1,content,NULL)
WHERE operations = 1
-- 打印结果
PRINT '测试语料处理效率> 批量更新左右相关系数耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';

SET @SqlDate = GetDate();
-- 设置无效标记位
UPDATE dbo.Grammar2
SET Grammar2.invalid = T5.invalid
FROM
(
	SELECT content,
	(CASE WHEN alpha > 2 * lalpha1 AND alpha > 2 * ralpha1 AND alpha > 2 * lalpha2 AND alpha > 2 * ralpha2 THEN 1 ELSE 0 END) AS invalid
	FROM
	(
		SELECT
		T1.content AS content, T1.alpha AS alpha,
		T2.lalpha AS lalpha1, T2.ralpha AS ralpha1,
		T3.lalpha AS lalpha2, T3.ralpha AS ralpha2
		FROM dbo.Grammar2 AS T1
		INNER JOIN dbo.Grammar1 T2 ON T2.content = T1.lcontent
		INNER JOIN dbo.Grammar1 T3 ON T3.content = T1.rcontent
		WHERE T1.invalid = 0
	) AS T4
) AS T5 WHERE Grammar2.content = T5.content AND T5.invalid = 1
-- 获得影响行数
SET @SqlCount = @@ROWCOUNT;
-- 打印结果
PRINT '测试语料处理效率> 受影响' + CONVERT(NVARCHAR(MAX), @SqlCount) + '行！';
-- 打印结果
PRINT '测试语料处理效率> 设置无效标记位耗时' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '毫秒！';
-- 检查结果
IF @SqlCount > 0 GOTO DO_IT_AGAIN;
-- 打印结果
PRINT '测试语料处理效率> 全部处理完毕！';
-- 清理标记位
UPDATE dbo.Grammar1 SET operations = 0 WHERE operations > 0;
UPDATE dbo.Grammar2 SET operations = 0 WHERE operations > 0;

