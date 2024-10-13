USE [nldb]
GO

-- ������ʱ����
DECLARE @SqlContent UString;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT DISTINCT(content) AS content
	FROM dbo.WordAttribute WHERE classification IN ('���ܴ�','ʵ��')
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '����ʵ����> ' + @SqlContent;
	
	--  ��õ�ǰʱ��
	SET @SqlDate = GetDate();

	--  ���´ʵ�
	UPDATE dbo.Dictionary SET [enable] = 0
		WHERE content like '%' + @SqlContent + '%';

	----  ���´ʵ�
	--UPDATE dbo.Dictionary SET [enable] = 0
	--WHERE content IN
	--(
	--	SELECT DISTINCT content FROM dbo.Dictionary WHERE content like @SqlContent + '%'
	--) AND content NOT IN (@SqlContent);
	
	----  ���´ʵ�
	--UPDATE dbo.Dictionary SET [enable] = 0
	--WHERE content IN
	--(
	--	SELECT DISTINCT content FROM dbo.Dictionary WHERE content like '%' + @SqlContent
	--) AND content NOT IN (@SqlContent);

	--  ��ӡ���
	PRINT '����ʵ����> ��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
	--  ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
END

-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 
