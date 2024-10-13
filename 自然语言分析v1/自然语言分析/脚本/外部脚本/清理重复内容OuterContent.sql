USE [nldb]
GO
/****** Object: 清理重复内容OuterContent ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月25日>
-- Description:	<清理重复内容OuterContent>
-- =============================================

-- 声明临时变量
DECLARE @SqlDID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = '词库';

-- 检查并删除对象
IF OBJECT_ID('SqlOIDTableIndex') IS NOT NULL
	DROP TABLE SqlOIDTableIndex;
IF OBJECT_ID('SqlContentTableIndex') IS NOT NULL
	DROP TABLE SqlContentTableIndex;
IF OBJECT_ID('#SqlOIDTable', 'U') IS NOT NULL
	DROP TABLE #SqlOIDTable;
IF OBJECT_ID('#SqlContentTable', 'U') IS NOT NULL
	DROP TABLE #SqlContentTable;

-- 创建临时表
CREATE TABLE #SqlOIDTable (oid INT);
CREATE TABLE #SqlContentTable (content NVARCHAR(256));
-- 创建临时索引
CREATE INDEX SqlOIDTableIndex ON #SqlOIDTable (oid);
CREATE INDEX SqlContentTableIndex ON #SqlContentTable (content);

-- 选择出重复的内容
INSERT INTO #SqlContentTable
	SELECT content from dbo.OuterContent
	WHERE classification = @SqlClassification GROUP BY content HAVING COUNT(content) > 1;
-- 选择出最小的OID
INSERT INTO #SqlOIDTable
	SELECT MIN(oid) from dbo.OuterContent
	WHERE classification = @SqlClassification GROUP BY content HAVING count(content) > 1;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT oid, content FROM dbo.OuterContent
		WHERE classification = @SqlClassification AND
		content IN (SELECT content FROM #SqlContentTable)
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 检查记录
	IF NOT EXISTS
		(SELECT TOP 1 * FROM #SqlOIDTable WHERE oid = @SqlDID)
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount + 1;
		-- 删除内容
		DELETE dbo.OuterContent WHERE oid = @SqlDID;
		-- 打印输出
		PRINT '清理重复内容OuterContent> 删除' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条内容！';
	END	
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

PRINT '清理重复内容OuterContent> 总共删除' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条内容！';

-- 删除索引
DROP INDEX SqlOIDTableIndex ON #SqlOIDTable;
DROP INDEX SqlContentTableIndex ON #SqlContentTable;
-- 删除临时表
DROP TABLE #SqlOIDTable;
DROP TABLE #SqlContentTable;

-- 选择出重复的内容
--SELECT * FROM dbo.OuterContent AS m
--	INNER JOIN @SqlOIDTable AS d ON m.oid <> d.oid
--	INNER JOIN @SqlContentTable AS c ON m.content = c.content
--	WHERE classification = @SqlClassification;

	--WHERE oid NOT IN (SELECT oid FROM @SqlOIDTable) AND
	--hash_value IN (SELECT hash_value FROM @SqlContentTable) AND	classification = @SqlClassification;
