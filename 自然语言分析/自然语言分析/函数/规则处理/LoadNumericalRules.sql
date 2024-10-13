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
-- Create date: <2020年12月23日>
-- Description:	<加载数量词解析规则>
-- =============================================

CREATE OR ALTER FUNCTION LoadNumericalRules
(
	-- Add the parameters for the function here
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlResult UString;

	DECLARE @SqlRID INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlAttribute UString;

	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<rule rid="' + CONVERT(NVARCHAR(MAX), rid) + '">' +
				ISNULL('<regular>' + dbo.XMLEscape([rule]) + '</regular>','') +
				ISNULL('<attribute>' + dbo.XMLEscape([attribute]) + '</attribute>', '') + '</rule>'
				FROM dbo.PhraseRule
				WHERE [classification] = '正则'
				ORDER BY rid DESC FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule], [attribute]
		FROM dbo.PhraseRule WHERE [classification] IN ('数词', '数量词')
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlAttribute;

	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 实现替换
		SET @SqlRule = dbo.RecoverRegularRule(@SqlRule);
		-- 拼接
		SET @SqlResult = @SqlResult +
			'<rule rid="' + CONVERT(NVARCHAR(MAX), @SqlRID) + '">' +
				ISNULL('<regular>' + dbo.XMLEscape(@SqlRule) + '</regular>','') +
				ISNULL('<attribute>' + dbo.XMLEscape(@SqlAttribute) + '</attribute>', '') + '</rule>'
		-- 取下一条记录 
		FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlAttribute;
	END

	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 

	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO

