USE [nldb]
GO

/****** Object: ȫ����ʼ�����ݿ� ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��18��>
-- Description:	<��ȫ���³�ʼ�����ݿ�>
-- =============================================

DECLARE @SqlBackup UString;

------------------------------------------------
--
-- ��λ����
--
------------------------------------------------

-- ���ö����Ƿ����
IF OBJECT_ID('RuleSequence') IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵ�RuleSequence��';
	-- ɾ��֮ǰ���ڵ�����
	DROP SEQUENCE dbo.RuleSequence;
END
PRINT '�����µ�RuleSequence��';
-- ��������
CREATE SEQUENCE dbo.RuleSequence AS INT START WITH 1 INCREMENT BY 1;

-- ���ö����Ƿ����
IF OBJECT_ID('ContentSequence') IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵ�ContentSequence��';
	-- ɾ��֮ǰ���ڵ�����
	DROP SEQUENCE dbo.ContentSequence;
END
PRINT '�����µ�ContentSequence��';
-- ��������
CREATE SEQUENCE dbo.ContentSequence AS INT START WITH 1 INCREMENT BY 1;

------------------------------------------------
--
-- ���ݺʹ���InnerContent
--
------------------------------------------------
PRINT '����InnerContent���ݣ�';
-- ����InnerContent����
-- ���ñ��ݱ�����
SET @SqlBackup = 'InnerContent' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'InnerContent', @SqlBackup;
-- �����µ�InnerContent���ݱ�
EXEC dbo.[������InnerContent];

------------------------------------------------
--
-- ���ݺʹ���OuterContent
--
------------------------------------------------
PRINT '����OuterContent���ݣ�';
-- ����OuterContent����
-- ���ñ��ݱ�����
SET @SqlBackup = 'OuterContent' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'OuterContent', @SqlBackup;
-- �����µ�OuterContent���ݱ�
EXEC dbo.[������OuterContent];

------------------------------------------------
--
-- ���ݺʹ���ExternalContent
--
------------------------------------------------
PRINT '����ExternalContent���ݣ�';
-- ����ExternalContent����
-- ���ñ��ݱ�����
SET @SqlBackup = 'ExternalContent' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'ExternalContent', @SqlBackup;
-- �����µ�ExternalContent���ݱ�
EXEC dbo.[������ExternalContent];

------------------------------------------------
--
-- ���ݺʹ���FilterRule
--
------------------------------------------------
PRINT '����FilterRule���ݣ�';
-- ����FilterRule����
-- ���ñ��ݱ�����
SET @SqlBackup = 'FilterRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'FilterRule', @SqlBackup;
-- �����µ�FilterRule���ݱ�
EXEC dbo.[������FilterRule];

------------------------------------------------
--
-- ���ݺʹ���ParseRule
--
------------------------------------------------
PRINT '����ParseRule���ݣ�';
-- ����ParseRule����
-- ���ñ��ݱ�����
SET @SqlBackup = 'ParseRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'ParseRule', @SqlBackup;
-- �����µ�ParseRule���ݱ�
EXEC dbo.[������ParseRule];

------------------------------------------------
--
-- ���ݺʹ���PhraseRule
--
------------------------------------------------
PRINT '����PhraseRule���ݣ�';
-- ����ParseRule����
-- ���ñ��ݱ�����
SET @SqlBackup = 'PhraseRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '���ݱ����ƣ�' + @SqlBackup + ')��';

-- ���ö����Ƿ����
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT 'ɾ��֮ǰ���ڵı�' + @SqlBackup + '����';
	-- ɾ��֮ǰ���ڵı�
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- �Ա���������������
PRINT '���������������ݱ���Ϊ���ݱ�';

-- �����������ݱ�
EXEC sp_rename 'PhraseRule', @SqlBackup;
-- �����µ�PhraseRule���ݱ�
EXEC dbo.[������PhraseRule];

------------------------------------------------
--
-- ���ô���
--
------------------------------------------------

-- ����ParseRule
EXEC dbo.[����ParseRule];
-- ����PhraseRule
EXEC dbo.[����PhraseRule];
-- ����FilterRule
EXEC dbo.[����FilterRule];

-- ������ʱ����
DECLARE @SqlRules XML;
-- ���ع��˹���
SET @SqlRules = dbo.LoadFilterRules();
-- �����������
SET @SqlRules = dbo.LoadRegularRules();
-- ���ص������
SET @SqlRules = dbo.LoadSentenceRules();

-- ����InnerContent
-- ���ñ��ݱ�����
SET @SqlBackup = 'InnerContent' + CONVERT(varchar(8),GETDATE(),112);
-- ��������
PRINT '��ʼ�ӱ��ݱ��п����ؼ����ݣ�';
EXEC ('INSERT INTO dbo.InnerContent (cid, [classification], [type], content, [length], count, attribute) ' + 
	'SELECT (NEXT VALUE FOR ContentSequence), [classification], [type], content, LEN(content), count, attribute FROM dbo.' + @SqlBackup);
PRINT '�ӱ��ݱ��п����ؼ����ݽ�����';

-- ����OuterContent
-- ���ñ��ݱ�����
SET @SqlBackup = 'OuterContent' + CONVERT(varchar(8),GETDATE(),112);
-- ��������
PRINT '��ʼ�ӱ��ݱ��п����ؼ����ݣ�';
EXEC ('INSERT INTO dbo.OuterContent (cid, [classification], [type], content, [length], count) ' + 
	'SELECT (NEXT VALUE FOR ContentSequence), [classification], [type], content, LEN(content), count FROM dbo.' + @SqlBackup);
PRINT '�ӱ��ݱ��п����ؼ����ݽ�����';

-- ����ExternalContent
-- ���ñ��ݱ�����
SET @SqlBackup = 'ExternalContent' + CONVERT(varchar(8),GETDATE(),112);
-- ��������
PRINT '��ʼ�ӱ��ݱ��п����ؼ����ݣ�';
EXEC ('INSERT INTO dbo.ExternalContent ([classification], [type], content, [length], count) ' + 
	'SELECT [classification], [type], content, LEN(content), count FROM dbo.' + @SqlBackup);
PRINT '�ӱ��ݱ��п����ؼ����ݽ�����';

------------------------------------------------
--
-- ���ô���
--
------------------------------------------------

PRINT '���ֵ�����Ϊ��ʼ״̬'
UPDATE dbo.Dictionary SET count = 0;

PRINT '���ı�������Ϊ��ʼ״̬';
UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;

PRINT '�����쳣��־��'
TRUNCATE TABLE dbo.ExceptionLog;