USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[XMLParseContent]    Script Date: 2020/12/6 10:55:00 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月1日>
-- Description:	<依据规则解析内容>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[XMLParseContent]
(
	-- Add the parameters for the function here
	@SqlRule XML,
	@SqlContent UString,
	@SqlAllowPunctuation INT = 0
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlType UString;
	DECLARE @SqlName UString;
	DECLARE @SqlValue UString;

	-- 声明临时表变量
	DECLARE @SqlMaxID INT;
	DECLARE @SqlPad UString;
	DECLARE @SqlPosition INT;
	DECLARE @SqlEndPosition INT;
	DECLARE @SqlTable UParseTable;

	-- 检查参数
	IF @SqlRule IS NULL
		OR @SqlContent IS NULL
		RETURN CONVERT(XML, '<result id="-1">input is null</result>');

	-- 先将内容选择插入至临时表
	INSERT INTO @SqlTable
		(id, type, name, value)
		SELECT nodeID, nodeType, nodeName, nodeValue FROM
		(
			SELECT
				Nodes.value('(@id)[1]','int') AS nodeID,
				Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
				Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
				FROM @SqlRule.nodes('//result/*') AS N(Nodes)
		) AS NodesTable ORDER BY nodeID;

	-- 设置初始值
	SET @SqlPosition = 1;
	-- 声明静态游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, type, name, value FROM @SqlTable
		WHERE type = 'var' OR type = 'pad' ORDER BY id;
	-- 打开游标
	OPEN SqlCursor;
	-- 获取一行记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;
	-- 检查结果
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查类型
		IF @SqlType = 'var'
		BEGIN
			-- 更新当前数值
			UPDATE @SqlTable SET pos = @SqlPosition WHERE id = @SqlID;
		END 
		-- 检查类型
		IF @SqlType = 'pad'
		BEGIN
			-- 检查结果
			IF ISNULL(LEN(@SqlValue), 0) <= 0
			BEGIN
				-- 返回结果
				RETURN CONVERT(XML, '<result id="-2">pad is null</result>');
			END
			-- 对匹配内容进行转义还原
			-- 主要面对特殊字符，例如：空格
			SET @SqlValue = dbo.XMLUnescape(@SqlValue);
			-- 查找匹配字符串
			SET @SqlPosition =
				CHARINDEX(@SqlValue, @SqlContent, @SqlPosition);
			-- 检查匹配结果
			IF ISNULL(@SqlPosition, 0) <= 0
			BEGIN
				-- 返回结果
				RETURN CONVERT(XML, '<result id="-3">no pad matched</result>');
			END
			-- 更新当前数值
			UPDATE @SqlTable SET pos = @SqlPosition WHERE id = @SqlID;
			-- 查找匹配字符串
			SET @SqlPosition = @SqlPosition + LEN(@SqlValue);
		END
		-- 获取一行记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlType, @SqlName, @SqlValue;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 设置初始值
	SET @SqlMaxID = 1;
	-- 获得最后一个ID
	SELECT @SqlMaxID = MAX(id) FROM @SqlTable;

	-- 声明静态游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT id, name, pos FROM @SqlTable
		WHERE type = 'var' ORDER BY id;
	-- 打开游标
	OPEN SqlCursor;
	-- 获取一行记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlName, @SqlPosition;
	-- 检查结果
	WHILE @@FETCH_STATUS = 0
	BEGIN
			-- 设置结尾位置
			SET @SqlEndPosition = LEN(@SqlContent) + 1;
			-- 是否有后续终结符
			-- 如果存在这样的终结符，就更改结尾位置
			SELECT TOP 1 @SqlEndPosition = pos FROM @SqlTable
				WHERE type = 'pad' AND id > @SqlID ORDER BY id;
			-- 截取字符串
			SET @SqlValue = SUBSTRING(@SqlContent, @SqlPosition, @SqlEndPosition - @SqlPosition);
			-- 检查是否允许并包含有标点符号
			IF @SqlAllowPunctuation = 0 AND dbo.HasPunctuation(@SqlValue) = 1
			BEGIN
				-- 是否为第一个var
				IF @SqlID = 1
				BEGIN
					-- 截取最近的一串字符
					WHILE dbo.HasPunctuation(@SqlValue) = 1
					BEGIN
						-- 更新位置
						SET @SqlPosition = @SqlPosition + 1;
						-- 截取字符串
						SET @SqlValue = RIGHT(@SqlValue, LEN(@SqlValue) - 1);
					END
					-- 检查结果
					IF LEN(@SqlValue) <= 0
					BEGIN
						-- 返回结果
						RETURN CONVERT(XML, '<result id="-5">empty var</result>');
					END
					-- 更新位置
					UPDATE @SqlTable SET pos = @SqlPosition WHERE id = @SqlID;
				END
				-- 是否为最后一个var
				ELSE IF @SqlID = @SqlMaxID
				BEGIN
					-- 截取最近的一串字符
					WHILE dbo.HasPunctuation(@SqlValue) = 1
					BEGIN
						-- 更新位置
						SET @SqlEndPosition = @SqlEndPosition - 1;
						-- 截取字符串
						SET @SqlValue = LEFT(@SqlValue, LEN(@SqlValue) - 1);
					END
					-- 检查结果
					IF LEN(@SqlValue) <= 0
					BEGIN
						-- 返回结果
						RETURN CONVERT(XML, '<result id="-5">empty var</result>');
					END
				END
				ELSE
				BEGIN
					-- 返回结果
					RETURN CONVERT(XML, '<result id="-4">interrupted by punctuation</result>');
				END
			END
			-- 更改当前节点内容
			UPDATE @SqlTable SET value = @SqlValue WHERE id = @SqlID;
		-- 获取一行记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlName, @SqlPosition;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 定义临时变量
	DECLARE @SqlResult UString;
	-- 设置结果值
	SET @SqlResult = dbo.FormatParseResult(@SqlTable);
	-- 获得开始位置
	SET @SqlPosition = 1;
	SELECT @SqlPosition = pos FROM @SqlTable
		WHERE id IN (SELECT MIN(id) FROM @SqlTable);
	-- 获得结束位置
	SET @SqlEndPosition = LEN(@SqlContent) + 1;
	SELECT @SqlEndPosition = pos, @SqlValue = value FROM @SqlTable
		WHERE id IN (SELECT MAX(id) FROM @SqlTable);
	-- 修改结束位置
	-- 对可能存在转义内容的字符串求长度
	SET @SqlEndPosition = @SqlEndPosition + ISNULL(LEN(@SqlValue), 0);
	-- 将结果记录插入到首个节点之中。
	SET @SqlResult = '<result id="1" start="' + CONVERT(NVARCHAR(MAX), @SqlPosition) + '" ' +
				'end="' + CONVERT(NVARCHAR(MAX), @SqlEndPosition) + '">' + @SqlResult + '</result>';
	-- 返回结果
	RETURN CONVERT(NVARCHAR(MAX), @SqlResult);
END
GO
