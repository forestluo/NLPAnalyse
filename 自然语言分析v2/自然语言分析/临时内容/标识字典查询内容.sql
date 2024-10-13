USE [nldb2]
GO
/****** Object: ��ʶ�ֵ��ѯ���� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��18��>
-- Description:	<��ʶ�ֵ��ѯ����>
-- =============================================

-- ��ʶ����
UPDATE dbo.InnerContent
SET classification = '����', type = -1
WHERE /*classification <> '����' AND */  cid IN
(
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('����', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
	UNION
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('����', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
	UNION
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('����', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
);

-- ��ʶҩƷ
UPDATE dbo.InnerContent
SET classification = 'ҩƷ', type = -1
WHERE /*classification <> 'ҩƷ' AND */ cid IN
(
	SELECT cid
	FROM dbo.InnerContent
	WHERE CHARINDEX('ҽѧ', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
) AND (LEFT(content, 3) IN ('ע����') OR LEFT(content, 2) IN ('�ڷ�', '����') OR
RIGHT(content, 1) IN ('Ƭ', '��', '��', 'ɢ', '˨', '��', 'Һ', 'ҩ', '��', '��', '��', '��') OR
RIGHT(content, 2) IN ('����', '����', '˨��', '�ǽ�') OR
RIGHT(content, 3) IN ('�ڷ�Һ', 'ע��Һ', '����Ƭ')) AND RIGHT(content, 2) NOT IN ('ͼƬ');