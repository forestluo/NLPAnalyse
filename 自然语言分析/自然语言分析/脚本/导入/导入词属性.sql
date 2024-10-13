USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlRID INT;
DECLARE @SqlContent UString;
DECLARE @SqlAttribute UString;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT rid, [rule], attribute
	FROM dbo.LogicRule WHERE classification = '���ܴ�';
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlContent, @SqlAttribute;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��������
	SET @SqlContent =
		LEFT(@SqlContent, LEN(@SqlContent) - 1);
	SET @SqlContent =
		RIGHT(@SqlContent, LEN(@SqlContent) - 1);
	-- �����
	IF CHARINDEX(@SqlAttribute, '|') > 0
	BEGIN
		-- ����һ����¼
		INSERT INTO dbo.WordAttribute
			(classification, length, content, attribute)
			VALUES ('���ܴ�', LEN(@SqlContent), @SqlContent, @SqlAttribute);
	END
	ELSE
	BEGIN
		-- ���������¼
		INSERT INTO dbo.WordAttribute
			(classification, length, content, attribute)
			SELECT '���ܴ�', LEN(@SqlContent), @SqlContent, * FROM dbo.RegExSplit('\|', @SqlAttribute, 1);
	END
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlContent, @SqlAttribute;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());
