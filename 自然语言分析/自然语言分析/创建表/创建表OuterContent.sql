USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[创建表OuterContent]    Script Date: 2020/12/9 15:42:28 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月9日>
-- Description:	<创建外部文本内容表>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[创建表OuterContent]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 删除之前的索引
	IF OBJECT_ID('OuterContentIndex') IS NOT NULL
		DROP INDEX dbo.OuterContentIndex;
	IF OBJECT_ID('OuterContentOIDIndex') IS NOT NULL
		DROP INDEX dbo.OuterContentOIDIndex;
	IF OBJECT_ID('OuterContentCIDIndex') IS NOT NULL
		DROP INDEX dbo.OuterContentCIDIndex;
	IF OBJECT_ID('OuterParseRuleIndex') IS NOT NULL
		DROP INDEX dbo.OuterParseRuleIndex;
	IF OBJECT_ID('OuterContentClassificationIndex') IS NOT NULL
		DROP INDEX dbo.OuterContentClassificationIndex;
	IF OBJECT_ID('OuterContentTypeIndex') IS NOT NULL
		DROP INDEX dbo.OuterContentTypeIndex;

	--IF OBJECT_ID('OuterContentAAIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentAAIDIndex;
	--IF OBJECT_ID('OuterContentBBIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentBBIDIndex;
	--IF OBJECT_ID('OuterContentCCIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentCCIDIndex;
	--IF OBJECT_ID('OuterContentDDIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentDDIDIndex;
	--IF OBJECT_ID('OuterContentEEIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentEEIDIndex;
	--IF OBJECT_ID('OuterContentFFIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentFFIDIndex;
	--IF OBJECT_ID('OuterContentGGIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentGGIDIndex;
	--IF OBJECT_ID('OuterContentHHIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentHHIDIndex;
	--IF OBJECT_ID('OuterContentIIIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentIIIDIndex;
	--IF OBJECT_ID('OuterContentJJIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentJJIDIndex;
	--IF OBJECT_ID('OuterContentKKIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentKKIDIndex;
	--IF OBJECT_ID('OuterContentLLIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentLLIDIndex;
	--IF OBJECT_ID('OuterContentMMIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentMMIDIndex;
	--IF OBJECT_ID('OuterContentNNIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentNNIDIndex;
	--IF OBJECT_ID('OuterContentOOIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentOOIDIndex;
	--IF OBJECT_ID('OuterContentPPIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentPPIDIndex;
	--IF OBJECT_ID('OuterContentQQIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentQQIDIndex;
	--IF OBJECT_ID('OuterContentRRIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentRRIDIndex;
	--IF OBJECT_ID('OuterContentSSIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentSSIDIndex;
	--IF OBJECT_ID('OuterContentTTIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentTTIDIndex;
	--IF OBJECT_ID('OuterContentUUIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentUUIDIndex;
	--IF OBJECT_ID('OuterContentVVIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentVVIDIndex;
	--IF OBJECT_ID('OuterContentWWIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentWWIDIndex;
	--IF OBJECT_ID('OuterContentXXIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentXXIDIndex;
	--IF OBJECT_ID('OuterContentYYIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentYYIDIndex;
	--IF OBJECT_ID('OuterContentZZIDIndex') IS NOT NULL
	--	DROP INDEX dbo.OuterContentZZIDIndex;

	-- 删除之前的表
	IF OBJECT_ID('OuterContent') IS NOT NULL
		DROP TABLE dbo.OuterContent;
	-- 创建数据表
	CREATE TABLE dbo.OuterContent
	(
		-- 编号
		oid						INT						IDENTITY(1,1)				NOT NULL,
		-- 内容ID（允许重复）
		cid						INT						NOT NULL,
		-- 分类描述
		[classification]		NVARCHAR(64)			NULL,
		-- 计数器
		[count]					INT						NOT NULL					DEFAULT 0,
		-- 内容长度
		[length]				INT						NOT NULL					DEFAULT 0,
		-- 类型
		[type]					INT						NOT NULL					DEFAULT 0,
		-- 内容描述（允许重复）
		content					NVARCHAR(450)			NOT NULL,
		-- 解析规则（允许重复）
		[rule]					NVARCHAR(256)			NULL,
		-- 参数编号
		a_id					INT						NOT NULL					DEFAULT 0,
		b_id					INT						NOT NULL					DEFAULT 0,
		c_id					INT						NOT NULL					DEFAULT 0,
		d_id					INT						NOT NULL					DEFAULT 0,
		e_id					INT						NOT NULL					DEFAULT 0,
		f_id					INT						NOT NULL					DEFAULT 0,
		g_id					INT						NOT NULL					DEFAULT 0,
		h_id					INT						NOT NULL					DEFAULT 0,
		i_id					INT						NOT NULL					DEFAULT 0,
		j_id					INT						NOT NULL					DEFAULT 0,
		k_id					INT						NOT NULL					DEFAULT 0,
		l_id					INT						NOT NULL					DEFAULT 0,
		m_id					INT						NOT NULL					DEFAULT 0,
		n_id					INT						NOT NULL					DEFAULT 0,
		o_id					INT						NOT NULL					DEFAULT 0,
		p_id					INT						NOT NULL					DEFAULT 0,
		q_id					INT						NOT NULL					DEFAULT 0,
		r_id					INT						NOT NULL					DEFAULT 0,
		s_id					INT						NOT NULL					DEFAULT 0,
		t_id					INT						NOT NULL					DEFAULT 0,
		u_id					INT						NOT NULL					DEFAULT 0,
		v_id					INT						NOT NULL					DEFAULT 0,
		w_id					INT						NOT NULL					DEFAULT 0,
		x_id					INT						NOT NULL					DEFAULT 0,
		y_id					INT						NOT NULL					DEFAULT 0,
		z_id					INT						NOT NULL					DEFAULT 0
	);
	-- 创建简单索引
	CREATE INDEX OuterContentOIDIndex ON OuterContent (oid);
	CREATE INDEX OuterContentCIDIndex ON OuterContent (cid);
	CREATE INDEX OuterContentIndex ON OuterContent (content);
	CREATE INDEX OuterParseRuleIndex ON OuterContent ([rule]);
	CREATE INDEX OuterContentClassificationIndex ON OuterContent ([classification]);
	CREATE INDEX OuterContentTypeIndex ON OuterContent ([type]);

	--CREATE INDEX OuterContentAAIDIndex ON dbo.OuterContent (a_id);
	--CREATE INDEX OuterContentBBIDIndex ON dbo.OuterContent (b_id);
	--CREATE INDEX OuterContentCCIDIndex ON dbo.OuterContent (c_id);
	--CREATE INDEX OuterContentDDIDIndex ON dbo.OuterContent (d_id);
	--CREATE INDEX OuterContentEEIDIndex ON dbo.OuterContent (e_id);
	--CREATE INDEX OuterContentFFIDIndex ON dbo.OuterContent (f_id);
	--CREATE INDEX OuterContentGGIDIndex ON dbo.OuterContent (g_id);
	--CREATE INDEX OuterContentHHIDIndex ON dbo.OuterContent (h_id);
	--CREATE INDEX OuterContentIIIDIndex ON dbo.OuterContent (i_id);
	--CREATE INDEX OuterContentJJIDIndex ON dbo.OuterContent (j_id);
	--CREATE INDEX OuterContentKKIDIndex ON dbo.OuterContent (k_id);
	--CREATE INDEX OuterContentLLIDIndex ON dbo.OuterContent (l_id);
	--CREATE INDEX OuterContentMMIDIndex ON dbo.OuterContent (m_id);
	--CREATE INDEX OuterContentNNIDIndex ON dbo.OuterContent (n_id);
	--CREATE INDEX OuterContentOOIDIndex ON dbo.OuterContent (o_id);
	--CREATE INDEX OuterContentPPIDIndex ON dbo.OuterContent (p_id);
	--CREATE INDEX OuterContentQQIDIndex ON dbo.OuterContent (q_id);
	--CREATE INDEX OuterContentRRIDIndex ON dbo.OuterContent (r_id);
	--CREATE INDEX OuterContentSSIDIndex ON dbo.OuterContent (s_id);
	--CREATE INDEX OuterContentTTIDIndex ON dbo.OuterContent (t_id);
	--CREATE INDEX OuterContentUUIDIndex ON dbo.OuterContent (u_id);
	--CREATE INDEX OuterContentVVIDIndex ON dbo.OuterContent (v_id);
	--CREATE INDEX OuterContentWWIDIndex ON dbo.OuterContent (w_id);
	--CREATE INDEX OuterContentXXIDIndex ON dbo.OuterContent (x_id);
	--CREATE INDEX OuterContentYYIDIndex ON dbo.OuterContent (y_id);
	--CREATE INDEX OuterContentZZIDIndex ON dbo.OuterContent (z_id);

END
