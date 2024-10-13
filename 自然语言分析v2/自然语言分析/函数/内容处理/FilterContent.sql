USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月14日>
-- Description:	<获得清理替换的内容>
-- =============================================

CREATE OR ALTER FUNCTION FilterContent
(
	-- Add the parameters for the function here
	@SqlRules XML,
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlReplaced INT;
	DECLARE @SqlFilter UString;
	DECLARE @SqlReplace UString;

	-- 检查参数
	IF @SqlRules IS NULL RETURN NULL;
	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN NULL;

	-- 替代特殊空白为普通空白
	SET @SqlContent = dbo.ClearBlankspace(@SqlContent, ' ');

	-- 循环处理
DOIT_AGAIN:
	-- 设置初始值
	SET @SqlReplaced = 0;
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT
			Nodes.value('(./filter/text())[1]', 'nvarchar(max)'),
			Nodes.value('(./replace/text())[1]','nvarchar(max)')
			FROM @SqlRules.nodes('//result/rule') AS N(Nodes)
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlFilter, @SqlReplace;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 替换规则
		SET @SqlFilter = REPLACE(@SqlFilter, 'b', ' ');
		-- 检查结果
		IF CHARINDEX(@SqlFilter, @SqlContent) > 0
		BEGIN
			-- 设置标记
			SET @SqlReplaced = 1;
			-- 检查结果
			IF @SqlReplace IS NULL OR
				LEN(@SqlReplace) <= 0
			BEGIN
				-- 删除字符串
				SET @SqlContent = REPLACE(@SqlContent, @SqlFilter, '');
			END
			ELSE
			BEGIN
				-- 替换规则
				SET @SqlReplace = REPLACE(@SqlReplace, 'b', ' ');
				-- 替换字符串
				SET @SqlContent = REPLACE(@SqlContent, @SqlFilter, @SqlReplace);
			END
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlFilter, @SqlReplace;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 检查结果
	IF @SqlReplaced = 1 GOTO DOIT_AGAIN;
	-- 返回结果
	RETURN @SqlContent;
END
GO

