DECLARE @SqlResult XML;
DECLARE @SqlReduceRule UString;

-- ���ü򻯹���
SET @SqlReduceRule = '$a��$b��';
-- ��ȡһ�����ݣ�������ؽ��
SET @SqlResult = dbo.XMLReadContent('�����ݵ�۸ĸ������������˼��ѵ�һ�������ǵ�۸ĸ���ȫ�����г�����ңԶ����Ҫһ������������δ��������г���������������Ҫ��ܡ����ֲ�ǿ�Լ��߱�ʾ��');
PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

BEGIN
	-- ������ʱ����
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;

	DECLARE @SqlCRule UString;
	DECLARE @SqlCReduceRule UString;
	DECLARE @SqlClassification UString;

	-- ������
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	-- ������
	IF @SqlReduceRule IS NULL OR
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION
	-- ��������ļ򻯹���
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	PRINT 'ReduceRule = ' + @SqlReduceRule;
	PRINT 'CReduceRule = ' + @SqlCReduceRule;
	
	-- ��û�������
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION
	-- ���������ԭʼ����
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);
	PRINT 'Rule = ' + @SqlRule;
	PRINT 'CRule = ' + @SqlCRule;

	---- ���ó�ʼֵ
	--SET @SqlClassification = NULL;
	---- ��û������ķ���
	--SELECT @SqlClassification = classification
	--	FROM dbo.ParseRule WHERE parse_rule = @SqlRule;
	---- �����
	---- �Ѿ�ƥ�䵽���䣬�����һ������
	--PRINT 'Classification = ' + @SqlClassification;
	--IF @SqlClassification = '����' GOTO END_OF_FUNCTION;

	-- ���ƥ���ϵ
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- �����
	-- ����֮�䲻����ƥ���ϵ
	-- ��Ȼƥ���ϵҲ���ܴ��ڲ�ֹһ��λ��
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
	-- ���ó�ʼֵ
	SET @SqlClassification = NULL;
	-- ��û������ķ���
	SELECT @SqlClassification = classification
		FROM dbo.ParseRule WHERE parse_rule = @SqlReduceRule;
	-- �����
	PRINT 'Classification = ' + @SqlClassification;
	-- ������������ͷ����ʼ����
	IF @SqlClassification = '����' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION

	-- ������ʱ����
	DECLARE @SqlCount INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlValue UString;

	DECLARE @SqlType INT;
	DECLARE @SqlIndex INT = 0;
	DECLARE @SqlCurrent INT = 0;
	DECLARE @SqlReduced UString = '';

	-- ������в���������
	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
	PRINT 'SqlCount = ' + CONVERT(NVARCHAR(MAX), @SqlCount);
	PRINT '----------------------';
