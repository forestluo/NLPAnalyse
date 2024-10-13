USE [nldb]
GO

-- Add the parameters for the function here
DECLARE @SqlResult XML ;
DECLARE @SqlReduceRule UString;

-- ���ü򻯹���
SET @SqlReduceRule = '$a��$b';
-- ��ȡһ�����ݣ�������ؽ��
SET @SqlResult = dbo.XMLReadContent('����:����˵��һ����, ����?');
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
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION;
	-- ��������ļ򻯹���
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	
	PRINT 'Step 1';

	-- ��û�������
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION;
	-- ���������ԭʼ����
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);

	PRINT 'Step 2';
	PRINT 'ReduceRule = ' + @SqlCReduceRule;
	PRINT 'Rule = ' + @SqlCRule;
	-- ���ƥ���ϵ
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- �����
	-- ����֮�䲻����ƥ���ϵ
	-- ��Ȼƥ���ϵҲ���ܴ��ڲ�ֹһ��λ��
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION;
	-- ��û������ķ���
	SET @SqlClassification =
		dbo.GetClassification(@SqlReduceRule);
	-- ������������ͷ����ʼ����
	IF @SqlClassification = '����' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION;

	PRINT 'Step 3';

	---- ������ʱ����
	--DECLARE @SqlCount INT;
	--DECLARE @SqlChar UChar;
	--DECLARE @SqlValue UString;

	-- ������ʱ��
	DECLARE @SqlTable UParseTable;
	DECLARE @SqlResultTable UParseTable;

	-- ������ʱ����
	--DECLARE @SqlType INT;
	--DECLARE @SqlID INT = 0;
	--DECLARE @SqlIndex INT = 0;
	--DECLARE @SqlCurrent INT = 0;


	-- �Ƚ�����ѡ���������ʱ��
	INSERT INTO @SqlTable
		(id, type, name, pos, value)
		SELECT nodeID, nodeType, nodeName, nodePos, nodeValue FROM
		(
			SELECT
				Nodes.value('(@id)[1]','int') AS nodeID,
				Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
				Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
				Nodes.value('(@pos)[1]', 'int') AS nodePos,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
				FROM @SqlResult.nodes('//result/*') AS N(Nodes)
		) AS NodesTable WHERE nodeID IS NOT NULL ORDER BY nodeID;

	SELECT * FROM @SqlTable;

	DECLARE @SqlEndPosition INT;
	
	SET @SqlPosition = 1;
	SET @SqlEndPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition);

	WHILE @SqlPosition > 0
	BEGIN
		-- ����ǰ�����ֵ
		INSERT INTO @SqlResultTable
			SELECT * FROM @SqlTable
			WHERE id >= @SqlPosition AND id < @SqlEndPosition;

		-- SELECT * FROM @SqlResultTable;

		IF @SqlEndPosition = LEN(@SqlCRule) BREAK;

		-- ������ʱ����
		DECLARE @SqlValue UString;
		SET @SqlValue = 
			(SELECT ISNULL(value,'') + '' FROM @SqlTable
				WHERE id >= @SqlEndPosition AND id < @SqlEndPosition + LEN(@SqlCReduceRule) FOR XML PATH(''));
		PRINT 'Value = ' + @SqlValue;

		DECLARE @SqlID INT = 0;
		SELECT @SqlID = MAX(id) FROM @SqlResultTable;
		INSERT INTO @SqlResultTable
			(id, type, name, seg, pos, value)
			VALUES
			(@SqlID + 1, 'var', '*', 1, 0, @SqlValue);

		-- ����λ��
		SET @SqlPosition = @SqlEndPosition + LEN(@SqlCReduceRule);
		SET @SqlEndPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition);
		IF @SqlEndPosition <= 0 SET @SqlEndPosition = LEN(@SqlCRule);
	END

	

	--DECLARE @SqlID INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlSegment INT;
	DECLARE @SqlType UString;
	DECLARE @SqlName UString;
	--DECLARE @SqlValue UString;

	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlPosition = 1;
	-- ������̬�α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, type, name, value FROM @SqlResultTable
	-- ���α�
	OPEN SqlCursor;
	-- ��ȡһ�м�¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;
	-- �����
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ���ü�����
		SET @SqlCount = @SqlCount + 1;
		-- �������
		IF @SqlType = 'pad'
		BEGIN
			UPDATE @SqlResultTable
				SET id = @SqlCount, pos = @SqlPosition WHERE id = @SqlID;
		END
		ELSE IF @SqlType = 'var'
		BEGIN
			-- ���ü�����
			SET @SqlIndex = @SqlIndex + 1;
			
			UPDATE @SqlResultTable
				SET id = @SqlCount, pos = @SqlPosition, name = dbo.GetLowercase(@SqlIndex) WHERE id = @SqlID;
		END
		IF @SqlValue IS NOT NULL
			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
			
		-- ��ȡһ�м�¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;

	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;
	
