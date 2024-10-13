USE [nldb]
GO

DECLARE @SqlTID INT;
SELECT @SqlTID = MAX(TID) FROM dbo.TextPool;
SET @SqlTID = ROUND(@SqlTID * RAND(), 0);
SET @SqlTID = 4177243;

DECLARE @SqlText UString;
SELECT @SqlText = content FROM dbo.TextPool WHERE tid = @SqlTID;

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
	PRINT '�����ı��ؼ��ص������> �޷����ع��˹���'; GOTO END_OF_EXECUTION;
END

DECLARE @SqlRegulars XML;
-- ���������������
SET @SqlRegulars = dbo.LoadRegularRules();
-- �����
IF @SqlRegulars IS NULL
BEGIN
	-- ��ӡ��ʾ
	PRINT '�����ı��ؼ��ص������> �޷������������'; GOTO END_OF_EXECUTION;
END

IF @SqlDebug = 0
BEGIN

PRINT '�����ı��ؼ��ص������> ��������״̬��';

DECLARE @SqlID INT;
DECLARE @SqlXML XML;
DECLARE @SqlResult INT;
DECLARE @SqlLoopCount INT;
DECLARE @SqlExpressions XML;
DECLARE @SqlContent UString;

BEGIN TRY
	-- ��ԭʼ���ݽ���Ԥ����
	-- ��ִ��ת��
	SET @SqlText = dbo.XMLUnescape(@SqlText);
	-- �滻����ı��
	SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);
	-- ��ӡ��Ϣ
	PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> {' + @SqlText + '}';

	-- ���ó�ʼֵ
	SET @SqlLoopCount = 0;
	-- ѭ������
	WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
	BEGIN
		-- �޸ļ�����
		SET @SqlLoopCount = @SqlLoopCount + 1;
		-- ��ȡ����������ʽ
		SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);

		-- ������Ч�ַ�
		SET @SqlText = dbo.LeftTrim(@SqlText);
		-- �����
		IF @SqlText IS NULL OR LEN(@SqlText) <= 0
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = 0;/*�����ݿ��Լ�������*/
			-- ��ӡ��Ϣ
			PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> �����ݣ�'; BREAK;
		END

		-- ֱ���з־���
		SET @SqlXML = dbo.XMLCutSentence(@SqlText, @SqlExpressions);
		-- �����
		IF @SqlXML IS NULL
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -101;
			-- ��ӡ��Ϣ
			PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> �־�ʧ�ܣ�'; BREAK;
		END
		-- ��ý��
		SET @SqlResult = @SqlXML.value('(//result/@id)[1]', 'int');
		-- �����
		IF @SqlResult IS NULL
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -101;
			-- ��ӡ��Ϣ
			PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> �־�ʧ�ܣ�'; BREAK;
		END
		ELSE IF @SqlResult <= 0
		BEGIN
			-- ���������
			IF @SqlResult <> - 7
			BEGIN
				-- ��ӡ��Ϣ
				PRINT CONVERT(NVARCHAR(MAX), @SqlXML);
				-- PRINT @SqlText;
				-- ��ӡ��Ϣ
				PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) +
					')> ��������(' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')��'; BREAK;
			END
		END
		-- ��þ���
		SET @SqlContent = @SqlXML.value('(//result/sentence/text())[1]', 'nvarchar(max)');
		-- �����
		IF @SqlContent IS NULL	OR LEN(@SqlContent) <= 0
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -102;
			-- ��ӡ��Ϣ
			PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ����Ϊ�գ�'; BREAK;
		END
			
		-- ��鳤��
		IF dbo.IsTooLong(@SqlContent) = 1
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -103;
			-- ��ӡ��Ϣ
			PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ����̫����'; BREAK;
		END
		ELSE
		BEGIN
			-- ����ֱ�����
			-- ����ʶ
			SET @SqlID = dbo.ContentGetCID(@SqlContent);
			-- �����
			IF @SqlID <= 0 AND NOT EXISTS(SELECT * FROM dbo.ExternalContent WHERE content = @SqlContent)
			BEGIN
				PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ',' +
					(CASE WHEN @SqlResult > 0 THEN '����' ELSE '���' END) + ')> {' + @SqlContent + '}';
				-- ���������
				SET @SqlResult = 0;
			END
		END
		-- �����
		IF LEN(@SqlContent) < LEN(@SqlText)
		BEGIN
			-- ��ȡ����
			SET @SqlText = LTRIM(RIGHT(@SqlText, LEN(@SqlText) - LEN(@SqlContent)));
		END
		ELSE
		BEGIN
			-- ������Ϣ��������
			SET @SqlResult = 0; SET @SqlText = NULL;
			-- �����Ϣ
			/*PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ������ϣ�';*/ BREAK;
		END
	END

	-- �����
	IF @SqlText IS NOT NULL AND LEN(@SqlText) > 0
		-- ��ӡ���
		PRINT '���ı��ؼ��ص������(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ', left)> ' + @SqlText;

END TRY
BEGIN CATCH
	-- ������ʾ��ץȡ�쳣��¼
	SET @SqlContent = '���ı��ؼ��ص������(tid=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')'; EXEC dbo.CatchException @SqlContent;	
END CATCH

	-- ��ʱ����
	PRINT '���ı��ؼ��ص������> ' + CONVERT(NVARCHAR(MAX), @SqlLoopCount) + 
		'��ѭ������ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';

END
ELSE
BEGIN

PRINT '�����ı��ؼ��ص������> ����Debug״̬��';

END

END_OF_EXECUTION:
/*���SQL�ű�����*/
PRINT '�����ı��ؼ��ص������> [���ִ�л���ʱ��(����)] ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
