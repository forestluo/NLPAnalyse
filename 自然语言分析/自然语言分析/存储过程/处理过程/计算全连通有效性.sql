USE [nldb]
GO

DECLARE @SqlRowCount INT;
DECLARE @SqlDate DATETIME;

--SET @SqlDate = GETDATE();
---- ��ʼ������Ϊ2������
--UPDATE dbo.Grammar2
--	SET invalid = 0, lalpha = -1.0, ralpha = -1.0, operations = 1,
--	lcontent = LEFT(content,1),	rcontent = RIGHT(content,1),
--	alpha = dbo.GrammarGetAlphaValue(LEFT(content,1) + '|' + RIGHT(content,1));
---- ��ʱ����
--PRINT '����ȫ��ͨ��Ƶ> ��ʼ�����ݣ�����Ϊ2����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GETDATE();
---- ��ʼ������Ϊ3������
--UPDATE dbo.Grammar3
--SET Grammar3.operations = 1,
--alpha =
--CASE
--WHEN lcontent = '' AND rcontent = ''
--THEN dbo.GrammarGetAlphaValue(LEFT(Grammar3.content,1) + '|' + SUBSTRING(Grammar3.content,2,1) + '|' + RIGHT(Grammar3.content,1))
--ELSE dbo.GrammarGetAlphaValue(Grammar3.lcontent + '|' + Grammar3.rcontent) END;
---- ��ʱ����
--PRINT '����ȫ��ͨ��Ƶ> ��ʼ�����ݣ�����Ϊ3����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GETDATE();
---- ��ʼ������Ϊ4������
--UPDATE dbo.Grammar4
--SET Grammar4.operations = 1,
--alpha =
--CASE
--WHEN lcontent = '' AND rcontent = ''
--THEN dbo.GrammarGetAlphaValue(LEFT(Grammar4.content,1) + '|' + SUBSTRING(Grammar4.content,2,1) + '|' + SUBSTRING(Grammar4.content,3,1) + '|' + RIGHT(Grammar4.content,1))
--ELSE dbo.GrammarGetAlphaValue(Grammar4.lcontent + '|' + Grammar4.rcontent) END;
---- ��ʱ����
--PRINT '����ȫ��ͨ��Ƶ> ��ʼ�����ݣ�����Ϊ4����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

DO_IT_AGAIN:

SET @SqlDate = GETDATE();
-- ���³���Ϊ1������
UPDATE dbo.Grammar1
	SET	ralpha = dbo.GrammarGetAverageAlpha(1,content), lalpha = dbo.GrammarGetAverageAlpha(-1,content);
-- ��ʱ����
PRINT '����ȫ��ͨ��Ƶ> ����Alpha������Ϊ2����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

SET @SqlDate = GETDATE();
-- ���³���Ϊ2������
UPDATE dbo.Grammar2
	SET invalid = 1
	WHERE gid IN
	(
		SELECT gid FROM
		(
			SELECT gid,invalid,enable,content,lcontent,rcontent,alpha,lalpha1,ralpha1,lalpha2,ralpha2 FROM
			(
				SELECT
					T1.gid AS gid, T1.invalid AS invalid, T1.enable AS enable,
					T1.content AS content, T1.lcontent AS lcontent, T1.rcontent AS rcontent,
					T1.alpha AS alpha, T2.lalpha AS lalpha1, T2.ralpha AS ralpha1, T3.lalpha AS lalpha2, T3.ralpha AS ralpha2
					FROM dbo.Grammar2 AS T1
					INNER JOIN dbo.Grammar1 T2 ON T2.content = T1.lcontent
					INNER JOIN dbo.Grammar1 T3 ON T3.content = T1.rcontent
					WHERE NOT (T1.invalid = 1 AND T1.enable = 0)
			) AS T WHERE alpha > 2 * lalpha1 AND alpha > 2 * ralpha1 AND alpha > 2 * lalpha2 AND alpha > 2 * ralpha2
		) AS S
	);
-- �������
SET @SqlRowCount = @@ROWCOUNT;
-- ��ʱ����
PRINT '����ȫ��ͨ��Ƶ> ����Invalid������Ϊ2����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

-- �����
IF @SqlRowCount > 0
BEGIN
	-- ��������
	UPDATE dbo.Grammar3
	SET invalid= 1
	FROM (SELECT content FROM dbo.Grammar2 WHERE invalid = 1 AND enable = 0) AS T
	WHERE Grammar3.lcontent = T.content;
	-- ��������
	UPDATE dbo.Grammar3
	SET invalid= 1
	FROM (SELECT content FROM dbo.Grammar2 WHERE invalid = 1 AND enable = 0) AS T
	WHERE Grammar3.rcontent = T.content;

	-- ��������
	UPDATE dbo.Grammar4
	SET invalid= 1
	FROM (SELECT content FROM dbo.Grammar2 WHERE invalid = 1 AND enable = 0) AS T
	WHERE Grammar4.lcontent = T.content;
	-- ��������
	UPDATE dbo.Grammar4
	SET invalid= 1
	FROM (SELECT content FROM dbo.Grammar2 WHERE invalid = 1 AND enable = 0) AS T
	WHERE Grammar4.rcontent = T.content;

	PRINT '����ȫ��ͨ��Ƶ> �����δ������count='+ CONVERT(NVARCHAR(MAX),@SqlRowCount) + '����'; GOTO DO_IT_AGAIN;
END

-- ���سɹ�
PRINT '������ͨ��Ч��> ��������ȫ��������ϣ�';
GO
