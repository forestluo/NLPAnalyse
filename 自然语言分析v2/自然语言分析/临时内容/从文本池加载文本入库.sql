USE [nldb2]
GO
/****** Object:  StoredProcedure [dbo].[从文本池加载文本入库]    Script Date: 2020/12/30 16:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月30日>
-- Description:	<解析文本池，并将文本记录至数据库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[从文本池加载文本入库]
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlTID INT;
	DECLARE @SqlEnd INT;
	DECLARE @SqlResult XML;

	DECLARE @SqlTips UString;
	DECLARE @SqlText UString;

	DECLARE @SqlDate DATETIME;
	DECLARE @SqlLoopCount INT;
	
	-- 开始计时
	SET @SqlDate = GetDate();
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0 /*ORDER BY length*/;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- 计时结束
	PRINT '从文本池加载文本入库> 开启游标耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 开始计时
		SET @SqlDate = GetDate();
		-- 打印内容
		/*
		PRINT '从文本池加载文本入库(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlText;*/
		BEGIN TRY

			-- 设置初始值
			SET @SqlLoopCount = 0;
			-- 循环处理
			WHILE @SqlText IS NOT NULL AND LEN(@SqlText) > 0
			BEGIN
				-- 修改计数器
				SET @SqlLoopCount = @SqlLoopCount + 1;

				-- 读取中文
				SET @SqlResult = dbo.ReadChinese(@SqlText);
				-- 检查结果
				IF @SqlResult IS NULL OR
					ISNULL(@SqlResult.value('((.//result/@id)[1])', 'int'), 0) <= 0
				BEGIN
					-- 打印输出
					PRINT '从文本池加载文本入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 加载失败！'; BREAK;
				END
				-- 获得结尾
				SET @SqlEnd = @SqlResult.value('((.//result/@end)[1])', 'int');
				-- 检查结果
				IF @SqlEnd IS NULL OR @SqlEnd <= 0
				BEGIN
					-- 打印输出
					PRINT '从文本池加载文本入库(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 无效结尾！'; BREAK;
				END

				-- 插入数据记录
				INSERT INTO dbo.OuterContent
					(cid, [classification], [length], content)
					SELECT NEXT VALUE FOR ContentSequence,
					'文本', LEN(nodeValue), nodeValue
					FROM
					(
						SELECT
						DISTINCT(Nodes.value('(text())[1]', 'nvarchar(max)')) AS nodeValue
						FROM @SqlResult.nodes('//result/var') AS N(Nodes)
					) AS NodesTable WHERE dbo.ContentGetCID(nodeValue) <= 0;

				-- 检查结尾
				IF @SqlEnd > LEN(@SqlText) SET @SqlText = NULL;
				-- 截取剩余部分
				ELSE SET @SqlText = RIGHT(@SqlText, LEN(@SqlText) - @SqlEnd);
			END
		END TRY
		BEGIN CATCH
			-- 设置提示，抓取异常记录
			SET @SqlTips = '从文本池加载文本入库(tid=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')'; EXEC dbo.CatchException @SqlTips;	
		END CATCH

NEXT_ROW:
		-- 更新记录
		UPDATE dbo.TextPool
			SET parsed = 1 WHERE tid = @SqlTID;
		-- 取下一条记录 
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
		-- 计时结束
		PRINT '从文本池加载文本入库> ' + CONVERT(NVARCHAR(MAX), @SqlLoopCount) + 
			'次循环，耗时' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '毫秒';
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '从文本池加载文本入库> 所有文本全部切分成中文入库！'; RETURN 1;
END
