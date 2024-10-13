USE [nldb]
GO
/****** Object: �����ظ�����OuterContent ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��25��>
-- Description:	<�����ظ�����OuterContent>
-- =============================================

-- ������ʱ����
DECLARE @SqlDID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = '�ʿ�';

-- ��鲢ɾ������
IF OBJECT_ID('SqlOIDTableIndex') IS NOT NULL
	DROP TABLE SqlOIDTableIndex;
IF OBJECT_ID('SqlContentTableIndex') IS NOT NULL
	DROP TABLE SqlContentTableIndex;
IF OBJECT_ID('#SqlOIDTable', 'U') IS NOT NULL
	DROP TABLE #SqlOIDTable;
IF OBJECT_ID('#SqlContentTable', 'U') IS NOT NULL
	DROP TABLE #SqlContentTable;

-- ������ʱ��
CREATE TABLE #SqlOIDTable (oid INT);
CREATE TABLE #SqlContentTable (content NVARCHAR(256));
-- ������ʱ����
CREATE INDEX SqlOIDTableIndex ON #SqlOIDTable (oid);
CREATE INDEX SqlContentTableIndex ON #SqlContentTable (content);

-- ѡ����ظ�������
INSERT INTO #SqlContentTable
	SELECT content from dbo.OuterContent
	WHERE classification = @SqlClassification GROUP BY content HAVING COUNT(content) > 1;
-- ѡ�����С��OID
INSERT INTO #SqlOIDTable
	SELECT MIN(oid) from dbo.OuterContent
	WHERE classification = @SqlClassification GROUP BY content HAVING count(content) > 1;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT oid, content FROM dbo.OuterContent
		WHERE classification = @SqlClassification AND
		content IN (SELECT content FROM #SqlContentTable)
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ����¼
	IF NOT EXISTS
		(SELECT TOP 1 * FROM #SqlOIDTable WHERE oid = @SqlDID)
	BEGIN
		-- ���ü�����
		SET @SqlCount = @SqlCount + 1;
		-- ɾ������
		DELETE dbo.OuterContent WHERE oid = @SqlDID;
		-- ��ӡ���
		PRINT '�����ظ�����OuterContent> ɾ��' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�����ݣ�';
	END	
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

PRINT '�����ظ�����OuterContent> �ܹ�ɾ��' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�����ݣ�';

-- ɾ������
DROP INDEX SqlOIDTableIndex ON #SqlOIDTable;
DROP INDEX SqlContentTableIndex ON #SqlContentTable;
-- ɾ����ʱ��
DROP TABLE #SqlOIDTable;
DROP TABLE #SqlContentTable;

-- ѡ����ظ�������
--SELECT * FROM dbo.OuterContent AS m
--	INNER JOIN @SqlOIDTable AS d ON m.oid <> d.oid
--	INNER JOIN @SqlContentTable AS c ON m.content = c.content
--	WHERE classification = @SqlClassification;

	--WHERE oid NOT IN (SELECT oid FROM @SqlOIDTable) AND
	--hash_value IN (SELECT hash_value FROM @SqlContentTable) AND	classification = @SqlClassification;
