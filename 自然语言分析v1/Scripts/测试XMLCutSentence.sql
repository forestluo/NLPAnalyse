USE [nldb]
GO

DECLARE @SqlResult XML;
DECLARE @SqlContent UString;

SET @SqlContent = '�������ݴ�ҿ��Ե�����һ�ʣ��Ϲ�עʵս���������ڷ�����˫����ע��������Ϲ�ע���� ���� ���� ��������ֵ��ע���� �����㡣��ȹ�ע�� �������ڹ�עʮ���������ֵ����ע����������ն�����ϡ���ע��λ�ϳ��֣��򣶡���ע��λ�ϵĺ�����֣��򣸣��ڶ������ص��ע����������ν��ѡ�������ǿ��������У�������������������ڣ���ֵ���ߣ���ֵ�� ��ע ������ ������ ������ ������ ������ ������ ������������ѡ���͵ĺ��룬�ر��ע������չ�֣���ע�����ĳ��֡���λ���棺��λ����������ʮλ������������λ��������������ʵս�������뵽����һ�ʡ����ʣ����Կ������������Ϸ��������ο�';

BEGIN
	-- ������ʱ����
	DECLARE @SqlCount INT;

	DECLARE @SqlRule UString;
	DECLARE @SqlMatchRule UString;
	DECLARE @SqlReduceRule UString;

	DECLARE @SqlSentence UString;
	DECLARE @SqlClassification UString;

	-- ������ʱ�����
	DECLARE @SqlTable UReduceTable;

	-- ������
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- ���ؽ��
		SET @SqlResult = '<result id="-1">input is null</result>';
		GOTO END_OF_FUNCTION;
	END
	--------------------------------------------------------------------------------
	--
	-- �������������ַ���
	--
	--------------------------------------------------------------------------------
	-- ������Ч�ַ�
	SET @SqlContent = dbo.LeftTrim(@SqlContent);
	-- �����
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- ���ؽ��
		SET @SqlResult = '<result id="-2">input is null after trimed</result>';
		GOTO END_OF_FUNCTION;
	END
	--------------------------------------------------------------------------------
	--
	-- �������������ȡһ�����ݣ�����������һ����ͷ��ʼ�ľ��ӣ���
	--
	--------------------------------------------------------------------------------
	-- ��ȡһ�����ݣ�������ؽ��
	SET @SqlResult = dbo.XMLReadContent(@SqlContent);
	-- �����
	IF @SqlResult IS NULL OR
		ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- ���ؽ��
		SET @SqlResult = '<result id="-2">fail to read content</result>';
		GOTO END_OF_FUNCTION;
	END
	-- ��ù���
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- ���ؽ��
		SET @SqlResult = '<result id="-3">fail to get rule</result>';
		GOTO END_OF_FUNCTION;
	END

	--------------------------------------------------------------------------------
	--
	-- ����������ʷ��¼��
	--
	--------------------------------------------------------------------------------
	-- ���ó�ʼֵ
	SET @SqlCount = 0;
	SET @SqlSentence = @SqlContent;

	-- ѭ������
	WHILE @SqlResult IS NOT NULL AND @SqlRule IS NOT NULL
	BEGIN
		--------------------------------------------------------------------------------
		--
		-- ��鵱ǰ����������Ϊ�ջ���Ϊ��������ԡ�
		--
		--------------------------------------------------------------------------------
		PRINT 'Rule = ' + @SqlRule;
		-- ��鵱ǰ����״̬
		SET @SqlClassification =
			dbo.GetClassification(@SqlRule);
		-- �����
		-- ����������Ϳ����ڹ������ƥ�䵽
		IF @SqlRule IN ('$a', '$a��', '$a��') OR
			@SqlClassification IN ('ƴ��', '���', 'ͨ��')
		BEGIN
			-- ���ü�����
			SET @SqlCount = @SqlCount + 1;
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable
				(id, parse_rule) VALUES (@SqlCount, @SqlRule);
			-- ���ؽ��
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + 
				dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
		ELSE
		BEGIN
			-- ���ü�����
			SET @SqlCount = @SqlCount + 1;
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlRule);
		END

		--------------------------------------------------------------------------------
		--
		-- ����ֱ��ƥ�䡣
		--
		--------------------------------------------------------------------------------
		PRINT 'MatchSentenceRule';
		-- ֱ��ƥ�䵥��
		SET @SqlMatchRule = dbo.MatchSentenceRule(@SqlRule);
		-- �����
		IF @SqlMatchRule IS NOT NULL
		BEGIN
			PRINT 'Matche Rule = ' + @SqlMatchRule;
			PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
			-- ���ü�����
			SET @SqlCount = @SqlCount + 1;
			-- ����ԭʼ��¼
			INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlMatchRule);
			-- Ҫ�����е�������װ����
			SET @SqlSentence = dbo.XMLGetSentence(@SqlResult, @SqlMatchRule);
			-- ���ؽ��
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END

		--------------------------------------------------------------------------------
		--
		-- �Թ�����м򻯣���������ֱ��ʶ��Ϊֹ��
		--
		--------------------------------------------------------------------------------
		PRINT 'GetReduceRule';
		-- ��ȡ�������
		SET @SqlReduceRule = dbo.MatchReduceRule(@SqlRule);
		-- �����
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0
		BEGIN
			-- ���ؽ��
			SET @SqlResult = '<result id="-7">fail to reduce' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
		PRINT 'Reduce Rule = ' + @SqlReduceRule;
		-- ���ü�����
		SET @SqlCount = @SqlCount + 1;
		-- ����ԭʼ��¼
		INSERT INTO @SqlTable (id, parse_rule) VALUES (@SqlCount, @SqlReduceRule);

		-- �Խ�����л���
		SET @SqlResult = dbo.XMLGetReducedResult(@SqlResult, @SqlReduceRule);
		-- �����
		-- �޷������Ӧ�ļ򻯽��
		IF @SqlResult IS NULL OR
			ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
		BEGIN
			-- ���ؽ��
			SET @SqlResult = '<result id="-8">reduced result is null' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END

		--------------------------------------------------------------------------------
		--
		-- ���ڼ򻯵ĵĹ�������ǵ��䣨����Ҫ����ͷ��ʼ��������
		--
		--------------------------------------------------------------------------------
		-- �������
		SET @SqlClassification = dbo.GetClassification(@SqlReduceRule);
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
				SET @SqlResult = '<result id="1">sentence is null' +
					dbo.FormatRules(@SqlTable) + '</result>';
				GOTO END_OF_FUNCTION;
			END
			-- ���Ӧ�����򲿷ֵ�����
			SET @SqlSentence = dbo.XMLGetSentence(@SqlResult, @SqlReduceRule);
			-- ���ؽ��
			SET @SqlResult = '<result id="1">' +
				'<sentence>' + @SqlSentence + '</sentence>' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
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
			SET @SqlResult = '<result id="-9">fail to reduce' + dbo.FormatRules(@SqlTable) + '</result>';
			GOTO END_OF_FUNCTION;
		END
	END
	-- ���ؽ��
	SET @SqlResult = '<result id="-10">something cannot be reduced' + dbo.FormatRules(@SqlTable) + '</result>';
END
END_OF_FUNCTION:
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
GO
