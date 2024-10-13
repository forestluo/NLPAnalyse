USE [nldb]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Add the parameters for the function here
DECLARE @SqlResult XML;
DECLARE @SqlReduceRule UString;

SET @SqlResult = dbo.XMLReadContent('��:����˵��һ����, ����?');
SET @SqlReduceRule = '$a��$b��$c';

BEGIN
	-- ������ʱ����
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;

	DECLARE @SqlCRule UString;
	DECLARE @SqlCReduceRule UString;

	-- ������
	IF @SqlResult IS NULL GOTO END_OF_FUNCTION;
	-- ������
	IF @SqlReduceRule IS NULL OR
		LEN(@SqlReduceRule) <= 0 GOTO END_OF_FUNCTION;
	-- ��������ļ򻯹���
	SET @SqlCReduceRule = dbo.ClearParameters(@SqlReduceRule);
	PRINT 'ReduceRule = ' + @SqlReduceRule;
	
	-- ��û�������
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0 GOTO END_OF_FUNCTION;
	-- ���������ԭʼ����
	SET @SqlCRule = dbo.ClearParameters(@SqlRule);
	PRINT 'Rule = ' + @SqlRule;

	-- ���ƥ���ϵ
	SET @SqlPosition = CHARINDEX(@SqlCReduceRule, @SqlCRule);
	-- �����
	-- ����֮�䲻����ƥ���ϵ
	-- ��Ȼƥ���ϵҲ���ܴ��ڲ�ֹһ��λ��
	IF @SqlPosition <= 0 GOTO END_OF_FUNCTION;

	-- ������ʱ����
	DECLARE @SqlClassification UString;
	-- ��û������ķ���
	SET @SqlClassification =
		dbo.GetClassification(@SqlReduceRule);
	-- ������������ͷ����ʼ����
	IF @SqlClassification = '����' AND @SqlPosition <> 1 GOTO END_OF_FUNCTION;

	-- ������ʱ��
	DECLARE @SqlTable UParseTable;
	DECLARE @SqlResultTable UParseTable;

	-- �Ƚ�ȫ������ѡ���������ʱ��
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

	PRINT 'CRule = ' + @SqlCRule;
	PRINT 'CReduceRule = ' + @SqlCReduceRule;

	-- ������ʱ����
	DECLARE @SqlCount INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlValue UString;

	DECLARE @SqlType INT;
	DECLARE @SqlID INT = 0;
	DECLARE @SqlIndex INT = 0;
	DECLARE @SqlCurrent INT = 0;

	-- ������в���������
	SET @SqlCount = dbo.GetCount(@SqlCRule, '$');
