USE [nldb2]
GO
/****** Object: 标识字典查询内容 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月18日>
-- Description:	<标识字典查询内容>
-- =============================================

-- 标识姓名
UPDATE dbo.InnerContent
SET classification = '人名', type = -1
WHERE /*classification <> '人名' AND */  cid IN
(
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('姓名', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
	UNION
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('古名', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
	UNION
	SELECT cid
	FROM dbo.InnerContent
	WHERE length <= 4 AND CHARINDEX('名人', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
);

-- 标识药品
UPDATE dbo.InnerContent
SET classification = '药品', type = -1
WHERE /*classification <> '药品' AND */ cid IN
(
	SELECT cid
	FROM dbo.InnerContent
	WHERE CHARINDEX('医学', CONVERT(NVARCHAR(MAX), dbo.LookupDictionary(content))) > 0
) AND (LEFT(content, 3) IN ('注射用') OR LEFT(content, 2) IN ('口服', '复方') OR
RIGHT(content, 1) IN ('片', '丸', '剂', '散', '栓', '浆', '液', '药', '酒', '素', '膏', '胶') OR
RIGHT(content, 2) IN ('颗粒', '胶囊', '栓剂', '糖浆') OR
RIGHT(content, 3) IN ('口服液', '注射液', '肠溶片')) AND RIGHT(content, 2) NOT IN ('图片');