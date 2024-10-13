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

-- ���ó�ʼֵ
SET @SqlGID = 0;
-- ��ѯ���
SELECT TOP 1 @SqlGID = gid,
	@SqlAlpha = alpha, @SqlCount = count,
	@SqlContent = content,
	@SqlLContent = lcontent, @SqlRContent = rcontent
	FROM dbo.Grammar2 WHERE operations = 0 AND enable = 0;
-- �����
IF @@ROWCOUNT <= 0
BEGIN
	UPDATE dbo.Grammar2 SET operations = 0; GOTO END_OF_EXECUTION;
END
-- �����
IF @SqlAlpha < 0
BEGIN
	-- ����Alpha��ֵ
	SET @SqlAlpha = dbo.GrammarGetAlphaValue(@SqlLContent + '|' + @SqlRContent);
END

-- ��ӡ���
PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "'
	+ @SqlContent + '"="' + @SqlLContent + '"|"' + @SqlRContent
	+ '", alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ', count = ' + CONVERT(NVARCHAR(MAX), @SqlCount);

SET @SqlDate = GetDate();
-- �������ƽ����ֵ
UPDATE dbo.Grammar2
-- ����������ݵ�Alpha��ֵ
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
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ����Grammar2��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

SET @SqlDate = GetDate();
-- �����Ҳ�ƽ����ֵ
UPDATE dbo.Grammar2
-- ����������ݵ�Alpha��ֵ
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
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ����Grammar2��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GetDate();
---- �������ƽ����ֵ
--UPDATE dbo.Grammar3
---- ����������ݵ�Alpha��ֵ
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
---- ��ʱ����
--PRINT '������Ч�Ĵʻ�> ����Grammar3��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GetDate();
---- �����Ҳ�ƽ����ֵ
--UPDATE dbo.Grammar3
---- ����������ݵ�Alpha��ֵ
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
---- ��ʱ����
--PRINT '������Ч�Ĵʻ�> ����Grammar3��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GetDate();
---- �������ƽ����ֵ
--UPDATE dbo.Grammar4
---- ����������ݵ�Alpha��ֵ
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
---- ��ʱ����
--PRINT '������Ч�Ĵʻ�> ����Grammar4��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

--SET @SqlDate = GetDate();
---- �����Ҳ�ƽ����ֵ
--UPDATE dbo.Grammar4
---- ����������ݵ�Alpha��ֵ
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
---- ��ʱ����
--PRINT '������Ч�Ĵʻ�> ����Grammar4��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

SET @SqlDate = GetDate();
-- ����Ҳ�ƽ�����ϵ��
SELECT @SqlRAlpha = Average, @SqlRDeviation = Deviation
FROM dbo.GrammarGetAlphaDeviation(1, @SqlLContent, @SqlRContent);
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ����RAlpha��RDeviation��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

SET @SqlDate = GetDate();
-- ������ƽ�����ϵ��
SELECT @SqlLAlpha = Average, @SqlLDeviation = Deviation
FROM dbo.GrammarGetAlphaDeviation(-1, @SqlRContent, @SqlLContent);
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ����LAlpha��LDeviation��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

-- ��ӡ���
PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlContent + '".(alpha = ' + CONVERT(NVARCHAR(MAX), @SqlAlpha) + ',count = ' + CONVERT(NVARCHAR(MAX), @SqlCount) + ')';
PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlLContent + '".(ralpha = ' + CONVERT(NVARCHAR(MAX), @SqlRAlpha) + ',deviation = ' + CONVERT(NVARCHAR(MAX), @SqlRDeviation) + ')';
PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> "' + @SqlRContent + '".(lalpha = ' + CONVERT(NVARCHAR(MAX), @SqlLAlpha) + ',deviation = ' + CONVERT(NVARCHAR(MAX), @SqlLDeviation) + ')';

-- �����
IF @SqlLAlpha < 0 OR @SqlRAlpha < 0 OR
	(@SqlAlpha > 2 * @SqlLAlpha AND @SqlAlpha > 2 * @SqlRAlpha)
BEGIN
	-- ��ӡ���
	PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> ��Ҫ������Ч��ǣ�';

	SET @SqlDate = GetDate();
	-- ��������
	UPDATE dbo.Grammar2 SET invalid = 1 WHERE content = @SqlContent;
	--UPDATE dbo.Grammar3 SET invalid = 1 WHERE lcontent = @SqlContent;
	--UPDATE dbo.Grammar3 SET invalid = 1 WHERE rcontent = @SqlContent;
	--UPDATE dbo.Grammar4 SET invalid = 1 WHERE lcontent = @SqlContent;
	--UPDATE dbo.Grammar4 SET invalid = 1 WHERE rcontent = @SqlContent;
	-- ��ʱ����
	PRINT '������Ч�Ĵʻ�> ������Ч��Ǻ�ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';
	
	-- ��ӡ���
	PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> ��Ч����Ѿ����ã�';
END
ELSE
BEGIN
	-- ��ӡ���
	PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> �ݲ���Ҫ������Ч��ǣ�';
END
-- ��ʱ����
PRINT '������Ч�Ĵʻ�> ������ݼ����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlTotal, GetDate())) + '����';

-- ��������
UPDATE dbo.Grammar2
SET alpha = @SqlAlpha,
operations = 1 WHERE content = @SqlContent;

-- ���ѭ��������
SET @SqlLoop = @SqlLoop - 1; IF @SqlLoop > 0 GOTO DO_IT_AGAIN;

-- ��ӡ���
PRINT '������Ч�Ĵʻ�(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> ��ز����Ѿ�ȫ����ɣ�';

END_OF_EXECUTION:

SET NOCOUNT OFF;
