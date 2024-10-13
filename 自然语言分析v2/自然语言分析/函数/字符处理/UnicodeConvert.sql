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
-- Description:	<全角转换函数>
-- =============================================

CREATE OR ALTER FUNCTION UnicodeConvert 
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
    DECLARE @SqlStep INT;
    DECLARE @SqlIndex INT;
    DECLARE @SqlPattern NVARCHAR(8);

	-- 设置初始值    
    SELECT
		@SqlStep = 65248,
		@SqlPattern = N'%[!-~]%',      --半角的通配符
		@SqlValue = REPLACE(@SqlValue, N'   ', N'　 ');
    -- 指定排序规则
    SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	-- 循环处理
    WHILE @SqlIndex > 0
	BEGIN
      SELECT
        @SqlValue = REPLACE(@SqlValue,
                       SUBSTRING(@SqlValue, @SqlIndex, 1),
                       NCHAR(UNICODE(SUBSTRING(@SqlValue, @SqlIndex, 1)) + @SqlStep)),
        @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	END
	-- 返回结果
    RETURN @SqlValue;
END
GO

