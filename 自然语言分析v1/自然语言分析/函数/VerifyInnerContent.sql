USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[[VerifyInnerContent]]    Script Date: 2020/12/6 10:49:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月9日>
-- Description:	<验证内容规则是否正确>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[VerifyInnerContent]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;

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
	
	-- 设置初始值
	SET @SqlID = -1;
	SET @SqlRule = NULL;
	-- 获得该分词的相关参数
	SELECT TOP 1 @SqlID = a.cid, @SqlRule = b.parse_rule,
		@SqlAid = a.a_id, @SqlBid = a.b_id,	@SqlCid = a.c_id, @SqlDid = a.d_id,	@SqlEid = a.e_id,
		@SqlFid = a.f_id, @SqlGid = a.g_id,	@SqlHid = a.h_id, @SqlIid = a.i_id,	@SqlJid = a.j_id,
		@SqlKid = a.k_id, @SqlLid = a.l_id,	@SqlMid = a.m_id, @SqlNid = a.n_id,	@SqlOid = a.o_id,
		@SqlPid = a.p_id, @SqlQid = a.q_id,	@SqlRid = a.r_id, @SqlSid = a.s_id,	@SqlTid = a.t_id,
		@SqlUid = a.u_id, @SqlVid = a.v_id,	@SqlWid = a.w_id, @SqlXid = a.x_id,	@SqlYid = a.y_id, @SqlZid = a.z_id
		FROM dbo.InnerContent AS a
		INNER JOIN dbo.ParseRule AS b ON a.rid = b.rid WHERE a.hash_value = dbo.GetHash(@SqlContent);
	-- 检查结果
	IF @SqlID <= 0 RETURN -1;
	-- 检查是否为终结符
	IF @SqlAid = -1
	BEGIN
		-- 终结符的条件检查完毕
		IF @SqlRule IS NULL
			OR LEN(@SqlRule) <= 0 RETURN 1;
		ELSE RETURN -2;
	END
	-- 检查解析规则
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN -3;
	-- 获得参数总数
	SET @SqlCount = dbo.GetVarCount(@SqlRule);
	-- 设置初始值
	SET @SqlIndex = 0;
	-- 循环处理
	WHILE @SqlIndex < @SqlCount
	BEGIN
		-- 增加索引值
		SET @SqlIndex = @SqlIndex + 1;
		-- 获得当前参数名
		SET @SqlChar = dbo.GetLowercase(@SqlIndex);

		-- 设置ID值
		SET @SqlID = CASE @SqlIndex
			WHEN 1 THEN @SqlAid
			WHEN 2 THEN @SqlBid
			WHEN 3 THEN @SqlCid
			WHEN 4 THEN @SqlDid
			WHEN 5 THEN @SqlEid
			WHEN 6 THEN @SqlFid
			WHEN 7 THEN @SqlGid
			WHEN 8 THEN @SqlHid
			WHEN 9 THEN @SqlIid
			WHEN 10 THEN @SqlJid
			WHEN 11 THEN @SqlKid
			WHEN 12 THEN @SqlLid
			WHEN 13 THEN @SqlMid
			WHEN 14 THEN @SqlNid
			WHEN 15 THEN @SqlOid
			WHEN 16 THEN @SqlPid
			WHEN 17 THEN @SqlQid
			WHEN 18 THEN @SqlRid
			WHEN 19 THEN @SqlSid
			WHEN 20 THEN @SqlTid
			WHEN 21 THEN @SqlUid
			WHEN 22 THEN @SqlVid
			WHEN 23 THEN @SqlWid
			WHEN 24 THEN @SqlXid
			WHEN 25 THEN @SqlYid
			WHEN 26 THEN @SqlZid ELSE -1 END;
		-- 检查结果
		IF @SqlID IS NOT NULL AND @SqlID > 0
		BEGIN
			-- 设置初始值
			SET @SqlValue = NULL;
			-- 查询数值
			SELECT TOP 1 @SqlValue = content
				FROM dbo.InnerContent WHERE cid = @SqlID;
			-- 没有找到对应的记录
			IF @SqlValue IS NULL OR
				LEN(@SqlValue) <= 0 RETURN -4;
			-- 执行替换操作
			SET @SqlRule = REPLACE(@SqlRule, '$' + @SqlChar, @SqlValue);
		END
	END
	-- 检查字符串匹配
	IF @SqlContent <> @SqlRule RETURN -5;
	-- 返回成功
	RETURN 1;
END
GO

