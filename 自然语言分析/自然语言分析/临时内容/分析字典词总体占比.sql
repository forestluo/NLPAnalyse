SELECT TOP 1000 * FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�';
SELECT TOP 1000 * FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 ORDER BY gamma;

SELECT 'ǰ׺', CEILING(gamma) AS [gamma],count(*) FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 GROUP BY CEILING(gamma) ORDER BY [gamma];
SELECT 'ǰ׺', CEILING(gamma) AS [gamma],count(*) FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 AND dictionary = 1 GROUP BY CEILING(gamma) ORDER BY [gamma];

SELECT 'ǰ׺', CEILING(gamma) AS [gamma],count FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 ORDER BY [gamma];
SELECT 'ǰ׺', CEILING(gamma) AS [gamma],count FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 AND dictionary = 1 ORDER BY [gamma];

SELECT * FROM 
(
SELECT 'ǰ׺' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT ORDER BY gamma;

SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1],ISNULL(1.0 * [1] / ([0] + [1]),0) AS P FROM
(
	SELECT * FROM 
	(
	SELECT 'ǰ׺' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K ORDER BY gamma;

SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1] FROM
(
	SELECT * FROM
	(
	SELECT 'ǰ׺' AS prefix, CEILING(gamma) AS [gamma], count, dictionary FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K ORDER BY gamma;

CREATE VIEW [�����ϵ������ͳ������] AS
SELECT prefix,gamma,ISNULL([0],0) AS [D0],ISNULL([1],0) AS [D1],(ISNULL([0],0) + ISNULL([1],0)) AS D FROM
(
	SELECT * FROM 
	(
	SELECT 'ǰ׺' AS prefix, CEILING(gamma) AS [gamma],dictionary,count(*) AS COUNT FROM dbo.InnerContent WHERE classification <> '����Ӣ���ʵ�' AND gamma > 0 GROUP BY CEILING(gamma),dictionary
	) AS T PIVOT(MAX(count) FOR dictionary IN ([0],[1])) AS PVT
) AS K;


DECLARE @SqlTable AS TABLE(prefix NVARCHAR(8),gamma INT PRIMARY KEY,D0 INT,D1 INT,D INT,T INT,Q FLOAT);
INSERT INTO @SqlTable (prefix,gamma,D0,D1,D,T,Q)
SELECT prefix,gamma,D0,D1,D,0,0 FROM dbo.[�����ϵ������ͳ������];
DECLARE @SqlD INT;
DECLARE @SqlD1 INT;
DECLARE @SqlGamma INT;
DECLARE @SqlTCount INT;
DECLARE @SqlD1Count INT;
SET @SqlTCount = 0;
SET @SqlD1Count = 0;
-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT gamma, D1, D FROM @SqlTable Order by gamma;
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlGamma, @SqlD1, @SqlD;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��������
	SET @SqlTCount = @SqlTCount + @SqlD;
	SET @SqlD1Count = @SqlD1Count + @SqlD1;
	-- ���½��
	UPDATE @SqlTable SET T = @SqlTCount, Q = 1.0 * @SqlD1Count / @SqlTCount WHERE gamma = @SqlGamma;
	PRINT 'Gamma = ' + CONVERT(NVARCHAR(MAX),@SqlGamma) + ',T = ' + CONVERT(NVARCHAR(MAX),@SqlTCount) + ',D1 = ' + CONVERT(NVARCHAR(MAX),@SqlD1Count);
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlGamma, @SqlD1, @SqlD;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 
-- ��ѯ���
SELECT * FROM @SqlTable ORDER BY gamma;


--DECLARE @SqlTable AS TABLE(prefix NVARCHAR(8),freq INT PRIMARY KEY,T0 INT,T1 INT,T INT,D INT,Q FLOAT);
--INSERT INTO @SqlTable (prefix,freq,T0,T1,T,D,Q)
--SELECT prefix,freq,T0,T1,T,0,0 FROM dbo.[��ͳ�ƴ�Ƶ����ͳ������];
--DECLARE @SqlT INT;
--DECLARE @SqlT1 INT;
--DECLARE @SqlFreq INT;
--DECLARE @SqlDCount INT;
--DECLARE @SqlT1Count INT;
--SET @SqlDCount = 0;
--SET @SqlT1Count = 0;
---- �����α�
--DECLARE SqlCursor CURSOR
--	STATIC FORWARD_ONLY LOCAL FOR
--	SELECT freq, T1, T FROM @SqlTable ORDER BY freq;
---- ���α�
--OPEN SqlCursor;
---- ȡ��һ����¼
--FETCH NEXT FROM SqlCursor INTO @SqlFreq, @SqlT1, @SqlT;
---- ѭ�������α�
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	-- ��������
--	SET @SqlDCount = @SqlDCount + @SqlT;
--	SET @SqlT1Count = @SqlT1Count + @SqlT1;
--	-- ���½��
--	UPDATE @SqlTable SET D = @SqlDCount, Q = 1.0 * @SqlT1Count / @SqlDCount WHERE freq = @SqlFreq;
--	PRINT 'Freq = ' + CONVERT(NVARCHAR(MAX),@SqlFreq) + ',D = ' + CONVERT(NVARCHAR(MAX),@SqlDCount) + ',T1 = ' + CONVERT(NVARCHAR(MAX),@SqlT1Count);
--	-- ȡ��һ����¼ 
--	FETCH NEXT FROM SqlCursor INTO @SqlFreq, @SqlT1, @SqlT;
--END
---- �ر��α�
--CLOSE SqlCursor;
---- �ͷ��α�
--DEALLOCATE SqlCursor; 
---- ��ѯ���
--SELECT * FROM @SqlTable ORDER BY freq;
