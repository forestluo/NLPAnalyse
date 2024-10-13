USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[VerifyTextContents]    Script Date: 2020/12/6 19:59:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<验证可解析的内容>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[VerifyTextContents]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlCID INT;
	DECLARE @SqlResult XML;

	DECLARE @SqlRule UString;
	DECLARE @SqlContent UString;

	-- 声明游标
	DECLARE SqlCursor CURSOR FOR
		SELECT cid, content, parse_rule FROM dbo.TextContent
		WHERE parse_rule IS NOT NULL AND LEN(parse_rule) > 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlCID, @SqlContent, @SqlRule;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 解析内容
		SET @SqlResult = dbo.ParseContent(@SqlRule, @SqlContent);
		-- PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
		-- 检查结果
		IF @SqlResult IS NULL OR
			@SqlResult.value('(//result/@id)[1]','int') <> 1 OR
			@SqlResult.value('(//result/@start)[1]','int') <> 1 OR
			@SqlResult.value('(//result/@end)[1]','int') <> LEN(@SqlContent) + 1
		BEGIN
			PRINT '验证(cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + ')记录失败！';
			PRINT '(cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + '：' + @SqlRule + ')> ' + @SqlContent;
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlCID, @SqlContent, @SqlRule;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
END
GO

