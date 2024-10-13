USE [nldb]
GO

DECLARE @SqlTID INT;
SELECT @SqlTID = MAX(TID) FROM dbo.TextPool;
SET @SqlTID = ROUND(@SqlTID * RAND(), 0);
-- SET @SqlTID = 2;

DECLARE @SqlText UString;
SELECT @SqlText = content FROM dbo.TextPool WHERE tid = @SqlTID;

SET @SqlText = '��̸�����ʱ����̹ȻһЦ������ʵ��跶Χ�ܹ㣬����������ͨ�׸����۶��ܳ���ҡ�����ң���Ҳ���ڻ��¡���';

DECLARE @SqlDebug INT = 0;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*���SQL�ű���ʼ*/

DECLARE @SqlFilters XML;
-- �������й��˹���
SET @SqlFilters = dbo.LoadFilterRules();
-- �����
IF @SqlFilters IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '���XMLCutSentence> �޷����ع��˹���'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlRegulars XML;
-- ���������������
SET @SqlRegulars = dbo.LoadRegularRules();
-- �����
IF @SqlRegulars IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '���XMLCutSentence> �޷������������'; GOTO END_OF_EXECUTION;
END

-- ��ԭʼ���ݽ���Ԥ����
-- ��ִ��ת��
SET @SqlText = dbo.XMLUnescape(@SqlText);
-- �滻����ı��
SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);
-- ��ӡ��Ϣ
PRINT '����ı��з�״��(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> {' + @SqlText + '}';

DECLARE @SqlExpressions XML;
-- ��ȡ����������ʽ
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);

-- ������Ч�ַ�
SET @SqlText = dbo.LeftTrim(@SqlText);
-- �����
IF @SqlText IS NULL OR LEN(@SqlText) <= 0
BEGIN
	-- ��ӡ��Ϣ
	PRINT '����ı��з�״��(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> �����ݣ�'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '���XMLCutSentence> ��������״̬��';

DECLARE @SqlContent UString = @SqlText;