SELECT * FROM @SqlResultTable;

		SET @SqlValue = 
			(SELECT '<' + type + ' ' + 
				'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
				IsNull('name="' + name + '" ','') +
				'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' +
				value + '</' + type + '>'
				FROM @SqlResultTable
				FOR XML PATH(''));
		PRINT 'Value = ' + dbo.HTMLUnescape(@SqlValue);


--	-- ������в���������
--	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
--DOIT_AGAIN:
--	-- ���ó�ʼֵ
--	SET @SqlType = 0;
--	-- ѭ������
--	WHILE @SqlCurrent < @SqlPosition - 1
--	BEGIN
--		-- ���ü�����
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- ��õ�ǰ�ַ�
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- ��鵱ǰ�ַ�
--		IF @SqlChar <> '$'
--		BEGIN
--			-- �������
--			IF @SqlType <> 1
--			BEGIN
--				-- ��������
--				SET @SqlType = 1;
--				-- ���ó�ʼֵ
--				SET @SqlValue = '';
--			END
--			-- ����һ���ַ�
--			SET @SqlValue = @SqlValue + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- �������
--			IF @SqlType <> 2
--			BEGIN
--				-- ��������
--				SET @SqlType = 2;
--				-- �����
--				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--				BEGIN
--					-- ����ID
--					SET @SqlID = @SqlID + 1;
--					-- ����һ���ָ���
--					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--				END
--			END
--			-- ��������ֵ
--			SET @SqlIndex = @SqlIndex + 1;
--			-- ��ò�����
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- ��ò�������
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- �����
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			BEGIN
--				-- ����ID
--				SET @SqlID = @SqlID + 1;
--				-- ����һ������
--				INSERT INTO @SqlResultTable (id , type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
--			END
--		END
--	END
--	-- �������
--	IF @SqlType = 1
--	BEGIN
--		-- �����
--		-- ����һ���ָ���
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--		BEGIN
--			-- ����ID
--			SET @SqlID = @SqlID + 1;
--			-- ����һ���ָ���
--			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--		END
--	END

--	SELECT * FROM @SqlResultTable;

--	-- ������ʱ����
--	DECLARE @SqlSegment UString = '';
--	-- ���ó�ʼֵ
--	SET @SqlPosition =
--		@SqlPosition + LEN(@SqlCReduceRule);
--	-- ѭ������
--	WHILE @SqlCurrent < @SqlPosition - 1
--	BEGIN
--		-- ���ü�����
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- ��õ�ǰ�ַ�
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- ��鵱ǰ�ַ�
--		IF @SqlChar <> '$'
--		BEGIN
--			-- ����һ���ַ�
--			SET @SqlSegment = @SqlSegment + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- ��������ֵ
--			SET @SqlIndex = @SqlIndex + 1;
--			-- ��ò�����
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- ��ò�������
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- �����
--			-- ����һ������
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
--		END
--	END
--	-- �����
--	-- ����һ������
--	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
--	BEGIN
--		-- ����ID
--		SET @SqlID = @SqlID + 1;
--		-- ����һ������
--		INSERT INTO @SqlResultTable (id , type, seg, name, value) VALUES (@SqlID, 'var', 1, '*', @SqlSegment);
--	END

--	-- �����һ��λ��
--	IF CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition) > 0
--	BEGIN
--		-- ������λ��
--		SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule, @SqlPosition); GOTO DOIT_AGAIN;
--	END

--	SELECT * FROM @SqlResultTable;

