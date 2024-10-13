USE [nldb2]
GO

DECLARE @SqlCount INT;
SET @SqlCount = 1;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlCID INT;
DECLARE @SqlOID INT;
DECLARE @SqlResult INT;
DECLARE @SqlContent UString;

/*
INSERT INTO InnerContent
(cid, classification, length, type, content)
SELECT TOP 1 cid, '词典', length, -1, content FROM OuterContent WHERE dbo.LookupDictionary(content) IS NOT NULL;

DELETE FROM OuterContent WHERE content IN (SELECT content FROM InnerContent);
*/

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT TOP (@SqlCount) oid, cid, content
	FROM dbo.OuterContent
	WHERE classification = '文本' AND type = 0;
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 更新词典库检查结果
	EXEC @SqlResult = dbo.CheckDictionary @SqlContent;
	-- 检查结果
	IF @SqlResult <= 0
	BEGIN
		-- 标识已经检查过
		UPDATE OuterContent
		SET type = 1 WHERE oid = @SqlOID;
	END
	ELSE
	BEGIN
		-- 在内表插入一条数据
		INSERT INTO InnerContent
		(cid, classification, length, type, content)
		VALUES (@SqlCID, '词典', LEN(@SqlContent), -1 ,@SqlContent);
		-- 在外表中删除一条数据
		DELETE FROM OuterContent WHERE oid = @SqlOID;
	END
	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());

-- SELECT * FROM OuterContent WHERE type = 1;
-- SELECT * FROM InnerContent WHERE classification='词典';
-- UPDATE OuterContent SET classification = '文本' WHERE type = 1;
