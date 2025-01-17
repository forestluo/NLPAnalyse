USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月17日>
-- Description:	<清理语料内容>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[ClearTextContent]
(
	-- Add the parameters for the function here
	@SqlTID INT
)
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlContent UString;

	-- 查询内容
	SELECT @SqlContent = content
		FROM dbo.TextPool WHERE tid = @SqlTID;
	-- 清理内容
	SET @SqlContent = dbo.ClearInvisible(@SqlContent);
	-- 更新语料
	UPDATE dbo.TextPool
		SET length = LEN(@SqlContent), content = @SqlContent WHERE tid = @SqlTID;
	-- 返回结果
	RETURN @SqlTID;
END
