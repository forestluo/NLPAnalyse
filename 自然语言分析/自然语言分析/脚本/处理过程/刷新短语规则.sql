USE [nldb]
GO

/****** Object: 刷新短语规则 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月30日>
-- Description:	<刷新短语规则>
-- =============================================

------------------------------------------------
--
-- 更新PhraseRule
--
------------------------------------------------

PRINT '删除短语规则！';
DELETE FROM PhraseRule WHERE classification IN ('数词', '数量词', '短语');

------------------------------------------------
--
-- 后置处理
--
------------------------------------------------

-- 加载PhraseRule
EXEC dbo.[加载PhraseRule];

-- 声明临时变量
DECLARE @SqlRules XML;

-- 加载短语规则
SET @SqlRules = dbo.LoadPhraseRules();
-- PRINT '刷新解析规则 > 短语规则！';
-- PRINT CONVERT(NVARCHAR(MAX), @SqlRules);
