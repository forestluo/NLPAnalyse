USE [nldb]
GO

DECLARE @SqlResult XML;
DECLARE @SqlContent UString;

SET @SqlContent = '���⾲������������ְ���������ƽ�����侲����������ֵ�ڹ�ͻ��Ǻܵ�λ�������񣬺���Ҫ��Ҫ���˶�Ա�������⣢�������Ǻܸߵ��������ܸߵľ��磬������ƽ˵��';

BEGIN
	-- ������ʱ����
	DECLARE @SqlExist INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlSentence UString;
	DECLARE @SqlReduceRule UString;
	DECLARE @SqlClassification UString;

	-- ��ȡһ�����ݣ�������ؽ��
	SET @SqlResult =
		dbo.XMLReadContent(@SqlContent);
	-- �����
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

	-- ��ù���
	SET @SqlRule =
		@SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		PRINT '����Ϊ��!';
		GOTO END_OF_FUNCTION;
	END

	SET @SqlExist = 0;
	-- ѭ������
	WHILE @SqlResult IS NOT NULL
	BEGIN
		PRINT '��ʼ���л�������';

		PRINT 'SqlRule = ' + @SqlRule;

		-- SELECT * FROM dbo.ParseRule;
		-- ��ȡ�������
		SET @SqlReduceRule = dbo.GetReduceRule(@SqlRule);
		-- �����
		IF @SqlReduceRule IS NULL OR LEN(@SqlReduceRule) <= 0 
		BEGIN
			PRINT '�Ҳ��������õĹ���'; BREAK;
		END
		PRINT 'SqlReduceRule = ' + @SqlReduceRule;

		-- �������
		SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);

		-- ��ù���
		SET @SqlRule =
			@SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
		-- �����
		IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
		BEGIN
			PRINT '����Ϊ��!';
			GOTO END_OF_FUNCTION;
		END
		-- �������
		SET @SqlClassification = NULL;
		-- ��ѯ���
		SELECT @SqlClassification = classification
			FROM dbo.ParseRule WHERE parse_rule = @SqlRule;
		-- �����
		IF @SqlClassification = '����'
		BEGIN
			SET @SqlExist = 1;
			PRINT '����������䣡'; BREAK;
		END
		IF @SqlRule = '$a'
		BEGIN
			PRINT '����ѭ��������'; BREAK;
		END
		/*
		IF dbo.GetCount(@SqlRule, '$') <= 1
		BEGIN
			PRINT 'ֻʣ��һ��������'; BREAK;
		END
		*/
		-- �������
		SET @SqlClassification = NULL;
		-- ��ѯ���
		SELECT @SqlClassification = classification
			FROM dbo.ParseRule WHERE parse_rule = @SqlReduceRule;
		-- �����
		IF @SqlClassification = '����'
		BEGIN
			SET @SqlExist = 1;
			PRINT '��������Ա��������'; BREAK;
		END

	END
	IF @SqlResult IS NULL PRINT '����ʧ�ܣ�';
	PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

	IF @SqlExist = 1
	BEGIN
		-- ��õ�һ������
		SET @SqlSentence = @SqlResult.value('(//result/var[@name="a"]/text())[1]', 'nvarchar(max)');
		PRINT 'Sentence = ' + @SqlSentence;
	END
END

END_OF_FUNCTION:
	PRINT '�ű�������';