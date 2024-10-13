USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[SetVocabulary]    Script Date: 2020/12/6 19:57:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<将分词设置为单词>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[SetWordAttribute]
	-- Add the parameters for the stored procedure here
	@SqlWord UString,
	@SqlAttribute UString = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlBid INT = 0;
	DECLARE @SqlCid INT = 0;
	DECLARE @SqlDid INT = 0;
	DECLARE @SqlEid INT = 0;
	DECLARE @SqlFid INT = 0;
	DECLARE @SqlGid INT = 0;
	DECLARE @SqlHid INT = 0;
	DECLARE @SqlIid INT = 0;
	DECLARE @SqlJid INT = 0;
	DECLARE @SqlKid INT = 0;
	DECLARE @SqlLid INT = 0;
	DECLARE @SqlMid INT = 0;
	DECLARE @SqlNid INT = 0;
	DECLARE @SqlOid INT = 0;
	DECLARE @SqlPid INT = 0;
	DECLARE @SqlQid INT = 0;
	DECLARE @SqlRid INT = 0;
	DECLARE @SqlSid INT = 0;
	DECLARE @SqlTid INT = 0;
	DECLARE @SqlUid INT = 0;
	DECLARE @SqlVid INT = 0;
	DECLARE @SqlWid INT = 0;
	DECLARE @SqlXid INT = 0;
	DECLARE @SqlYid INT = 0;
	DECLARE @SqlZid INT = 0;

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
	--PRINT @SqlAttribute;
	-- 检查属性
	IF @SqlAttribute IS NOT NULL
		AND LEN(@SqlAttribute) > 0
	BEGIN
		IF CHARINDEX('SUFFIX', @SqlAttribute) > 0
		BEGIN
			SET @SqlLid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'SUFFIX', '');
		END
		IF CHARINDEX('PREFIX', @SqlAttribute) > 0
		BEGIN
			SET @SqlMid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'PREFIX', '');
		END
		IF CHARINDEX('IDIOM', @SqlAttribute) > 0
		BEGIN
			SET @SqlRid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'IDIOM', '');
		END
		IF CHARINDEX('CLAS', @SqlAttribute) > 0
		BEGIN
			SET @SqlFid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'CLAS', '');
		END
		IF CHARINDEX('ECHO', @SqlAttribute) > 0
		BEGIN
			SET @SqlGid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'ECHO', '');
		END
		IF CHARINDEX('STRU', @SqlAttribute) > 0
		BEGIN
			SET @SqlHid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'STRU', '');
		END
		IF CHARINDEX('COOR', @SqlAttribute) > 0
		BEGIN
			SET @SqlJid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'COOR', '');
		END
		IF CHARINDEX('CONJ', @SqlAttribute) > 0
		BEGIN
			SET @SqlKid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'CONJ', '');
		END
		IF CHARINDEX('PREP', @SqlAttribute) > 0
		BEGIN
			SET @SqlNid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'PREP', '');
		END
		IF CHARINDEX('PRON', @SqlAttribute) > 0
		BEGIN
			SET @SqlOid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'PRON', '');
		END
		IF CHARINDEX('QUES', @SqlAttribute) > 0
		BEGIN
			SET @SqlPid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'QUES', '');
		END
		IF CHARINDEX('AUX', @SqlAttribute) > 0
		BEGIN
			SET @SqlIid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'AUX', '');
		END
		IF CHARINDEX('ADJ', @SqlAttribute) > 0
		BEGIN
			SET @SqlDid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'ADJ', '');
		END
		IF CHARINDEX('ADV', @SqlAttribute) > 0
		BEGIN
			SET @SqlEid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'ADV', '');
		END
		IF CHARINDEX('NUM', @SqlAttribute) > 0
		BEGIN
			SET @SqlQid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'NUM', '');
		END
		IF CHARINDEX('N', @SqlAttribute) > 0
		BEGIN
			SET @SqlBid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'N', '');
		END
		IF CHARINDEX('V', @SqlAttribute) > 0
		BEGIN
			SET @SqlCid = 1;
			SET @SqlAttribute = REPLACE(@SqlAttribute, 'V', '');
		END
	END
	-- 更新数据
	UPDATE dbo.InnerContent
		SET classification = '单词', rid = 0, a_id = -1,
		b_id = @SqlBid, c_id = @SqlCid, d_id = @SqlDid, e_id = @SqlEid, f_id = @SqlFid, 
		g_id = @SqlGid, h_id = @SqlHid, i_id = @SqlIid, j_id = @SqlJid, k_id = @SqlKid, 
		l_id = @SqlLid, m_id = @SqlMid, n_id = @SqlNid, o_id = @SqlOid, p_id = @SqlPid, 
		q_id = @SqlQid, r_id = @SqlRid, s_id = @SqlSid, t_id = @SqlTid, u_id = @SqlUid, 
		v_id = @SqlVid, w_id = @SqlWid, x_id = @SqlXid, y_id = @SqlYid, z_id = @SqlZid
		WHERE hash_value = dbo.GetHash(@SqlWord);
	-- 返回结果
	RETURN @@ROWCOUNT;
END
GO

