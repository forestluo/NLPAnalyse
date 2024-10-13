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

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��7��>
-- Description:	<��ü򻯺�Ľ����>
-- =============================================

CREATE OR ALTER FUNCTION GetReducedResult
(
	-- Add the parameters for the function here
	@SqlInputRule XML,
	@SqlReduceRule UString
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;

	DECLARE @SqlARule UString;
	DECLARE @SqlAReduceRule UString;

	-- ������
	IF @SqlInputRule IS NULL
		RETURN CONVERT(XML, '<result id="-1"/>');
	-- ������
	IF @SqlReduceRule IS NULL
		OR LEN(@SqlReduceRule) <= 0
		RETURN CONVERT(XML, '<result id="-2"/>');
	-- ��������ļ򻯹���
	SET @SqlAReduceRule = dbo.ClearParameters(@SqlReduceRule);
	
	-- ��û�������
	SET @SqlRule = @SqlInputRule.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN CONVERT(XML, '<result id="-3"/>');
	-- ���������ԭʼ����
	SET @SqlARule = dbo.ClearParameters(@SqlRule);

	-- ���ƥ���ϵ
	SET @SqlPosition = CHARINDEX(@SqlAReduceRule, @SqlARule);
	-- �����
	-- ����֮�䲻����ƥ���ϵ
	-- ��Ȼƥ���ϵҲ���ܴ��ڲ�ֹһ��λ��
	IF @SqlPosition <= 0 RETURN CONVERT(XML, '<result id="-4"/>');

	-- ������ʱ����
	DECLARE @SqlClassification UString;
	-- ��û������ķ���
	SET @SqlClassification =
		dbo.ParseRuleGetClassification(@SqlReduceRule);
	-- ������������ͷ����ʼ����
	IF @SqlClassification = '����'
		AND @SqlPosition <> 1 RETURN CONVERT(XML, '<result id="-5"/>');

	-- ������ʱ��
	DECLARE @SqlTable UParseTable;
	DECLARE @SqlInputRuleTable UParseTable;

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
				FROM @SqlInputRule.nodes('//result/*') AS N(Nodes)
		) AS NodesTable WHERE nodeID IS NOT NULL ORDER BY nodeID;
	
	-- ������ʱ����
	DECLARE @SqlCount INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlValue UString;

	DECLARE @SqlType INT;
	DECLARE @SqlID INT = 0;
	DECLARE @SqlIndex INT = 0;
	DECLARE @SqlCurrent INT = 0;

	-- ������в���������
	SET @SqlCount = dbo.GetVarCount(@SqlARule);
