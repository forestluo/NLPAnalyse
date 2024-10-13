USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[XMLEscape]    Script Date: 2020/12/6 9:54:40 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<对特殊字符进行转义处理>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[XMLEscape]
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
	-- 检查参数
	IF @SqlValue IS NULL RETURN NULL;
	-- 将字符串转义
	-- 将&优先转换，避免后续重复叠加转换
	IF CHARINDEX('&', @SqlValue) > 0
		SET @SqlValue = REPLACE(@SqlValue, '&', '&amp;');
	-- 将字符串转义
	IF CHARINDEX('<', @SqlValue) > 0
		SET @SqlValue = REPLACE(@SqlValue, '<', '&lt;');
	IF CHARINDEX('>', @SqlValue) > 0
		SET @SqlValue = REPLACE(@SqlValue, '>', '&gt;');
	IF CHARINDEX('"', @SqlValue) > 0
		SET @SqlValue = REPLACE(@SqlValue, '"', '&quot;');
	IF CHARINDEX('''', @SqlValue) > 0
		SET @SqlValue = REPLACE(@SqlValue, '''', '&apos;');
	-- 将字符串转义
	RETURN REPLACE(@SqlValue, ' ', '&#x20;');
END
GO

