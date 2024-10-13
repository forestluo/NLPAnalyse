USE [nldb]
GO
/****** Object: 清理分词程序错误 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月22日>
-- Description:	<清理分词程序错误>
-- =============================================

DECLARE @SqlOID1 INT;
DECLARE @SqlCount INT;
DECLARE @SqlPositive INT;
DECLARE @SqlRule UString;

DECLARE @SqlAid INT = 0;
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

------------------------------------------------
--
-- 清理程序
--
------------------------------------------------

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT oid, parse_rule, a_id,
		b_id, c_id, d_id, e_id, f_id,
		g_id, h_id, i_id, j_id, k_id,
		l_id, m_id, n_id, o_id, p_id,
		q_id, r_id, s_id, t_id, u_id,
		v_id, w_id, x_id, y_id, z_id FROM dbo.OuterContent
		WHERE a_id > 0 AND dbo.IsContactRule(parse_rule) = 1;
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlOID1, @SqlRule, @SqlAid,
	@SqlBid, @SqlCid, @SqlDid, @SqlEid, @SqlFid,
	@SqlGid, @SqlHid, @SqlIid, @SqlJid, @SqlKid,
	@SqlLid, @SqlMid, @SqlNid, @SqlOid, @SqlPid,
	@SqlQid, @SqlRid, @SqlSid, @SqlTid, @SqlUid,
	@SqlVid, @SqlWid, @SqlXid, @SqlYid, @SqlZid;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 检查规则
	IF @SqlRule IS NOT NULL AND LEN(@SqlRule) > 0
	BEGIN
		-- 设置初始值
		SET @SqlPositive = 0;
		-- 获得正值参数的个数
		IF @SqlAid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlBid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlCid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlDid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlEid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlFid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlGid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlHid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlIid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlJid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlKid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlLid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlMid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlNid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlOid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlPid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlQid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlRid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlSid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlTid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlUid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlVid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlWid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlXid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlYid > 0 SET @SqlPositive = @SqlPositive + 1;
		IF @SqlZid > 0 SET @SqlPositive = @SqlPositive + 1;
		-- 获得参数个数
		SET @SqlCount = dbo.GetVarCount(@SqlRule);
		-- 检查参数个数
		IF @SqlCount < 26 SET @SqlZid = 0;
		IF @SqlCount < 25 SET @SqlYid = 0;
		IF @SqlCount < 24 SET @SqlXid = 0;
		IF @SqlCount < 23 SET @SqlWid = 0;
		IF @SqlCount < 22 SET @SqlVid = 0;
		IF @SqlCount < 21 SET @SqlUid = 0;
		IF @SqlCount < 20 SET @SqlTid = 0;
		IF @SqlCount < 19 SET @SqlSid = 0;
		IF @SqlCount < 18 SET @SqlRid = 0;
		IF @SqlCount < 17 SET @SqlQid = 0;
		IF @SqlCount < 16 SET @SqlPid = 0;
		IF @SqlCount < 15 SET @SqlOid = 0;
		IF @SqlCount < 14 SET @SqlNid = 0;
		IF @SqlCount < 13 SET @SqlMid = 0;
		IF @SqlCount < 12 SET @SqlLid = 0;
		IF @SqlCount < 11 SET @SqlKid = 0;
		IF @SqlCount < 10 SET @SqlJid = 0;
		IF @SqlCount <  9 SET @SqlIid = 0;
		IF @SqlCount <  8 SET @SqlHid = 0;
		IF @SqlCount <  7 SET @SqlGid = 0;
		IF @SqlCount <  6 SET @SqlFid = 0;
		IF @SqlCount <  5 SET @SqlEid = 0;
		IF @SqlCount <  4 SET @SqlDid = 0;
		IF @SqlCount <  3 SET @SqlCid = 0;
		IF @SqlCount <  2 SET @SqlBid = 0;
		IF @SqlCount <  1 SET @SqlAid = 0;
		-- 检查参数个数差
		IF @SqlPositive > @SqlCount
		BEGIN
			PRINT '清理分词程序错误(oid=' + CONVERT(NVARCHAR(MAX), @SqlOID1) +
				')> 参数(' + CONVERT(NVARCHAR(MAX), @SqlCount) + '个)/正值(' +
				CONVERT(NVARCHAR(MAX), @SqlPositive) + '个)！';
			-- 更新一条记录
			UPDATE dbo.OuterContent
				SET a_id = @SqlAid,
				b_id = @SqlBid, c_id = @SqlCid, d_id = @SqlDid, e_id = @SqlEid,	f_id = @SqlFid,
				g_id = @SqlGid, h_id = @SqlHid, i_id = @SqlIid, j_id = @SqlJid,	k_id = @SqlKid,
				l_id = @SqlLid, m_id = @SqlMid, n_id = @SqlNid,	o_id = @SqlOid, p_id = @SqlPid,
				q_id = @SqlQid, r_id = @SqlRid, s_id = @SqlSid,	t_id = @SqlTid, u_id = @SqlUid,
				v_id = @SqlVid, w_id = @SqlWid, x_id = @SqlXid,	y_id = @SqlYid, z_id = @SqlZid
				WHERE oid = @SqlOID1;
		END
	END
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlOID1, @SqlRule, @SqlAid,
		@SqlBid, @SqlCid, @SqlDid, @SqlEid, @SqlFid,
		@SqlGid, @SqlHid, @SqlIid, @SqlJid, @SqlKid,
		@SqlLid, @SqlMid, @SqlNid, @SqlOid, @SqlPid,
		@SqlQid, @SqlRid, @SqlSid, @SqlTid, @SqlUid,
		@SqlVid, @SqlWid, @SqlXid, @SqlYid, @SqlZid;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 
