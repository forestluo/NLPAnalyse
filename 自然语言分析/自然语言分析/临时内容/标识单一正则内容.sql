USE [nldb2]
GO
/****** Object: ����һ�������� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��18��>
-- Description:	<��ʶ��һ��������>
-- =============================================

UPDATE dbo.OuterContent
SET classification = '���', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^0\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '����', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?[1-9]\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '����', type = -1
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^��[1-9]\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '����', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^\d{1,3}(,\d{3})+$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '�ٷ���', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?\d+(\.\d+)?%$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '������', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+)$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = 'Ӣ��', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^[A-Za-z][''A-Za-z]*$',dbo.LatinConvert(content), 1) = 1;