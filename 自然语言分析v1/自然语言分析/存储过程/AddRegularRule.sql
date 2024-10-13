USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[AddGeneralRule]    Script Date: 2020/12/6 18:42:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年11月30日>
-- Description:	<加入正则关系规则>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[AddRegularRule]
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
	-- 检查规则
	EXEC @SqlResult = dbo.AddLogicRule @SqlRule, '正则';
	-- 返回结果
	RETURN @SqlResult;
END
GO

