USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月28日>
-- Description:	<切分外部内容表单句，并将更新数据库>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[切分外部内容表单句]
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlExtID INT;
	DECLARE @SqlResult XML;
	DECLARE @SqlTips UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlSentence UString;

	DECLARE @SqlRule UString;
	DECLARE @SqlName UString;
	DECLARE @SqlRegulars XML;
	DECLARE @SqlDate DATETIME;
	DECLARE @SqlExpressions XML;
	DECLARE @SqlNewValue UString;
	
	-- 打印空行
	PRINT '切分外部内容表单句> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 加载所有正则规则
	SET @SqlRegulars = dbo.LoadRegularRules();
	-- 检查结果
	IF @SqlRegulars IS NULL
	BEGIN
		-- 打印提示
		PRINT '切分外部内容表单句> 无法加载正则规则！'; RETURN -1;
	END

	-- 开始计时
	SET @SqlDate = GetDate();
	-- 声明游标
	DECLARE SqlCursor1 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) eid, content
			FROM dbo.ExternalContent
			WHERE classification = '单句' AND type = 0;
	-- 打开游标
	OPEN SqlCursor1;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor1 INTO @SqlExtID, @SqlSentence;
	-- 计时结束
	PRINT '切分外部内容表单句> 开启游标耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 开始计时
		SET @SqlDate = GetDate();
		/*
		-- 打印内容
		PRINT '切分外部内容表单句(oid=' +
			CONVERT(NVARCHAR(MAX), @SqlExtID) + ')> ' + @SqlSentence;
		*/

		BEGIN TRY

			-- 提取所有正则表达式
			SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlSentence);

			-- 读取一段内容，生成相关结果
			SET @SqlResult = dbo.ReadContent(@SqlSentence, @SqlExpressions);
			-- 检查结果
			IF @SqlResult IS NULL OR
				ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
			BEGIN
				-- 返回结果
				PRINT '切分外部内容表单句(eid=' + CONVERT(NVARCHAR(MAX), @SqlExtID) + ')> 读取内容失败！'; GOTO NEXT_ROW; 
			END
			-- 获得规则
			SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
			-- 检查结果
			IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
			BEGIN
				-- 返回结果
				PRINT '切分外部内容表单句(eid=' + CONVERT(NVARCHAR(MAX), @SqlExtID) + ')> 获取规则失败！'; GOTO NEXT_ROW; 
			END

			-- 声明游标
			DECLARE SqlCursor2 CURSOR
				STATIC FORWARD_ONLY LOCAL FOR
				SELECT
					Nodes.value('(@id)[1]','int') AS nodeID,
					Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
					FROM @SqlResult.nodes('//result/var') AS N(Nodes) ORDER BY nodeID; 
			-- 打开游标
			OPEN SqlCursor2;
			-- 取第一条记录
			FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			-- 循环处理游标
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- 检查结果
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				BEGIN
					-- 剪裁
					SET @SqlNewValue = TRIM(@SqlValue);
					-- 检查结果
					IF LEN(@SqlNewValue) < LEN(@SqlValue)
					BEGIN
						-- 需要替换原句的内容
						SET @SqlSentence =
							REPLACE(@SqlSentence, @SqlValue, @SqlNewValue);
						-- 设置新的数值
						SET @SqlValue = @SqlNewValue;
					END
					-- 设置初始值
					SET @SqlID = 0;
					-- 查询结果
					SELECT @SqlID = eid FROM dbo.ExternalContent
						WHERE content = @SqlValue;
					-- 检查结果
					IF @SqlID <= 0
					BEGIN
						-- 插入一条记录
						INSERT INTO dbo.ExternalContent
							(classification, length, content) VALUES ('分句', LEN(@SqlValue), @SqlValue);
						-- 选择当前的ID
						SET @SqlID = SCOPE_IDENTITY();
					END
				END

				-- 取下一条记录
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			END
			-- 关闭游标
			CLOSE SqlCursor2;
			-- 释放游标
			DEALLOCATE SqlCursor2;

			-- 更新内容
			UPDATE dbo.ExternalContent
				SET [length] = LEN(@SqlSentence), content = @SqlSentence, [rule] = @SqlRule WHERE eid = @SqlExtID;

		END TRY
		BEGIN CATCH
			-- 设置提示，抓取异常记录
			SET @SqlTips = '切分外部内容表单句(eid=' + CONVERT(NVARCHAR(MAX), @SqlExtID) + ')'; EXEC dbo.CatchException @SqlTips;
		END CATCH

NEXT_ROW:
		-- 更新数据
		UPDATE dbo.ExternalContent
			SET type = type + 1 WHERE eid = @SqlExtID;
		-- 取第一条记录
		FETCH NEXT FROM SqlCursor1 INTO @SqlExtID, @SqlSentence;

		-- 计时结束
		PRINT '切分外部内容表单句(oid=' + CONVERT(NVARCHAR(MAX), @SqlExtID) + ')> ' + 
			'耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	END
	-- 关闭游标
	CLOSE SqlCursor1;
	-- 释放游标
	DEALLOCATE SqlCursor1; 
	-- 返回成功
	PRINT '切分外部内容表单句> 所有单句全部切分完毕！'; RETURN 1;
END
