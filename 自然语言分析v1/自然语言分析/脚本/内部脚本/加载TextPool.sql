USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[加载TextPool]    Script Date: 2020/12/10 16:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月7日>
-- Description:	<解析文本池，并记录至数据库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载TextPool]
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlTID INT;
	DECLARE @SqlRID INT;
	DECLARE @SqlXML XML;
	DECLARE @SqlResult INT;
	DECLARE @SqlFilters XML;
	DECLARE @SqlRule UString;
	DECLARE @SqlText UString;
	DECLARE @SqlSentence UString;

	-- 加载所有过滤规则
	SET @SqlFilters = dbo.LoadFilterRules();
	-- 检查结果
	IF @SqlFilters IS NULL
	BEGIN
		-- 打印提示
		PRINT '加载TextPool> 无法加载过滤规则！'; RETURN -1;
	END
	-- 打印空行
	PRINT '加载TextPool> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0 ORDER BY length;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 打印内容
		/*
		PRINT '加载TextPool(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlText;*/
		/*
		PRINT '加载TextPool(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ----------解析文本内容----------';*/
		BEGIN TRY

			-- 对原始内容进行预处理
			-- 先执行转义
			SET @SqlText = dbo.XMLUnescape(@SqlText);
			-- 替换多余的标点
			SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);

			-- 循环处理
			WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
			BEGIN
				-- 剪除无效字符
				SET @SqlText = dbo.LeftTrim(@SqlText);
				-- 检查结果
				IF @SqlText IS NULL OR LEN(@SqlText) <= 0
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -100;
					-- 打印消息
					PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 无效内容！'; BREAK;
				END

				-- 直接切分句子
				SET @SqlXML = dbo.XMLCutSentence(@SqlText);
				-- 检查结果
				IF @SqlXML IS NULL
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -101;
					-- 打印消息
					PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 分句失败！'; BREAK;
				END
				-- 获得结果
				SET @SqlResult = @SqlXML.value('(//result/@id)[1]', 'int');
				-- 检查结果
				IF @SqlResult IS NULL OR @SqlResult <= 0
				BEGIN
					-- 打印消息
					PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
					-- PRINT @SqlText;
					-- 打印消息
					PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) +
						')> 遇到错误(' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')！'; BREAK;
				END
				-- 获得句子
				SET @SqlSentence = @SqlXML.value('(//result/sentence/text())[1]', 'nvarchar(max)');
				-- 检查结果
				IF @SqlSentence IS NULL	OR LEN(@SqlSentence) <= 0
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -102;
					-- 打印消息
					PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 句子为空！'; BREAK;
				END
			
				-- 检查长度
				IF dbo.IsTooLong(@SqlSentence) = 1
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -103;
					-- 打印消息
					PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 句子太长！'; BREAK;
				END
				ELSE
				BEGIN
					-- 获得规则（该规则为最原始规则）
					SET @SqlRule = dbo.GetParseRule(@SqlSentence);
					-- 输出截取到的句子
					-- PRINT '加载TextPool(result=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlRule;
					-- 增加句子
					EXEC @SqlResult = dbo.OuterAddSentence @SqlSentence, @SqlRule;
					-- 输出截取到的句子
					-- PRINT '加载TextPool(result=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlSentence;
				END
				-- 检查结果
				IF LEN(@SqlSentence) < LEN(@SqlText)
				BEGIN
					-- 截取部分
					SET @SqlText = LTRIM(RIGHT(@SqlText, LEN(@SqlText) - LEN(@SqlSentence)));
				END
				ELSE
				BEGIN
					-- 设置信息并清理结果
					SET @SqlResult = 0; SET @SqlText = NULL;
					-- 输出信息
					/*PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 解析完毕！';*/ BREAK;
				END
			END

			-- 检查结果
			IF @SqlText IS NOT NULL AND LEN(@SqlText) > 0
				-- 打印输出
				PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ', left)> ' + @SqlText;

		END TRY
		BEGIN CATCH
			-- 打印记录
			PRINT '加载TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' +
				'消息 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
				'级别 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
				'状态' + CONVERT(NVARCHAR(MAX), ERROR_STATE()) + ', 过程 ' + ERROR_PROCEDURE() + ' ' +
				'行' + CONVERT(NVARCHAR(MAX), ERROR_LINE()) +	' [' + ERROR_MESSAGE() + ']';
			-- 插入一条异常记录
			INSERT INTO dbo.ExceptionLog (number, serverity, state, prodcedure, line, message)
				values(ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE() ,
				'加载TextPool(tid=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + ERROR_MESSAGE());
		END CATCH

NEXT_ROW:
		-- 更新记录
		UPDATE dbo.TextPool SET parsed = 1, result = @SqlResult, remark = @SqlText WHERE tid = @SqlTID;

		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '加载TextPool> 所有文本全部解析完毕！'; RETURN 1;
END
