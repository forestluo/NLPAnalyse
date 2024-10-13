USE [nldb]
GO
/****** Object: ����δ���õ�ԭ�� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��22��>
-- Description:	<����δ���õ�ԭ��>
-- =============================================

DECLARE @SqlID INT;
DECLARE @SqlOID INT;
DECLARE @SqlCID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlTrimed UString;
DECLARE @SqlContent UString;

------------------------------------------------
--
-- �������
--
------------------------------------------------

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT oid, cid, content FROM dbo.OuterContent
		WHERE LEN(TRIM(content)) < LEN(content) AND classification = 'ԭ��'
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
	SET @SqlTrimed = TRIM(@SqlContent);
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
		UPDATE dbo.OuterContent
			SET content = REPLACE(content, @SqlContent, @SqlTrimed),
			content_hash = dbo.GetHash(REPLACE(content, @SqlContent, @SqlTrimed))
			WHERE a_id = @SqlCID OR
			b_id = @SqlCID OR c_id = @SqlCID OR d_id = @SqlCID OR e_id = @SqlCID OR f_id = @SqlCID OR
			g_id = @SqlCID OR h_id = @SqlCID OR i_id = @SqlCID OR j_id = @SqlCID OR k_id = @SqlCID OR
			l_id = @SqlCID OR m_id = @SqlCID OR n_id = @SqlCID OR o_id = @SqlCID OR p_id = @SqlCID OR
			q_id = @SqlCID OR r_id = @SqlCID OR s_id = @SqlCID OR t_id = @SqlCID OR u_id = @SqlCID OR
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '����';
		-- ��ӡ���
		PRINT '����δ�ü���ԭ��(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',1)>��Ӱ��' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';
	END
	ELSE
	BEGIN
		-- ɾ��ԭ��ֵ
		DELETE FROM dbo.OuterContent WHERE oid = @SqlOID;
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
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '����';
		-- ��ӡ���
		PRINT '����δ�ü���ԭ��(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',2)>��Ӱ��' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '�У�';
	END
	-- ��ӡ���
	PRINT '����δ�ü���ԭ��>�Ѵ���' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�У�';
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

