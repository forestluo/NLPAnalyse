USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[IsPureSentence]    Script Date: 2021/1/28 10:41:14 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月28日>
-- Description:	<是否为纯粹句子>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].IsPureSentence
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlChar UChar;
	DECLARE @SqlPosition INT = 0;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN 0;

	-- 转换小写
	SET @SqlContent = LOWER(@SqlContent);
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 修改计数器
		SET @SqlPosition = @SqlPosition + 1;
		SET @SqlChar = SUBSTRING(@SqlContent, @SqlPosition, 1);
		-- 检查结果
		IF dbo.IsDigit(@SqlChar) = 0 AND dbo.IsLowercase(@SqlChar) = 0 AND
			dbo.IsChineseChar(@SqlChar) = 0 AND	dbo.IsPunctuation(@SqlChar) = 0 RETURN 0;
	END
	-- 返回结果
	RETURN 1;
END
GO

