USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[AddPhraseRule]    Script Date: 2021/1/25 18:42:21 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月25日>
-- Description:	<增加逻辑规则>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[AddPhraseRule]
(
	-- Add the parameters for the function here
	@SqlClassification UString,
	@SqlRule UString,
	@SqlAttribute UString
)
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlID INT;

	-- 剪切字符串
	SET @SqlRule = TRIM(@SqlRule);
	-- 检查规则
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN -1;
	-- 剪切字符串
	SET @SqlAttribute = TRIM(@SqlAttribute);
	-- 剪切字符串
	SET @SqlClassification = TRIM(@SqlClassification);

	-- 设置初始值
	SET @SqlID = -1;
	-- 查询结果
	SELECT @SqlID = rid	FROM dbo.PhraseRule
		WHERE classification = @SqlClassification AND [rule] = @SqlRule;
	-- 检查数据
	IF @SqlID > 0 RETURN @SqlID; /*返回已存在的标识*/

	-- 获得ID编号
	SET @SqlID = NEXT VALUE FOR RuleSequence;
	-- 插入数据
	INSERT INTO dbo.PhraseRule
		(rid, [rule], [attribute], [classification])
		VALUES (@SqlID, @SqlRule, @SqlAttribute, @SqlClassification);
	-- 打印输出日志
	PRINT 'AddPhraseRule(result=' + CONVERT(NVARCHAR(MAX), @SqlID) + ')> 已加入{"' + @SqlRule + '"}';
	-- 返回结果
	RETURN @SqlID;
END
GO

