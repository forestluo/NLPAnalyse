USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[LoadTextFile]    Script Date: 2020/12/6 19:48:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<导入文本文件>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载文件TextPool]
	-- Add the parameters for the stored procedure here
	@SqlFileName UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @Sql UString;

	-- 检查对象
	IF OBJECT_ID('TempPool') IS NOT NULL
		DROP TABLE dbo.TempPool;
	-- 创建临时表
	CREATE TABLE dbo.TempPool (content NVARCHAR(MAX));
	-- 拼写SQL语句
	SET @Sql = 'BULK INSERT dbo.TempPool FROM ''' + @SqlFileName + ''' WITH (ROWTERMINATOR = ''\n'')';
	-- 执行SQL语句
	EXEC (@Sql);
	-- 更新数据
	UPDATE dbo.TempPool SET content = REPLACE(content, CHAR(9), ' ');
	UPDATE dbo.TempPool SET content = REPLACE(content, CHAR(10), ' ');
	UPDATE dbo.TempPool SET content = REPLACE(content, CHAR(32), ' ');
	UPDATE dbo.TempPool SET content = REPLACE(content, '&nbsp;', ' ');
	UPDATE dbo.TempPool SET content = REPLACE(content, '&nbsp', ' ');
	UPDATE dbo.TempPool SET content = TRIM(content);
	-- 删除无效数据
	DELETE dbo.TempPool WHERE content IS NULL OR LEN(content) <= 0;

	-- 执行导入语句
	INSERT INTO dbo.TextPool (length,content)
		SELECT LEN(content), content FROM dbo.TempPool;
	-- 释放临时表对象
	IF OBJECT_ID('TempPool') IS NOT NULL
		DROP TABLE dbo.TempPool;
END
GO

