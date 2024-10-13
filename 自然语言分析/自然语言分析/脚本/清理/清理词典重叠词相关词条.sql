USE [nldb]
GO

--  ��õ�ǰʱ��
DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- ������ʱ����
DECLARE @SqlCount1 INT;
DECLARE @SqlContent1 UString;

DECLARE @SqlCount2 INT;
DECLARE @SqlContent2 UString;

-- �����α�
DECLARE SqlCursor1 CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT content, count 
	FROM
	(
		SELECT DISTINCT content,count FROM dbo.Dictionary
		WHERE enable = 1 AND count > 0 AND length > 1 AND dbo.ContentGetCID(content) <= 0
		AND classification NOT IN ('��˾','��˾��д','����','����','����','������','�»��ֵ�','�ִ�����ʵ�','��֯�ṹ','����')
	) AS T;
-- ���α�
OPEN SqlCursor1;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor1 INTO @SqlContent1, @SqlCount1;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '����ʵ��ص�����ش���> ' + @SqlContent1;
	
	SET @SqlDate = GetDate();
	-- �����α�
	DECLARE SqlCursor2 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT content, count
		FROM
		(
			SELECT DISTINCT content, count FROM dbo.Dictionary WHERE count > 0 AND length > LEN(@SqlContent1)
		) AS T
		WHERE content like '%' + @SqlContent1 + '%';
	-- ���α�
	OPEN SqlCursor2;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor2 INTO @SqlContent2, @SqlCount2;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �����
		IF (@SqlCount2 * 1.0 / @SqlCount1) > 0.6
		BEGIN
			PRINT '����ʵ��ص�����ش���> content(' + @SqlContent1 + '/' + @SqlContent2 + ') ' + 
				'����(' + CONVERT(NVARCHAR(MAX),@SqlCount1) + ':' + CONVERT(NVARCHAR(MAX),@SqlCount2) + ')����Ԥ�ڣ�';
			-- ɾ������
			EXEC dbo.ContentDeleteValue @SqlContent1;
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor2 INTO @SqlContent2, @SqlCount2;
	END
	-- �ر��α�
	CLOSE SqlCursor2;
	-- �ͷ��α�
	DEALLOCATE SqlCursor2; 
	--  ��ӡ���
	PRINT '����ʵ��ص�����ش���> ��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));

	--  ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor1 INTO @SqlContent1, @SqlCount1;
END

-- �ر��α�
CLOSE SqlCursor1;
-- �ͷ��α�
DEALLOCATE SqlCursor1; 

--  ��ӡ���
PRINT '����ʵ��ص�����ش���> ��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
