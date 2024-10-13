USE [nldb]
GO

DECLARE @SqlTID INT;
SELECT @SqlTID = MAX(TID) FROM dbo.TextPool;
SET @SqlTID = ROUND(@SqlTID * RAND(), 0);
-- SET @SqlTID = 2746456;

DECLARE @SqlText UString;
SELECT @SqlText = content FROM dbo.TextPool WHERE tid = @SqlTID;

SET @SqlText = '��̸�����ʱ����̹ȻһЦ������ʵ��跶Χ�ܹ㣬����������ͨ�׸����۶��ܳ���ҡ�����ң���Ҳ���ڻ��¡���';

--PRINT 'Text Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlText));
--PRINT 'Text Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlText));

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
	PRINT '���ReadContent> �޷����ع��˹���'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlRegulars XML;
-- ���������������
SET @SqlRegulars = dbo.LoadRegularRules();
-- �����
IF @SqlRegulars IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '���ReadContent> �޷������������'; GOTO END_OF_EXECUTION;
END

-- ��ԭʼ���ݽ���Ԥ����
-- ��ִ��ת��
SET @SqlText = dbo.XMLUnescape(@SqlText);
-- �滻����ı��
SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);
-- ��ӡ��Ϣ
PRINT '���ReadContent(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> {' + @SqlText + '}';

DECLARE @SqlExpressions XML;
-- ��ȡ����������ʽ
SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);
-- �鿴���ʽ
-- SELECT @SqlExpressions;

-- ������Ч�ַ�
SET @SqlText = dbo.LeftTrim(@SqlText);
-- �����
IF @SqlText IS NULL OR LEN(@SqlText) <= 0
BEGIN
	-- ��ӡ��Ϣ
	PRINT '���ReadContent(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> �����ݣ�'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '���ReadContent> ��������״̬��';

--PRINT 'Text Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlText));
--PRINT 'Text Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlText));
DECLARE @SqlContent UString = TRIM(@SqlText);
--PRINT 'Content Length = ' + CONVERT(NVARCHAR(MAX), LEN(@SqlContent));
--PRINT 'Content Data Length = ' + CONVERT(NVARCHAR(MAX), DATALENGTH(@SqlContent));

BEGIN
	-- ������ʱ����
	DECLARE @SqlXML XML;
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlVarType INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlName UString;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlExpression UString;

	-- ������
	IF @SqlContent IS NULL OR LEN(@SqlContent) <= 0
	BEGIN
		-- ���ؽ��
		PRINT '<result id="-1">content is null</result>'; GOTO END_OF_EXECUTION;
	END

	-- ���ó�ʼֵ
	SET @SqlRule = '';
	SET @SqlResult = '';
	-- ���ó�ʼֵ
	SET @SqlIndex = 0;
	SET @SqlCount = 0;
	SET @SqlVarType = 0;

	-- ���ó�ʼֵ
	SET @SqlPosition= 0;
	-- ѭ������
	WHILE @SqlIndex <= 26 AND @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- ��������һ
		SET @SqlPosition = @SqlPosition + 1;
		-- ��鵱ǰ���ʽ
		IF @SqlExpressions IS NOT NULL
		BEGIN
			-- ��õ�ǰ�������ʽ
			SET @SqlExpression =
				dbo.IsInsideExpression(@SqlExpressions, @SqlPosition);
			-- ������ô���ĳ�����ʽ��ͷ��λ��
			IF @SqlExpression IS NOT NULL
			BEGIN
				-- �����λ
				-- ���ڴ���VAR
				IF @SqlVarType = 2
				-- ��������VAR��������һ��������
				BEGIN
					-- ��������
					SET @SqlValue = @SqlValue + @SqlExpression;
				END
				ELSE
				BEGIN
					-- �����
					IF @SqlVarType = 1
					BEGIN
						-- �޸��ı���ֵ
						SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</pad>';
					END
					-- ���ñ��λ
					SET @SqlVarType = 2;

					-- ���ó�ʼֵ
					SET @SqlValue = @SqlExpression;
					-- ���ñ�ǩ����
					SET @SqlCount = @SqlCount + 1;
					SET @SqlIndex = @SqlIndex + 1;
					-- ��ò�����
					SET @SqlName = dbo.GetLowercase(@SqlIndex);
					-- ����һ������
					SET @SqlRule = @SqlRule + '$' + @SqlName;
					-- ���ӽڵ�
					SET @SqlResult = @SqlResult + '<var name="' + @SqlName + '" ' +
						'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
						'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
				END
				-- �������ʽ������
				SET @SqlPosition = @SqlPosition + LEN(@SqlExpression) - 1; CONTINUE;
			END
		END
		-- ��õ�ǰ�ַ�
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- �����
		IF dbo.IsPunctuation(@SqlChar) = 1
		-- ������
		BEGIN
			-- �������ֵ
			IF @SqlIndex >= 26 BREAK;
			-- �����λ
			IF @SqlVarType <> 1
			BEGIN
				-- �����λ
				IF @SqlVarType = 2
				BEGIN
					IF LEN(@SqlValue) <= 0
					BEGIN
						-- ���ñ�ǩֵ
						SET @SqlIndex = @SqlIndex - 1;
						SET @SqlCount = @SqlCount - 1;
						SET @SqlRule = REPLACE(@SqlRule, '$' + @SqlName, '');
					END
					-- �޸��ı���ֵ
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</var>';
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
					SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) + '</pad>';
				END
				-- ���ñ��λ
				SET @SqlVarType = 2;

				-- ���ó�ʼֵ
				SET @SqlValue = '';
				-- ���ñ�ǩ����
				SET @SqlCount = @SqlCount + 1;
				SET @SqlIndex = @SqlIndex + 1;
				-- ��ò�����
				SET @SqlName = dbo.GetLowercase(@SqlIndex);
				-- ����һ������
				SET @SqlRule = @SqlRule + '$' + @SqlName;
				-- ���ӽڵ�
				SET @SqlResult = @SqlResult + '<var name="' + @SqlName + '" ' +
					'id="' + CONVERT(NVARCHAR(MAX), @SqlCount) + '" ' + 
					'pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '">';
			END
			-- ����һ���ַ�
			SET @SqlValue = @SqlValue + @SqlChar;
		END
	END
	-- ��βλ��
	SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
	-- �޸��ı���ֵ
	SET @SqlResult = @SqlResult + dbo.XMLEscape(@SqlValue) +
		CASE @SqlVarType WHEN 1 THEN '</pad>' WHEN 2 THEN '</var>' ELSE '' END;
	-- PRINT @SqlResult;
	-- ���÷���ֵ
	SET @SqlResult = '<result id="1" start="1" end="'+
		CONVERT(NVARCHAR(MAX), @SqlPosition) + '">' +
		'<rule>' + @SqlRule + '</rule>' + @SqlResult + '</result>';
	-- PRINT @SqlResult;
	-- ת����XML
	SET @SqlXML = CONVERT(XML, @SqlResult);
	-- ɾ������Ϊ�յ�var�ڵ�
	SET @SqlXML.modify('delete //result/var[empty(text())]');
	-- ���ؽ��
	PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
END

END
ELSE
BEGIN

PRINT '���ReadContent> ����Debug״̬��';

END

END_OF_EXECUTION:
/*���SQL�ű�����*/
PRINT '���ReadContent> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
