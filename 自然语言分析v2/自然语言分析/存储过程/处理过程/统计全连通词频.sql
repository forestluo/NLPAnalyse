USE [nldb]
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
-- Create date: <2021年2月28日>
-- Description:	<统计全连通词频>
-- =============================================

CREATE OR ALTER PROCEDURE [统计全连通词频]
	-- Add the parameters for the stored procedure here
	@SqlCount INT,
	@SqlLength INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlEID INT;
	DECLARE @SqlDate DATETIME;
	DECLARE @SqlContent UString;

	DECLARE @SqlRules XML;
	DECLARE @SqlExpressions XML;

	-- 装载所有数字规则
	SET @SqlRules = dbo.LoadNumericalRules();
	-- 检查结果
	IF @SqlRules IS NULL OR
		ISNULL(@SqlRules.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- 返回结果
		PRINT '统计全连通词频> 加载规则失败！'; RETURN 0;
	END

	-- 打印空行
	PRINT '统计全连通词频> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 开始计时
	SET @SqlDate = GetDate();
	-- 声明游标
	DECLARE SqlCursor1 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) eid, content
			FROM dbo.ExternalContent WHERE type = @SqlLength - 1;
	-- 打开游标
	OPEN SqlCursor1;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	-- 计时结束
	PRINT '统计全连通词频> 开启游标耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 打印记录
		--PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '")';
		--PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '": ' + master.dbo.fn_varbintohexstr(CONVERT(VARBINARY(MAX), @SqlContent)) + ')';

		-- 开始计时
		SET @SqlDate = GetDate();
		-- 清理不可见字符
		SET @SqlContent = dbo.ClearInvisible(@SqlContent);
		-- 将空格进行转义
		SET @SqlContent = dbo.EscapeBlankspace(@SqlContent);
		-- 尝试处理
		BEGIN TRY
			-- 加载表达式
			SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);
			---- 检查结果
			--IF @SqlExpressions IS NULL OR
			--	ISNULL(@SqlExpressions.value('(//result/@id)[1]', 'int'), 0) <= 0
			--BEGIN
			--	-- 返回结果
			--	PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> 解析表达式失败！'; /*GOTO NEXT_ROW;*/
			--END

			DECLARE @SqlResult1 XML;
			-- 读取一段内容，生成相关结果
			SET @SqlResult1 = dbo.SplitContent(@SqlContent, @SqlExpressions);
			-- 检查结果
			IF @SqlResult1 IS NULL OR
				ISNULL(@SqlResult1.value('(//result/@id)[1]', 'int'), 0) <= 0
			BEGIN
				-- 返回结果
				PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> 读取内容失败！'; GOTO NEXT_ROW;
			END

			-- 声明临时变量
			DECLARE @SqlID INT;
			DECLARE @SqlName UString;
			DECLARE @SqlValue UString;
			-- 声明游标
			DECLARE SqlCursor2 CURSOR
				STATIC FORWARD_ONLY LOCAL FOR
				SELECT
					Nodes.value('(@id)[1]','int') AS nodeID,
					Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
					FROM @SqlResult1.nodes('//result/var') AS N(Nodes) ORDER BY nodeID; 
			-- 打开游标
			OPEN SqlCursor2;
			-- 取第一条记录
			FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			-- 循环处理游标
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @SqlResult2 XML;
				-- 按照中文读取
				SET @SqlResult2 = dbo.ReadChinese(@SqlValue);

				-- 声明游标
				DECLARE SqlCursor3 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT
						Nodes.value('(@id)[1]','int') AS nodeID,
						Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
						Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
						FROM @SqlResult2.nodes('//result/var') AS N(Nodes) ORDER BY nodeID; 
				-- 打开游标
				OPEN SqlCursor3;
				-- 取第一条记录
				FETCH NEXT FROM SqlCursor3 INTO @SqlID, @SqlName, @SqlValue;
				-- 循环处理游标
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- 声明临时变量
					-- DECLARE @SqlDate3 DATETIME;
					-- 获取时间
					-- SET @SqlDate3 = GETDATE();
					-- 尝试处理
					BEGIN TRY
						-- 全连通语法统计
						EXEC dbo.GrammarStatistics @SqlLength, @SqlValue;
					END TRY
					BEGIN CATCH
						-- 设置提示，抓取异常记录
						SET @SqlContent = '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
					END CATCH

					-- 计时结束
					-- PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> 插入耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate3, GetDate())) + '毫秒';

					-- 取下一条记录
					FETCH NEXT FROM SqlCursor3 INTO @SqlID, @SqlName, @SqlValue;
				END
				-- 关闭游标
				CLOSE SqlCursor3;
				-- 释放游标
				DEALLOCATE SqlCursor3;

				-- 取下一条记录
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			END
			-- 关闭游标
			CLOSE SqlCursor2;
			-- 释放游标
			DEALLOCATE SqlCursor2;

		END TRY
		BEGIN CATCH
			-- 设置提示，抓取异常记录
			SET @SqlContent = '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
		END CATCH

NEXT_ROW:
		------ 更新数据记录
		UPDATE dbo.ExternalContent
			SET type = @SqlLength WHERE eid = @SqlEID;
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
		-- 计时结束
		PRINT '统计全连通词频(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> 耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	END
	-- 关闭游标
	CLOSE SqlCursor1;
	-- 释放游标
	DEALLOCATE SqlCursor1; 
	-- 返回成功
	PRINT '统计全连通词频> 所有文本全部统计完毕！';

END
GO
