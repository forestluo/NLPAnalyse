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
-- Description:	<��ȫ���³�ʼ�������>
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
-- ���ݺʹ���LogicRule
--
------------------------------------------------
PRINT '����LogicRule���ݣ�';
-- ����ParseRule����
-- ���ñ��ݱ�����
SET @SqlBackup = 'LogicRule' + CONVERT(varchar(8),GETDATE(),112);
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
EXEC sp_rename 'LogicRule', @SqlBackup;
-- �����µ�LogicRule���ݱ�
EXEC dbo.[������LogicRule];

------------------------------------------------
--
-- ���ô���
--
------------------------------------------------
PRINT '���³�ʼ��RulePool';
EXEC dbo.[������RulePool];
EXEC dbo.[��ʼ��RulePool];
-- ����RulePool
PRINT '����RulePool';
EXEC dbo.[����RulePool];

-- PRINT '���½����ִ����֮��Ĺ�ϵ';
-- EXEC dbo.[�ؽ�WordRules];
