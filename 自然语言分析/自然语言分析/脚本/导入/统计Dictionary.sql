USE [nldb]
GO

SET NOCOUNT ON;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlDID INT;
DECLARE @SqlContent UString;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content FROM dbo.Dictionary WHERE operations = 0
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SqlDate = GetDate();
	-- ��ӡ���
	PRINT 'ͳ��Dictionary(did=' + CONVERT(NVARCHAR(MAX),@SqlDID) + ')> ��' + @SqlContent + '��';
	-- �������
	IF dbo.IsChineseString(@SqlContent) = 1
	BEGIN
		---- ��鳤��
		--IF LEN(@SqlContent) >= 1
		--BEGIN
		--	-- ����ͳ��
		--	EXEC dbo.GrammarStatistics 1, @SqlContent;
		--END
		---- ��鳤��
		--IF LEN(@SqlContent) >= 2
		--BEGIN
		--	-- ����ͳ��
		--	EXEC dbo.GrammarStatistics 2, @SqlContent;
		--END
		-- ��鳤��
		IF LEN(@SqlContent) >= 3
		BEGIN
			-- ����ͳ��
			EXEC dbo.GrammarStatistics 3, @SqlContent;
		END
		---- ��鳤��
		--IF LEN(@SqlContent) >= 4
		--BEGIN
		--	-- ����ͳ��
		--	EXEC dbo.GrammarStatistics 4, @SqlContent;
		--END
	END
	-- ��ӡ���
	PRINT 'ͳ��Dictionary(did=' + CONVERT(NVARCHAR(MAX),@SqlDID) + ')> ��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '����';
	-- ���¼�¼
	UPDATE dbo.Dictionary
	SET operations = 1 WHERE did = @SqlDID;
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

SET NOCOUNT OFF;