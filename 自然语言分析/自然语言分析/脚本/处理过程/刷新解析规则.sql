USE [nldb]
GO

/****** Object: ˢ�½������� ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��1��26��>
-- Description:	<ˢ�½�������>
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
-- EXEC sp_rename 'FilterRule', @SqlBackup;
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
-- EXEC sp_rename 'ParseRule', @SqlBackup;
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
-- EXEC sp_rename 'PhraseRule', @SqlBackup;
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
PRINT 'ˢ�½������� > ���˹���';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- �����������
SET @SqlRules = dbo.LoadRegularRules();
PRINT 'ˢ�½������� > �������';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- ���ص������
SET @SqlRules = dbo.LoadSentenceRules();
PRINT 'ˢ�½������� > �������';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- �������Թ���
SET @SqlRules = dbo.LoadAttributeRules();
PRINT 'ˢ�½������� > ���Թ���';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

