USE [nldb]
GO

DECLARE @SqlTID INT;
SELECT @SqlTID = MAX(TID) FROM dbo.TextPool;
SET @SqlTID = ROUND(@SqlTID * RAND(), 0);
SET @SqlTID = 4177243;

DECLARE @SqlText UString;
SELECT @SqlText = content FROM dbo.TextPool WHERE tid = @SqlTID;

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlFilters XML;
-- 加载所有过滤规则
SET @SqlFilters = dbo.LoadFilterRules();
-- 检查结果
IF @SqlFilters IS NULL
BEGIN
	-- 打印提示
	PRINT '检测从文本池加载单句入库> 无法加载过滤规则！'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlRegulars XML;
-- 加载所有正则规则
SET @SqlRegulars = dbo.LoadRegularRules();
-- 检查结果
IF @SqlRegulars IS NULL
BEGIN
	-- 打印提示
	PRINT '检测从文本池加载单句入库> 无法加载正则规则！'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '检测从文本池加载单句入库> 进入正常状态！';

DECLARE @SqlID INT;
DECLARE @SqlXML XML;
DECLARE @SqlResult INT;
DECLARE @SqlLoopCount INT;
DECLARE @SqlExpressions XML;
DECLARE @SqlContent UString;

BEGIN TRY
	-- 对原始内容进行预处理
	-- 先执行转义
	SET @SqlText = dbo.XMLUnescape(@SqlText);
	-- 替换多余的标点
	SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);
	-- 打印消息
	PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> {' + @SqlText + '}';

	-- 设置初始值
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
				PRINT '从文本池加载单句入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ',' +
					(CASE WHEN @SqlResult > 0 THEN '单句' ELSE '错句' END) + ')> {' + @SqlContent + '}';
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

	-- 计时结束
	PRINT '从文本池加载单句入库> ' + CONVERT(NVARCHAR(MAX), @SqlLoopCount) + 
		'次循环，耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';

END
ELSE
BEGIN

PRINT '检测从文本池加载单句入库> 进入Debug状态！';

END

END_OF_EXECUTION:
/*你的SQL脚本结束*/
PRINT '检测从文本池加载单句入库> [语句执行花费时间(毫秒)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
