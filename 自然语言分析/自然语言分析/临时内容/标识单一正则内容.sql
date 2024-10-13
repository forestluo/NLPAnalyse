USE [nldb2]
GO
/****** Object: 处理单一正则内容 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月18日>
-- Description:	<标识单一正则内容>
-- =============================================

UPDATE dbo.OuterContent
SET classification = '编号', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^0\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '整数', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?[1-9]\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '货币', type = -1
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^￥[1-9]\d*$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '整数', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^\d{1,3}(,\d{3})+$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '百分数', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?\d+(\.\d+)?%$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '浮点数', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+)$',dbo.LatinConvert(content), 1) = 1;

UPDATE dbo.OuterContent
SET classification = '英文', type = -1, content = dbo.LatinConvert(content)
FROM dbo.OuterContent WHERE dbo.RegExIsMatch('^[A-Za-z][''A-Za-z]*$',dbo.LatinConvert(content), 1) = 1;