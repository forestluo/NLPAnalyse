USE [nldb2]
GO
/****** Object: 清理符号错误的内容 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月18日>
-- Description:	<清理符号错误的内容>
-- =============================================

-- 清理开头为【"】，但是后面没有对应的符号
UPDATE OuterContent SET content = RIGHT(content, LEN(content) - 1)
WHERE content like '"%' AND CHARINDEX('"', content, 2) <= 0 AND length > 1;

-- 清理结尾为【"】，但是前面没有对应的符号
/*
SELECT content, REPLACE(REPLACE(LEFT(content, LEN(content) - 1), '.', '。'), ',', '，')
FROM dbo.OuterContent
WHERE content like '%"' AND CHARINDEX('"', LEFT(content, LEN(content) - 1)) <= 0 AND length > 1
AND dbo.RegExIsMatch(content, 's+[,.0-9a-zA-Z]*s+', 1) = 0;
*/
UPDATE OuterContent
SET content = REPLACE(REPLACE(LEFT(content, LEN(content) - 1), '.', '。'), ',', '，')
WHERE content like '%"' AND CHARINDEX('"', LEFT(content, LEN(content) - 1)) <= 0 AND length > 1
AND dbo.RegExIsMatch(content, 's+[,.0-9a-zA-Z]*s+', 1) = 0;

-- 清理开头为【"】，结尾为【."】，修改为标准的标点符号
/*
SELECT content, '“' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 3), '.', '。'), ',', '，') + '。”'
FROM dbo.OuterContent
WHERE content like '"%."' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 3)) <= 0 AND length > 3;
*/
UPDATE dbo.OuterContent
SET content =  '“' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 3), '.', '。'), ',', '，') + '。”'
WHERE content like '"%."' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 3)) <= 0 AND length > 3;

-- 清理开头为【"】，结尾为【"】，修改为标准的标点符号
/*
SELECT content, '“' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 2), '.', '。'), ',', '，') + '。”'
FROM dbo.OuterContent
WHERE content like '"%"' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 2)) <= 0 AND length > 2;
*/
UPDATE dbo.OuterContent
SET content = '“' + REPLACE(REPLACE(SUBSTRING(content, 2, LEN(content) - 2), '.', '。'), ',', '，') + '。”'
WHERE content like '"%"' AND CHARINDEX('"', SUBSTRING(content, 2, LEN(content) - 2)) <= 0 AND length > 2;

-- 清理【中文："中文】模式的错误
/*
SELECT content, content = REPLACE(REPLACE(REPLACE(content, '.', '。'), ',', '，'), '"', '“') + '”'
FROM dbo.OuterContent
WHERE content like '%："%' AND dbo.GetCharCount(content, '"') = 1
*/
UPDATE dbo.OuterContent
SET content = REPLACE(REPLACE(REPLACE(content, '.', '。'), ',', '，'), '"', '“') + '”'
WHERE content like '%："%' AND dbo.GetCharCount(content, '"') = 1

-- 清理【""】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 1) FROM OuterContent WHERE content like '""%';
-- 清理【",】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '",%';
-- 清理【" 】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '" %';
-- 清理【"(】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 1) FROM OuterContent WHERE content like '"(%';
-- 清理【" "】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '" "%';
-- 清理【"…"】模式的错误
UPDATE dbo.OuterContent
SET content = RIGHT(content, LEN(content) - 2) FROM OuterContent WHERE content like '"…"%';

-- 修正包含【"】模式的错误
/*
SELECT content, dbo.AmendSentence(content) FROM dbo.OuterContent WHERE content like '%"%' AND LENGTH > 2
*/
UPDATE dbo.OuterContent
SET content = dbo.AmendContent(content) WHERE content like '%"%' AND LENGTH > 2
