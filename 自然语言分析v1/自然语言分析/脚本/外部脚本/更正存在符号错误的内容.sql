USE [nldb]
GO
/****** Object: �������ڷ��Ŵ�������� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��22��>
-- Description:	<�������ڷ��Ŵ��������>
-- =============================================

-- ������ʱ����
DECLARE @SqlID INT;
DECLARE @SqlOID INT;
DECLARE @SqlCID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlTrimed UString;
DECLARE @SqlContent UString;

-- �����ʱ��
IF OBJECT_ID('#SqlTable', 'U') IS NOT NULL
	DROP TABLE #SqlTable;
-- ������ʱ��
CREATE TABLE #SqlTable
(
	oid		INT					NULL,
	cid		INT					NULL,
	id		INT					NULL,
	content	NVARCHAR(256)		NOT NULL,
	trimed	NVARCHAR(256)		NOT NULL
);

------------------------------------------------
--
-- �������
--
------------------------------------------------

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT TOP 100 oid, cid, content FROM dbo.OuterContent
		WHERE RIGHT(content,1) = '"' AND CHARINDEX('"',LEFT(content,LEN(content) - 1)) <= 0 AND classification = '�־�';
		-- WHERE LEFT(content, 1) = '"' AND CHARINDEX('"', content, 2) <= 0 AND classification = '�־�'
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- �޸ļ�����
	SET @SqlCount = @SqlCount + 1;
	-- �����ô���
	SET @SqlTrimed = LEFT(@SqlContent,LEN(@SqlContent) - 1);
	-- SET @SqlTrimed = RIGHT(@SqlContent, LEN(@SqlContent) - 1);
	-- ���Ҽ��ú��Ƿ��ж�Ӧ��CID
	SET @SqlID = dbo.GetContentID(@SqlTrimed);
	-- �����
	IF @SqlID IS NULL OR @SqlID <= 0
	BEGIN
		-- �������ݿ�
		UPDATE dbo.OuterContent
			SET content = @SqlTrimed, content_hash = dbo.GetHash(@SqlTrimed)
			WHERE oid = @SqlOID;
		-- �������ݿ�
		INSERT INTO #SqlTable (oid, cid, content, trimed)
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE a_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE b_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE c_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE d_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE e_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE f_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE g_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE h_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE i_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE j_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE k_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE l_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE m_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE n_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE o_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE p_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE q_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE r_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE s_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE t_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE u_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE v_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE w_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE x_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE y_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE z_id = @SqlCID;
		/*
		-- �������ݿ�
		UPDATE dbo.OuterContent
			SET content = REPLACE(content, @SqlContent, @SqlTrimed),
			content_hash = dbo.GetHash(REPLACE(content, @SqlContent, @SqlTrimed))
			WHERE a_id = @SqlCID OR
			b_id = @SqlCID OR c_id = @SqlCID OR d_id = @SqlCID OR e_id = @SqlCID OR f_id = @SqlCID OR
			g_id = @SqlCID OR h_id = @SqlCID OR i_id = @SqlCID OR j_id = @SqlCID OR k_id = @SqlCID OR
			l_id = @SqlCID OR m_id = @SqlCID OR n_id = @SqlCID OR o_id = @SqlCID OR p_id = @SqlCID OR
			q_id = @SqlCID OR r_id = @SqlCID OR s_id = @SqlCID OR t_id = @SqlCID OR u_id = @SqlCID OR
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '����';*/
		-- ��ӡ���
		PRINT '�������ڷ��Ŵ��������(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',1)>��Ӱ��' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';
	END
	ELSE
	BEGIN
		-- ɾ��ԭ��ֵ
		DELETE FROM dbo.OuterContent WHERE oid = @SqlOID;
		-- �������ݿ�
		INSERT INTO #SqlTable (oid, cid, id, content, trimed)
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE a_id = @SqlCID UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE a_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE b_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE c_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE d_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE e_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE f_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE g_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE h_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE i_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE j_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE k_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE l_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE m_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE n_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE o_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE p_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE q_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE r_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE s_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE t_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE u_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE v_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE w_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE x_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE y_id = @SqlCID	UNION
			SELECT oid, @SqlCID, @SqlID, @SqlContent, @SqlTrimed FROM dbo.OuterContent WHERE z_id = @SqlCID;
		/*
		-- �������ݿ�
		UPDATE dbo.OuterContent
			SET content = REPLACE(content, @SqlContent, @SqlTrimed),
			content_hash = dbo.GetHash(REPLACE(content, @SqlContent, @SqlTrimed)),
			a_id = CASE a_id WHEN @SqlCID THEN @SqlID ELSE a_id END,
			b_id = CASE b_id WHEN @SqlCID THEN @SqlID ELSE b_id END,
			c_id = CASE c_id WHEN @SqlCID THEN @SqlID ELSE c_id END,
			d_id = CASE d_id WHEN @SqlCID THEN @SqlID ELSE d_id END,
			e_id = CASE e_id WHEN @SqlCID THEN @SqlID ELSE e_id END,
			f_id = CASE f_id WHEN @SqlCID THEN @SqlID ELSE f_id END,
			g_id = CASE g_id WHEN @SqlCID THEN @SqlID ELSE g_id END,
			h_id = CASE h_id WHEN @SqlCID THEN @SqlID ELSE h_id END,
			i_id = CASE i_id WHEN @SqlCID THEN @SqlID ELSE i_id END,
			j_id = CASE j_id WHEN @SqlCID THEN @SqlID ELSE j_id END,
			k_id = CASE k_id WHEN @SqlCID THEN @SqlID ELSE k_id END,
			l_id = CASE l_id WHEN @SqlCID THEN @SqlID ELSE l_id END,
			m_id = CASE m_id WHEN @SqlCID THEN @SqlID ELSE m_id END,
			n_id = CASE n_id WHEN @SqlCID THEN @SqlID ELSE n_id END,
			o_id = CASE o_id WHEN @SqlCID THEN @SqlID ELSE o_id END,
			p_id = CASE p_id WHEN @SqlCID THEN @SqlID ELSE p_id END,
			q_id = CASE q_id WHEN @SqlCID THEN @SqlID ELSE q_id END,
			r_id = CASE r_id WHEN @SqlCID THEN @SqlID ELSE r_id END,
			s_id = CASE s_id WHEN @SqlCID THEN @SqlID ELSE s_id END,
			t_id = CASE t_id WHEN @SqlCID THEN @SqlID ELSE t_id END,
			u_id = CASE u_id WHEN @SqlCID THEN @SqlID ELSE u_id END,
			v_id = CASE v_id WHEN @SqlCID THEN @SqlID ELSE v_id END,
			w_id = CASE w_id WHEN @SqlCID THEN @SqlID ELSE w_id END,
			x_id = CASE x_id WHEN @SqlCID THEN @SqlID ELSE x_id END,
			y_id = CASE y_id WHEN @SqlCID THEN @SqlID ELSE y_id END,
			z_id = CASE z_id WHEN @SqlCID THEN @SqlID ELSE z_id END
			WHERE a_id = @SqlCID OR
			b_id = @SqlCID OR c_id = @SqlCID OR d_id = @SqlCID OR e_id = @SqlCID OR f_id = @SqlCID OR
			g_id = @SqlCID OR h_id = @SqlCID OR i_id = @SqlCID OR j_id = @SqlCID OR k_id = @SqlCID OR
			l_id = @SqlCID OR m_id = @SqlCID OR n_id = @SqlCID OR o_id = @SqlCID OR p_id = @SqlCID OR
			q_id = @SqlCID OR r_id = @SqlCID OR s_id = @SqlCID OR t_id = @SqlCID OR u_id = @SqlCID OR
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '����';*/
		-- ��ӡ���
		PRINT '�������ڷ��Ŵ��������(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',2)>��Ӱ��' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';
	END
	-- ��ӡ���
	PRINT '�������ڷ��Ŵ��������>�Ѽ�¼' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�У�';
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