DOIT_AGAIN:
	-- ���ó�ʼֵ
	SET @SqlType = 0;
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlARule, @SqlCurrent, 1);
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
					-- ���ñ�ʶ
					SET @SqlID = @SqlID + 1;
					-- ����һ������
					INSERT INTO @SqlInputRuleTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
				END
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- ��ò�������
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				-- ���ñ�ʶ
				SET @SqlID = @SqlID + 1;
				-- ����һ������
				INSERT INTO @SqlInputRuleTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
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
			-- ���ñ�ʶ
			SET @SqlID = @SqlID + 1;
			-- ����һ������
			INSERT INTO @SqlInputRuleTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
		END
	END

	-- ������ʱ����
	DECLARE @SqlSegment UString = '';
	-- ���ó�ʼֵ
	SET @SqlPosition =
		@SqlPosition + LEN(@SqlAReduceRule);
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition - 1
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlARule, @SqlCurrent, 1);
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
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0 SET @SqlSegment = @SqlSegment + @SqlValue;
		END
	END
	-- �����
	-- ����һ������
	IF @SqlSegment IS NOT NULL AND LEN(@SqlSegment) > 0
	BEGIN
		-- ���ñ�ʶ
		SET @SqlID = @SqlID + 1;
		-- ����һ������
		INSERT INTO @SqlInputRuleTable (id, type, name, seg, value) VALUES (@SqlID, 'var', '*', 1, @SqlSegment);
	END

	-- �����һ��λ��
	IF CHARINDEX(@SqlAReduceRule, @SqlARule, @SqlPosition) > 0
	BEGIN
		-- ������λ��
		SET @SqlPosition = CHARINDEX(@SqlAReduceRule, @SqlARule, @SqlPosition); GOTO DOIT_AGAIN;
	END

	-- ���ó�ʼֵ
	SET @SqlType = 0;
	SET @SqlValue = '';
	-- ���ó�ʼֵ
	SET @SqlPosition = LEN(@SqlARule);
	-- ѭ������
	WHILE @SqlCurrent < @SqlPosition
	BEGIN
		-- ���ü�����
		SET @SqlCurrent = @SqlCurrent + 1;
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlARule, @SqlCurrent, 1);
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
					-- ���ñ�ʶ
					SET @SqlID = @SqlID + 1;
					-- ����һ������
					INSERT INTO @SqlInputRuleTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
				END
			END
			-- ��������ֵ
			SET @SqlIndex = @SqlIndex + 1;
			-- ��ò�����
			SET @SqlChar = dbo.GetLowercase(@SqlIndex);
			-- ��ò�������
			SELECT @SqlValue = value FROM @SqlTable WHERE name = @SqlChar AND type = 'var';
			-- �����
			-- ����һ������
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				-- ���ñ�ʶ
				SET @SqlID = @SqlID + 1;
				-- ����һ������
				INSERT INTO @SqlInputRuleTable (id, type, name, value) VALUES (@SqlID, 'var', '*', @SqlValue);
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
			-- ���ñ�ʶ
			SET @SqlID = @SqlID + 1;
			-- ����һ������
			INSERT INTO @SqlInputRuleTable (id, type, value) VALUES (@SqlID, 'pad', @SqlValue);
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
		SELECT id, type, name, value FROM @SqlInputRuleTable
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
			UPDATE @SqlInputRuleTable
				SET pos = @SqlPosition WHERE id = @SqlID;
		END
		ELSE IF @SqlTypeName = 'var'
		BEGIN
			-- ���ü�����
			SET @SqlIndex = @SqlIndex + 1;
			-- �������ƣ���ź�λ��
			UPDATE @SqlInputRuleTable
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

	-- ������ʱ����
	DECLARE @SqlReduced UString;
	DECLARE @SqlEndPosition INT;
	-- �ϲ��������
	SET @SqlReduced = 
	(
		(
			SELECT '<' + type + ' ' + 'id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
			CASE seg WHEN 1 THEN 'seg="1" ' ELSE '' END +
			ISNULL('name="' + name + '" ','') +	'pos="' + CONVERT(NVARCHAR(MAX), pos) + '">' + dbo.XMLEscape(value) + '</' + type + '>'
			FROM @SqlInputRuleTable FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ��ÿ�ʼλ��
	SELECT @SqlPosition = pos FROM @SqlInputRuleTable
		WHERE id IN (SELECT MIN(id) FROM @SqlInputRuleTable);
	-- ���ý���λ��
	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlInputRuleTable
		WHERE id IN (SELECT MAX(id) FROM @SqlInputRuleTable);
	-- �޸Ľ���λ��
	SET @SqlEndPosition = @SqlEndPosition + LEN(@SqlValue);
	-- ���ӹ���
	SET @SqlReduced = '<rule>' +
		dbo.RecoverParameters(REPLACE(@SqlARule, @SqlAReduceRule, '$')) + '</rule>' + @SqlReduced;
	-- �������¼���뵽�׸��ڵ�֮�С�
	SET @SqlReduced = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
				'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' + @SqlReduced + '</result>';
	-- ���ؽ��
	RETURN CONVERT(NVARCHAR(MAX), @SqlReduced);
END
GO
