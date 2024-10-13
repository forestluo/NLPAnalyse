USE [nldb]
GO

-- ������ʱ����
DECLARE @SqlCount INT;
DECLARE @SqlDate DATETIME;

-- ���ó�ʼֵ
SET @SqlCount = 10;

SET @SqlDate = GetDate();
-- ͳ��ȫ��ͨ��Ƶ(����1)
EXEC dbo.[ͳ��ȫ��ͨ��Ƶ] @SqlCount, 1
-- ��ӡ���
PRINT '�������ϴ���Ч��> ͳ��ȫ��ͨ��Ƶ(����1)��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

SET @SqlDate = GetDate();
-- ͳ��ȫ��ͨ��Ƶ(����2)
EXEC dbo.[ͳ��ȫ��ͨ��Ƶ] @SqlCount, 2
-- ��ӡ���
PRINT '�������ϴ���Ч��> ͳ��ȫ��ͨ��Ƶ(����2)��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

--SET @SqlDate = GetDate();
---- ͳ��ȫ��ͨ��Ƶ(����3)
--EXEC dbo.[ͳ��ȫ��ͨ��Ƶ] @SqlCount, 3
---- ��ӡ���
--PRINT '�������ϴ���Ч��> ͳ��ȫ��ͨ��Ƶ(����3)��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

-- ������Ӱ����λ
SET @SqlDate = GetDate();
-- ��(����1ѡ����³���2������3�ͳ���4)
-- ���±��λ
UPDATE dbo.Grammar2
SET operations = 1
FROM
(
	SELECT content FROM dbo.Grammar1 WHERE operations = 1
) AS T WHERE Grammar2.lcontent = T.content

-- ���±��λ
UPDATE dbo.Grammar2
SET operations = 1
FROM
(
	SELECT content FROM dbo.Grammar1 WHERE operations = 1
) AS T WHERE Grammar2.rcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar3.lcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar3.rcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar1 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

---- ��(����2ѡ����³���3�ͳ���4)
---- ���±��λ
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar3.lcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar3
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar3.rcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar2 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

---- ��(����3ѡ����³���4)
---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar3 WHERE operations = 1
--) AS T WHERE Grammar4.lcontent = T.content

---- ���±��λ
--UPDATE dbo.Grammar4
--SET operations = 1
--FROM
--(
--	SELECT content FROM dbo.Grammar3 WHERE operations = 1
--) AS T WHERE Grammar4.rcontent = T.content

-- ��operation�����invalid
UPDATE dbo.Grammar2 SET invalid = 0 WHERE operations = 1;
-- ��ӡ���
PRINT '�������ϴ���Ч��> ����������Ӱ����λ��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

-- �����������ϵ��
SET @SqlDate = GetDate();
-- �������ϵ��(����2)
UPDATE dbo.Grammar2
SET alpha = dbo.GrammarGetAlphaValue(lcontent + '|' + rcontent)
WHERE operations = 1
-- ��ӡ���
PRINT '�������ϴ���Ч��> �����������ϵ����ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

DO_IT_AGAIN:

-- �����������ϵ��
SET @SqlDate = GetDate();
-- �������ϵ��
UPDATE dbo.Grammar1
SET
ralpha = dbo.GrammarGetAlphaAverage(1,content,NULL),
lalpha = dbo.GrammarGetAlphaAverage(-1,content,NULL)
WHERE operations = 1
-- ��ӡ���
PRINT '�������ϴ���Ч��> ���������������ϵ����ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';

SET @SqlDate = GetDate();
-- ������Ч���λ
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
-- ���Ӱ������
SET @SqlCount = @@ROWCOUNT;
-- ��ӡ���
PRINT '�������ϴ���Ч��> ��Ӱ��' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�У�';
-- ��ӡ���
PRINT '�������ϴ���Ч��> ������Ч���λ��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '���룡';
-- �����
IF @SqlCount > 0 GOTO DO_IT_AGAIN;
-- ��ӡ���
PRINT '�������ϴ���Ч��> ȫ��������ϣ�';
-- ������λ
UPDATE dbo.Grammar1 SET operations = 0 WHERE operations > 0;
UPDATE dbo.Grammar2 SET operations = 0 WHERE operations > 0;

