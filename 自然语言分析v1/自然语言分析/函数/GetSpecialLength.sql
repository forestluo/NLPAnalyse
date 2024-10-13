USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetLength]    Script Date: 2020/12/6 10:01:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<计算特殊字符串的长度>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[GetLength]
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS INT
AS
BEGIN
	-- 检查参数
	-- 空格无法通过LEN检查
	IF @SqlValue IS NULL RETURN 0;
	-- 返回结果
	-- LEN不会把开头和结尾的空格认为是字符串的一部分
	SET @SqlValue = REPLACE(@SqlValue,' ','_');
	SET @SqlValue = REPLACE(@SqlValue,'&#x20;','_');
	-- 返回结果
	RETURN LEN(@SqlValue);
END
GO

