USE [nldb]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月19日>
-- Description:	<从OuterContent表中补充ParseRule>
-- =============================================
CREATE OR ALTER PROCEDURE [补充ParseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlResult INT;
	DECLARE @SqlRule UString;

	-- 打印空行
	PRINT '补充ParseRule> 加载数据记录！';

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT DISTINCT(parse_rule)	FROM dbo.OuterContent
			WHERE parse_rule IS NOT NULL AND dbo.IsTerminateRule(parse_rule) = 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlRule;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查规则
		IF dbo.GetParseRuleID(@SqlRule) <= 0
		BEGIN
			-- 加入规则
			EXEC @SqlResult = dbo.AddSentenceRule @SqlRule;
			-- 打印结果
			PRINT '补充ParseRule(rid=' + CONVERT(NVARCHAR(MAX), @SqlResult) + ')> ' + @SqlRule;
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlRule;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '补充ParseRule> 所有补充规则加载完毕！';
END
GO