DOIT_AGAIN:
	-- ���ó�ʼֵ
	SET @SqlType = 0;
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX), @SqlCurrent);
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		-- ��鵱ǰ�ַ�
		IF @SqlChar <> '$'
		BEGIN
			-- �������
			IF @SqlType <> 1
			BEGIN
				-- ��������
				SET @SqlType = 1;
				-- ���ó�ʼֵ
				SET @SqlValue = '';
			END
			-- ����һ���ַ�
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		BEGIN
			-- �������
			IF @SqlType <> 2
			BEGIN
				-- ��������
				SET @SqlType = 2;
				-- �����
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
					-- ����һ���ָ���
					SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			PRINT 'SqlChar = ' + @SqlChar;
			-- ��ò�������
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
		END
		PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
		PRINT '-----------------------------';
	END
	-- �������
	IF @SqlType = 1
	BEGIN
		-- �����
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			-- ����һ���ָ���
			SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
	END
	PRINT 'SqlReduced = ' + @SqlReduced;

	-- ������ʱ����
	DECLARE @SqlSegment UString = '';
	-- ���ó�ʼֵ
	SET @SqlPosition =
		@SqlPosition + LEN(@SqlCReduceRule);
	PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX), @SqlCurrent);
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX), @SqlPosition);
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		PRINT 'SqlChar = ' + @SqlChar;
		-- ��鵱ǰ�ַ�
		IF @SqlChar <> '$'
		BEGIN
			-- ����һ���ַ�
			SET @SqlSegment = @SqlSegment + @SqlChar;
		END
		ELSE
		BEGIN
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			PRINT 'SqlName = ' + @SqlChar;
			-- ��ò�������
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
		END
	END
	-- �����
	-- ����һ������
	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
		SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlSegment + '</var>';
	PRINT 'SqlReduced = ' + @SqlReduced;

	-- �ٴμ������ֵ
	IF CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition) > 0
	BEGIN
		-- ������λ��
		SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition); GOTO DOIT_AGAIN;
	END

	-- ���ó�ʼֵ
	SET @SqlType = 0;
	SET @SqlValue = '';
	-- ���ó�ʼֵ
	SET @SqlPosition = LEN(@SqlCRule);
	PRINT 'SqlCurrent = ' + CONVERT(NVARCHAR(MAX),@SqlCurrent);
	PRINT 'SqlPosition = ' + CONVERT(NVARCHAR(MAX),@SqlPosition);
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
		PRINT 'SqlChar = ' + @SqlChar;
		-- ��鵱ǰ�ַ�
		IF @SqlChar <> '$'
		BEGIN
			-- �������
			IF @SqlType <> 1
			BEGIN
				-- ��������
				SET @SqlType = 1;
				-- ���ó�ʼֵ
				SET @SqlValue = '';
			END
			-- ����һ���ַ�
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		BEGIN
			-- �������
			IF @SqlType <> 2
			BEGIN
				-- ��������
				SET @SqlType = 2;
				-- �����
				-- ����һ���ָ���
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
					SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			PRINT 'Name = ' + @SqlChar;
			-- ��ò�������
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
		END
	END
	-- �������
	IF @SqlType = 1
	BEGIN
		-- �����
		-- ����һ���ָ���
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
	END
	PRINT 'SqlReduced = ' + @SqlReduced;

	SET @SqlCRule = REPLACE(@SqlCRule, @SqlCReduceRule, '$');
	-- �ָ�������
	SET @SqlRule = dbo.RecoverParameters(@SqlCRule);
	SET @SqlIndex = 0;
	PRINT 'SqlRule = ' + @SqlRule;

	SET @SqlReduced = '<result id="1" start="1" end="0">' + @SqlReduced + '</result>';
	SET @SqlResult = @SqlReduced;

	-- ��ýڵ�����
	SET @SqlCount = @SqlResult.value('count(//result/*)', 'int');

	-- ������ʱ����
	DECLARE @SqlID INT = 0;
	DECLARE @SqlName UString;

	-- ���ó�ʼֵ
	SET @SqlPosition = 1;
	-- ѭ������
	WHILE @SqlID < @SqlCount
	BEGIN
		-- ���ü�����
		SET @SqlID = @SqlID + 1;
		-- ���Ľڵ����
		SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@pos)[1] with sql:variable("@SqlPosition")');
		
		-- ��ýڵ�����
		SET @SqlValue = @SqlResult.value('(//result/*[position()=sql:variable("@SqlID")]/text())[1]', 'nvarchar(max)');
		-- �����
		-- �޸�λ��
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlPosition = @SqlPosition + LEN(@SqlValue);

		-- ��ñ�������
		SET @SqlName = @SqlResult.value('local-name((//result/*[position()=sql:variable("@SqlID")])[1])', 'nvarchar(max)');
		-- ��鱾������
		IF @SqlName = 'pad'
		BEGIN
			-- ���Ľڵ����
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@id)[1] with sql:variable("@SqlID")');
		END
		ELSE IF @SqlName = 'var'
		BEGIN
			-- ��������
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- ���Ľڵ����
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@id)[1] with sql:variable("@SqlID")');
			SET @SqlResult.modify('replace value of ((//result/*[position()=sql:variable("@SqlID")])/@name)[1] with sql:variable("@SqlChar")');
		END
	END

	-- ����һ���ڵ�
	SET @SqlResult.modify('insert <rule>&#x20;</rule> as first into (//result)[1]');
	-- ���Ľڵ���ֵ
	SET @SqlResult.modify('replace value of (//result/@end)[1] with sql:variable("@SqlPosition")');
	SET @SqlResult.modify('replace value of (//result/rule/text())[1] with sql:variable("@SqlRule")');

	PRINT CONVERT(NVARCHAR(MAX),@SqlResult);
END

END_OF_FUNCTION:
	PRINT '�ű�������';