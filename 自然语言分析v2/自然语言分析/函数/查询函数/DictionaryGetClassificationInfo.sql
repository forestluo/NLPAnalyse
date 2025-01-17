USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月7日>
-- Description:	<依据内容查询分类信息>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[DictionaryGetClassificationInfo]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlInfo UString;
	-- 查询结果
	SET @SqlInfo =
	(
		SELECT (classification + '；') FROM
			dbo.Dictionary WHERE content = @SqlContent FOR XML PATH('')
	);
	-- 返回结果
	RETURN @SqlInfo;
END
