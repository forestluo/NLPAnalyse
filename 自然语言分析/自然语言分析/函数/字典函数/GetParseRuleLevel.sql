USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetRuleLevel]    Script Date: 2020/12/6 10:20:14 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月2日>
-- Description:	<获得匹配规则的优先级>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetParseRuleLevel]
(
	-- Add the parameters for the function here
	@SqlClassification UString
)
RETURNS INT
AS
BEGIN
	-- 返回数值
	RETURN CASE @SqlClassification
		-- 拼接优先，配对其次，通用和单句最后处理
		-- WHEN '替换' THEN 0
		WHEN '拼接' THEN 1
		WHEN '配对' THEN 2
		WHEN '单句' THEN 3
		WHEN '通用' THEN 4
		WHEN '复句' THEN 5
		ELSE 5 END;
END
GO

