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
-- Create date: <2020年12月27日>
-- Description:	<从字典中查询内容>
-- =============================================

CREATE OR ALTER FUNCTION LookupDictionary 
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明变量
	DECLARE @SqlResult UString;

	-- 检查输入
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN NULL;
	-- 形成结果
	SET @SqlResult = 
	(
		(
			SELECT '<item id="' + CONVERT(NVARCHAR(MAX), did) + '" ' +
				ISNULL('class="' + classification + '" ', '') +
				'count="' + CONVERT(NVARCHAR(MAX), count) + '">' +
				ISNULL(dbo.XMLEscape(remark), '') + '</item>' FROM dbo.Dictionary
				WHERE [enable] = 1 AND content = @SqlContent FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

