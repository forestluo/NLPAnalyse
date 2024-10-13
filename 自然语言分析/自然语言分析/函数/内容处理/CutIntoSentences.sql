USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��2��5��>
-- Description:	<���ı��зֳɾ���>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[CutIntoSentences]
(
	-- Add the parameters for the function here
	@SqlText UString
)
RETURNS XML
AS
BEGIN

	-- ������ʱ����
	DECLARE @SqlXML XML;
	DECLARE @SqlResult INT;
	DECLARE @SqlExpressions XML;
	DECLARE @SqlContent UString;

	DECLARE @SqlID INT = 0;
	DECLARE @SqlEID INT = 0;
	DECLARE @SqlFilters XML;
	DECLARE @SqlRegulars XML;
	DECLARE @SqlValue UString;

	-- ������
	IF @SqlText IS NULL
		OR LEN(@SqlText) <= 0
		RETURN CONVERT(XML, '<result id="-1">text is null</result>');

	-- �������й��˹���
	SET @SqlFilters = dbo.LoadFilterRules();
	-- �����
	IF @SqlFilters IS NULL
		RETURN CONVERT(XML, '<result id="-2">filters is null</result>');

	-- ���������������
	SET @SqlRegulars = dbo.LoadRegularRules();
	-- �����
	IF @SqlRegulars IS NULL
		RETURN CONVERT(XML, 'result id="-3">fail to load rules</result>');

	-- ���ó�ʼֵ
	SET @SqlValue = '';
	-- ��ԭʼ���ݽ���Ԥ����
	-- ��ִ��ת��
	SET @SqlText = dbo.XMLUnescape(@SqlText);
	-- �滻����ı��
	SET @SqlText = dbo.FilterContent(@SqlFilters, @SqlText);

	-- ѭ������
	WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
	BEGIN
		-- ��ȡ����������ʽ
		SET @SqlExpressions = dbo.ExtractExpressions(@SqlRegulars, @SqlText);

		-- ������Ч�ַ�
		SET @SqlText = dbo.LeftTrim(@SqlText);
		-- �����
		IF @SqlText IS NULL OR LEN(@SqlText) <= 0
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = 0;/*�����ݿ��Լ�������*/ BREAK;
		END

		-- ֱ���з־���
		SET @SqlXML = dbo.XMLCutSentence(@SqlText, @SqlExpressions);
		-- �����
		IF @SqlXML IS NULL
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -101; BREAK;
		END
		-- ��ý��
		SET @SqlResult = @SqlXML.value('(//result/@id)[1]', 'int');
		-- �����
		IF @SqlResult IS NULL
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -101; BREAK;
		END
		ELSE IF @SqlResult <= 0 BREAK;
		-- ��þ���
		SET @SqlContent = @SqlXML.value('(//result/sentence/text())[1]', 'nvarchar(max)');
		-- �����
		IF @SqlContent IS NULL	OR LEN(@SqlContent) <= 0
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -102; BREAK;
		END
			
		-- ��鳤��
		IF dbo.IsTooLong(@SqlContent) = 1
		BEGIN
			-- ���ô�����Ϣ
			SET @SqlResult = -103; BREAK;
		END
		ELSE
		BEGIN
			-- ���ü�����
			SET @SqlID = @SqlID + 1;

			-- ���ó�ʼֵ
			SET @SqlEID = 0;
			-- ѡ����
			SELECT TOP 1 @SqlEID = eid FROM dbo.ExternalContent WHERE content = @SqlContent;

			-- ����XML����
			SET @SqlValue = @SqlValue +
			'<sentence id="' + CONVERT(NVARCHAR(MAX), @SqlID) + '" ' +
			'eid="' + CONVERT(NVARCHAR(MAX), @SqlEID) + '" len="' +
			CONVERT(NVARCHAR(MAX), LEN(@SqlContent)) + '">' + dbo.XMLEscape(@SqlContent) + '</sentence>';
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
			SET @SqlResult = 0; SET @SqlText = NULL; BREAK;
		END
	END

	-- �����
	RETURN CONVERT(XML, '<result id="' + CONVERT(NVARCHAR(MAX), @SqlResult) + '">' + @SqlValue + '</result>');
END
