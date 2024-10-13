USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
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
-- Create date: <2021年1月31日>
-- Description:	<提取内容中的所有词汇>
-- =============================================

CREATE OR ALTER FUNCTION ExtractAllWords
(	
	-- Add the parameters for the function here
	@SqlDictionary INT,
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlFindResult XML;
	-- 声明临时变量
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractPhrases> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理游标
	WHILE @SqlPosition < LEN(@SqlContent)
	BEGIN
		-- 修改位置
		SET @SqlPosition = @SqlPosition + 1;
		-- 查询结果
		SET @SqlFindResult = dbo.WMMFind(@SqlPosition, @SqlDictionary, @SqlContent);
		-- 检查结果
		IF @SqlFindResult IS NOT NULL
		BEGIN
			-- 检查结果
			IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
			BEGIN
				-- 获得结果
				SET @SqlStart = @SqlFindResult.value('(//result/@pos)[1]', 'INT');
				SET @SqlValue = @SqlFindResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
				-- 检查结果
				IF @SqlPosition IS NOT NULL AND @SqlValue IS NOT NULL
				BEGIN
					-- 插入数据
					IF NOT EXISTS (SELECT * FROM @SqlTable WHERE position = @SqlStart AND value = @SqlValue)
					INSERT INTO @SqlTable (expression, value, length , position) VALUES ('分词', @SqlValue, LEN(@SqlValue), @SqlStart);
				END
			END
		END
	END

	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<exp id="' + CONVERT(NVARCHAR(MAX),id) + '" type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN dbo.ClearMatchTable(CONVERT(XML, '<result id="1">' + @SqlResult + '</result>'));
END
GO
