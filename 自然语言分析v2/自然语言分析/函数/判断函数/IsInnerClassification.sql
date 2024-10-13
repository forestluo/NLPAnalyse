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
-- Create date: <2020年12月19日>
-- Description:	<是否为InnerContent表分类>
-- =============================================

CREATE OR ALTER FUNCTION IsInnerClassification
(
	-- Add the parameters for the function here
	@SqlClassification UString
)
RETURNS INT
AS
BEGIN
	-- 返回结果
	RETURN CASE @SqlClassification
		WHEN '汉字'		THEN 1
		WHEN '标点符号' THEN 1
		WHEN '英文字母'	THEN 1
		WHEN '数学符号' THEN 1
		WHEN '编号序号' THEN 1
		WHEN '俄语字母' THEN 1
		WHEN '单位符号' THEN 1
		WHEN '特殊符号' THEN 1
		WHEN '制表符'	THEN 1
		WHEN '货币符号'	THEN 1
		WHEN '汉语拼音' THEN 1
		WHEN '符号图案' THEN 1
		WHEN '中文字符' THEN 1
		WHEN '希腊字母'	THEN 1
		WHEN '箭头符号' THEN 1
		WHEN '日文平假名片假名' THEN 1
		ELSE 0 END;
END
GO

