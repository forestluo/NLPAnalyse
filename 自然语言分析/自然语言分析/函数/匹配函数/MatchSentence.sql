USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[MatchSentence]    Script Date: 2020/12/6 20:03:04 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<解析句子>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[MatchSentence]
(
	-- Add the parameters for the stored procedure here
	@SqlContent UString
)
RETURNS XML
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlRID INT;
	DECLARE @SqlResult XML;
	DECLARE @SqlRule UString;
	DECLARE @SqlRemark UString;

	-- 剪裁文本行
	SET @SqlContent = TRIM(@SqlContent);
	-- 检查结果
	IF @SqlContent IS NULL
		OR LEN(@SqlContent) <= 0 RETURN NULL;

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT rid, [rule], xml_remark FROM dbo.ParseRule
			WHERE xml_remark IS NOT NULL AND minimum_length < LEN(@SqlContent) AND normalized = 1 AND classification = '单句'
			ORDER BY minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlRemark;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- PRINT '开始尝试匹配（' + CONVERT(NVARCHAR(MAX),@SqlRID) + ',"' + @SqlRule + '"）！';
		-- 解析XML
		SET @SqlResult = CONVERT(XML, @SqlRemark);
		-- 检查结果
		IF @SqlResult IS NOT NULL
		BEGIN
			-- 解析内容
			SET @SqlResult = dbo.XMLParseContent(@SqlResult, @SqlContent, 0);
			-- PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
			-- 检查结果
			IF @SqlResult IS NOT NULL AND
				@SqlResult.value('(//result/@id)[1]','int') = 1
				AND	@SqlResult.value('(//result/@start)[1]','int') = 1
			BEGIN
				-- 增加属性
				SET @SqlResult.modify('insert (attribute rid {sql:variable("@SqlRID")}) into ((//result[position()=1])[1])'); BREAK;
			END
		END
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlRID, @SqlRule, @SqlRemark;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	RETURN @SqlResult;
END
GO

