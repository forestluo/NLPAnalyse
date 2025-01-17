USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[加载RulePool]    Script Date: 2020/12/12 12:39:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月7日>
-- Description:	<解析文本池，并记录至数据库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[加载RulePool]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlRID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlClassification UString;

	-- 声明临时变量
	DECLARE @SqlCount INT = 0;
	-- 查询总数
	SELECT @SqlCount = COUNT(*) FROM dbo.RulePool;
	-- 打印空行
	PRINT '加载RulePool> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, parse_rule, classification FROM dbo.RulePool
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlClassification;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 打印内容
		PRINT '加载RulePool(rid=' +
			CONVERT(NVARCHAR(MAX), @SqlRID) + ')> ' + @SqlRule;

		-- 检查分类
		IF @SqlClassification IN ('通用', '拼接',  '配对', '单句', '复句')
		BEGIN
			-- 加入一条规则
			EXEC dbo.AddParseRule @SqlRule, @SqlClassification;
		END
		ELSE IF LEFT(@SqlClassification, 2) = '正则'
		BEGIN
			-- 加入一条规则
			EXEC dbo.AddLogicRule @SqlRule, @SqlClassification;
		END
		ELSE IF @SqlClassification IN ('因果','假设','充分','必要','目的','转折','让步','并列','承接','递进','选择')
		BEGIN
			-- 加入一条规则
			EXEC dbo.AddLogicRule @SqlRule, @SqlClassification;
		END
		ELSE
		BEGIN
			-- 打印内容
			PRINT '加载RulePool(rid=' +
				CONVERT(NVARCHAR(MAX), @SqlRID) + ')> 未处理{' + @SqlClassification + '}';
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlClassification;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '加载RulePool> 所有规则全部加载完毕！';
	RETURN 1;
END
