USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[加载表达式TextPool]    Script Date: 2020/12/10 16:23:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月7日>
-- Description:	<解析文本池中的表达式，并记录至数据库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载表达式TextPool]
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlTID INT;
	DECLARE @SqlResult INT;
	DECLARE @SqlText UString;

	-- 打印空行
	PRINT '加载表达式TextPool> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 打印内容
		PRINT '加载表达式TextPool(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + @SqlText;
		/*
		PRINT '加载表达式TextPool(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ----------解析文本内容----------';*/

		-- 替换多余的字符
		SET @SqlText = dbo.ReplaceContent(@SqlText);
		
		-- 记录异常
		BEGIN TRY

			-- 提取表达式
			EXEC @SqlResult = dbo.ExtractExpression @SqlText;

		END TRY
		BEGIN CATCH
			-- 打印记录
			PRINT '加载表达式TextPool(tid=' +	CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' +
				'消息 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
				'级别 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
				'状态' + CONVERT(NVARCHAR(MAX), ERROR_STATE()) + ', 过程 ' + ERROR_PROCEDURE() + ' ' +
				'行' + CONVERT(NVARCHAR(MAX), ERROR_LINE()) +	' [' + ERROR_MESSAGE() + ']';
			-- 插入一条异常记录
			INSERT INTO dbo.ExceptionLog values(ERROR_NUMBER(),
				ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(), ERROR_LINE() ,
				'加载表达式TextPool(tid=' + CONVERT(NVARCHAR(MAX), @SqlTID) + ')> ' + ERROR_MESSAGE());
		END CATCH

NEXT_ROW:
		---- 更新数据记录
		UPDATE dbo.TextPool	SET parsed = 1, result = @SqlResult WHERE tid = @SqlTid;
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '加载表达式TextPool> 所有文本全部解析完毕！';
	RETURN 1;
END
