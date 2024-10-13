USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[BMMSplit]    Script Date: 2020/12/6 10:53:37 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<使用逆向最大匹配切分>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[BMMSplit]
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

	--  设置初始值
	SET @SqlResult = '';
	-- PRINT 'BMMSplit>开始分词（“' + @SqlContent + '”）！';
	-- 设置计数器
	SET @SqlIndex = 0;
	SET @SqlCount = LEN(@SqlContent);
	SET @SqlPosition = LEN(@SqlContent) + 1;
	-- 循环处理
	WHILE LEN(@SqlContent) >= 1 AND @SqlCount > 1 AND @SqlIndex < 26
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount - 1;
		-- 获得右侧最大内容
		SET @SqlValue = RIGHT(@SqlContent, @SqlCount);

		-- 设置初始值
		SET @SqlCID = dbo.ContentGetCID(@SqlValue);
		-- 没有找到该内容则继续寻找下一个
		IF @SqlCID <= 0
		BEGIN
			-- 是否依赖字典
			IF @SqlDictionary = 0 CONTINUE;
			-- 清理数值
			SET @SqlCID = 0;
			-- 查下词典
			IF dbo.LookupDictionary(@SqlValue) IS NULL CONTINUE;
		END

		-- 设置索引
		SET @SqlIndex = @SqlIndex + 1;
		-- 设置位置
		SET @SqlPosition = @SqlPosition - LEN(@SqlValue);
		-- 设置结果
		SET @SqlResult = '<var id="*' + CONVERT(NVARCHAR(MAX), @SqlIndex) +
			'" name="*' + dbo.GetLowercase(@SqlIndex) +
			'" pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) +
			'" cid="' + CONVERT(NVARCHAR(MAX), @SqlCid) + '">' + @SqlValue + '</var>' + @SqlResult;
		-- 重置参数
		SET @SqlContent = LEFT(@SqlContent, LEN(@SqlContent) - @SqlCount); SET @SqlCount = LEN(@SqlContent) + 1;
		-- PRINT 'BMMSplit>找到匹配（cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + '，“' + @SqlValue + '”）！';
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
		-- 更换参数名称
		SET @SqlResult = REPLACE(@SqlResult,
							'name="*' + dbo.GetLowercase(@SqlIndex) + '"',
							'name="' + dbo.GetLowercase(@SqlCount - @SqlIndex + 1) + '"');
		-- 更换标识编号
		SET @SqlResult = REPLACE(@SqlResult,
							'id="*' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '"',
							'id="' + CONVERT(NVARCHAR(MAX), @SqlCount - @SqlIndex + 1) + '"');
	END
	-- 分解成功
	RETURN CONVERT(XML, '<result id="1" met="BMM" count="' + CONVERT(NVARCHAR(MAX), @SqlIndex) + '">' + @SqlResult + '</result>');
END
GO
