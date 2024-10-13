USE [nldb]
GO

DECLARE @SqlResult XML;
DECLARE @SqlContent UString;

SET @SqlContent = '“吴静钰这个＂静＂字啊，安静，平静，冷静，她对这个字的诠释还是很到位。静如玉，很重要，要是运动员能做到这＂三静＂是很高的修养，很高的境界，”常建平说。';

BEGIN
	-- 声明临时变量
	DECLARE @SqlExist INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlSentence UString;
	DECLARE @SqlReduceRule UString;
	DECLARE @SqlClassification UString;

	-- 读取一段内容，生成相关结果
	SET @SqlResult =
		dbo.XMLReadContent(@SqlContent);
	-- 检查结果
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

	-- 获得规则
	SET @SqlRule =
		@SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		PRINT '规则为空!';
		GOTO END_OF_FUNCTION;
	END

	SET @SqlExist = 0;
	-- 循环处理
	WHILE @SqlResult IS NOT NULL
	BEGIN
		PRINT '开始进行化简工作！';

		PRINT 'SqlRule = ' + @SqlRule;

		-- SELECT * FROM dbo.ParseRule;
		-- 获取化简规则
		SET @SqlReduceRule = dbo.GetReduceRule(@SqlRule);
		-- 检查结果
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0 
		BEGIN
			PRINT '找不到化简用的规则'; BREAK;
		END
		PRINT 'SqlReduceRule = ' + @SqlReduceRule;

		-- 化简规则
		SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);

		-- 获得规则
		SET @SqlRule =
			@SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
		-- 检查结果
		IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
		BEGIN
			PRINT '规则为空!';
			GOTO END_OF_FUNCTION;
		END
		-- 检查类型
		SET @SqlClassification = NULL;
		-- 查询结果
		SELECT @SqlClassification = classification
			FROM dbo.ParseRule WHERE parse_rule = @SqlRule;
		-- 检查结果
		IF @SqlClassification = '单句'
		BEGIN
			SET @SqlExist = 1;
			PRINT '自身就是整句！'; BREAK;
		END
		IF @SqlRule = '$a'
		BEGIN
			PRINT '自身循环解析！'; BREAK;
		END
		/*
		IF dbo.GetCount(@SqlRule, '$') <= 1
		BEGIN
			PRINT '只剩余一个参数！'; BREAK;
		END
		*/
		-- 检查类型
		SET @SqlClassification = NULL;
		-- 查询结果
		SELECT @SqlClassification = classification
			FROM dbo.ParseRule WHERE parse_rule = @SqlReduceRule;
		-- 检查结果
		IF @SqlClassification = '单句'
		BEGIN
			SET @SqlExist = 1;
			PRINT '有整句可以被化简出！'; BREAK;
		END

	END
	IF @SqlResult IS NULL PRINT '化简失败！';
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

	IF @SqlExist = 1
	BEGIN
		-- 获得第一个参数
		SET @SqlSentence = @SqlResult.value('(//result/var[@name="a"]/text())[1]', 'nvarchar(max)');
		PRINT 'Sentence = ' + @SqlSentence;
	END
END

END_OF_FUNCTION:
	PRINT '脚本结束！';