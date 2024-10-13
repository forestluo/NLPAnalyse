USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[BMMSplitAll]    Script Date: 2020/12/6 10:53:37 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<使用逆向最大匹配切分>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[BMMSplitAll]
(
	-- Add the parameters for the function here
	@SqlDictionary INT,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN

	-- 声明临时变量
	DECLARE @SqlAid INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlXML XML;
	DECLARE @SqlFreq INT;
	DECLARE @SqlCount INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;

	-- 剪裁
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查参数
	IF @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
	-- 检查终结符号
	-- 包括空，单字
	-- 终结符拒绝进一步分割
	IF LEN(@SqlContent) = 1 OR dbo.IsTerminator(@SqlContent) > 0
		RETURN CONVERT(XML, '<result id="-2">it is a terminator</result>');

	-- 将空格替换成特殊字符
	SET @SqlContent = dbo.EscapeBlankspace(@SqlContent);

	--  设置初始值
	SET @SqlResult = '';
	-- PRINT 'BMMSplitAll>开始分词（“' + @SqlContent + '”）！';
	-- 设置计数器
	SET @SqlIndex = 0;
	SET @SqlCount = LEN(@SqlContent);
	SET @SqlPosition = LEN(@SqlContent) + 1;
	-- 循环处理
	WHILE LEN(@SqlContent) >= 1 AND @SqlCount > 1
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount - 1;
		-- 获得右侧最大内容
		SET @SqlValue = RIGHT(@SqlContent, @SqlCount);

		-- 设置初始值
		SET @SqlFreq = 0;
		SET @SqlCID = dbo.ContentGetCID(@SqlValue);
		-- 没有找到该内容则继续寻找下一个
		IF @SqlCID > 0
		BEGIN
			-- 获得词频
			SET @SqlFreq = dbo.GetFreqCount(@SqlValue);
		END
		ELSE
		BEGIN
			-- 是否依赖字典
			IF @SqlDictionary = 0 CONTINUE;
			-- 清理数值
			SET @SqlCID = 0;
			-- 查询字典
			SET @SqlXML = dbo.LookupDictionary(@SqlValue)
			-- 检查结果
			IF @SqlXML IS NULL CONTINUE;
			-- 获得词频
			SET @SqlFreq = ISNULL(@SqlXML.value('(//result/item/@count)[1]','INT'),0);
		END

		-- 设置索引
		SET @SqlIndex = @SqlIndex + 1;
		-- 设置位置
		SET @SqlPosition = @SqlPosition - LEN(@SqlValue);
		-- 检查内容
		IF @SqlValue = dbo.BlankspaceChar()
		BEGIN
			-- 设置结果
			SET @SqlResult = '<blank id="*' + CONVERT(NVARCHAR(MAX), @SqlIndex) +
				'" pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '"/>' + @SqlResult;
		END
		ELSE
		BEGIN
			-- 设置结果
			SET @SqlResult = '<var id="*' + CONVERT(NVARCHAR(MAX), @SqlIndex) +
				'" term="' + CONVERT(NVARCHAR(MAX),
					CASE WHEN dbo.IsTerminator(@SqlValue) > 0 THEN 1 ELSE 0 END) +
				'" pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) +
				'" cid="' + CONVERT(NVARCHAR(MAX), @SqlCid) + 
				'" freq="' + CONVERT(NVARCHAR(MAX), @SqlFreq) + '">' + dbo.XMLEscape(@SqlValue) + '</var>' + @SqlResult;
		END

		-- 重置参数
		SET @SqlContent = LEFT(@SqlContent, LEN(@SqlContent) - @SqlCount); SET @SqlCount = LEN(@SqlContent) + 1;
		-- PRINT 'BMMSplitAll>找到匹配（cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + '，“' + @SqlValue + '”）！';
	END
	-- 检查结果
	-- 存在有无法识别的内容
	IF LEN(@SqlContent) >= 1 AND @SqlCount <= 1
		RETURN CONVERT(XML, '<result id="-3">something unrecognized</result>');

	-- 颠倒交换次序
	-- 设置初始值
	SET @SqlCount = @SqlIndex;
	SET @SqlIndex = 0;
	-- 循环处理
	WHILE @SqlIndex < @SqlCount
	BEGIN
		-- 设置计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 更换标识编号
		SET @SqlResult = REPLACE(@SqlResult,
							'id="*' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '"',
							'id="' + CONVERT(NVARCHAR(MAX), @SqlCount - @SqlIndex + 1) + '"');
	END
	-- 分解成功
	RETURN CONVERT(XML, '<result id="1" met="BMM" count="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' + @SqlResult + '</result>');
END
GO
