SELECT TOP 1000 * FROM dbo.InnerContent WHERE classification <> '简明英汉词典';
SELECT TOP 1000 * FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 ORDER BY gamma;

SELECT '前缀', CEILING(gamma) AS [gamma],count(*) FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 GROUP BY CEILING(gamma) ORDER BY [gamma];
SELECT '前缀', CEILING(gamma) AS [gamma],count(*) FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 AND dictionary = 1 GROUP BY CEILING(gamma) ORDER BY [gamma];

SELECT '前缀', CEILING(gamma) AS [gamma],count FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 ORDER BY [gamma];
SELECT '前缀', CEILING(gamma) AS [gamma],count FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 AND dictionary = 1 ORDER BY [gamma];

SELECT * FROM 
(
SELECT '前缀' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT ORDER BY gamma;

SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1],ISNULL(1.0 * [1] / ([0] + [1]),0) AS P FROM
(
	SELECT * FROM 
	(
	SELECT '前缀' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K ORDER BY gamma;

SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1] FROM
(
	SELECT * FROM
	(
	SELECT '前缀' AS prefix, CEILING(gamma) AS [gamma], count, dictionary FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K ORDER BY gamma;

CREATE VIEW [按相关系数分组统计数量] AS
SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1],(ISNULL([0],0) + ISNULL([1],0)) AS D FROM
(
	SELECT * FROM 
	(
	SELECT '前缀' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '简明英汉词典' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K;


DECLARE @SqlTable AS TABLE(prefix NVARCHAR(8),gamma INT PRIMARY KEY,D0 INT,D1 INT,D INT,T INT,Q FLOAT);
INSERT INTO @SqlTable (prefix,gamma,D0,D1,D,T,Q)
SELECT prefix,gamma,D0,D1,D,0,0 FROM dbo.[按相关系数分组统计数量];
DECLARE @SqlD INT;
DECLARE @SqlD1 INT;
DECLARE @SqlGamma INT;
DECLARE @SqlTCount INT;
DECLARE @SqlD1Count INT;
SET @SqlTCount = 0;
SET @SqlD1Count = 0;
-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT gamma, D1, D FROM @SqlTable Order by gamma;
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlGamma, @SqlD1, @SqlD;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 计算总数
	SET @SqlTCount = @SqlTCount + @SqlD;
	SET @SqlD1Count = @SqlD1Count + @SqlD1;
	-- 更新结果
	UPDATE @SqlTable SET T = @SqlTCount, Q = 1.0 * @SqlD1Count / @SqlTCount WHERE gamma = @SqlGamma;
	PRINT 'Gamma = ' + CONVERT(NVARCHAR(MAX),@SqlGamma) + ',T = ' + CONVERT(NVARCHAR(MAX),@SqlTCount) + ',D1 = ' + CONVERT(NVARCHAR(MAX),@SqlD1Count);
	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlGamma, @SqlD1, @SqlD;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 
-- 查询结果
SELECT * FROM @SqlTable ORDER BY gamma;


--DECLARE @SqlTable AS TABLE(prefix NVARCHAR(8),freq INT PRIMARY KEY,T0 INT,T1 INT,T INT,D INT,Q FLOAT);
--INSERT INTO @SqlTable (prefix,freq,T0,T1,T,D,Q)
--SELECT prefix,freq,T0,T1,T,0,0 FROM dbo.[按统计词频分组统计数量];
--DECLARE @SqlT INT;
--DECLARE @SqlT1 INT;
--DECLARE @SqlFreq INT;
--DECLARE @SqlDCount INT;
--DECLARE @SqlT1Count INT;
--SET @SqlDCount = 0;
--SET @SqlT1Count = 0;
---- 声明游标
--DECLARE SqlCursor CURSOR
--	STATIC FORWARD_ONLY LOCAL FOR
--	SELECT freq, T1, T FROM @SqlTable ORDER BY freq;
---- 打开游标
--OPEN SqlCursor;
---- 取第一条记录
--FETCH NEXT FROM SqlCursor INTO @SqlFreq, @SqlT1, @SqlT;
---- 循环处理游标
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	-- 计算总数
--	SET @SqlDCount = @SqlDCount + @SqlT;
--	SET @SqlT1Count = @SqlT1Count + @SqlT1;
--	-- 更新结果
--	UPDATE @SqlTable SET D = @SqlDCount, Q = 1.0 * @SqlT1Count / @SqlDCount WHERE freq = @SqlFreq;
--	PRINT 'Freq = ' + CONVERT(NVARCHAR(MAX),@SqlFreq) + ',D = ' + CONVERT(NVARCHAR(MAX),@SqlDCount) + ',T1 = ' + CONVERT(NVARCHAR(MAX),@SqlT1Count);
--	-- 取下一条记录 
--	FETCH NEXT FROM SqlCursor INTO @SqlFreq, @SqlT1, @SqlT;
--END
---- 关闭游标
--CLOSE SqlCursor;
---- 释放游标
--DEALLOCATE SqlCursor; 
---- 查询结果
--SELECT * FROM @SqlTable ORDER BY freq;
