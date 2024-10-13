USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月9日>
-- Description:	<恢复规则内的正则参数>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[RecoverRegularRule]
(
	-- Add the parameters for the stored procedure here
	@SqlRule UString
)
RETURNS UString
AS
BEGIN
	-- 检查参数
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN NULL;
	-- 替换操作
	IF CHARINDEX('$a', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$a', dbo.GetRegularString('$a'));
	IF CHARINDEX('$b', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$b', dbo.GetRegularString('$b'));
	IF CHARINDEX('$c', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$c', dbo.GetRegularString('$c'));
	IF CHARINDEX('$d', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$d', dbo.GetRegularString('$d'));
	IF CHARINDEX('$e', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$e', dbo.GetRegularString('$e'));
	IF CHARINDEX('$f', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$f', dbo.GetRegularString('$f'));
	IF CHARINDEX('$n', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$n', dbo.GetRegularString('$n'));
	IF CHARINDEX('$s', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$s', dbo.GetRegularString('$s'));

	IF CHARINDEX('$q', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$q', dbo.GetRegularString('$q'));
	IF CHARINDEX('$u', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$u', dbo.GetRegularString('$u'));
	IF CHARINDEX('$v', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$v', dbo.GetRegularString('$v'));
	IF CHARINDEX('$y', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$y', dbo.GetRegularString('$y'));
	IF CHARINDEX('$z', @SqlRule) > 0
		SET @SqlRule = REPLACE(@SqlRule, '$z', dbo.GetRegularString('$z'));

	-- 返回结果
	RETURN @SqlRule;
END
GO

