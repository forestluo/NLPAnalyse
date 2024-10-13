USE [nldb]
GO

/****** Object: 刷新解析规则 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月26日>
-- Description:	<刷新解析规则>
-- =============================================

DECLARE @SqlBackup UString;

------------------------------------------------
--
-- 复位序列
--
------------------------------------------------

-- 检查该对象是否存在
IF OBJECT_ID('RuleSequence') IS NOT NULL
BEGIN
	PRINT '删除之前存在的RuleSequence！';
	-- 删除之前存在的序列
	DROP SEQUENCE dbo.RuleSequence;
END
PRINT '创建新的RuleSequence！';
-- 创建序列
CREATE SEQUENCE dbo.RuleSequence AS INT START WITH 1 INCREMENT BY 1;

------------------------------------------------
--
-- 备份和创建FilterRule
--
------------------------------------------------
PRINT '备份FilterRule内容！';
-- 备份FilterRule内容
-- 设置备份表名称
SET @SqlBackup = 'FilterRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '备份表名称（' + @SqlBackup + ')！';

-- 检查该对象是否存在
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT '删除之前存在的表（' + @SqlBackup + '）！';
	-- 删除之前存在的表
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- 对表做重新命名操作
PRINT '重新命名现有数据表，作为备份表！';

-- 重新命名数据表
-- EXEC sp_rename 'FilterRule', @SqlBackup;
-- 创建新的FilterRule数据表
EXEC dbo.[创建表FilterRule];

------------------------------------------------
--
-- 备份和创建ParseRule
--
------------------------------------------------
PRINT '备份ParseRule内容！';
-- 备份ParseRule内容
-- 设置备份表名称
SET @SqlBackup = 'ParseRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '备份表名称（' + @SqlBackup + ')！';

-- 检查该对象是否存在
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT '删除之前存在的表（' + @SqlBackup + '）！';
	-- 删除之前存在的表
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- 对表做重新命名操作
PRINT '重新命名现有数据表，作为备份表！';

-- 重新命名数据表
-- EXEC sp_rename 'ParseRule', @SqlBackup;
-- 创建新的ParseRule数据表
EXEC dbo.[创建表ParseRule];

------------------------------------------------
--
-- 备份和创建PhraseRule
--
------------------------------------------------
PRINT '备份PhraseRule内容！';
-- 备份ParseRule内容
-- 设置备份表名称
SET @SqlBackup = 'PhraseRule' + CONVERT(varchar(8),GETDATE(),112);
PRINT '备份表名称（' + @SqlBackup + ')！';

-- 检查该对象是否存在
IF OBJECT_ID(@SqlBackup) IS NOT NULL
BEGIN
	PRINT '删除之前存在的表（' + @SqlBackup + '）！';
	-- 删除之前存在的表
	EXEC ('DROP TABLE ' + @SqlBackup);
END
-- 对表做重新命名操作
PRINT '重新命名现有数据表，作为备份表！';

-- 重新命名数据表
-- EXEC sp_rename 'PhraseRule', @SqlBackup;
-- 创建新的PhraseRule数据表
EXEC dbo.[创建表PhraseRule];

------------------------------------------------
--
-- 后置处理
--
------------------------------------------------

-- 加载ParseRule
EXEC dbo.[加载ParseRule];
-- 加载PhraseRule
EXEC dbo.[加载PhraseRule];
-- 加载FilterRule
EXEC dbo.[加载FilterRule];

-- 声明临时变量
DECLARE @SqlRules XML;

-- 加载过滤规则
SET @SqlRules = dbo.LoadFilterRules();
PRINT '刷新解析规则 > 过滤规则！';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- 加载正则规则
SET @SqlRules = dbo.LoadRegularRules();
PRINT '刷新解析规则 > 正则规则！';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- 加载单句规则
SET @SqlRules = dbo.LoadSentenceRules();
PRINT '刷新解析规则 > 单句规则！';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

-- 加载属性规则
SET @SqlRules = dbo.LoadAttributeRules();
PRINT '刷新解析规则 > 属性规则！';
PRINT CONVERT(NVARCHAR(MAX), @SqlRules);

