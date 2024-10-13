USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年2月17日>
-- Description:	<记录捕获的异常信息>
-- =============================================
CREATE OR ALTER PROCEDURE ResetException 
	-- Add the parameters for the stored procedure here
	@SqlEID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlContent UString;
	DECLARE @SqlMessage UString;

	-- 获得记录
	SELECT @SqlMessage = message
		FROM dbo.ExceptionLog WHERE eid = @SqlEID;
	-- PRINT '清理异常日志> ' + @SqlMessage;

	-- 解析消息
	SET @SqlStart = PATINDEX('%(tid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- 检查结果
	IF @SqlStart > 0
	BEGIN
		-- 寻找结尾
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		-- PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- 检查结果
		IF @SqlEnd > 0
		BEGIN
			-- 获得标识内容
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- 获得标识
			SET @SqlID = CONVERT(INT, @SqlValue);
			-- 打印
			-- PRINT '清理异常日志> tid=' + @SqlValue; 

			-- 更新日志所指语料
			UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL WHERE tid = @SqlID;
			-- 删除该日志记录
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END

	-- 解析消息
	SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- 检查结果
	IF @SqlStart > 0
	BEGIN
		-- 寻找结尾
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		-- PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- 检查结果
		IF @SqlEnd > 0
		BEGIN
			-- 获得标识内容
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- 获得标识
			SET @SqlID = CONVERT(INT, @SqlValue);
			-- 打印
			-- PRINT '清理异常日志> eid=' + @SqlValue;

			-- 更新日志所指语料
			UPDATE dbo.ExternalContent SET type = 0 WHERE eid = @SqlID;
			-- 删除该日志记录
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END
END
GO
