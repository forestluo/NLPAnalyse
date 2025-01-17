USE [nldb]
GO
/****** Object:  UserDefinedFunction [dbo].[InnerFMMSplit]    Script Date: 2020/12/21 18:52:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<使用正向最大匹配切分>
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[InnerFMMSplit]
(
	-- Add the parameters for the function here
	@SqlWord UString
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

	-- 检查参数
	IF @SqlWord IS NULL OR LEN(@SqlWord) = 1
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
	-- 检查终结符号
	-- 包括空，单字
	-- 终结符拒绝进一步分割
	IF dbo.IsTerminateWord(@SqlWord) > 0
		RETURN CONVERT(XML, '<result id="-2">it is a terminator</result>');

	--  设置初始值
	SET @SqlResult = '';
	-- PRINT 'InnerFMMSplit>开始分词（“' + @SqlWord + '”）！';
	-- 设置计数器
	SET @SqlIndex = 0;
	SET @SqlPosition = 1;
	SET @SqlCount = LEN(@SqlWord);
	-- 循环处理
	WHILE LEN(@SqlWord) >= 1 AND @SqlCount > 1
	BEGIN
		-- 设置计数器
		SET @SqlCount = @SqlCount - 1;
		-- 获得左侧最大内容
		SET @SqlValue = LEFT(@SqlWord, @SqlCount);

		-- 设置初始值
		SET @SqlCID = dbo.InnerExists(@SqlValue);
		-- 没有找到该内容则继续寻找下一个
		IF @SqlCid <= 0 CONTINUE;

		-- 设置索引
		SET @SqlIndex = @SqlIndex + 1;
		-- 设置结果
		SET @SqlResult = @SqlResult + '<var id="' + CONVERT(NVARCHAR(MAX), @SqlIndex) +
			'" name="' + dbo.GetLowercase(@SqlIndex) +
			'" pos="' + CONVERT(NVARCHAR(MAX), @SqlPosition) +
			'" cid="' + CONVERT(NVARCHAR(MAX), @SqlCid) + '">' + @SqlValue + '</var>';

		-- 设置位置
		SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		-- 重置参数
		SET @SqlWord = RIGHT(@SqlWord, LEN(@SqlWord) - @SqlCount); SET @SqlCount = LEN(@SqlWord) + 1;
		-- PRINT 'InnerFMMSplit>找到匹配（cid=' + CONVERT(NVARCHAR(MAX), @SqlCid) + '，“' + @SqlValue + '”）！';
	END
	-- 检查结果
	-- 存在有无法识别的内容
	IF LEN(@SqlWord) >= 1 AND @SqlCount <= 1
		RETURN CONVERT(XML, '<result id="-3">something unrecognized</result>');
	-- 分解成功
	RETURN CONVERT(XML, '<result id="1" met="FMM">' + @SqlResult + '</result>');
END
