USE [nldb2]
GO

DECLARE @SqlCount INT;
SET @SqlCount = 1;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlCID INT;
DECLARE @SqlOID INT;
DECLARE @SqlResult INT;
DECLARE @SqlContent UString;

/*
INSERT INTO InnerContent
(cid, classification, length, type, content)
SELECT TOP 1 cid, '�ʵ�', length, -1, content FROM OuterContent WHERE dbo.LookupDictionary(content) IS NOT NULL;

DELETE FROM OuterContent WHERE content IN (SELECT content FROM InnerContent);
*/

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT TOP (@SqlCount) oid, cid, content
	FROM dbo.OuterContent
	WHERE classification = '�ı�' AND type = 0;
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ���´ʵ������
	EXEC @SqlResult = dbo.CheckDictionary @SqlContent;
	-- �����
	IF @SqlResult <= 0
	BEGIN
		-- ��ʶ�Ѿ�����
		UPDATE OuterContent
		SET type = 1 WHERE oid = @SqlOID;
	END
	ELSE
	BEGIN
		-- ���ڱ����һ������
		INSERT INTO InnerContent
		(cid, classification, length, type, content)
		VALUES (@SqlCID, '�ʵ�', LEN(@SqlContent), -1 ,@SqlContent);
		-- �������ɾ��һ������
		DELETE FROM OuterContent WHERE oid = @SqlOID;
	END
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());

-- SELECT * FROM OuterContent WHERE type = 1;
-- SELECT * FROM InnerContent WHERE classification='�ʵ�';
-- UPDATE OuterContent SET classification = '�ı�' WHERE type = 1;
