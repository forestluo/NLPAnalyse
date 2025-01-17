USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[LoadSentenceFile]    Script Date: 2020/12/9 16:05:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<导入以单句为一行的文本文件>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载外部单句文件]
	-- Add the parameters for the stored procedure here
	@SqlFileName UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlResult INT;

	DECLARE @Sql UString;
	DECLARE @SqlRule UString;
	DECLARE @SqlSentence UString;

	-- 检查对象
	IF OBJECT_ID('TempContent') IS NOT NULL
		DROP TABLE dbo.TempContent;
	-- 创建临时表
	CREATE TABLE dbo.TempContent (content NVARCHAR(MAX));
	-- 拼写SQL语句
	SET @Sql = 'BULK INSERT dbo.TempContent FROM ''' + @SqlFileName + ''' WITH (ROWTERMINATOR = ''\n'')';
	-- 执行SQL语句
	EXEC (@Sql);
	-- 更新数据
	UPDATE dbo.TempContent SET content = REPLACE(content, CHAR(9), ' ');
	UPDATE dbo.TempContent SET content = REPLACE(content, CHAR(10), ' ');
	UPDATE dbo.TempContent SET content = REPLACE(content, CHAR(32), ' ');
	UPDATE dbo.TempContent SET content = REPLACE(content, '&nbsp;', ' ');
	UPDATE dbo.TempContent SET content = REPLACE(content, '&nbsp', ' ');
	UPDATE dbo.TempContent SET content = TRIM(content);
	-- 删除无效数据
	DELETE dbo.TempContent WHERE content IS NULL OR LEN(content) <= 0;
	-- 删除重复数据
	DELETE FROM dbo.TempContent WHERE content IN
		(SELECT content FROM dbo.TempContent GROUP BY content HAVING COUNT(content) > 1);

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT content FROM dbo.TempContent;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlSentence;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 获得句子规则
		SET @SqlRule = dbo.GetParseRule(@SqlSentence);
		-- 检查句子规则
		IF @SqlRule IS NULL OR
			LEN(@SqlRule) <= 0 GOTO NEXT_ROW;
		-- 增加一条单句记录
		EXEC @SqlResult = dbo.OuterAddSentence @SqlSentence, @SqlRule;
		-- 检查结果
		IF @SqlResult <= 0
		BEGIN
			PRINT '加载外部单句文件(result=' + CONVERT(NVARCHAR(MAX), @SqlResult) + ') > ' + @SqlSentence;
		END
NEXT_ROW:
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlSentence;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 释放临时表对象
	IF OBJECT_ID('TempContent') IS NOT NULL
		DROP TABLE dbo.TempContent;
END
