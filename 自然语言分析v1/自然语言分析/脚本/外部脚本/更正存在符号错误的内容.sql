USE [nldb]
GO
/****** Object: 更正存在符号错误的内容 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月22日>
-- Description:	<更正存在符号错误的内容>
-- =============================================

-- 声明临时变量
DECLARE @SqlID INT;
DECLARE @SqlOID INT;
DECLARE @SqlCID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlTrimed UString;
DECLARE @SqlContent UString;

-- 检查临时表
IF OBJECT_ID('#SqlTable', 'U') IS NOT NULL
	DROP TABLE #SqlTable;
-- 创建临时表
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
-- 清理程序
--
------------------------------------------------

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT TOP 100 oid, cid, content FROM dbo.OuterContent
		WHERE RIGHT(content,1) = '"' AND CHARINDEX('"',LEFT(content,LEN(content) - 1)) <= 0 AND classification = '分句';
		-- WHERE LEFT(content, 1) = '"' AND CHARINDEX('"', content, 2) <= 0 AND classification = '分句'
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 修改计数器
	SET @SqlCount = @SqlCount + 1;
	-- 做剪裁处理
	SET @SqlTrimed = LEFT(@SqlContent,LEN(@SqlContent) - 1);
	-- SET @SqlTrimed = RIGHT(@SqlContent, LEN(@SqlContent) - 1);
	-- 查找剪裁后是否有对应的CID
	SET @SqlID = dbo.GetContentID(@SqlTrimed);
	-- 检查结果
	IF @SqlID IS NULL OR @SqlID <= 0
	BEGIN
		-- 更新内容库
		UPDATE dbo.OuterContent
			SET content = @SqlTrimed, content_hash = dbo.GetHash(@SqlTrimed)
			WHERE oid = @SqlOID;
		-- 插入数据库
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
		-- 更新内容库
		UPDATE dbo.OuterContent
			SET content = REPLACE(content, @SqlContent, @SqlTrimed),
			content_hash = dbo.GetHash(REPLACE(content, @SqlContent, @SqlTrimed))
			WHERE a_id = @SqlCID OR
			b_id = @SqlCID OR c_id = @SqlCID OR d_id = @SqlCID OR e_id = @SqlCID OR f_id = @SqlCID OR
			g_id = @SqlCID OR h_id = @SqlCID OR i_id = @SqlCID OR j_id = @SqlCID OR k_id = @SqlCID OR
			l_id = @SqlCID OR m_id = @SqlCID OR n_id = @SqlCID OR o_id = @SqlCID OR p_id = @SqlCID OR
			q_id = @SqlCID OR r_id = @SqlCID OR s_id = @SqlCID OR t_id = @SqlCID OR u_id = @SqlCID OR
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '单句';*/
		-- 打印输出
		PRINT '更正存在符号错误的内容(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',1)>受影响' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '行！';
	END
	ELSE
	BEGIN
		-- 删除原有值
		DELETE FROM dbo.OuterContent WHERE oid = @SqlOID;
		-- 插入数据库
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
		-- 更新内容库
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
			v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID AND classification = '单句';*/
		-- 打印输出
		PRINT '更正存在符号错误的内容(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID)	+ ',2)>受影响' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '行！';
	END
	-- 打印输出
	PRINT '更正存在符号错误的内容>已记录' + CONVERT(NVARCHAR(MAX), @SqlCount) + '行！';
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

-- 进行集中更新处理
-- 更新内容库
UPDATE dbo.OuterContent
	SET content = REPLACE(o.content, t.content, t.trimed),
	content_hash = dbo.GetHash(REPLACE(o.content, t.content, t.trimed))
	FROM dbo.OuterContent AS o, #SqlTable AS t WHERE o.oid = t.oid AND t.id IS NULL;
-- 打印输出
PRINT '更正存在符号错误的内容>已处理' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '行！';
-- 更新内容库
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
-- 打印输出
PRINT '更正存在符号错误的内容>已处理' + CONVERT(NVARCHAR(MAX), @@ROWCOUNT) + '行！';

-- 显示临时表的内容
SELECT * FROM #SqlTable;
-- 删除临时表
DROP TABLE #SqlTable;
