USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[LoadTextFiles]    Script Date: 2020/12/6 19:49:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<导入多个文本文件>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载搜狗分类新闻]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlFileName UString;
	DECLARE @SqlDirectory UString;

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000008\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000010\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000013\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000014\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000016\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000020\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000022\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000023\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END

	-- 设置目录名
	SET @SqlDirectory = 'D:\Resources\汉语语料库\中文语料库\搜狗分类新闻.20061127\SogouC.reduced\Reduced\C000024\';
	-- 设置初始值
	SET @SqlIndex = 10;
	WHILE @SqlIndex <= 1999
	BEGIN
		-- 文件名
		SET @SqlFileName = @SqlDirectory + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt';
		-- 加载文件
		EXEC dbo.[加载文件TextPool] @SqlFileName;
		PRINT '文件（' + CONVERT(NVARCHAR(MAX),@SqlIndex) + '.txt）加载完毕！';
		-- 索引加一
		SET @SqlIndex = @SqlIndex + 1;
	END
END
GO

