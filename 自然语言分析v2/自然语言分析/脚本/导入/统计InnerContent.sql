USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlCID INT;
DECLARE @SqlContent UString;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT cid, content
	FROM dbo.InnerContent WHERE classification IN ('����','�ִ�����ʵ�','�»��ֵ�','����ʵ�');
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlCID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SqlDate = GetDate();
	-- ��ӡ���
	PRINT 'ͳ��InnerContent(cid=' + CONVERT(NVARCHAR(MAX),@SqlCID) + ')> ��' + @SqlContent + '��';
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
	PRINT 'ͳ��InnerContent(cid=' + CONVERT(NVARCHAR(MAX),@SqlCID) + ')> ��ʱ' + CONVERT(NVARCHAR(MAX), DATEDIFF(ms, @SqlDate, GETDATE())) + '����';
	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlCID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

