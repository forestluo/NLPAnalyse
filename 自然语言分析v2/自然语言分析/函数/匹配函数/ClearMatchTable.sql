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
-- Create date: <2021年2月16日>
-- Description:	<清理匹配结果表>
-- =============================================

CREATE OR ALTER FUNCTION ClearMatchTable
(	
	-- Add the parameters for the function here
	@SqlExpressions XML
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlMID INT;
	DECLARE @SqlMatch INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlAttribute UString;

	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlExpressions IS NULL OR
		ISNULL(@SqlExpressions.value('(//result/@id)[1]', 'int'), 0) <= 0
		RETURN CONVERT(NVARCHAR(MAX), '<result id="-1">invalid expressions</result>');

	-- 插入到临时表中
	INSERT INTO @SqlTable
		(expression, length, position, value)
		SELECT
			Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
			ISNULL(Nodes.value('(@len)[1]', 'int'), 0) AS nodeLen,
			ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
			Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
			FROM @SqlExpressions.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;
		
	-- 设置初始值
	SET @SqlMatch = 1;
	-- 循环处理
	WHILE @SqlMatch > 0
	BEGIN
		-- 设置初始值
		SET @SqlMatch = 0;
		-- 多个正则同时处理时才会出现相互重叠问题
		-- 清理相互重叠的解析结果（保长去短）
		-- 声明游标
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT id, length, position	FROM @SqlTable ORDER BY length;
		-- 打开游标
		OPEN SqlCursor;
		-- 取第一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
		-- 循环处理游标
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 检查结果
			IF EXISTS
				(SELECT * FROM @SqlTable WHERE
					@SqlID <> id AND
					@SqlPosition >= position AND
					(@SqlPosition + @SqlLength <= position + length))
			BEGIN
				-- 设置标记位
				SET @SqlMatch = 1;
				-- 删除该条被包括的数据
				DELETE FROM @SqlTable WHERE id = @SqlID;
			END
			-- 取下一条记录
			FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
		END
		-- 关闭游标
		CLOSE SqlCursor;
		-- 释放游标
		DEALLOCATE SqlCursor;
	END

	-- 设置初始值
	SET @SqlMatch = 1;
	-- 循环处理
	WHILE @SqlMatch > 0
	BEGIN
		-- 设置初始值
		SET @SqlMatch = 0;
		-- 多个正则同时处理时才会出现相互重叠问题
		-- 清理相互重叠的解析结果（融合搭界）
		-- 声明游标
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
		-- 打开游标
		OPEN SqlCursor;
		-- 取第一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
		-- 循环处理游标
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 设置初始值
			SET @SqlMID = -1;
			-- 查询记录
			SELECT TOP 1 @SqlMID = id FROM @SqlTable WHERE
				@SqlID <> id AND
				@SqlPosition < position AND
				(@SqlPosition + @SqlLength > position) AND
				(@SqlPosition + @SqlLength < position + length) ORDER BY position;
			-- 检查结果
			IF @SqlMID > 0
			BEGIN
				-- 设置标记位
				SET @SqlMatch = 1;
				-- 更新数据
				UPDATE @SqlTable SET
					position = @SqlPosition,
					length = position - @SqlPosition + length,
					value = LEFT(@SqlValue, position - @SqlPosition) + value,
					expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
					WHERE id = @SqlMID;
				-- 删除该条被包括的数据
				DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
			END
			-- 取下一条记录
			FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
		END
		-- 关闭游标
		CLOSE SqlCursor;
		-- 释放游标
		DEALLOCATE SqlCursor;
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
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
