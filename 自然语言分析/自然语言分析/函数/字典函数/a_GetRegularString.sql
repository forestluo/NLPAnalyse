USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月11日>
-- Description:	<获得匹配正则规则>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetRegularString]
(
	-- Add the parameters for the function here
	@SqlType UString
)
RETURNS UString
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;

	-- 检查类型
	IF @SqlType = '$a'
		RETURN '(((?!(，|：|；|…|—|《|》|\。|\？|\！|\s)).)*)';
	ELSE IF @SqlType = '$b'
		RETURN '(((?!(，|：|；|…|—|《|》|\。|\？|\！|\s)).)+)';
	ELSE IF @SqlType = '$c'
		RETURN '[一|二|三|四|五|六|七|八|九]';
	ELSE IF @SqlType = '$d'
		RETURN '(-?[1-9]\d*|0)';
	ELSE IF @SqlType = '$e'
		RETURN '[A-Za-z]';
	ELSE IF @SqlType = '$f'
		RETURN '(-?([1-9]\d*|[1-9]\d*\.\d+|0\.\d+))';
	ELSE IF @SqlType = '$n'
		RETURN '(\d+)';
	ELSE IF @SqlType = '$s'
		RETURN '[A-Za-z]+[A-Za-z'' ]*';
	ELSE IF @SqlType = 'parameter'
		RETURN '(((?!(，|：|；|…|—|\。|\？|\！)).)+)';
	ELSE IF @SqlType = '$q'
	BEGIN
		-- 拼接字符串
		SET @SqlResult = 
		(
			(
				SELECT content + '|'
					FROM
					(
						SELECT DISTINCT(content) AS content
							FROM dbo.WordAttribute
							WHERE classification = '实词' AND attribute = '量词'
					) AS T
					ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		)
		-- 修正规则
		SET @SqlResult = '(' + LEFT(@SqlResult, LEN(@SqlResult) - 1) + ')';
	END
	ELSE IF @SqlType = '$u'
	BEGIN
		-- 拼接字符串
		SET @SqlResult = 
		(
			(
				SELECT content + '|'
					FROM
					(
						SELECT DISTINCT(content) AS content
							FROM dbo.WordAttribute
							WHERE classification = '实词' AND attribute = '单位'
					) AS T
					ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		)
		-- 修正规则
		SET @SqlResult = '(' + LEFT(@SqlResult, LEN(@SqlResult) - 1) + ')';
	END
	ELSE IF @SqlType = '$v'
	BEGIN
		-- 拼接字符串
		SET @SqlResult = 
		(
			(
				SELECT content + '|'
					FROM
					(
						SELECT DISTINCT(content) AS content
							FROM dbo.WordAttribute
							WHERE classification = '符号' AND attribute = '单位'
					) AS T
					ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		)
		-- 修正规则
		SET @SqlResult = '(' + LEFT(@SqlResult, LEN(@SqlResult) - 1) + ')';
	END
	ELSE IF @SqlType = '$y'
	BEGIN
		-- 拼接字符串
		SET @SqlResult = 
		(
			(
				SELECT content + '|'
					FROM
					(
						SELECT DISTINCT(content) AS content
							FROM dbo.WordAttribute
							WHERE classification = '实词' AND attribute = '货币'
					) AS T
					ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		)
		-- 修正规则
		SET @SqlResult = '(' + LEFT(@SqlResult, LEN(@SqlResult) - 1) + ')';
	END
	ELSE IF @SqlType = '$z'
	BEGIN
		-- 拼接字符串
		SET @SqlResult = 
		(
			(
				SELECT content + '|'
					FROM
					(
						SELECT DISTINCT(content) AS content
							FROM dbo.WordAttribute
							WHERE classification = '符号' AND attribute = '货币'
					) AS T
					ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
		)
		-- 修正规则
		SET @SqlResult = '(' + LEFT(@SqlResult, LEN(@SqlResult) - 1) + ')';
	END
	-- 返回结果
	RETURN @SqlResult;
END
GO

