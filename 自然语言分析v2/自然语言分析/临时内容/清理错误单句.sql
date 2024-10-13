USE [nldb]
GO

-- 声明临时变量
DECLARE @SqlEID INT;
DECLARE @SqlContent UString;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT eid, content FROM dbo.ExternalContent
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlContent;

-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 检查内容
	IF CHARINDEX('"', @SqlContent) = 1
		AND CHARINDEX('"', @SqlContent, 2) <= 0
	BEGIN
		-- 打印
		PRINT '清理错误单句(eid=' + CONVERT(NVARCHAR(MAX),@SqlEID) + ')> {' + @SqlContent + '}';
		-- 清理
		SET @SqlContent = RIGHT(@SqlContent,LEN(@SqlContent) - 1);
		-- 检查是否唯一
		IF EXISTS (SELECT * FROM dbo.ExternalContent WHERE content = @SqlContent)
			-- 删除当前记录
			DELETE FROM dbo.ExternalContent WHERE eid = @SqlEID;
		ELSE
			-- 更新当前记录
			UPDATE dbo.ExternalContent SET length = LEN(@SqlContent), content = @SqlContent WHERE eid = @SqlEID;
	END
	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlContent;
END

-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 
