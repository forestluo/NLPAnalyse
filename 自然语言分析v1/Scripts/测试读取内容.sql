DECLARE @SqlContent UString = '�����Ǳ������������ʵ��ȫ�����ʽ����ã���������˵�����ţ�����Ҳ����˵�Ǵ��ţ�ԶԶû�дﵽ���ˮƽ��Ҫ�����Щ���⣬�ںܴ�̶��Ͼ���֤ȯ��ҵ���ʱ��г��������ˡ� ��������˵��';

BEGIN
	-- ������ʱ����
	DECLARE @SqlXML XML;

	-- ������ʱ����
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlVarType INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlName UString;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;

	-- ������
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 GOTO END_OF_FUNCTION;

	-- ���ó�ʼֵ
	SET @SqlResult = '';
	SET @SqlXML = '<result id="1" start="1" end="0"><rule>&#x20;</rule></result>';

	-- ���ó�ʼֵ
	SET @SqlRule = '';
	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlVarType = 0;

	-- ���ó�ʼֵ
	SET @SqlPosition= 0;
	-- ѭ������
	WHILE @SqlIndex < 26 AND @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- ��������һ
		SET @SqlPosition = @SqlPosition + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- �����
		IF dbo.IsPunctuation(@SqlChar) = 1
		-- ������
		BEGIN
			-- �����λ
			IF @SqlVarType <> 1
			BEGIN
				-- �����λ
				IF @SqlVarType = 2
				BEGIN
					-- �޸��ı���ֵ
					SET @SqlResult = @SqlResult + @SqlValue + '</var>';

					IF LEN(@SqlValue) <= 0
					BEGIN
						PRINT 'empty content';
						SET @SqlIndex = @SqlIndex - 1;
						SET @SqlCount = @SqlCount - 1;
						--SET @SqlRule = LEFT(@SqlRule, LEN(@SqlRule) - 2);
						SET @SqlRule = REPLACE(@SqlRule, '$' + @SqlName, '');
					END

					SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
				END
				-- ���ñ��λ
				SET @SqlVarType = 1;

				-- ���ó�ʼֵ
				SET @SqlValue = '';
				-- ���ñ�ǩ����
				SET @SqlCount = @SqlCount + 1;
				-- ���ӽڵ�
				SET @SqlResult = @SqlResult + '<pad ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
				SET @SqlXML.modify('insert <pad id="256" pos="0">&#x20;</pad> as last into (//result[position()=1])[1]');
				SET @SqlXML.modify('replace value of (//result/pad[@id=256]/@id)[1] with sql:variable("@SqlCount")');
				SET @SqlXML.modify('replace value of (//result/pad[@id=sql:variable("@SqlCount")]/@pos)[1] with sql:variable("@SqlPosition")');
			END
			-- ����һ���ַ�
			SET @SqlRule = @SqlRule + @SqlChar;
			SET @SqlValue = @SqlValue + @SqlChar;
		END
		ELSE
		-- �ı�����
		BEGIN
			-- �����λ
			IF @SqlVarType <> 2
			BEGIN
				-- �����
				IF @SqlVarType = 1
				BEGIN
					-- �޸��ı���ֵ
					SET @SqlResult = @SqlResult + @SqlValue + '</pad>';

					SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
				END
				-- ���ñ��λ
				SET @SqlVarType = 2;

				-- ���ó�ʼֵ
				SET @SqlValue = '';
				-- ���ñ�ǩ����
				SET @SqlCount = @SqlCount + 1;
				SET @SqlIndex = @SqlIndex + 1;
				-- ��ò�����
				SET @SqlName =
					dbo.GetLowercase(@SqlIndex);
				-- ����һ������
				SET @SqlRule = @SqlRule + '$' + @SqlName;
				-- ���ӽڵ�
				SET @SqlResult = @SqlResult + '<var name="' + @SqlName + '" ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
				SET @SqlXML.modify('insert <var name="*" id="256" pos="0">&#x20;</var> as last into (//result[position()=1])[1]');
				SET @SqlXML.modify('replace value of (//result/var[@id=256]/@id)[1] with sql:variable("@SqlCount")');
				SET @SqlXML.modify('replace value of (//result/var[@id=sql:variable("@SqlCount")]/@name)[1] with sql:variable("@SqlName")');
				SET @SqlXML.modify('replace value of (//result/var[@id=sql:variable("@SqlCount")]/@pos)[1] with sql:variable("@SqlPosition")');
			END
			-- ����һ���ַ�
			SET @SqlValue = @SqlValue + @SqlChar;
		END
	END
	-- �����λ
	IF @SqlVarType = 1
	BEGIN
		-- ��βλ��
		SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- �޸��ı���ֵ
		SET @SqlResult = @SqlResult + @SqlValue + '</pad>';
		SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
	END
	ELSE IF @SqlVarType = 2
	BEGIN
		-- ��βλ��
		SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- �޸��ı���ֵ
		SET @SqlResult = @SqlResult + @SqlValue + '</var>';
		SET @SqlXML.modify('replace value of (//result/*[@id=sql:variable("@SqlCount")]/text())[1] with sql:variable("@SqlValue")');
	END
	
	-- ���÷���ֵ
	SET @SqlResult = '<result id="1" start="1" end="'+
		CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
		'<rule>' + @SqlRule + '</rule>' + @SqlResult + '</result>';
	PRINT @SqlResult;

	SET @SqlXML = @SqlResult;
	-- ɾ������Ϊ�յ�pad�ڵ�
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
	-- �޸�����
	-- SET @SqlXML.modify('replace value of (//result/@end)[1] with sql:variable("@SqlPosition")');
	-- �޸��ı���ֵ
	-- SET @SqlXML.modify('replace value of (//result/rule[position()=1]/text())[1] with sql:variable("@SqlRule")');
	-- ���ؽ��
END
END_OF_FUNCTION:
GO