DOIT_AGAIN:
	-- ���ó�ʼֵ
	SET @SqlType = 0;
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
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
				-- ����һ���ָ���
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				BEGIN
					SET @SqlID = @SqlID + 1;
					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
					--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
				END
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- ��ò�������
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			/*
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');*/
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				SET @SqlID = @SqlID + 1;
				INSERT INTO @SqlResultTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
				--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
			END
		END
	END
	-- �������
	IF @SqlType = 1
	BEGIN
		-- �����
		-- ����һ���ָ���
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			SET @SqlID = @SqlID + 1;
			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
			--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
		END
	END

	-- ������ʱ����
	DECLARE @SqlSegment UString = '';
	-- ���ó�ʼֵ
	SET @SqlPosition =
		@SqlPosition + LEN(@SqlCReduceRule);
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlCRule, @SqlCurrent, 1);
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
			-- ��ò�������
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			/*
			SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');
			*/
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
		END
	END
	-- �����
	-- ����һ������
	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
	BEGIN
		SET @SqlID = @SqlID + 1;
		INSERT INTO @SqlResultTable (id, type, name, seg, value) VALUES (@SqlID, 'var', '*', 1, @SqlSegment);
		--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0" seg="1">' + @SqlSegment + '</var>';
	END

	-- �����һ��λ��
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
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
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
				-- ����һ���ָ���
				IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
				BEGIN
					SET @SqlID = @SqlID + 1;
					INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
					--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
				END
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- ��ò�������
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			-- ��ò�������
			/*SET @SqlValue =
				@SqlResult.value('(//result/var[@name=sql:variable("@SqlChar")]/text())[1]', 'nvarchar(max)');*/
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				SET @SqlID = @SqlID + 1;
				INSERT INTO @SqlResultTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
				--SET @SqlReduced = @SqlReduced + '<var name="*" id="0" pos="0">' + @SqlValue + '</var>';
			END
		END
	END
	-- �������
	IF @SqlType = 1
	BEGIN
		-- �����
		-- ����һ���ָ���
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			SET @SqlID = @SqlID + 1;
			INSERT INTO @SqlResultTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
			--SET @SqlReduced = @SqlReduced + '<pad id="0" pos="0">' + @SqlValue + '</pad>';
		END
	END

	---- ������ʱ����
	DECLARE @SqlName UString;
	DECLARE @SqlTypeName UString;

	-- ���ó�ʼֵ
	SET @SqlIndex = 0;
	SET @SqlPosition = 1;
	-- ������̬�α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, type, name, value FROM @SqlResultTable
	-- ���α�
	OPEN SqlCursor;
	-- ��ȡһ�м�¼
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
	-- �����
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ���ü�����
		SET @SqlCount = @SqlCount + 1;
		-- �������
		IF @SqlTypeName = 'pad'
		BEGIN
			-- ���±�ź�λ��
			UPDATE @SqlResultTable
				SET pos = @SqlPosition WHERE id = @SqlID;
		END
		ELSE IF @SqlTypeName = 'var'
		BEGIN
			-- ���ü�����
			SET @SqlIndex = @SqlIndex + 1;
			-- �������ƣ���ź�λ��
			UPDATE @SqlResultTable
				SET pos = @SqlPosition,
					name = dbo.GetLowercase(@SqlIndex) WHERE id = @SqlID;
		END
		-- �������
		IF @SqlValue IS NOT NULL
			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- ��ȡһ�м�¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlTypeName, @SqlName, @SqlValue;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;

	SELECT * FROM @SqlResultTable;

	-- ������ʱ����
	DECLARE @SqlReduced UString;
	DECLARE @SqlEndPosition INT;
	-- �ϲ��������
	SET @SqlReduced = 
	(
		SELECT '<' + type + ' ' + 'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
		CASE seg WHEN 1 THEN 'seg="1" ' ELSE '' END +
		ISNULL('name="' + name + '" ','') +	'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' + value + '</' + type + '>'
		FROM @SqlResultTable FOR XML PATH('')
	);
	-- ת��
	SET @SqlReduced = dbo.XMLUnescape(@SqlReduced);
	-- ��ÿ�ʼλ��
	SELECT @SqlPosition = pos FROM @SqlResultTable
		WHERE id IN (SELECT MIN(id) FROM @SqlResultTable);
	-- ���ý���λ��
	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlResultTable
		WHERE id IN (SELECT MAX(id) FROM @SqlResultTable);
	-- �޸Ľ���λ��
	-- �Կ��ܴ���ת�����ݵ��ַ����󳤶�
	SET @SqlEndPosition = @SqlEndPosition + dbo.GetLength(@SqlValue);
	-- ���ӹ���
	SET @SqlReduced = '<rule>' +
		dbo.RecoverParameters(REPLACE(@SqlCRule, @SqlCReduceRule, '$')) + '</rule>' + @SqlReduced;
	-- �������¼���뵽�׸��ڵ�֮�С�
	SET @SqlReduced = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
				'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' + @SqlReduced + '</result>';
	-- ���ؽ��
	PRINT @SqlReduced;
END
END_OF_FUNCTION:
GO
