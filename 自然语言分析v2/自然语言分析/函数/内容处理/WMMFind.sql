USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[WPMMFind]    Script Date: 2021/1/31 10:53:37 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月31日>
-- Description:	<使用窗口最大匹配搜索>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[WMMFind]
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
	DECLARE @SqlLeft INT;
	DECLARE @SqlWidth INT;
	DECLARE @SqlResult XML;

	DECLARE @SqlMatch INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlValue UString;

	-- 剪裁
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查参数
	IF @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	-- 获得宽度
	SET @SqlWidth = LEN(@SqlContent) - @SqlPosition + 1;
	IF @SqlWidth < @SqlPosition SET @SqlWidth = @SqlPosition;

	-- 设置初始值
	SET @SqlMatch = 0;
	SET @SqlStart = 0;
	-- 循环处理
	WHILE @SqlWidth >= 2
	BEGIN
		-- 最大匹配搜索
		SET @SqlResult = dbo.WPMMFind(@SqlPosition, @SqlWidth, @SqlDictionary, @SqlContent);
		-- 检查结果
		IF @SqlResult IS NOT NULL
		BEGIN
			-- 检查结果
			IF @SqlResult.value('(//result/@id)[1]', 'INT') = 1
			BEGIN
				-- 获得结果
				SET @SqlStart = @SqlResult.value('(//result/@pos)[1]', 'INT');
				SET @SqlValue = @SqlResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
				-- 检查结果
				IF @SqlStart IS NOT NULL AND @SqlValue IS NOT NULL BEGIN SET @SqlMatch = 1; BREAK; END
			END
		END
		-- 收缩宽度
		SET @SqlWidth = @SqlWidth - 1;
	END
	-- 检查结果
	-- 存在有无法识别的内容
	IF @SqlMatch <= 0
		RETURN CONVERT(XML, '<result id="-2">something unrecognized</result>');
	-- 搜索成功
	RETURN CONVERT(XML, '<result id="1" met="WMM" pos="' + CONVERT(NVARCHAR(MAX), @SqlStart) + '">' + @SqlValue + '</result>');
END
GO
