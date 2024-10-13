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
-- Create date: <2020年12月27日>
-- Description:	<记录捕获的异常信息>
-- =============================================
CREATE OR ALTER PROCEDURE CatchException 
	-- Add the parameters for the stored procedure here
	@SqlTips UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 打印记录
	PRINT ISNULL(@SqlTips, '') + '> ' +
		'消息 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
		'级别 ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
		'状态' + CONVERT(NVARCHAR(MAX), ERROR_STATE()) + ', 过程 ' + ERROR_PROCEDURE() + ' ' +
		'行' + CONVERT(NVARCHAR(MAX), ERROR_LINE()) +	' [' + ERROR_MESSAGE() + ']';
	-- 插入一条异常记录
	INSERT INTO dbo.ExceptionLog (number, serverity, state, prodcedure, line, message)
		values(ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE() ,
		ISNULL(@SqlTips, '') + '> ' + ERROR_MESSAGE());
END
GO
