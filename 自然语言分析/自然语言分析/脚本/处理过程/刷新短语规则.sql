USE [nldb]
GO

/****** Object: ˢ�¶������ ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��1��30��>
-- Description:	<ˢ�¶������>
-- =============================================

------------------------------------------------
--
-- ����PhraseRule
--
------------------------------------------------

PRINT 'ɾ���������';
DELETE FROM PhraseRule WHERE classification IN ('����', '������', '����');

------------------------------------------------
--
-- ���ô���
--
------------------------------------------------

-- ����PhraseRule
EXEC dbo.[����PhraseRule];

-- ������ʱ����
DECLARE @SqlRules XML;

-- ���ض������
SET @SqlRules = dbo.LoadPhraseRules();
-- PRINT 'ˢ�½������� > �������';
-- PRINT CONVERT(NVARCHAR(MAX), @SqlRules);
