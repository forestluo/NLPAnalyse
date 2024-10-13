USE [nldb]
GO

-- 声明临时变量
DECLARE @SqlID INT;
DECLARE @SqlEID INT;
DECLARE @SqlEnd INT;
DECLARE @SqlStart INT;
DECLARE @SqlValue UString;
DECLARE @SqlContent UString;
DECLARE @SqlMessage UString;

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT eid, message FROM dbo.ExceptionLog
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlMessage;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '清理异常日志> ' + @SqlMessage;

	-- 解析消息
	--SET @SqlStart = PATINDEX('%(tid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- 检查结果
	--IF @SqlStart > 0
	--BEGIN
	--	 寻找结尾
	--	SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
	--	 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
	--	 检查结果
	--	IF @SqlEnd > 0
	--	BEGIN
	--		 获得标识内容
	--		SET @SqlValue =
	--			SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
	--		 打印
	--		PRINT '清理异常日志> tid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

	--		 清理右侧有问题的内容
	--		SELECT @SqlContent = content FROM dbo.TextPool WHERE tid = @SqlID;
	--		 检查内容
	--		SET @SqlContent = dbo.ClearInvisibleChar(@SqlContent);
	--		 更新语料
	--		UPDATE dbo.TextPool
	--			SET parsed = 0, result = 0, remark = NULL, length = LEN(@SqlContent), content = @SqlContent WHERE tid = @SqlID;
	--		 删除该日志记录
	--		DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
	--	END
	--END
	
	-- 解析消息
	--SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- 检查结果
	--IF @SqlStart > 0
	--BEGIN
	--	 寻找结尾
	--	SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
	--	 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
	--	 检查结果
	--	IF @SqlEnd > 0
	--	BEGIN
	--		 获得标识内容
	--		SET @SqlValue =
	--			SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
	--		 打印
	--		PRINT '清理异常日志> eid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

	--		 更新日志所指语料
	--		UPDATE dbo.ExternalContent SET type = 0 WHERE eid = @SqlID;
	--		 删除该日志记录
	--		DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
	--	END
	--END

	-- 解析消息
	SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- 检查结果
	IF @SqlStart > 0
	BEGIN
		-- 寻找结尾
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		 PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- 检查结果
		IF @SqlEnd > 0 AND CHARINDEX('重复键值',@SqlMessage) > 0
		BEGIN
			-- 获得标识内容
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- 打印
			PRINT '清理异常日志> eid=' + @SqlValue; SET @SqlID = CONVERT(INT, @SqlValue);

			-- 更新日志所指语料
			UPDATE dbo.ExternalContent SET type = 2 WHERE eid = @SqlID;
			-- 删除该日志记录
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END

	--  取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlEID, @SqlMessage;
END

-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

--  打印结果
PRINT '清理异常日志> 耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate()));
