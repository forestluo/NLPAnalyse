USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlDID INT;
DECLARE @SqlRemark UString;
DECLARE @SqlContent UString;
DECLARE @SqlAttribute UString;

-- ������ʱ����
DECLARE @SqlIndex INT;
DECLARE @SqlValue UString;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content, remark
	FROM dbo.Dictionary WHERE classification = '�ִ�35��';
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent, @SqlRemark;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ����λ��
	SET @SqlIndex = CHARINDEX(',', @SqlRemark);
	-- �����
	IF @SqlIndex > 0
		SET @SqlRemark = LEFT(@SqlRemark, @SqlIndex - 1);

	-- ����
	SET @SqlRemark = TRIM(@SqlRemark);
	-- �����
	SET @SqlAttribute = 
		CASE @SqlRemark
			WHEN 'ag' THEN '����'
			WHEN 'a' THEN '���ݴ�'
			WHEN 'ad' THEN '����'
			WHEN 'an' THEN '������'
			WHEN 'b' THEN '�����'
			WHEN 'c' THEN '����'
			WHEN 'd' THEN '����'
			WHEN 'dg' THEN '������'
			WHEN 'df' THEN '�񶨸���'
			WHEN 'e' THEN '̾��'
			WHEN 'f' THEN '��λ��'
			WHEN 'g' THEN '����'
			WHEN 'h' THEN 'ǰ׺'
			WHEN 'i' THEN '����'
			WHEN 'j' THEN '������'
			WHEN 'k' THEN '��׺'
			WHEN 'l' THEN 'ϰ������'
			WHEN 'm' THEN '����'
			WHEN 'mg' THEN '��������'
			WHEN 'mq' THEN '������'
			WHEN 'ng' THEN '������'
			WHEN 'n' THEN '����'
			WHEN 'nr' THEN '����'
			WHEN 'nrt' THEN 'Ӣ����'
			WHEN 'nrfg' THEN '��ʷ����'
			WHEN 'ns' THEN '����'
			WHEN 'nt' THEN '�������'
			WHEN 'nz' THEN 'ר����'
			WHEN 'o' THEN '������'
			WHEN 'p' THEN '���'
			WHEN 'q' THEN '����'
			WHEN 'r' THEN '����'
			WHEN 'rg' THEN '��������'
			WHEN 'rr' THEN '�˳ƴ���'
			WHEN 'rz' THEN 'ָʾ����'
			WHEN 's' THEN '������'
			WHEN 'tg' THEN 'ʱ����'
			WHEN 't' THEN 'ʱ���'
			WHEN 'u' THEN '����'
			WHEN 'vg' THEN '������'
			WHEN 'v' THEN '����'
			WHEN 'vd' THEN '������'
			WHEN 'vn' THEN '������'
			WHEN 'vi' THEN '���ʳ�����'
			WHEN 'vq' THEN '�����Ķ���'
			WHEN 'w' THEN '������'
			WHEN 'x' THEN '��������'
			WHEN 'y' THEN '������'
			WHEN 'z' THEN '״̬��'
			WHEN 'zg' THEN '״̬����'
			WHEN 'un' THEN 'δ֪��'
			WHEN 'uv' THEN '�ṹ���ʵ�'
			WHEN 'uz' THEN '�ṹ������'
			WHEN 'uj' THEN '�ṹ���ʵ�'
			WHEN 'ug' THEN 'ʱ̬����'
			WHEN 'ud' THEN '�ṹ����'
			WHEN 'ul' THEN '�ṹ������'
			ELSE '��' END;

	-- ��ӡ
	PRINT '�������(did=' + CONVERT(NVARCHAR(MAX), @SqlDID) + ') > {' + @SqlContent + '}:' + @SqlRemark + ',' + @SqlAttribute;

--	IF @SqlAttribute IN ('����', '������')
--		SET @SqlAttribute = '����';
--	ELSE IF @SqlAttribute IN ('����', 'Ӣ����', '��ʷ����')
--		SET @SqlAttribute = '����';
--	ELSE IF @SqlAttribute IN ('ר����', '�������')
--		SET @SqlAttribute = 'ר����';
--	ELSE IF @SqlAttribute IN ('����', '������', '������')
--		SET @SqlAttribute = '����';
--	ELSE IF @SqlAttribute IN ('����', '�˳ƴ���', 'ָʾ����')
--		SET @SqlAttribute = '����';
--	ELSE IF @SqlAttribute IN ('����', '�񶨸���')
--		SET @SqlAttribute = '����';
--	ELSE IF @SqlAttribute IN ('ǰ׺', '����', '������', '��׺', 'ϰ������')
--		SET @SqlAttribute = 'ϰ������';
--	ELSE IF @SqlAttribute IN ('����', '���', '̾��', '����', '����', '����', '������', '���ݴ�', '��λ��')
--		GOTO NEXT_STEP;
--	ELSE
--		SET @SqlAttribute = NULL;
--NEXT_STEP:
	UPDATE dbo.InnerContent SET attribute = @SqlAttribute WHERE content = @SqlContent;

	-- ȡ��һ����¼ 
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent, @SqlRemark;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

/*���SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DateDiff(ms, @SqlDate, GetDate());

PRINT '������� > ȫ��������ϣ�';