-- ���м��и��´���
-- �������ݿ�
UPDATE dbo.OuterContent
	SET content = REPLACE(o.content, t.content, t.trimed),
	content_hash = dbo.GetHash(REPLACE(o.content, t.content, t.trimed))
	FROM dbo.OuterContent AS o, #SqlTable AS t WHERE o.oid = t.oid AND t.id IS NULL;
-- ��ӡ���
PRINT '�������ڷ��Ŵ��������>�Ѵ���' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';
-- �������ݿ�
UPDATE dbo.OuterContent
	SET content = REPLACE(o.content, t.content, t.trimed),
	content_hash = dbo.GetHash(REPLACE(o.content, t.content, t.trimed)),
	a_id = CASE a_id WHEN t.cid THEN t.id ELSE a_id END,
	b_id = CASE b_id WHEN t.cid THEN t.id ELSE b_id END,
	c_id = CASE c_id WHEN t.cid THEN t.id ELSE c_id END,
	d_id = CASE d_id WHEN t.cid THEN t.id ELSE d_id END,
	e_id = CASE e_id WHEN t.cid THEN t.id ELSE e_id END,
	f_id = CASE f_id WHEN t.cid THEN t.id ELSE f_id END,
	g_id = CASE g_id WHEN t.cid THEN t.id ELSE g_id END,
	h_id = CASE h_id WHEN t.cid THEN t.id ELSE h_id END,
	i_id = CASE i_id WHEN t.cid THEN t.id ELSE i_id END,
	j_id = CASE j_id WHEN t.cid THEN t.id ELSE j_id END,
	k_id = CASE k_id WHEN t.cid THEN t.id ELSE k_id END,
	l_id = CASE l_id WHEN t.cid THEN t.id ELSE l_id END,
	m_id = CASE m_id WHEN t.cid THEN t.id ELSE m_id END,
	n_id = CASE n_id WHEN t.cid THEN t.id ELSE n_id END,
	o_id = CASE o_id WHEN t.cid THEN t.id ELSE o_id END,
	p_id = CASE p_id WHEN t.cid THEN t.id ELSE p_id END,
	q_id = CASE q_id WHEN t.cid THEN t.id ELSE q_id END,
	r_id = CASE r_id WHEN t.cid THEN t.id ELSE r_id END,
	s_id = CASE s_id WHEN t.cid THEN t.id ELSE s_id END,
	t_id = CASE t_id WHEN t.cid THEN t.id ELSE t_id END,
	u_id = CASE u_id WHEN t.cid THEN t.id ELSE u_id END,
	v_id = CASE v_id WHEN t.cid THEN t.id ELSE v_id END,
	w_id = CASE w_id WHEN t.cid THEN t.id ELSE w_id END,
	x_id = CASE x_id WHEN t.cid THEN t.id ELSE x_id END,
	y_id = CASE y_id WHEN t.cid THEN t.id ELSE y_id END,
	z_id = CASE z_id WHEN t.cid THEN t.id ELSE z_id END
	FROM dbo.OuterContent AS o, #SqlTable AS t WHERE o.oid = t.oid AND t.id IS NOT NULL;
-- ��ӡ���
PRINT '�������ڷ��Ŵ��������>�Ѵ���' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';

-- ��ʾ��ʱ�������
SELECT * FROM #SqlTable;
-- ɾ����ʱ��
DROP TABLE #SqlTable;