--	-- ���ó�ʼֵ
--	SET @SqlType = 0;
--	SET @SqlValue = '';
--	-- ���ó�ʼֵ
--	SET @SqlPosition = LEN(@SqlCRule);
--	-- ѭ������
--	WHILE @SqlCurrent < @SqlPosition
--	BEGIN
--		-- ���ü�����
--		SET @SqlCurrent = @SqlCurrent + 1;
--		-- ��õ�ǰ�ַ�
--		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
--		-- ��鵱ǰ�ַ�
--		IF @SqlChar <> '$'
--		BEGIN
--			-- �������
--			IF @SqlType <> 1
--			BEGIN
--				-- ��������
--				SET @SqlType = 1;
--				-- ���ó�ʼֵ
--				SET @SqlValue = '';
--			END
--			-- ����һ���ַ�
--			SET @SqlValue = @SqlValue + @SqlChar;
--		END
--		ELSE
--		BEGIN
--			-- �������
--			IF @SqlType <> 2
--			BEGIN
--				-- ��������
--				SET @SqlType = 2;
--				-- �����
--				-- ����һ���ָ���
--				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--				BEGIN
--					-- ����ID
--					SET @SqlID = @SqlID + 1;
--					-- ����һ���ָ���
--					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--				END
--			END
--			-- ��������ֵ
--			SET @SqlIndex = @SqlIndex + 1;
--			-- ��ò�����
--			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
--			-- ��ò�������
--			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar;
--			-- �����
--			-- ����һ������
--			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			BEGIN
--				-- ����ID
--				SET @SqlID = @SqlID + 1;
--				-- ����һ������
--				INSERT INTO @SqlResultTable (id , type, name, value) VALUES (@SqlID, 'var', @SqlChar, @SqlValue);
--			END
--		END
--	END
--	-- �������
--	IF @SqlType = 1
--	BEGIN
--		-- �����
--		-- ����һ���ָ���
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--		BEGIN
--			-- ����ID
--			SET @SqlID = @SqlID + 1;
--			-- ����һ���ָ���
--			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
--		END
--	END

--	-- ������ʱ����
--	DECLARE @SqlEndPosition INT;
--	DECLARE @SqlName UString;
--	DECLARE @SqlTypeName UString;
	DECLARE @SqlReduced UString = '';

--	-- ���ó�ʼֵ
--	SET @SqlPosition = 1;
--	-- ������̬�α�
--	DECLARE SqlCursor CURSOR
--		STATIC FORWARD_ONLY LOCAL FOR 
--		SELECT id, type, name, value FROM @SqlResultTable
--		WHERE type = 'var' OR type = 'pad' ORDER BY id;
--	-- ���α�
--	OPEN SqlCursor;
--	-- ��ȡһ�м�¼
--	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
--	-- �����
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--		-- ����λ��
--		UPDATE @SqlResultTable
--			SET pos = @SqlPosition WHERE id = @SqlID;
--		-- �����
--		-- �޸�λ��
--		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
--			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
--		-- ��ý��
--		SET @SqlReduced = @SqlReduced + '<' + @SqlTypeName + ' ' + 
--				'id="' + CONVERT(NVARCHAR(MAX), @SqlID) + '" ' +
--				IsNull('name="' + @SqlName + '" ','') +
--				'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
--				@SqlValue + '</' + @SqlType + '>';
--		-- ��ȡһ�м�¼
--		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
--	END
--	-- �ر��α�
--	CLOSE SqlCursor;
--	-- �ͷ��α�
--	DEALLOCATE SqlCursor;

--	-- �򻯹���
--	SET @SqlCRule = REPLACE(@SqlCRule, @SqlCReduceRule, '$');
--	-- �ָ�������
--	SET @SqlRule = dbo.RecoverParameters(@SqlCRule);

--	-- ��ÿ�ʼλ��
--	SELECT @SqlPosition = pos FROM @SqlResultTable
--		WHERE id IN (SELECT MIN(id) FROM @SqlResultTable);
--	-- ���ý���λ��
--	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlResultTable
--		WHERE id IN (SELECT MAX(id) FROM @SqlResultTable);
--	-- �޸Ľ���λ��
--	-- �Կ��ܴ���ת�����ݵ��ַ����󳤶�
--	SET @SqlEndPosition = @SqlEndPosition + dbo.GetLength(@SqlValue);

	-- �������¼���뵽�׸��ڵ�֮�С�
	--SET @SqlReduced = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
	--			'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' +
	--			'<rule>' + @SqlRule + '</rule>' + @SqlReduced + '</result>';
	-- ���ؽ��
	PRINT @SqlReduced;
END
END_OF_FUNCTION:
GO
