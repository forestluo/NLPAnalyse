USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[重建“分词”规则]    Script Date: 2020/12/9 13:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<重建分词解析规则>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[重建WordRules]
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlValue INT;

	DECLARE @SqlResult XML;
	DECLARE @SqlChar UChar;
	DECLARE @SqlWord UString;
	DECLARE @SqlRule UString;

	-- 声明临时变量
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

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY FOR
		SELECT cid, content FROM dbo.InnerContent
		WHERE classification = '分词' AND a_id >= 0
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlWord;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 执行解析
		SET @SqlResult = dbo.InnerFMMSplit(@SqlWord);
		-- 检查结果
		IF @SqlResult IS NOT NULL
		BEGIN
			--PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

			-- 初始化所有变量
			SET @SqlAid = 0;
			SET @SqlBid = 0;
			SET @SqlCid = 0;
			SET @SqlDid = 0;
			SET @SqlEid = 0;
			SET @SqlFid = 0;
			SET @SqlGid = 0;
			SET @SqlHid = 0;
			SET @SqlIid = 0;
			SET @SqlJid = 0;
			SET @SqlKid = 0;
			SET @SqlLid = 0;
			SET @SqlMid = 0;
			SET @SqlNid = 0;
			SET @SqlOid = 0;
			SET @SqlPid = 0;
			SET @SqlQid = 0;
			SET @SqlRid = 0;
			SET @SqlSid = 0;
			SET @SqlTid = 0;
			SET @SqlUid = 0;
			SET @SqlVid = 0;
			SET @SqlWid = 0;
			SET @SqlXid = 0;
			SET @SqlYid = 0;
			SET @SqlZid = 0;

			-- 设置初始值
			SET @SqlRule = '';
			-- 统计参数个数
			SET @SqlCount =  @SqlResult.value('count(//result/var)','int');
			-- 设置初始参数
			SET @SqlIndex = 0;
			-- 循环处理
			WHILE @SqlIndex < @SqlCount
			BEGIN
				-- 设置计数器
				SET @SqlIndex = @SqlIndex + 1;
				-- 获得当前变量名
				SET @SqlChar =
					dbo.GetLowercase(@SqlIndex)
				-- 设置规则
				SET @SqlRule = @SqlRule + '$' + @SqlChar;
				-- 获得结果
				SET @SqlValue = @SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")])[1]/@cid','int');
				-- 检查结果
				IF @SqlValue IS NOT NULL
				BEGIN
					-- 获得ID数值
					IF @SqlIndex = 1 SET @SqlAid = @SqlValue;
					ELSE IF @SqlIndex = 2 SET @SqlBid = @SqlValue;
					ELSE IF @SqlIndex = 3 SET @SqlCid = @SqlValue;
					ELSE IF @SqlIndex = 4 SET @SqlDid = @SqlValue;
					ELSE IF @SqlIndex = 5 SET @SqlEid = @SqlValue;
					ELSE IF @SqlIndex = 6 SET @SqlFid = @SqlValue;
					ELSE IF @SqlIndex = 7 SET @SqlGid = @SqlValue;
					ELSE IF @SqlIndex = 8 SET @SqlHid = @SqlValue;
					ELSE IF @SqlIndex = 9 SET @SqlIid = @SqlValue;
					ELSE IF @SqlIndex = 10 SET @SqlJid = @SqlValue;
					ELSE IF @SqlIndex = 11 SET @SqlKid = @SqlValue;
					ELSE IF @SqlIndex = 12 SET @SqlLid = @SqlValue;
					ELSE IF @SqlIndex = 13 SET @SqlMid = @SqlValue;
					ELSE IF @SqlIndex = 14 SET @SqlNid = @SqlValue;
					ELSE IF @SqlIndex = 15 SET @SqlOid = @SqlValue;
					ELSE IF @SqlIndex = 16 SET @SqlPid = @SqlValue;
					ELSE IF @SqlIndex = 17 SET @SqlQid = @SqlValue;
					ELSE IF @SqlIndex = 18 SET @SqlRid = @SqlValue;
					ELSE IF @SqlIndex = 19 SET @SqlSid = @SqlValue;
					ELSE IF @SqlIndex = 20 SET @SqlTid = @SqlValue;
					ELSE IF @SqlIndex = 21 SET @SqlUid = @SqlValue;
					ELSE IF @SqlIndex = 22 SET @SqlVid = @SqlValue;
					ELSE IF @SqlIndex = 23 SET @SqlWid = @SqlValue;
					ELSE IF @SqlIndex = 24 SET @SqlXid = @SqlValue;
					ELSE IF @SqlIndex = 25 SET @SqlYid = @SqlValue;
					ELSE IF @SqlIndex = 26 SET @SqlZid = @SqlValue;
				END
			END
			-- 更改数据
			UPDATE dbo.InnerContent SET
				rid = dbo.GetParseRuleID(@SqlRule), a_id = @SqlAid,
				b_id = @SqlBid, c_id = @SqlCid, d_id = @SqlDid, e_id = @SqlEid, f_id = @SqlFid,
				g_id = @SqlGid, h_id = @SqlHid, i_id = @SqlIid, j_id = @SqlJid, k_id = @SqlKid,
				l_id = @SqlLid, m_id = @SqlMid, n_id = @SqlNid, o_id = @SqlOid, p_id = @SqlPid,
				q_id = @SqlQid, r_id = @SqlRid, s_id = @SqlSid, t_id = @SqlTid, u_id = @SqlUid,
				v_id = @SqlVid, w_id = @SqlWid, x_id = @SqlXid, y_id = @SqlYid, z_id = @SqlZid WHERE cid = @SqlID;
			PRINT '重建“分词”规则>更新规则（cid=' + CONVERT(NVARCHAR(MAX), @SqlID) + ',“' + @SqlWord + '”）！';
		END
		ELSE
		BEGIN
			PRINT '重建“分词”规则>获取规则（cid=' + CONVERT(NVARCHAR(MAX), @SqlID) + ',“' + @SqlWord + '”）失败！';
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlWord;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
END
