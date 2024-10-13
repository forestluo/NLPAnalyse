USE [nldb2]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月21日>
-- Description:	<切分外部内容表文本>
-- =============================================
CREATE OR ALTER PROCEDURE [切分外部内容表文本]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlOOID INT;
	DECLARE @SqlCCID INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlResult INT;
	DECLARE @SqlFMMCount INT;
	DECLARE @SqlBMMCount INT;

	DECLARE @SqlFMM XML;
	DECLARE @SqlBMM XML;
	DECLARE @SqlRule UString;
	DECLARE @SqlName UString;
	DECLARE @SqlContent UString;
	DECLARE @SqlFMMValue UString;
	DECLARE @SqlBMMValue UString;

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

	-- 打印空行
	PRINT '切分外部内容表文本> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) oid, cid, content
			FROM dbo.OuterContent
			WHERE (classification = '文本' AND type = 1) ORDER BY length;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlOOID, @SqlCCID, @SqlContent;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置初始值
		SET @SqlAid = 0; SET @SqlBid = 0; SET @SqlCid = 0; SET @SqlDid = 0;	SET @SqlEid = 0;
		SET @SqlFid = 0; SET @SqlGid = 0; SET @SqlHid = 0; SET @SqlIid = 0;	SET @SqlJid = 0;
		SET @SqlKid = 0; SET @SqlLid = 0; SET @SqlMid = 0; SET @SqlNid = 0;	SET @SqlOid = 0;
		SET @SqlPid = 0; SET @SqlQid = 0; SET @SqlRid = 0; SET @SqlSid = 0;	SET @SqlTid = 0;
		SET @SqlUid = 0; SET @SqlVid = 0; SET @SqlWid = 0; SET @SqlXid = 0;	SET @SqlYid = 0; SET @SqlZid = 0;

		-- 打印记录
		PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> ' + @SqlContent;

		BEGIN TRY
			-- 按照FMM算法切分
			SET @SqlFMM = dbo.FMMSplit(@SqlContent);
			-- 检查结果
			IF @SqlFMM IS NOT NULL
			BEGIN
				-- 获得结果
				SET @SqlResult = ISNULL(@SqlFMM.value('(//result/@id)[1]', 'int'), -1);
				-- 检查结果
				IF @SqlResult < 0
				BEGIN
					-- 更新记录
					UPDATE dbo.OuterContent SET [type] = @SqlResult - 100 WHERE oid = @SqlOOID;
					-- 打印记录
					PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) +
							')> FMM错误(' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')！'; GOTO NEXT_ROW;
				END
			END
			ELSE
			BEGIN
				-- 更新记录
				UPDATE dbo.OuterContent SET [type] = -100 WHERE oid = @SqlOOID;
				-- 打印记录
				PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> FMM失败！'; GOTO NEXT_ROW;
			END

			-- 按照BMM算法切分
			SET @SqlBMM = dbo.BMMSplit(@SqlContent);
			-- 检查结果
			IF @SqlBMM IS NOT NULL
			BEGIN
				-- 获得结果
				SET @SqlResult = ISNULL(@SqlBMM.value('(//result/@id)[1]', 'int'), -1);
				-- 检查结果
				IF @SqlResult < 0
				BEGIN
					-- 更新记录
					UPDATE dbo.OuterContent SET [type] = @SqlResult - 200 WHERE oid = @SqlOOID;
					-- 打印记录
					PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) +
							')> BMM错误(' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')！'; GOTO NEXT_ROW;
				END
			END
			ELSE
			BEGIN
				-- 更新记录
				UPDATE dbo.OuterContent SET [type] = -200 WHERE oid = @SqlOOID;
				-- 打印记录
				PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> BMM失败！'; GOTO NEXT_ROW;
			END
		
			-- 打印解析结果
			-- PRINT 'FMM = ' + CONVERT(NVARCHAR(MAX), @SqlFMM);
			-- PRINT 'BMM = ' + CONVERT(NVARCHAR(MAX), @SqlBMM);
			-- 比较两个算法结果
			SET @SqlFMMCount = ISNULL(@SqlFMM.value('count(//result/var)', 'int'), 0);
			SET @SqlBMMCount = ISNULL(@SqlBMM.value('count(//result/var)', 'int'), 0);
			-- 检查算法两个结果
			IF @SqlFMMCount <> @SqlBMMCount
			BEGIN
				-- 更新记录
				UPDATE dbo.OuterContent SET [type] = -300 WHERE oid = @SqlOOID;
				-- 打印记录
				PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> FMM与BMM不一致！'; GOTO NEXT_ROW;
			END

			-- 设置初始值
			SET @SqlRule = '';
			SET @SqlIndex = 0;
			-- 循环处理
			WHILE @SqlIndex < @SqlFMMCount AND @SqlIndex < @SqlBMMCount
			BEGIN
				-- 修改计数器
				SET @SqlIndex = @SqlIndex + 1;
				-- 取得FMM的结果
				SET @SqlFMMValue = @SqlFMM.value('(//result/var[position()=sql:variable("@SqlIndex")]/text())[1]', 'nvarchar(max)');

				-- 取得BMM的结果
				SET @SqlBMMValue = @SqlBMM.value('(//result/var[position()=sql:variable("@SqlIndex")]/text())[1]', 'nvarchar(max)');
				-- 比较两种方法的结果
				IF @SqlFMMValue <> @SqlBMMValue
				BEGIN
					-- 更新记录
					UPDATE dbo.OuterContent SET [type] = -400 WHERE oid = @SqlOOID;
					-- 打印记录
					PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> FMM与BMM不一样！'; GOTO NEXT_ROW;
				END

				-- 获得标识
				SET @SqlID = @SqlFMM.value('(//result/var[position()=sql:variable("@SqlIndex")]/@cid)[1]', 'int');
				-- 检查结果
				IF @SqlID IS NULL
				BEGIN
					-- 更新记录
					UPDATE dbo.OuterContent SET [type] = -401 WHERE oid = @SqlOOID;
					-- 打印记录
					PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> 无效(' + @SqlFMMValue + ')！'; GOTO NEXT_ROW;
				END
				ELSE IF @SqlID <= 0
				BEGIN
					-- 更新字典统计
					EXEC dbo.CheckDictionary @SqlFMMValue;
					-- 设置初始值
					SET @SqlID = dbo.ContentGetCID(@SqlFMMValue);
					-- 检查结果
					IF @SqlID IS NULL OR @SqlID <= 0
					BEGIN
						-- 获得标识
						SET @SqlID = NEXT VALUE FOR ContentSequence;
						-- 插入数据
						INSERT INTO dbo.InnerContent
							(cid, content, [type], [length], [classification])
							VALUES (@SqlID, @SqlFMMValue, -1, LEN(@SqlFMMValue), '词典');
					END
				END

				-- 取得名字
				SET @SqlName = @SqlFMM.value('(//result/var[position()=sql:variable("@SqlIndex")]/@name)[1]', 'nvarchar(max)');
				SET @SqlRule = @SqlRule + '$' + @SqlName;
				-- 获得ID数值
				IF @SqlName = 'a' SET @SqlAid = @SqlID;
				ELSE IF @SqlName = 'b' SET @SqlBid = @SqlID;
				ELSE IF @SqlName = 'c' SET @SqlCid = @SqlID;
				ELSE IF @SqlName = 'd' SET @SqlDid = @SqlID;
				ELSE IF @SqlName = 'e' SET @SqlEid = @SqlID;
				ELSE IF @SqlName = 'f' SET @SqlFid = @SqlID;
				ELSE IF @SqlName = 'g' SET @SqlGid = @SqlID;
				ELSE IF @SqlName = 'h' SET @SqlHid = @SqlID;
				ELSE IF @SqlName = 'i' SET @SqlIid = @SqlID;
				ELSE IF @SqlName = 'j' SET @SqlJid = @SqlID;
				ELSE IF @SqlName = 'k' SET @SqlKid = @SqlID;
				ELSE IF @SqlName = 'l' SET @SqlLid = @SqlID;
				ELSE IF @SqlName = 'm' SET @SqlMid = @SqlID;
				ELSE IF @SqlName = 'n' SET @SqlNid = @SqlID;
				ELSE IF @SqlName = 'o' SET @SqlOid = @SqlID;
				ELSE IF @SqlName = 'p' SET @SqlPid = @SqlID;
				ELSE IF @SqlName = 'q' SET @SqlQid = @SqlID;
				ELSE IF @SqlName = 'r' SET @SqlRid = @SqlID;
				ELSE IF @SqlName = 's' SET @SqlSid = @SqlID;
				ELSE IF @SqlName = 't' SET @SqlTid = @SqlID;
				ELSE IF @SqlName = 'u' SET @SqlUid = @SqlID;
				ELSE IF @SqlName = 'v' SET @SqlVid = @SqlID;
				ELSE IF @SqlName = 'w' SET @SqlWid = @SqlID;
				ELSE IF @SqlName = 'x' SET @SqlXid = @SqlID;
				ELSE IF @SqlName = 'y' SET @SqlYid = @SqlID;
				ELSE IF @SqlName = 'z' SET @SqlZid = @SqlID;
			END

			-- 更新一条记录
			UPDATE dbo.OuterContent
				SET [rule] = @SqlRule, [type] = 2, a_id = @SqlAid,
				b_id = @SqlBid, c_id = @SqlCid, d_id = @SqlDid, e_id = @SqlEid,	f_id = @SqlFid,
				g_id = @SqlGid, h_id = @SqlHid, i_id = @SqlIid, j_id = @SqlJid,	k_id = @SqlKid,
				l_id = @SqlLid, m_id = @SqlMid, n_id = @SqlNid,	o_id = @SqlOid, p_id = @SqlPid,
				q_id = @SqlQid, r_id = @SqlRid, s_id = @SqlSid,	t_id = @SqlTid, u_id = @SqlUid,
				v_id = @SqlVid, w_id = @SqlWid, x_id = @SqlXid,	y_id = @SqlYid, z_id = @SqlZid
				WHERE oid = @SqlOOID;
			-- 打印记录
			PRINT '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')> 成功切分！';

		END TRY
		BEGIN CATCH
			-- 更新记录
			UPDATE dbo.OuterContent SET [type] = -500 WHERE oid = @SqlOOID;
			-- 设置提示，抓取异常记录
			SET @SqlContent = '切分外部内容表文本(oid=' + CONVERT(NVARCHAR(MAX), @SqlOOID) + ')'; EXEC dbo.CatchException @SqlContent;	
		END CATCH

NEXT_ROW:
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlOOID, @SqlCCID, @SqlContent;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 

	-- 返回成功
	PRINT '切分外部内容表文本> 所有内容全部切分完毕！';
END
GO
