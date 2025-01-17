USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[从文本池加载单句入库]    Script Date: 2020/12/10 16:23:22 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月7日>
-- Description:	<解析文本池，并将单句记录至数据库>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[从文本池加载单句入库]
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlTID INT;
	DECLARE @SqlXML XML;
	DECLARE @SqlResult INT;

	DECLARE @SqlFilters XML;
	DECLARE @SqlRegulars XML;
	DECLARE @SqlExpressions XML;

	DECLARE @SqlRule UString;
	DECLARE @SqlText UString;
	DECLARE @SqlContent UString;

	DECLARE @SqlDate DATETIME;
	DECLARE @SqlLoopCount INT;
	
	-- 开始计时
	SET @SqlDate = GetDate();
	-- 加载所有过滤规则
	SET @SqlFilters = dbo.LoadFilterRules();
	-- 检查结果
	IF @SqlFilters IS NULL
	BEGIN
		-- 打印提示
		PRINT '从文本池加载单句入库> 无法加载过滤规则！'; RETURN -1;
	END
	-- 加载所有正则规则
	SET @SqlRegulars = dbo.LoadRegularRules();
	-- 检查结果
	IF @SqlRegulars IS NULL
	BEGIN
		-- 打印提示
		PRINT '从文本池加载单句入库> 无法加载正则规则！'; RETURN -2;
	END
	-- 打印空行
	PRINT '从文本池加载单句入库> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';
	-- 计时结束
	PRINT '从文本池加载单句入库> 加载过滤规则耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

	-- 开始计时
	SET @SqlDate = GetDate();
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- 计时结束
	PRINT '从文本池加载单句入库> 开启游标耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置初始值
		SET @SqlResult = 0;
		-- 开始计时
		SET @SqlDate = GetDate();
		-- 打印内容
		--PRINT '从文本池加载单句入库(tid=' +
		--	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlText;

		BEGIN TRY

			-- 对原始内容进行预处理
			-- 先执行转义
			SET @SqlText = dbo.XMLUnescape(@SqlText);
			-- 替换多余的标点
			SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);

			-- 设置初始值
			SET @SqlResult = 0;
			SET @SqlLoopCount = 0;
			-- 循环处理
			WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
			BEGIN
				-- 修改计数器
				SET @SqlLoopCount = @SqlLoopCount + 1;
				-- 提取所有正则表达式
				SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);

				-- 剪除无效字符
				SET @SqlText = dbo.LeftTrim(@SqlText);
				-- 检查结果
				IF @SqlText IS NULL OR LEN(@SqlText) <= 0
				BEGIN
					-- 设置错误信息
					SET @SqlResult = 0;/*无内容可以继续解析*/
					-- 打印消息
					PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 无内容！'; BREAK;
				END

				-- 设置初始值
				SET @SqlResult = 0;
				-- 直接切分句子
				SET @SqlXML = dbo.XMLCutSentence(@SqlText, @SqlExpressions);
				-- 检查结果
				IF @SqlXML IS NULL
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -101;
					-- 打印消息
					PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 分句失败！'; BREAK;
				END
				-- 获得结果
				SET @SqlResult = @SqlXML.value('(//result/@id)[1]', 'int');
				-- 检查结果
				IF @SqlResult IS NULL
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -101;
					-- 打印消息
					PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 分句失败！'; BREAK;
				END
				ELSE IF @SqlResult <= 0
				BEGIN
					-- 检查错误代码
					IF @SqlResult <> - 7
					BEGIN
						-- 打印消息
						PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
						-- PRINT @SqlText;
						-- 打印消息
						PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) +
							')> 遇到错误(' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')！'; BREAK;
					END
				END
				-- 获得句子
				SET @SqlContent = @SqlXML.value('(//result/sentence/text())[1]', 'nvarchar(max)');
				-- 检查结果
				IF @SqlContent IS NULL	OR LEN(@SqlContent) <= 0
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -102;
					-- 打印消息
					PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 句子为空！'; BREAK;
				END
			
				-- 检查长度
				IF dbo.IsTooLong(@SqlContent) = 1
				BEGIN
					-- 设置错误信息
					SET @SqlResult = -103;
					-- 打印消息
					PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 句子太长！'; BREAK;
				END
				ELSE
				BEGIN
					-- 单句直接入库
					-- 检查标识
					SET @SqlID = dbo.ContentGetCID(@SqlContent);
					-- 检查结果
					IF @SqlID <= 0 AND NOT EXISTS(SELECT * FROM dbo.ExternalContent WHERE content = @SqlContent)
					BEGIN
						-- 插入记录至ExternalContent
						INSERT INTO dbo.ExternalContent
							(tid, [classification], [length], content)
							VALUES (@SqlTID, CASE WHEN @SqlResult > 0 THEN '单句' ELSE '错句' END, LEN(@SqlContent), @SqlContent);
						-- 清除错误标记
						SET @SqlResult = 0;
					END
				END

				-- 检查结果
				IF LEN(@SqlContent) < LEN(@SqlText)
				BEGIN
					-- 截取部分
					SET @SqlText = LTRIM(RIGHT(@SqlText, LEN(@SqlText) - LEN(@SqlContent)));
				END
				ELSE
				BEGIN
					-- 设置信息并清理结果
					SET @SqlResult = 0; SET @SqlText = NULL;
					-- 输出信息
					/*PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 解析完毕！';*/ BREAK;
				END
			END

			-- 检查结果
			IF @SqlText IS NOT NULL AND LEN(@SqlText) > 0
				-- 打印输出
				PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ', left)> ' + @SqlText;

		END TRY
		BEGIN CATCH
			-- 设置提示，抓取异常记录
			SET @SqlContent = '从文本池加载单句入库(tid=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')'; EXEC dbo.CatchException @SqlContent;	
		END CATCH

NEXT_ROW:
		-- 更新记录
		UPDATE dbo.TextPool SET parsed = parsed + 1, result = @SqlResult, remark = @SqlText WHERE tid = @SqlTID;
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
		-- 计时结束
		PRINT '从文本池加载单句入库> ' + CONVERT(NVARCHAR(MAX), @SqlLoopCount) + 
			'次循环，耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '从文本池加载单句入库> 所有文本全部切分成单句入库！'; RETURN 1;
END
