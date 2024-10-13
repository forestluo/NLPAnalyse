USE [nldb]
GO

-- ������ʱ����
DECLARE @SqlID INT;
DECLARE @SqlEID INT;
DECLARE @SqlEnd INT;
DECLARE @SqlStart INT;
DECLARE @SqlValue UString;
DECLARE @SqlContent UString;
DECLARE @SqlMessage UString;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT eid, message FROM dbo.ExceptionLog
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlMessage;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '�����쳣��־> ' + @SqlMessage;

	-- ������Ϣ
	--SET @SqlStart = PATINDEX('%(tid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- �����
	--IF @SqlStart > 0
	--BEGIN
	--	 Ѱ�ҽ�β
	--	SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
	--	 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
	--	 �����
	--	IF @SqlEnd > 0
	--	BEGIN
	--		 ��ñ�ʶ����
	--		SET @SqlValue =
	--			SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
	--		 ��ӡ
	--		PRINT '�����쳣��־> tid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

	--		 �����Ҳ������������
	--		SELECT @SqlContent = content FROM dbo.TextPool WHERE tid = @SqlID;
	--		 �������
	--		SET @SqlContent = dbo.ClearInvisibleChar(@SqlContent);
	--		 ��������
	--		UPDATE dbo.TextPool
	--			SET parsed = 0, result = 0, remark = NULL, length = LEN(@SqlContent), content = @SqlContent WHERE tid = @SqlID;
	--		 ɾ������־��¼
	--		DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
	--	END
	--END
	
	-- ������Ϣ
	--SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- �����
	--IF @SqlStart > 0
	--BEGIN
	--	 Ѱ�ҽ�β
	--	SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
	--	 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
	--	 �����
	--	IF @SqlEnd > 0
	--	BEGIN
	--		 ��ñ�ʶ����
	--		SET @SqlValue =
	--			SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
	--		 ��ӡ
	--		PRINT '�����쳣��־> eid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

	--		 ������־��ָ����
	--		UPDATE dbo.ExternalContent SET type = 0 WHERE eid = @SqlID;
	--		 ɾ������־��¼
	--		DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
	--	END
	--END

	-- ������Ϣ
	SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- �����
	IF @SqlStart > 0
	BEGIN
		-- Ѱ�ҽ�β
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- �����
		IF @SqlEnd > 0 AND CHARINDEX('�ظ���ֵ',@SqlMessage) > 0
		BEGIN
			-- ��ñ�ʶ����
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- ��ӡ
			PRINT '�����쳣��־> eid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

			-- ������־��ָ����
			UPDATE dbo.ExternalContent SET type = 2 WHERE eid = @SqlID;
			-- ɾ������־��¼
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END

	--  ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlMessage;
END

-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

--  ��ӡ���
PRINT '�����쳣��־> ��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
