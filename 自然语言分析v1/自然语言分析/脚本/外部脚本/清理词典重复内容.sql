USE [nldb]
GO
/****** Object: 清理词典重复内容 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月25日>
-- Description:	<清理词典重复内容>
-- =============================================

-- 声明临时变量
DECLARE @SqlDID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = '组织机构';

-- 检查并删除对象
IF OBJECT_ID('SqlDIDTableIndex') IS NOT NULL
	DROP TABLE SqlDIDTableIndex;
IF OBJECT_ID('SqlContentTableIndex') IS NOT NULL
	DROP TABLE SqlContentTableIndex;
IF OBJECT_ID('#SqlDIDTable', 'U') IS NOT NULL
	DROP TABLE #SqlDIDTable;
IF OBJECT_ID('#SqlContentTable', 'U') IS NOT NULL
	DROP TABLE #SqlContentTable;

-- 创建临时表
CREATE TABLE #SqlDIDTable (did INT);
CREATE TABLE #SqlContentTable (content NVARCHAR(256));
-- 创建临时索引
CREATE INDEX SqlDIDTableIndex ON #SqlDIDTable (did);
CREATE INDEX SqlContentTableIndex ON #SqlContentTable (content);

-- 选择出重复的内容
INSERT INTO #SqlContentTable
	SELECT content from dbo.Dictionary
	WHERE classification = @SqlClassification GROUP BY content HAVING COUNT(content) > 1;
-- 选择出最小的DID
INSERT INTO #SqlDIDTable
	SELECT MIN(did) from dbo.Dictionary
	WHERE classification = @SqlClassification GROUP BY content HAVING count(content) > 1;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content FROM dbo.Dictionary
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
		(SELECT TOP 1 * FROM #SqlDIDTable WHERE did = @SqlDID)
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount + 1;
		-- 删除内容
		DELETE dbo.Dictionary WHERE did = @SqlDID;
		-- 打印输出
		PRINT '清理词典重复内容> 删除' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条内容！';
	END	
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

PRINT '清理词典重复内容> 总共删除' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条内容！';

-- 删除索引
DROP INDEX SqlDIDTableIndex ON #SqlDIDTable;
DROP INDEX SqlContentTableIndex ON #SqlContentTable;
-- 删除临时表
DROP TABLE #SqlDIDTable;
DROP TABLE #SqlContentTable;

-- 选择出重复的内容
--SELECT * FROM dbo.Dictionary AS m
--	INNER JOIN @SqlDIDTable AS d ON m.did <> d.did
--	INNER JOIN @SqlContentTable AS c ON m.content = c.content
--	WHERE classification = @SqlClassification;

	--WHERE did NOT IN (SELECT did FROM @SqlDIDTable) AND
	--hash_value IN (SELECT hash_value FROM @SqlContentTable) AND	classification = @SqlClassification;
