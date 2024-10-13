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
-- Create date: <2021年3月5日>
-- Description:	<获得多个词的相关系数>
-- =============================================

CREATE OR ALTER FUNCTION GrammarGetAlphaValue
(
	-- Add the parameters for the function here
	@SqlInput UString
)
RETURNS FLOAT
AS
BEGIN

	-- 声明临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlValue FLOAT;
	DECLARE @SqlContent UString;

	-- 检查参数
	IF @SqlInput IS NULL OR
		LEN(@SqlInput) <= 0 RETURN -1.0;

	-- 设置初始值
	SET @SqlIndex = 0;
	SET @SqlValue = 0.0;
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT [Match] AS content
		FROM dbo.RegExSplit('[|]', @SqlInput, 1)
		WHERE [Match] IS NOT NULL AND LEN([Match]) > 0
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 修改计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 获得词频
		SET @SqlCount = 0;
		-- 检查长度
		IF LEN(@SqlContent) = 1
			-- 查询结果
			SELECT @SqlCount = count FROM dbo.Grammar1
				WHERE content = @SqlContent
		ELSE IF LEN(@SqlContent) = 2
			-- 查询结果
			SELECT @SqlCount = count FROM dbo.Grammar2
				WHERE content = @SqlContent
		ELSE
			-- 查询结果
			SELECT @SqlCount = count FROM dbo.GrammarX
				WHERE content = @SqlContent
		-- 检查结果
		IF @SqlCount <= 0 BREAK;
		-- 获得数据
		SET @SqlValue = @SqlValue + 1.0 / @SqlCount;
		-- 取下一条记录 
		FETCH NEXT FROM SqlCursor INTO @SqlContent;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;
	-- 检查结果
	IF @SqlIndex <= 0 OR
		@SqlCount <= 0 RETURN -1.0;
	-- 设置结果
	SET @SqlValue = 1.0 * @SqlIndex / @SqlValue;

	-- 获得整合内容
	SET @SqlContent = REPLACE(@SqlInput, '|', '');
	-- 获得词频
	SET @SqlCount = 0;
	-- 检查长度
	IF LEN(@SqlContent) = 1
		-- 查询结果
		SELECT @SqlCount = count FROM dbo.Grammar1
			WHERE content = @SqlContent
	ELSE IF LEN(@SqlContent) = 2
		-- 查询结果
		SELECT @SqlCount = count FROM dbo.Grammar2
			WHERE content = @SqlContent
	ELSE
		-- 查询结果
		SELECT @SqlCount = count FROM dbo.GrammarX
			WHERE content = @SqlContent
	-- 检查结果
	IF @SqlCount <= 0 SET @SqlCount = 1;

	-- 返回结果
	RETURN @SqlValue / @SqlCount;
END
GO

