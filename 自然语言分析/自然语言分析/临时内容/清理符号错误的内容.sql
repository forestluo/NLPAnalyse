USE [nldb2]
GO
/****** Object: ������Ŵ�������� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��18��>
-- Description:	<������Ŵ��������>
-- =============================================

-- ����ͷΪ��"�������Ǻ���û�ж�Ӧ�ķ���
UPDATE OuterContent SET content = RIGHT(content, LEN(content) - 1)
WHERE content like '"%' AND CHARINDEX('"', content, 2) <= 0 AND length > 1;

-- �����βΪ��"��������ǰ��û�ж�Ӧ�ķ���
/*
SELECT content, REPLACE(REPLACE(LEFT(content, LEN(content) - 1), '.', '��'), ',', '��')
FROM dbo.OuterContent
WHERE content like '%"' AND CHARINDEX('"', LEFT(content, LEN(content) - 1)) <= 0 AND length > 1
AND dbo.RegExIsMatch(content, 's+[,.0-9a-zA-Z]*s+', 1) = 0;
*/
UPDATE OuterContent
SET content = REPLACE(REPLACE(LEFT(content, LEN(content) - 1), '.', '��'), ',', '��')
WHERE content like '%"' AND CHARINDEX('"', LEFT(content, LEN(content) - 1)) <= 0 AND length > 1
AND dbo.RegExIsMatch(content, 's+[,.0-9a-zA-Z]*s+', 1) = 0;

-- ����ͷΪ��"������βΪ��."�����޸�Ϊ��׼�ı�����
/*
SELECT content, '��' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 3), '.', '��'), ',', '��') + '����'
FROM dbo.OuterContent
WHERE content like '"%."' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 3)) <= 0 AND length > 3;
*/
UPDATE dbo.OuterContent
SET content =  '��' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 3), '.', '��'), ',', '��') + '����'
WHERE content like '"%."' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 3)) <= 0 AND length > 3;

-- ����ͷΪ��"������βΪ��"�����޸�Ϊ��׼�ı�����
/*
SELECT content, '��' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 2), '.', '��'), ',', '��') + '����'
FROM dbo.OuterContent
WHERE content like '"%"' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 2)) <= 0 AND length > 2;
*/
UPDATE dbo.OuterContent
SET content = '��' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 2), '.', '��'), ',', '��') + '����'
WHERE content like '"%"' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 2)) <= 0 AND length > 2;

-- �������ģ�"���ġ�ģʽ�Ĵ���
/*
SELECT content, content = REPLACE(REPLACE(REPLACE(content, '.', '��'), ',', '��'), '"', '��') + '��'
FROM dbo.OuterContent
WHERE content like '%��"%' AND dbo.GetCharCount(content, '"') = 1
*/
UPDATE dbo.OuterContent
SET content = REPLACE(REPLACE(REPLACE(content, '.', '��'), ',', '��'), '"', '��') + '��'
WHERE content like '%��"%' AND dbo.GetCharCount(content, '"') = 1

-- ����""��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 1) FROM OuterContent WHERE content like '""%';
-- ����",��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '",%';
-- ����" ��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '" %';
-- ����"(��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 1) FROM OuterContent WHERE content like '"(%';
-- ����" "��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '" "%';
-- ����"��"��ģʽ�Ĵ���
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '"��"%';

-- ����������"��ģʽ�Ĵ���
/*
SELECT content, dbo.AmendSentence(content) FROM dbo.OuterContent WHERE content like '%"%' AND LENGTH > 2
*/
UPDATE dbo.OuterContent
SET content = dbo.AmendContent(content) WHERE content like '%"%' AND LENGTH > 2
