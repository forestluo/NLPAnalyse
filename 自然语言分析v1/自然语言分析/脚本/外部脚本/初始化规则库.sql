USE [nldb]
GO
/****** Object: 全部初始化数据库 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月18日>
-- Description:	<完全重新初始化规则库>
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
EXEC sp_rename 'ParseRule', @SqlBackup;
-- 创建新的ParseRule数据表
EXEC dbo.[创建表ParseRule];

------------------------------------------------
--
-- 备份和创建LogicRule
--
------------------------------------------------
PRINT '备份LogicRule内容！';
-- 备份ParseRule内容
-- 设置备份表名称
SET @SqlBackup = 'LogicRule' + CONVERT(varchar(8),GETDATE(),112);
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
EXEC sp_rename 'LogicRule', @SqlBackup;
-- 创建新的LogicRule数据表
EXEC dbo.[创建表LogicRule];

------------------------------------------------
--
-- 后置处理
--
------------------------------------------------
PRINT '重新初始化RulePool';
EXEC dbo.[创建表RulePool];
EXEC dbo.[初始化RulePool];
-- 加载RulePool
PRINT '加载RulePool';
EXEC dbo.[加载RulePool];

-- PRINT '重新建立分词与词之间的关系';
-- EXEC dbo.[重建WordRules];
