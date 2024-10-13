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
-- Create date: <2020年12月16日>
-- Description:	<半角转换函数>
-- =============================================

CREATE OR ALTER FUNCTION LatinConvert 
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
    DECLARE @SqlStep INT;
    DECLARE @SqlIndex INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlContent UString;
    DECLARE @SqlPattern NVARCHAR(8);
   
	-- 设置初始值
    SELECT
		@SqlContent = '',
		@SqlStep = -65248,
	    @SqlPattern = N'%[！-～]%',    --全角的通配符
		@SqlValue = REPLACE(@SqlValue, N'　 ', N'   ');
    -- 指定排序规则
    SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	-- 循环处理
    WHILE @SqlIndex > 0
	BEGIN
		-- 获得字符
		SET @SqlChar = SUBSTRING(@SqlValue, @SqlIndex, 1);
		-- 检查字符
		IF UNICODE(@SqlChar) < 65248
		BEGIN
			-- 按照原样保留
			SET @SqlContent = @SqlContent + LEFT(@SqlValue, @SqlIndex);
		END
		ELSE
		BEGIN
			-- 合并左侧内容
			IF @SqlIndex > 1
			SET @SqlContent = @SqlContent + LEFT(@SqlValue, @SqlIndex - 1);
			-- 转换字符处理
			SET @SqlContent = @SqlContent + NCHAR(UNICODE(@SqlChar) + @SqlStep);
		END
		-- 截取剩余内容
		SET @SqlValue = RIGHT(@SqlValue, LEN(@SqlValue) - @SqlIndex);
		-- 查找下一处位置
        SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	END
	-- 返回结果
    RETURN @SqlContent + @SqlValue;
END
GO

