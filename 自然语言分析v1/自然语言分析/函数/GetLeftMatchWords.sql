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
-- Create date: <2020年12月21日>
-- Description:	<寻找左侧匹配的词汇>
-- =============================================
CREATE OR ALTER FUNCTION GetLeftMatchWords 
(
	-- Add the parameters for the function here
	@SqlBase UString
)
RETURNS XML
AS
BEGIN
	--声明临时变量
	DECLARE @SqlOID INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlWord UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlContent UString;
	DECLARE @SqlTable UMatchTable;

	-- 剪裁
	SET @SqlBase = TRIM(@SqlBase);
	-- 检查变量
	IF @SqlBase IS NULL OR LEN(@SqlBase) <= 0
	BEGIN
		RETURN CONVERT(XML, '<result id="-1">input is null.</result>');
	END

	-- 设置初始值
	SET @SqlPosition = 1;
	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT oid, cid, content FROM dbo.OuterContent
			WHERE classification = '原句' AND content like ('%' + @SqlBase + '%');
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 寻找匹配的项目
		SET @SqlIndex =
			CHARINDEX(@SqlBase, @SqlContent, @SqlPosition);
		-- 检查结果
		IF @SqlIndex IS NOT NULL AND @SqlIndex > 0
		BEGIN
			-- 截取部分内容
			SET @SqlValue =
				LEFT(@SqlContent, @SqlIndex - 1);
			-- 检查结果
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				-- 设置初始值
				SET @SqlStart = 0;
				-- 寻找匹配的字符
				WHILE @SqlStart < LEN(@SqlValue)
				BEGIN
					-- 修改计数器
					SET @SqlStart = @SqlStart + 1;
					-- 获得匹配的字符
					SET @SqlWord = RIGHT(@SqlValue, LEN(@SqlValue) - @SqlStart + 1);
					-- 获得CID
					SET @SqlCID = dbo.GetContentID(@SqlWord);
					-- 检查结果
					IF @SqlCID > 0
					BEGIN
						-- 将结果插入到记录表之中
						INSERT INTO @SqlTable
							(expression, value, length, position)
							VALUES (CONVERT(NVARCHAR(MAX), @SqlCID), @SqlWord, LEN(@SqlWord), @SqlStart); BREAK;
					END
				END
			END
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 去掉重复的内容
	DELETE FROM @SqlTable
		WHERE id NOT IN (SELECT MIN(id) FROM @SqlTable GROUP BY value HAVING COUNT(0) > 1);
	-- 格式化输出
	SET @SqlContent =
	(
		(
			SELECT '<var id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
				'cid="' + expression + '" ' +
				'pos="' + CONVERT(NVARCHAR(MAX), position) + '">' + value + '</var>'
				FROM @SqlTable FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- 返回结果
	RETURN CONVERT(XML, '<result id="1">' + @SqlContent + '</result>');
END
GO

