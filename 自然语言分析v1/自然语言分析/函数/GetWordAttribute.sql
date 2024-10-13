USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetWordAttribute]    Script Date: 2020/12/6 10:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<获得单词的词性>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[GetWordAttribute]
(
	-- Add the parameters for the function here
	@SqlWord UString
)
RETURNS INT
AS
BEGIN

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlResult INT;

	-- 声明临时变量
	DECLARE @SqlAid INT;
	DECLARE @SqlBid INT;
	DECLARE @SqlCid INT;
	DECLARE @SqlDid INT;
	DECLARE @SqlEid INT;
	DECLARE @SqlFid INT;
	DECLARE @SqlGid INT;
	DECLARE @SqlHid INT;
	DECLARE @SqlIid INT;
	DECLARE @SqlJid INT;
	DECLARE @SqlKid INT;
	DECLARE @SqlLid INT;
	DECLARE @SqlMid INT;
	DECLARE @SqlNid INT;
	DECLARE @SqlOid INT;
	DECLARE @SqlPid INT;
	DECLARE @SqlQid INT;
	DECLARE @SqlRid INT;
	DECLARE @SqlSid INT;
	DECLARE @SqlTid INT;
	DECLARE @SqlUid INT;
	DECLARE @SqlVid INT;
	DECLARE @SqlWid INT;
	DECLARE @SqlXid INT;
	DECLARE @SqlYid INT;
	DECLARE @SqlZid INT;
	
	-- 检查参数
	IF @SqlWord IS NULL
		OR LEN(@SqlWord) <= 0 RETURN -1;
	----------------------------------------
	--
	-- 标记和词性对照表
	--
	----------------------------------------
	--				终结符			Aid
	--N				名词			Bid
	--V				动词			Cid
	--ADJ			形容词			Did
	--ADV			副词			Eid
	--CLAS			量词			Fid
	--ECHO			拟声词			Gid
	--STRU			结构助词		Hid
	--AUX			助词			Iid
	--COOR			并列连词		Jid
	--CONJ			连词			Kid
	--SUFFIX		前缀			Lid
	--PREFIX		后缀			Mid
	--PREP			介词			Nid
	--PRON			代词			Oid
	--QUES			疑问词			Pid
	--NUM			数词			Qid
	--IDIOM			成语			Rid
	----------------------------------------
	-- 设置初始值
	SET @SqlID = -1;
	-- 获得该分词的相关参数
	SELECT TOP 1
		@SqlID = cid,
		@SqlAid = a_id,	@SqlBid = b_id,	@SqlCid = c_id,	@SqlDid = d_id,	@SqlEid = e_id,
		@SqlFid = f_id,	@SqlGid = g_id,	@SqlHid = h_id,	@SqlIid = i_id,	@SqlJid = j_id,
		@SqlKid = k_id,	@SqlLid = l_id,	@SqlMid = m_id,	@SqlNid = n_id,	@SqlOid = o_id,
		@SqlPid = p_id,	@SqlQid = q_id,	@SqlRid = r_id,	@SqlSid = s_id,	@SqlTid = t_id,
		@SqlUid = u_id,	@SqlVid = v_id,	@SqlWid = w_id,	@SqlXid = x_id,	@SqlYid = y_id,	@SqlZid = z_id
		FROM dbo.InnerContent WHERE classification = '单词' AND hash_value = dbo.GetHash(@SqlWord);
	-- 检查结果
	IF @SqlID < 0 RETURN -1;
	-- 设置初始值
	SET @SqlResult = 0;
	-- 拼凑位操作
	IF @SqlAid < 0
		SET @SqlResult |= 0x00000003;
	ELSE IF @SqlAid = 0
		SET @SqlResult |= 0x00000000;
	ELSE
		SET @SqlResult |= 0x00000002;
	IF @SqlBid > 0
		SET @SqlResult |= 0x00000004;
	IF @SqlCid > 0
		SET @SqlResult |= 0x00000008;
	IF @SqlDid > 0
		SET @SqlResult |= 0x00000010;
	IF @SqlEid > 0
		SET @SqlResult |= 0x00000020;
	IF @SqlFid > 0
		SET @SqlResult |= 0x00000040;
	IF @SqlGid > 0
		SET @SqlResult |= 0x00000080;
	IF @SqlHid > 0
		SET @SqlResult |= 0x00000100;
	IF @SqlIid > 0
		SET @SqlResult |= 0x00000200;
	IF @SqlJid > 0
		SET @SqlResult |= 0x00000400;
	IF @SqlKid > 0
		SET @SqlResult |= 0x00000800;
	IF @SqlLid > 0
		SET @SqlResult |= 0x00001000;
	IF @SqlMid > 0
		SET @SqlResult |= 0x00002000;
	IF @SqlNid > 0
		SET @SqlResult |= 0x00004000;
	IF @SqlOid > 0
		SET @SqlResult |= 0x00008000;
	IF @SqlPid > 0
		SET @SqlResult |= 0x00010000;
	IF @SqlQid > 0
		SET @SqlResult |= 0x00020000;
	IF @SqlRid > 0
		SET @SqlResult |= 0x00040000;
	IF @SqlSid > 0
		SET @SqlResult |= 0x00080000;
	IF @SqlTid > 0
		SET @SqlResult |= 0x00100000;
	IF @SqlUid > 0
		SET @SqlResult |= 0x00200000;
	IF @SqlVid > 0
		SET @SqlResult |= 0x00400000;
	IF @SqlWid > 0
		SET @SqlResult |= 0x00800000;
	IF @SqlXid > 0
		SET @SqlResult |= 0x01000000;
	IF @SqlYid > 0
		SET @SqlResult |= 0x02000000;
	IF @SqlZid > 0
		SET @SqlResult |= 0x04000000;
	-- 返回数值
	RETURN @SqlResult;
END
GO

