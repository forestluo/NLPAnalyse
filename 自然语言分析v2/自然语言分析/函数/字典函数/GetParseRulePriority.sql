USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetPriority]    Script Date: 2020/12/6 10:04:43 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月2日>
-- Description:	<获得标点符号的优先级>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetParseRulePriority]
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlValue UString;
	DECLARE @SqlPriority INT = 0;

	-- 判断长度
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN 0;
	-- 截取右侧1个字符
	SET @SqlValue = RIGHT(@SqlRule, 1);
	-- 检查结果
	-- 以普通分隔符结尾
	IF @SqlValue IN ('…','—','：',' ')
		SET @SqlPriority = 1;
	-- 以句子标点结尾
	ELSE IF @SqlValue IN ('。','！','？','；')
		SET @SqlPriority = 3;
	-- 以成对分隔符标点结尾
	ELSE IF @SqlValue IN ('”','’','）','》', '〉')
		SET @SqlPriority = 2;
	-- 检查长度
	IF LEN(@SqlRule) >= 2
	BEGIN
		-- 截取右侧两个字符
		SET @SqlValue = RIGHT(@SqlRule, 2);
		-- 检查字符
		-- 以语句开头为结尾
		IF @SqlValue IN ('：“','，“')
			SET @SqlPriority = 1;
		-- 以普通分隔符结尾
		ELSE IF @SqlValue IN ('，”','；”')
			SET @SqlPriority = 2;
		-- 以句子标点结尾
		ELSE IF @SqlValue IN ('。”','？”','！”','…”','—”')
			SET @SqlPriority = 3;
	END
	-- 返回缺省数值
	RETURN @SqlPriority;
END
GO

