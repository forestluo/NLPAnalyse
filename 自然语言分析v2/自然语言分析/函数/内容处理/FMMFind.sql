USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[FMMFind]    Script Date: 2020/12/6 10:53:37 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<使用正向最大匹配搜索>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[FMMFind]
(
	-- Add the parameters for the function here
	@SqlPosition INT,
	@SqlDictionary INT,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN

	-- 声明临时变量
	DECLARE @SqlCID INT;
	DECLARE @SqlRight INT;
	DECLARE @SqlValue UString;

	-- 剪裁
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查参数
	IF @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');
	-- 检查终结符号
	-- 包括空，单字
	-- 终结符拒绝进一步分割
	IF LEN(@SqlContent) = 1 OR @SqlPosition >= LEN(@SqlContent)
		RETURN CONVERT(XML, '<result id="-2">it is a terminator</result>');

	-- 设置初始值
	SET @SqlCID = 0;
	SET @SqlRight = LEN(@SqlContent) + 1;
	-- 循环处理
	WHILE @SqlRight > @SqlPosition + 1
	BEGIN
		-- 设置计数器
		SET @SqlRight = @SqlRight - 1;
		-- 获得左侧最大内容
		SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition + 1, @SqlRight - @SqlPosition);

		-- 设置初始值
		SET @SqlCID = dbo.ContentGetCID(@SqlValue);
		-- 没有找到该内容则继续寻找下一个
		IF @SqlCID > 0 BREAK;
		ELSE
		BEGIN
			-- 是否依赖字典
			IF @SqlDictionary = 0 CONTINUE;
			-- 查询字典
			IF dbo.LookupDictionary(@SqlValue) IS NOT NULL BEGIN SET @SqlCID = 1; BREAK; END
		END
	END
	-- 检查结果
	-- 存在有无法识别的内容
	IF @SqlCID <= 0
		RETURN CONVERT(XML, '<result id="-3">something unrecognized</result>');
	-- 搜索成功
	RETURN CONVERT(XML, '<result id="1" met="FMM" pos="' + CONVERT(NVARCHAR(MAX), @SqlRight) + '">' + @SqlValue + '</result>');
END
GO
