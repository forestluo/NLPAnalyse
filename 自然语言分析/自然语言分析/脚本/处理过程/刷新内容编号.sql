USE [nldb]
GO

/****** Object: ˢ�����ݿ���� ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��1��26��>
-- Description:	<ˢ�����ݿ����>
-- =============================================

------------------------------------------------
--
-- ��λ����
--
------------------------------------------------

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
-- �������ݱ��
--
------------------------------------------------

-- ������
UPDATE dbo.InnerContent SET cid = - cid;
-- �ٸ���
UPDATE dbo.InnerContent SET cid = NEXT VALUE FOR ContentSequence;

DECLARE @SqlContent UString;
-- ������
UPDATE dbo.OuterContent SET cid = - cid;
-- �ٸ���
-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT DISTINCT(content) FROM dbo.OuterContent
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ���¼�¼
	UPDATE dbo.OuterContent
	SET cid = NEXT VALUE FOR ContentSequence
	WHERE content = @SqlContent;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor;
