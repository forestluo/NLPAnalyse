USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[AddSentenceRule]    Script Date: 2020/12/6 18:43:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<加入句子关系规则>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[AddSentenceRule]
(
	-- Add the parameters for the function here
	@SqlRule UString
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlResult INT = 0;
	-- 增加关系规则
	EXEC @SqlResult = dbo.AddParseRule @SqlRule, '单句';
	-- 返回结果
	RETURN @SqlResult;
END
GO

