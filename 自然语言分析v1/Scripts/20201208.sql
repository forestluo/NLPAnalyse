--SELECT * FROM dbo.TextContent;
--SELECT classification FROM dbo.TextContent GROUP BY classification;
--DELETE FROM dbo.TextContent WHERE classification IN ('µ¥¾ä', '·Ö¾ä');
--SELECT * FROM dbo.ParseRule;
--SELECT * FROM dbo.TextPool WHERE parsed <> 0;
--UPDATE dbo.TextPool SET parsed = 0 WHERE tid = 1;
--SELECT ASCII('ý£');
--UPDATE dbo.TextPool SET content = REPLACE(content,'ý£','');
--SELECT * FROM dbo.TextPool WHERE tid = 12;

DECLARE @SqlCount INT;
SET @SqlCount = 10000;
WHILE @SqlCount > 0
BEGIN
	SET @SqlCount = @SqlCount - 1;
	EXEC ParseTextPool;
END
