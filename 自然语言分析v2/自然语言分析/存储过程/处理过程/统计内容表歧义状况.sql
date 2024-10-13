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
-- Create date: <2021年2月19日>
-- Description:	<从内容表中统计歧义状况>
-- =============================================

CREATE OR ALTER PROCEDURE [统计内容表歧义状况]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlEID INT;
	DECLARE @SqlContent UString;
	
	DECLARE @SqlResult XML;
	DECLARE @SqlTable UMatchTable;

	-- 装载所有数字规则
	DECLARE @SqlRules XML;
	SET @SqlRules = dbo.LoadNumericalRules();

	-- 打印空行
	PRINT '统计内容表歧义状况> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 声明游标
	DECLARE SqlCursor1 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) eid, content
			FROM dbo.ExternalContent WHERE type = 0;
	-- 打开游标
	OPEN SqlCursor1;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 清空数据表
		DELETE FROM @SqlTable;
		-- 打印记录
		--PRINT '统计内容表歧义状况(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '")';

		BEGIN TRY

			--------------------------------------------------------------------------------
			--
			-- 解析数字内容
			--
			--------------------------------------------------------------------------------

			DECLARE @SqlValue UString;
			DECLARE @SqlAttribute UString;

			DECLARE @SqlExpressions XML;	
			-- 获得数字解析结果
			SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);

			-------------------------------------------------------------------------------
			--
			-- 正向最大切分
			--
			-------------------------------------------------------------------------------
			-- 正向最大切分
			SET @SqlResult = dbo.FMMSplitContent(1, @SqlContent, @SqlExpressions);
			-- 插入到临时表中
			INSERT INTO @SqlTable
				(expression, position, value, length)
				SELECT
					'FMM',
					ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
					ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
					FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					WHERE Nodes.value('local-name(.)', 'nvarchar(max)') <> 'rule' ORDER BY nodePos;

			-------------------------------------------------------------------------------
			--
			-- 逆向最大切分
			--
			-------------------------------------------------------------------------------
			-- 逆向最大切分
			SET @SqlResult = dbo.BMMSplitContent(1, @SqlContent, @SqlExpressions);
			-- 插入到临时表中
			INSERT INTO @SqlTable
				(expression, position, value, length)
				SELECT
					'BMM',
					ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
					ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
					FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					WHERE Nodes.value('local-name(.)', 'nvarchar(max)') <> 'rule' ORDER BY nodePos;

			-------------------------------------------------------------------------------
			--
			-- 去除重复（完全重复的仅保留一项）
			--
			-------------------------------------------------------------------------------

			DECLARE @SqlID INT;
			DECLARE @SqlMatch INT;
			DECLARE @SqlLength INT;
			DECLARE @SqlPosition INT;

			-- 设置初始值
			SET @SqlMatch = 1;
			-- 循环处理
			WHILE @SqlMatch > 0
			BEGIN
				-- 设置初始值
				SET @SqlMatch = 0;
				-- 多个正则同时处理时才会出现相互重叠问题
				-- 清理相互重叠的解析结果（保长去短）
				-- 声明游标
				DECLARE SqlCursor2 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT id, length, position	FROM @SqlTable ORDER BY length;
				-- 打开游标
				OPEN SqlCursor2;
				-- 取第一条记录
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition;
				-- 循环处理游标
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- 检查结果
					IF EXISTS
						(SELECT * FROM @SqlTable WHERE
							@SqlID <> id AND
							@SqlPosition >= position AND
							(@SqlPosition + @SqlLength <= position + length))
					BEGIN
						-- 设置标记位
						SET @SqlMatch = 1;
						-- 删除该条被包括的数据
						DELETE FROM @SqlTable WHERE id = @SqlID;
					END
					-- 取下一条记录
					FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition;
				END
				-- 关闭游标
				CLOSE SqlCursor2;
				-- 释放游标
				DEALLOCATE SqlCursor2;
			END

			-- SELECT *,dbo.GetFreqCount(value) AS freq FROM @SqlTable ORDER BY position;

			-------------------------------------------------------------------------------
			--
			-- 合并相互重叠的项目
			--
			-------------------------------------------------------------------------------

			DECLARE @SqlMID INT;
			DECLARE @SqlMPosition INT;
			DECLARE @SqlMValue UString;
			DECLARE @SqlMAttribute UString;

			-- 设置初始值
			SET @SqlMatch = 1;
			-- 循环处理
			WHILE @SqlMatch > 0
			BEGIN
				-- 设置初始值
				SET @SqlMatch = 0;
				-- 多个正则同时处理时才会出现相互重叠问题
				-- 清理相互重叠的解析结果（融合搭界）
				-- 声明游标
				DECLARE SqlCursor2 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
				-- 打开游标
				OPEN SqlCursor2;
				-- 取第一条记录
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
				-- 循环处理游标
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- 设置初始值
					SET @SqlContent = NULL;

					SET @SqlMID = -1;
					SET @SqlMPosition = 0;
					SET @SqlMValue = NULL;
					SET @SqlMAttribute = NULL;
					-- 查询记录
					SELECT TOP 1
						@SqlMID = id,
						@SqlMPosition = position,
						@SqlMValue = value,
						@SqlMAttribute = expression
						FROM @SqlTable
						WHERE
						@SqlID <> id AND
						@SqlPosition < position AND
						(@SqlPosition + @SqlLength > position) AND
						(@SqlPosition + @SqlLength < position + length) ORDER BY position
					-- 检查结果
					IF @SqlMID > 0
					BEGIN
						-- 设置标记位
						SET @SqlMatch = 1;

						-- 获得长度
						SET @SqlLength = @SqlMPosition - @SqlPosition + LEN(@SqlMValue);
						-- 获得内容
						SET @SqlContent = LEFT(@SqlValue, @SqlMPosition - @SqlPosition) + @SqlMValue;

						-- 检查内容
						UPDATE dbo.Ambiguity SET count = count + 1 WHERE eid = @SqlEID AND content = @SqlContent;
						-- 检查结果
						IF @@ROWCOUNT <= 0
						BEGIN
							-- 打印记录
							PRINT '统计内容表歧义状况(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
								'content("' + @SqlContent + '") = {' + CONVERT(NVARCHAR(MAX), @SqlPosition) + ':"' + @SqlValue + '",' + CONVERT(NVARCHAR(MAX), @SqlMPosition) + ':"' + @SqlMValue + '"}';
							-- 插入到记录表中
							INSERT INTO dbo.Ambiguity
								(eid, position, length, content, fmm_content, bmm_content, freq, fmm_freq, bmm_freq)
								VALUES
								(@SqlEID,
									@SqlPosition, @SqlLength, @SqlContent, @SqlValue, @SqlMValue,
									dbo.GetFreqCount(@SqlContent), dbo.GetFreqCount(@SqlValue), dbo.GetFreqCount(@SqlMValue));
						END

						-- 更新数据
						UPDATE @SqlTable SET
							position = @SqlPosition,
							length = position - @SqlPosition + length,
							value = LEFT(@SqlValue, position - @SqlPosition) + value,
							expression = expression + '+' + @SqlAttribute
							WHERE id = @SqlMID;
						-- 删除该条被包括的数据
						DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
					END
					-- 取下一条记录
					FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
				END
				-- 关闭游标
				CLOSE SqlCursor2;
				-- 释放游标
				DEALLOCATE SqlCursor2;
			END

		END TRY
		BEGIN CATCH
			-- 设置提示，抓取异常记录
			SET @SqlContent = '统计内容表歧义状况(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
		END CATCH

		---- 更新数据记录
		UPDATE dbo.ExternalContent SET type = type + 1 WHERE eid = @SqlEID;
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	END
	-- 关闭游标
	CLOSE SqlCursor1;
	-- 释放游标
	DEALLOCATE SqlCursor1; 
	-- 返回成功
	PRINT '统计内容表歧义状况> 所有文本全部统计完毕！';

END
GO