BEGIN
	-- ������ʱ����
	DECLARE @SqlResult XML;
	-- ������ʱ�����
	DECLARE @SqlTable UReduceTable;

	DECLARE @SqlRule UString;
	DECLARE @SqlMatchRule UString;
	DECLARE @SqlReduceRule UString;

	DECLARE @SqlSentence UString;
	DECLARE @SqlClassification UString;

	-- ������
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- ���ؽ��
		PRINT '<result id="-1">input is null</result>'; GOTO END_OF_EXECUTION;
	END
	--------------------------------------------------------------------------------
	--
	-- �������ݵ���Ч�ַ���
	--
	--------------------------------------------------------------------------------
	-- ������Ч�ַ�
	SET @SqlContent = dbo.LeftTrim(@SqlContent);
	-- �����
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- ���ؽ��
		PRINT '<result id="-2">input is null after trimed</result>'; GOTO END_OF_EXECUTION;
	END
	--------------------------------------------------------------------------------
	--
	-- �������������ȡһ�����ݣ�����������һ����ͷ��ʼ�ľ��ӣ���
	--
	--------------------------------------------------------------------------------
	-- ��ȡһ�����ݣ�������ؽ��
	SET @SqlResult = dbo.ReadContent(@SqlContent, @SqlExpressions);
	-- �����
	IF @SqlResult IS NULL OR
		ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- ���ؽ��
		PRINT '<result id="-2">fail to read content</result>'; GOTO END_OF_EXECUTION;
	END
	-- ��ù���
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- ���ؽ��
		PRINT '<result id="-3">fail to get rule</result>'; GOTO END_OF_EXECUTION;
	END

	--------------------------------------------------------------------------------
	--
	-- ����������ʷ��¼��
	--
	--------------------------------------------------------------------------------
	-- ���ó�ʼֵ
	SET @SqlSentence = @SqlContent;

	-- ѭ������
	WHILE @SqlResult IS NOT NULL AND @SqlRule IS NOT NULL
	BEGIN
		--------------------------------------------------------------------------------
		--
		-- ��鵱ǰ����������Ϊ�ջ���Ϊ��������ԡ�
		--
		--------------------------------------------------------------------------------
		-- ��鵱ǰ����״̬
		SET @SqlClassification =
			dbo.ParseRuleGetClassification(@SqlRule);
		-- �����
		-- ����������Ϳ����ڹ������ƥ�䵽
		IF dbo.IsTerminateRule(@SqlRule) = 1 OR
			@SqlClassification IN ('ƴ��', '���', 'ͨ��')
		BEGIN
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlRule);
			-- Ҫ�����е�������װ����
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlRule);

			SELECT @SqlResult;
			-- ���ؽ��
			PRINT '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END
		ELSE
		BEGIN
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlRule);
		END

		--------------------------------------------------------------------------------
		--
		-- ����ֱ��ƥ�䡣
		--
		--------------------------------------------------------------------------------
		-- ֱ��ƥ��
		SET @SqlMatchRule = dbo.MatchSentenceRule(@SqlRule);
		-- �����
		IF @SqlMatchRule IS NOT NULL
		BEGIN
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable (parse_rule) VALUES (@SqlMatchRule);
			-- Ҫ�����е�������װ����
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlMatchRule);
			
			SELECT @SqlResult;
			-- ���ؽ��
			PRINT '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END

		--------------------------------------------------------------------------------
		--
		-- �Թ�����м򻯣���������ֱ��ʶ��Ϊֹ��
		--
		--------------------------------------------------------------------------------
		-- ��ȡ�������
		SET @SqlReduceRule = dbo.MatchReduceRule(@SqlRule);
		-- �����
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0
		BEGIN
			-- Ҫ�����е�������װ����
			SET @SqlSentence = dbo.GetResultSentence(@SqlResult, @SqlRule);
			-- ���ؽ��
			PRINT '<result id="-7">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END
		-- ����ԭʼ��¼
		INSERT INTO @SqlTable (parse_rule) VALUES (@SqlReduceRule);

		-- �Խ�����л���
		SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);
		-- �����
		-- �޷������Ӧ�ļ򻯽��
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
		BEGIN
			-- ���ؽ��
			PRINT '<result id="-8">reduced result is null' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END

		--------------------------------------------------------------------------------
		--
		-- ���ڼ򻯵ĵĹ�������ǵ��䣨����Ҫ����ͷ��ʼ��������
		--
		--------------------------------------------------------------------------------
		-- �������
		SET @SqlClassification = dbo.ParseRuleGetClassification(@SqlReduceRule);
		-- �����
		IF @SqlClassification = '����'
		BEGIN
			-- ��þ�������
			SET @SqlSentence =
				@SqlResult.value('(//result/var[@name="a"]/text())[1]', 'nvarchar(max)');
			-- �����
			IF @SqlSentence IS NULL OR LEN(@SqlSentence) <= 0
			BEGIN
				-- ���ؽ��
				PRINT '<result id="1">sentence is null' +
					dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
			END

			-- ���ؽ��
			PRINT '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END

		--------------------------------------------------------------------------------
		--
		-- ��ü򻯺�Ĺ���
		--
		--------------------------------------------------------------------------------
		-- ��ü򻯺�Ĺ���
		SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
		-- �����
		IF @SqlRule IS NULL AND LEN(@SqlRule) <= 0
		BEGIN
			-- ���ؽ��
			PRINT '<result id="-9">fail to reduce' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
		END
	END
	-- ���ؽ��
	PRINT '<result id="-10">something cannot be reduced' + dbo.FormatReduceRules(@SqlTable) + '</result>'; GOTO END_OF_EXECUTION;
END

END
ELSE
BEGIN

PRINT '���XMLCutSentence> ����Debug״̬��';

END

END_OF_EXECUTION:
/*���SQL�ű�����*/
PRINT '���XMLCutSentence> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
