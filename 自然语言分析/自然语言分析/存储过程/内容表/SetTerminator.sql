USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月8日>
-- Description:	<设置为终结符号>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[SetTerminator]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
AS
BEGIN
	-- 检查参数
	IF @SqlContent IS NULL RETURN 0;

	-- 声明临时变量
	DECLARE @SqlCID INT = -1;
	-- 执行查询语句
	SELECT @SqlCID = cid
		FROM dbo.InnerContent
		WHERE content = @SqlContent;
	-- 检查结果
	IF @SqlCID > 0 RETURN @SqlCID;

	-- 执行查询语句
	SELECT TOP 1 @SqlCID = cid
		FROM dbo.OuterContent
		WHERE content = @SqlContent;
	-- 检查结果
	IF @SqlCID <= 0 RETURN @SqlCID;

	-- 先插入数据
	INSERT INTO dbo.InnerContent
		(cid, classification, length, content)
		VALUES (@SqlCID, '文本', LEN(@SqlContent), @SqlContent);
	-- 删除原数据
	DELETE FROM dbo.OuterContent
		WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCID;
END
GO

