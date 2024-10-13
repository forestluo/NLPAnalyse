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
-- Description:	<提取内容中的相关词汇>
-- =============================================

CREATE OR ALTER FUNCTION ExtractAttributeWords
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
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlFindResult XML;
	-- 声明临时变量
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractAttributeWords> 无效输入！';
		RETURN CONVERT(XML, '<result id="-1"/>');
	END
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 拼接内容
	SET @SqlRule =
	(
		(
			SELECT content + '|'
				FROM
				(
					SELECT DISTINCT(content) AS content
						FROM dbo.WordAttribute WHERE classification = '功能词'
				) AS T
				ORDER BY LEN(content) DESC, content FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- 修正结果
	SET @SqlRule = '(' + LEFT(@SqlRule, LEN(@SqlRule) - 1) + ')';
	-- 将结果插入到新的记录表中
	INSERT INTO @SqlTable
		(expression, value, length , position)
		SELECT '功能词', Match, MatchLength, MatchIndex + 1
			FROM dbo.RegExMatches(@SqlRule, @SqlContent, 1);

	-- 更新
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT id, position, value FROM @SqlTable ORDER BY position;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 查询结果
		SET @SqlFindResult = dbo.WMMFind(@SqlPosition, @SqlDictionary, @SqlContent);
		-- 检查结果
		IF @SqlFindResult IS NOT NULL
		BEGIN
			-- 检查结果
			IF @SqlFindResult.value('(//result/@id)[1]', 'INT') = 1
			BEGIN
				-- 获得结果
				SET @SqlPosition = @SqlFindResult.value('(//result/@pos)[1]', 'INT');
				SET @SqlValue = @SqlFindResult.value('(//result/text())[1]', 'NVARCHAR(MAX)');
				-- 检查结果
				IF @SqlPosition IS NOT NULL AND @SqlValue IS NOT NULL
				BEGIN
					-- 更新数据
					UPDATE @SqlTable
					SET position = @SqlPosition, length = LEN(@SqlValue), value = @SqlValue WHERE id = @SqlID;
				END
			END
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlPosition, @SqlValue;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

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
