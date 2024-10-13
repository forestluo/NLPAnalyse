USE [nldb]
GO
/****** Object: ����ʵ��ظ����� ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��25��>
-- Description:	<����ʵ��ظ�����>
-- =============================================

-- ������ʱ����
DECLARE @SqlDID INT;
DECLARE @SqlCount INT = 0;
DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = '��֯����';

-- ��鲢ɾ������
IF OBJECT_ID('SqlDIDTableIndex') IS NOT NULL
	DROP TABLE SqlDIDTableIndex;
IF OBJECT_ID('SqlContentTableIndex') IS NOT NULL
	DROP TABLE SqlContentTableIndex;
IF OBJECT_ID('#SqlDIDTable', 'U') IS NOT NULL
	DROP TABLE #SqlDIDTable;
IF OBJECT_ID('#SqlContentTable', 'U') IS NOT NULL
	DROP TABLE #SqlContentTable;

-- ������ʱ��
CREATE TABLE #SqlDIDTable (did INT);
CREATE TABLE #SqlContentTable (content NVARCHAR(256));
-- ������ʱ����
CREATE INDEX SqlDIDTableIndex ON #SqlDIDTable (did);
CREATE INDEX SqlContentTableIndex ON #SqlContentTable (content);

-- ѡ����ظ�������
INSERT INTO #SqlContentTable
	SELECT content from dbo.Dictionary
	WHERE classification = @SqlClassification GROUP BY content HAVING COUNT(content) > 1;
-- ѡ�����С��DID
INSERT INTO #SqlDIDTable
	SELECT MIN(did) from dbo.Dictionary
	WHERE classification = @SqlClassification GROUP BY content HAVING count(content) > 1;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content FROM dbo.Dictionary
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
		(SELECT TOP 1 * FROM #SqlDIDTable WHERE did = @SqlDID)
	BEGIN
		-- ���ü�����
		SET @SqlCount = @SqlCount + 1;
		-- ɾ������
		DELETE dbo.Dictionary WHERE did = @SqlDID;
		-- ��ӡ���
		PRINT '����ʵ��ظ�����> ɾ��' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�����ݣ�';
	END	
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

PRINT '����ʵ��ظ�����> �ܹ�ɾ��' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�����ݣ�';

-- ɾ������
DROP INDEX SqlDIDTableIndex ON #SqlDIDTable;
DROP INDEX SqlContentTableIndex ON #SqlContentTable;
-- ɾ����ʱ��
DROP TABLE #SqlDIDTable;
DROP TABLE #SqlContentTable;

-- ѡ����ظ�������
--SELECT * FROM dbo.Dictionary AS m
--	INNER JOIN @SqlDIDTable AS d ON m.did <> d.did
--	INNER JOIN @SqlContentTable AS c ON m.content = c.content
--	WHERE classification = @SqlClassification;

	--WHERE did NOT IN (SELECT did FROM @SqlDIDTable) AND
	--hash_value IN (SELECT hash_value FROM @SqlContentTable) AND	classification = @SqlClassification;
