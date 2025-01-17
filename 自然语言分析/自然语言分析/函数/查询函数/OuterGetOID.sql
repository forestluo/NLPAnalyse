USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[OuterGetOID]    Script Date: 2020/12/9 16:08:42 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月9日>
-- Description:	<是否存在于外部内容中>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[OuterGetOID]
(
	-- Add the parameters for the function here
	@SqlContent UString,
	@SqlRule UString = NULL
)
RETURNS INT
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlOID INT = -1;

	-- 检查参数
	IF @SqlContent IS NULL
		RETURN 0;
	-- 检查参数
	IF @SqlRule IS NULL	OR
		LEN(@SqlRule) <= 0
	BEGIN
		-- 执行查询语句
		SELECT TOP 1 @SqlOID = oid
			FROM dbo.OuterContent
			WHERE content = @SqlContent
				AND [rule] IS NULL;
	END
	ELSE
	BEGIN
		-- 执行查询语句
		SELECT TOP 1 @SqlOID = oid
			FROM dbo.OuterContent
			WHERE content = @SqlContent
				AND [rule] = @SqlRule;
	END
	-- 返回结果
	RETURN CASE WHEN @SqlOID > 0 THEN @SqlOID ELSE 0 END;
END
