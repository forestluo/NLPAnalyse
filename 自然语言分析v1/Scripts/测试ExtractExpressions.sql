DECLARE @SqlContent UString;
DECLARE @SqlClassification UString = NULL;

SET @SqlContent = ' 2018年9月13日 9月20日 9月 13日 430064';

BEGIN
	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlMatch INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlRule UString;
	DECLARE @SqlType UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlTable UMatchTable;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0
	BEGIN
		-- PRINT 'ExtractExpression> 无效输入！';
		GOTO END_OF_FUNCTION;
	END
	-- 将内容转换成半角
	SET @SqlContent = dbo.LatinConvert(@SqlContent);

	-- 声明游标
	IF @SqlClassification IS NULL
		OR LEN(@SqlClassification) <= 0
	BEGIN
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT rid, parse_rule, classification FROM dbo.LogicRule
				WHERE LEFT(classification, 2) = '正则' ORDER BY controllable_priority DESC;
	END
	ELSE
	BEGIN
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT rid, parse_rule, classification FROM dbo.LogicRule
				WHERE classification = @SqlClassification ORDER BY controllable_priority DESC;
	END
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlType;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 处理类型
		IF LEFT(@SqlType, 2) = '正则'
			SET @SqlType = RIGHT(@SqlType, LEN(@SqlType) - 2);
		-- 将结果插入到新的记录表中
		INSERT INTO @SqlTable
			(expression, value, length , position)
			SELECT @SqlType, Match, MatchLength, MatchIndex
				FROM dbo.RegExMatches(dbo.XMLUnescape(@SqlRule), @SqlContent, 1);
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlRule, @SqlType;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 检查参数
	IF @SqlClassification IS NULL
		OR LEN(@SqlClassification) <= 0
	BEGIN
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
	END

	-- 形成XML
	SET @SqlResult =
	(
		(
			SELECT '<exp type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position + 1) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	PRINT '<result id="1">' + @SqlResult + '</result>';
END
END_OF_FUNCTION:
GO

