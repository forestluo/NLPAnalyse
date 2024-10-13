USE [nldb]
GO

SET NOCOUNT ON;

-- ������ʱ����
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

-- ��ѯ���
SELECT TOP 1 @SqlContent= content
FROM ( SELECT DISTINCT content FROM dbo.Grammar4 WHERE operations = 0 ) AS T1;
-- �����
IF @@ROWCOUNT <= 0
BEGIN
	UPDATE dbo.Grammar4 SET operations = 0; GOTO END_OF_EXECUTION;
END

-- ��ӡ���
PRINT '������Ч�Ĵʻ�> "' + @SqlContent + '"';

SET @SqlDate = GetDate();
-- �������ƽ����ֵ
UPDATE dbo.Grammar4
-- ����������ݵ�Alpha��ֵ
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
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ����Grammar4��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

-- ����ڲ�������ϵ����GID
-- ����ȱʡ��ֵ
SET @SqlAlpha = - 1.0;
-- ��ѯ���
SELECT @SqlAlpha = MAX(alpha) FROM
(
	SELECT content, lcontent, rcontent, alpha
	FROM dbo.Grammar4 WHERE content = @SqlContent
) AS T1 WHERE NOT (lcontent = '' AND rcontent = '');
-- ��ӡ���
PRINT '������Ч�Ĵʻ�> "' + @SqlContent + '".(max alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ')';

-- ������Ч���
-- ���½��
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
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ������ݼ����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlTotal, GetDate())) + '����';

-- �������ݼ�¼
UPDATE dbo.Grammar4
SET operations = 1 WHERE content = @SqlContent;
-- ���ѭ��������
SET @SqlLoop = @SqlLoop - 1; IF @SqlLoop > 0 GOTO DO_IT_AGAIN;

-- ��ӡ���
PRINT '������Ч�Ĵʻ�> ��ز����Ѿ�ȫ����ɣ�';

END_OF_EXECUTION:

SET NOCOUNT OFF;
