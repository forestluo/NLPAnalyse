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
-- Description:	<完全重新初始化数据库>
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

-- 检查该对象是否存在
IF OBJECT_ID('ContentSequence') IS NOT NULL
BEGIN
	PRINT '删除之前存在的ContentSequence！';
	-- 删除之前存在的序列
	DROP SEQUENCE dbo.ContentSequence;
END
PRINT '创建新的ContentSequence！';
-- 创建序列
CREATE SEQUENCE dbo.ContentSequence AS INT START WITH 1 INCREMENT BY 1;

------------------------------------------------
--
-- 备份和创建InnerContent
--
------------------------------------------------
PRINT '备份InnerContent内容！';
-- 备份InnerContent内容
-- 设置备份表名称
SET @SqlBackup = 'InnerContent' + CONVERT(varchar(8),GETDATE(),112);
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
EXEC sp_rename 'InnerContent', @SqlBackup;
-- 创建新的InnerContent数据表
EXEC dbo.[创建表InnerContent];

------------------------------------------------
--
-- 备份和创建OuterContent
--
------------------------------------------------
PRINT '备份OuterContent内容！';
-- 备份OuterContent内容
-- 设置备份表名称
SET @SqlBackup = 'OuterContent' + CONVERT(varchar(8),GETDATE(),112);
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
EXEC sp_rename 'OuterContent', @SqlBackup;
-- 创建新的OuterContent数据表
EXEC dbo.[创建表OuterContent];

------------------------------------------------
--
-- 备份和创建ExternalContent
--
------------------------------------------------
PRINT '备份ExternalContent内容！';
-- 备份ExternalContent内容
-- 设置备份表名称
SET @SqlBackup = 'ExternalContent' + CONVERT(varchar(8),GETDATE(),112);
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
EXEC sp_rename 'ExternalContent', @SqlBackup;
-- 创建新的ExternalContent数据表
EXEC dbo.[创建表ExternalContent];

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
EXEC sp_rename 'FilterRule', @SqlBackup;
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
EXEC sp_rename 'ParseRule', @SqlBackup;
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
EXEC sp_rename 'PhraseRule', @SqlBackup;
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
-- 加载正则规则
SET @SqlRules = dbo.LoadRegularRules();
-- 加载单句规则
SET @SqlRules = dbo.LoadSentenceRules();

-- 拷贝InnerContent
-- 设置备份表名称
SET @SqlBackup = 'InnerContent' + CONVERT(varchar(8),GETDATE(),112);
-- 拷贝内容
PRINT '开始从备份表中拷贝关键内容！';
EXEC ('INSERT INTO dbo.InnerContent (cid, [classification], [type], content, [length], count, attribute) ' + 
	'SELECT (NEXT VALUE FOR ContentSequence), [classification], [type], content, LEN(content), count, attribute FROM dbo.' + @SqlBackup);
PRINT '从备份表中拷贝关键内容结束！';

-- 拷贝OuterContent
-- 设置备份表名称
SET @SqlBackup = 'OuterContent' + CONVERT(varchar(8),GETDATE(),112);
-- 拷贝内容
PRINT '开始从备份表中拷贝关键内容！';
EXEC ('INSERT INTO dbo.OuterContent (cid, [classification], [type], content, [length], count) ' + 
	'SELECT (NEXT VALUE FOR ContentSequence), [classification], [type], content, LEN(content), count FROM dbo.' + @SqlBackup);
PRINT '从备份表中拷贝关键内容结束！';

-- 拷贝ExternalContent
-- 设置备份表名称
SET @SqlBackup = 'ExternalContent' + CONVERT(varchar(8),GETDATE(),112);
-- 拷贝内容
PRINT '开始从备份表中拷贝关键内容！';
EXEC ('INSERT INTO dbo.ExternalContent ([classification], [type], content, [length], count) ' + 
	'SELECT [classification], [type], content, LEN(content), count FROM dbo.' + @SqlBackup);
PRINT '从备份表中拷贝关键内容结束！';

------------------------------------------------
--
-- 后置处理
--
------------------------------------------------

PRINT '将字典设置为初始状态'
UPDATE dbo.Dictionary SET count = 0;

PRINT '将文本池设置为初始状态';
UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;

PRINT '清理异常日志表'
TRUNCATE TABLE dbo.ExceptionLog;