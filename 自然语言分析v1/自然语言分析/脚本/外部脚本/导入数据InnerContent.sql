-- 显示前10000行记录
SELECT TOP 10000 * FROM dbo.[all];

-- 清理空格
UPDATE dbo.[all] SET [列 0] = dbo.ClearBlankspace([列 0], NULL);
-- 剪裁内容
UPDATE dbo.[all] SET [列 0] = TRIM([列 0]);
-- 清理掉空白行
DELETE FROM dbo.[all] WHERE LEN([列 0]) <= 0;
-- 删除不能解析的行
-- DELETE FROM dbo.[all] WHERE dbo.IsParsable([列 0]) = 0;
-- 删除掉已经存在于库中的内容
-- DELETE FROM dbo.[all] WHERE dbo.GetHash([列 0]) IN (SELECT hash_value FROM dbo.InnerContent);
-- 删除掉存在字符转换问题的内容
DELETE FROM dbo.[all] WHERE PATINDEX('%?%', [列 0]) > 0;
-- 删除掉存在字符问题的内容
DELETE FROM dbo.[all] WHERE PATINDEX('%�%', [列 0]) > 0;
-- 删除出含有英文字符的内容
DELETE FROM dbo.[all] WHERE PATINDEX('%[0-9a-zA-Z]%', [列 0]) > 0;

-- EXEC dbo.AddCharacters '後';

DECLARE @SqlCount INT = 0;
DECLARE @SqlContent UString;
-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT [列 0] FROM dbo.[all];
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 修改计数器
	SET @SqlCount = @SqlCount + 1;
	-- 检查是否重复
	IF NOT EXISTS
		(SELECT TOP 1 * FROM dbo.InnerContent WHERE hash_value = dbo.GetHash(@SqlContent))
	BEGIN
		PRINT '已处理(' + CONVERT(NVARCHAR(MAX), @SqlCount) + ')行> ' + @SqlContent;
		-- 插入数据
		INSERT INTO dbo.InnerContent (cid, content, length, hash_value, classification)
		VALUES (NEXT VALUE FOR ContentSequence, @SqlContent, LEN(@SqlContent), dbo.GetHash(@SqlContent), '公司名称');
	END
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 
