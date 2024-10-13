USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[LoadWordPool]    Script Date: 2020/12/6 19:50:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月2日>
-- Description:	<将分词池的内容加载至文本区>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载WordPool]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlCount INT;
	DECLARE @SqlValid INT;

	DECLARE @SqlChar UChar;
	DECLARE @SqlWord UString;
	DECLARE @SqlClassification UString;

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT word FROM dbo.WordPool;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlWord;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置初始值
		SET @SqlValid = 1;
		SET @SqlCount = 0;
		-- 先处理每个分词的字
		WHILE @SqlCount < LEN(@SqlWord)
		BEGIN
			-- 计数器加一
			SET @SqlCount = @SqlCount + 1;
			-- 得到一个字符
			SET @SqlChar = SUBSTRING(@SqlWord, @SqlCount, 1);
			-- 检查结果
			IF NOT EXISTS
				(SELECT * FROM dbo.TextContent WHERE content = @SqlChar)
			BEGIN
				SET @SqlValid = 0;
				PRINT '加载WordPool> 文本（“' + @SqlWord + '”）包含库中没有的成分（“' + @SqlChar + '”）!'; BREAK;
			END
			ELSE
			BEGIN
				-- 确定分类
				SELECT TOP 1 @SqlClassification = classification
					FROM dbo.TextContent WHERE content = @SqlChar;
				-- 检查类型
				IF @SqlClassification IS NOT NULL
					AND @SqlClassification <> '汉字'
				BEGIN
					SET @SqlValid = 0;
					PRINT '加载WordPool> 分词中有非汉字（“' + @SqlWord + '”）成分!'; BREAK;
				END
			END
		END
		-- 检查每个分词是否在库中有重复
		IF @SqlValid = 1 AND NOT EXISTS
			(SELECT * FROM dbo.TextContent WHERE content = @SqlWord)
		BEGIN
			-- 插入到分词表之中
			INSERT INTO dbo.TextContent
				(content, length, classification) VALUES (@SqlWord, LEN(@SqlWord), '分词');
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlWord;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
END
GO

