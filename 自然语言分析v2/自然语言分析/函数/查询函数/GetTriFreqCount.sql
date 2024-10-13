USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月6日>
-- Description:	<获得内容的三段词频>
-- =============================================

CREATE OR ALTER FUNCTION GetTriFreqCount
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlLength INT;
	DECLARE @SqlResult UString;
	DECLARE @SqlPattern UString;

	-- 检查输入参数
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	-- 设置长度
	SET @SqlLength = LEN(@SqlContent);
	SET @SqlPattern = '%' + @SqlContent + '%';
	-- 查询结果
	SET @SqlResult =
	(
		(
			SELECT '<freq type="' + 
				(CASE position
				WHEN 1 THEN 'prefix'
				WHEN 2 THEN 'middle'
				WHEN 3 THEN 'suffix'
				ELSE 'unknown' END) + '">' + CONVERT(NVARCHAR(MAX), SUM(count)) + '</freq>'
			FROM
			(
				SELECT
				(
					CASE
					WHEN LEFT(content,@SqlLength) = @SqlContent THEN 1
					WHEN RIGHT(content,@SqlLength) = @SqlContent THEN 3 ELSE 2 END
				) AS position,content,count
				FROM
				(
					SELECT DISTINCT content, count FROM dbo.Dictionary
					WHERE enable = 1 AND PATINDEX(@SqlPattern, content) > 0 AND content <> @SqlContent AND count > 0
				) AS T
			) AS T1
			GROUP BY position ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1" count="' + CONVERT(NVARCHAR(MAX), dbo.GetFreqCount(@SqlContent)) + '">' + @SqlResult + '</result>');
END
GO
