USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月5日>
-- Description:	<全连通词频统计>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[GrammarStatistics]
	-- Add the parameters for the stored procedure here
	@SqlLength INT,
	@SqlContent UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;

	-- 检查参数
	IF @SqlLength <= 0 RETURN -1;
	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;

	-- 检查长度
	IF @SqlLength <= 2
	BEGIN
		-- 设置初始值
		SET @SqlPosition = 0;
		-- 循环处理
		WHILE @SqlPosition + @SqlLength <= LEN(@SqlContent)
		BEGIN
			-- 修改计数器
			SET @SqlPosition = @SqlPosition + 1;
			-- 获得子字符串
			SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, @SqlLength);
			-- 检查长度
			IF LEN(@SqlValue) = 1
			BEGIN
				-- 更新记录
				UPDATE dbo.Grammar1
					SET operations = 1,
					count = count + 1 WHERE content = @SqlValue;
				-- 检查结果
				IF @@ROWCOUNT <= 0
				BEGIN
					-- 先插入
					INSERT INTO dbo.Grammar1
					(operations, content) VALUES (1, @SqlValue);
				END
			END
			ELSE IF LEN(@SqlValue) = 2
			BEGIN
				-- 更新记录
				UPDATE dbo.Grammar2
					SET operations = 1,
					count = count + 1 WHERE content = @SqlValue;
				-- 检查结果
				IF @@ROWCOUNT <= 0
				BEGIN
					-- 插入记录
					INSERT INTO dbo.Grammar2
					(operations, content, lcontent, rcontent)
					VALUES (1, @SqlValue, LEFT(@SqlValue,1), RIGHT(@SqlValue, 1));
				END
			END
		END
	END
	ELSE
	BEGIN
		-- 声明临时变量
		DECLARE @SqlID INT;
		DECLARE @SqlResult XML;
		DECLARE @SqlNLength INT;
		DECLARE @SqlNValue UString;
		DECLARE @SqlTable UMatchTable;

		-- 基于NGram进行分解
		SET @SqlResult = dbo.GrammarSplitAll(@SqlContent);
		-- 插入数据表
		INSERT INTO @SqlTable
			(length, position, value)
			SELECT
				Nodes.value('(@len)[1]', 'int') AS nodeLength,
				Nodes.value('(@pos)[1]', 'int') AS nodePosition,
				Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
				FROM @SqlResult.nodes('//result/var') AS N(Nodes);

		-- 声明游标
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT id, length, value FROM @SqlTable
				WHERE length > 0 AND value IS NOT NULL ORDER BY id;
		-- 打开游标
		OPEN SqlCursor;
		-- 取第一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlValue
		-- 循环处理游标
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 设置初始值
			SET @SqlNLength = 0;
			SET @SqlNValue = NULL;
			-- 查询结果
			SELECT @SqlNLength = length, @SqlNValue = value FROM @SqlTable WHERE id = @SqlID + 1;
			-- 检查结果
			IF @SqlNLength > 0 AND @SqlNValue IS NOT NULL
			BEGIN
				-- 检查长度
				IF (@SqlLength = 1 AND @SqlNLength = 2) OR
					(@SqlLength = 2 AND @SqlNLength = 1) OR	(@SqlLength = 2 AND @SqlNLength = 2)
				BEGIN
					-- 更新数据表
					UPDATE dbo.GrammarX
						SET operations = 1,
						count = count + 1 WHERE content = @SqlValue + @SqlNValue;
					-- 检查结果
					IF @@ROWCOUNT <= 0
					BEGIN
						-- 插入新数据
						INSERT INTO dbo.GrammarX (content, lcontent, rcontent) VALUES (@SqlValue + @SqlNValue, @SqlValue, @SqlNValue);
					END
				END
			END
			-- 取下一条记录
			FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlValue;
		END
		-- 关闭游标
		CLOSE SqlCursor;
		-- 释放游标
		DEALLOCATE SqlCursor;
	END
END
GO
