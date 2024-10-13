USE [nldb]
GO

/****** Object: 刷新数据库规则 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月26日>
-- Description:	<刷新数据库规则>
-- =============================================

------------------------------------------------
--
-- 复位序列
--
------------------------------------------------

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
-- 更新内容编号
--
------------------------------------------------

-- 先区别
UPDATE dbo.InnerContent SET cid = - cid;
-- 再更新
UPDATE dbo.InnerContent SET cid = NEXT VALUE FOR ContentSequence;

DECLARE @SqlContent UString;
-- 先区别
UPDATE dbo.OuterContent SET cid = - cid;
-- 再更新
-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT DISTINCT(content) FROM dbo.OuterContent
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlContent;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 更新记录
	UPDATE dbo.OuterContent
	SET cid = NEXT VALUE FOR ContentSequence
	WHERE content = @SqlContent;
	-- 取下一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlContent;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor;
