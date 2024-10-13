USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[AddParseRule]    Script Date: 2020/12/6 18:42:21 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月28日>
-- Description:	<增加关系规则>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[AddParseRule]
(
	-- Add the parameters for the function here
	@SqlClassification UString,
	@SqlRule UString
)
AS
BEGIN
	-- 定义临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlXML XML;
	DECLARE @SqlCount INT;

	-- 剪切字符串
	SET @SqlRule = TRIM(@SqlRule);
	-- 检查规则
	IF @SqlRule IS NULL
		OR LEN(@SqlRule) <= 0 RETURN -1;
	-- 剪切字符串
	SET @SqlClassification = TRIM(@SqlClassification);

	-- 设置初始值
	SET @SqlID = -1;
	-- 查询结果
	SELECT @SqlID = rid FROM dbo.ParseRule
		WHERE classification = @SqlClassification AND [rule] = @SqlRule;
	-- 检查数据
	IF @SqlID > 0 RETURN @SqlID; /*返回已存在的标识*/

	-- 将规则转换成XML
	SET @SqlXML = dbo.ConvertRule(@SqlRule);
	-- 检查结果
	IF ISNULL(@SqlXML.value('(//result/@id)[1]', 'int'), 0) <> 1
	BEGIN
		PRINT 'AddParseRule(result=-2)> 转换XML失败！'; RETURN -2;
	END

	-- 定义临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlName UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlPrevName UString;

	DECLARE @SqlSuffix INT = 0;
	DECLARE @SqlPrefix INT = 0;
	DECLARE @SqlLength INT = 0;
	DECLARE @SqlPriority INT = 0;
	DECLARE @SqlParameter INT = -1;
	DECLARE @SqlNormalized INT = 1;

	-- 获得节点总数量
	SET @SqlCount = @SqlXML.value('count(//result/*)','int');

	-- 设置初始值
	SET @SqlIndex = 0;
	-- 循环处理每一个节点
	WHILE @SqlIndex < @SqlCount
	BEGIN
		-- 计数器加一
		SET @SqlIndex = @SqlIndex + 1;
		-- 获得本地名称
		SET @SqlName = @SqlXML.value('local-name((//result/*[position()=sql:variable("@SqlIndex")])[1])', 'nvarchar(max)');
		-- 检查本地名称
		IF @SqlName = 'var'
		BEGIN
			-- 检查本地名称
			-- 连续两个变量，则无法实现正则解析
			IF @SqlPrevName = 'var'
				SET @SqlNormalized = 0;
		END
		ELSE IF @SqlName = 'pad'
		BEGIN
			-- 检查是否是开头
			IF @SqlIndex = 1
				SET @SqlPrefix = 1;
			-- 检查是否是结尾
			ELSE IF @SqlIndex = @SqlCount
			BEGIN
				-- 设置标记位
				SET @SqlSuffix = 1;
				-- 检查结尾符号
				SET @SqlPriority = dbo.GetParseRulePriority(@SqlValue);
			END
		END
		-- 设置上次的名称
		SET @SqlPrevName = @SqlName;
	END;
	-- 统计参数的数量
	SET @SqlParameter = dbo.GetVarCount(@SqlRule);
	-- 获得最小长度
	SET @SqlLength = LEN(dbo.ClearParameters(@SqlRule));

	-- 获得ID编号
	SET @SqlID = NEXT VALUE FOR RuleSequence;
	-- 插入数据
	INSERT INTO dbo.ParseRule (rid, [rule], abbreviation, [classification],
		xml_remark, normalized, static_suffix, static_prefix, minimum_length, parameter_count, controllable_priority)
		VALUES (@SqlID, @SqlRule, dbo.ClearParameters(@SqlRule), @SqlClassification,
		CONVERT(NVARCHAR(MAX),@SqlXML), @SqlNormalized, @SqlSuffix, @SqlPrefix, @SqlLength, @SqlParameter, @SqlPriority);
	-- 打印输出日志
	PRINT 'AddParseRule(result=' + CONVERT(NVARCHAR(MAX), @SqlID) + ')> 已加入{"' + @SqlRule + '"，n=' + CONVERT(NVARCHAR(MAX),@SqlNormalized) + '，sp=' + CONVERT(NVARCHAR(MAX),@SqlPrefix)
			+ '，ss=' + CONVERT(NVARCHAR(MAX),@SqlSuffix) + '，ml=' + CONVERT(NVARCHAR(MAX),@SqlLength) + '，pc=' + CONVERT(NVARCHAR(MAX),@SqlParameter) + '}';
	-- 返回结果
	RETURN @SqlID;
END

GO

