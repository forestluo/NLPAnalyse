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
-- Author:		<�ވ�>
-- Create date: <2020��12��27��>
-- Description:	<��¼������쳣��Ϣ>
-- =============================================
CREATE OR ALTER PROCEDURE CatchException 
	-- Add the parameters for the stored procedure here
	@SqlTips UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ��ӡ��¼
	PRINT ISNULL(@SqlTips, '') + '> ' +
		'��Ϣ ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
		'���� ' + CONVERT(NVARCHAR(MAX), ERROR_NUMBER()) + ', ' +
		'״̬' + CONVERT(NVARCHAR(MAX), ERROR_STATE()) + ', ���� ' + ERROR_PROCEDURE() + ' ' +
		'��' + CONVERT(NVARCHAR(MAX), ERROR_LINE()) +	' [' + ERROR_MESSAGE() + ']';
	-- ����һ���쳣��¼
	INSERT INTO dbo.ExceptionLog (number, serverity, state, prodcedure, line, message)
		values(ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE() ,
		ISNULL(@SqlTips, '') + '> ' + ERROR_MESSAGE());
END
GO
