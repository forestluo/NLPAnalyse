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
-- Create date: <20201207>
-- Description:	<���������зֳ�һ������>
-- =============================================

CREATE OR ALTER FUNCTION XMLCutSentence
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlExpressions XML
)
RETURNS XML
AS
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
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
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
		RETURN CONVERT(XML,	'<result id="-2">input is null after trimed</result>');
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
		RETURN CONVERT(XML, '<result id="-2">fail to read content</result>');
	END
	-- ��ù���
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- �����
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- ���ؽ��
		RETURN CONVERT(XML,	'<result id="-3">fail to get rule</result>');
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
			-- ���ؽ��
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
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
			-- ���ؽ��
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
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
			RETURN CONVERT(XML,	'<result id="-7">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
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
			RETURN CONVERT(XML,	'<result id="-8">reduced result is null' + dbo.FormatReduceRules(@SqlTable) + '</result>');
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
				RETURN CONVERT(XML, '<result id="1">sentence is null' +
					dbo.FormatReduceRules(@SqlTable) + '</result>');
			END
			-- ���ؽ��
			RETURN CONVERT(XML, '<result id="1">' +
				'<sentence>' + dbo.XMLEscape(@SqlSentence) + '</sentence>' + dbo.FormatReduceRules(@SqlTable) + '</result>');
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
			RETURN CONVERT(XML, '<result id="-9">fail to reduce' + dbo.FormatReduceRules(@SqlTable) + '</result>');
		END
	END
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="-10">something cannot be reduced' + dbo.FormatReduceRules(@SqlTable) + '</result>');
END
GO
