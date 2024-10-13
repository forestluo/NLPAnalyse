USE [nldb]
GO

-- ������ʱ����
DECLARE @SqlEID INT;
DECLARE @SqlContent UString;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT eid, content FROM dbo.ExternalContent
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlContent;

-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- �������
	IF CHARINDEX('"', @SqlContent) = 1
		AND CHARINDEX('"', @SqlContent, 2) <= 0
	BEGIN
		-- ��ӡ
		PRINT '������󵥾�(eid=' + CONVERT(NVARCHAR(MAX),@SqlEID) + ')> {' + @SqlContent + '}';
		-- ����
		SET @SqlContent = RIGHT(@SqlContent,LEN(@SqlContent) - 1);
		-- ����Ƿ�Ψһ
		IF EXISTS (SELECT * FROM dbo.ExternalContent WHERE content = @SqlContent)
			-- ɾ����ǰ��¼
			DELETE FROM dbo.ExternalContent WHERE eid = @SqlEID;
		ELSE
			-- ���µ�ǰ��¼
			UPDATE dbo.ExternalContent SET length = LEN(@SqlContent), content = @SqlContent WHERE eid = @SqlEID;
	END
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlContent;
END

-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 
