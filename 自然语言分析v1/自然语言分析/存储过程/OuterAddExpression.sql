USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[OuterAddExpression]    Script Date: 2020/12/14 15:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月15日>
-- Description:	<加入一条正则表达式内容到外部内容库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[OuterAddExpression]
	-- Add the parameters for the stored procedure here
	@SqlExpression UString,
	@SqlRule UString = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlRuleID INT;
	DECLARE @SqlContentID INT;

	DECLARE @SqlName UString;
	DECLARE @SqlValue UString;

	-- 检查参数
	IF @SqlExpression IS NULL
		OR LEN(@SqlExpression) <= 0
	BEGIN
		PRINT 'OuterAddExpression(result=-1):> 输入为空！'; RETURN -1;
	END
	-- 检查参数
	IF dbo.IsTooLong(@SqlExpression) = 1
	BEGIN
		PRINT 'OuterAddExpression(result=-2):> 表达式太长！'; RETURN -2;
	END
	-- 检查重复性
	SET @SqlContentID = dbo.GetContentID(@SqlExpression);
	-- 检查结果
	IF @SqlContentID > 0 RETURN @SqlContentID; /*直接返回已存在cid标识*/
	-- 设置初始值
	SET @SqlContentID = NEXT VALUE FOR ContentSequence;
	-- 插入一条记录
	INSERT INTO dbo.OuterContent
		(cid, classification, content, length, parse_rule, content_hash, parse_rule_hash, a_id)
		VALUES
		(@SqlContentID, '表达式', @SqlExpression, LEN(@SqlExpression), @SqlRule, dbo.GetHash(@SqlExpression), dbo.GetHash(@SqlRule), -1);
	-- 检查结果
	-- PRINT 'OuterAddExpression(result=' + CONVERT(NVARCHAR(MAX), @SqlContentID) + ')> ' + @SqlExpression;
	-- 返回成功
	RETURN @SqlContentID;
END
