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
-- Create date: <2021��2��17��>
-- Description:	<��¼������쳣��Ϣ>
-- =============================================
CREATE OR ALTER PROCEDURE ResetException 
	-- Add the parameters for the stored procedure here
	@SqlEID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlEnd INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlContent UString;
	DECLARE @SqlMessage UString;

	-- ��ü�¼
	SELECT @SqlMessage = message
		FROM dbo.ExceptionLog WHERE eid = @SqlEID;
	-- PRINT '�����쳣��־> ' + @SqlMessage;

	-- ������Ϣ
	SET @SqlStart = PATINDEX('%(tid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- �����
	IF @SqlStart > 0
	BEGIN
		-- Ѱ�ҽ�β
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		-- PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- �����
		IF @SqlEnd > 0
		BEGIN
			-- ��ñ�ʶ����
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- ��ñ�ʶ
			SET @SqlID = CONVERT(INT, @SqlValue);
			-- ��ӡ
			-- PRINT '�����쳣��־> tid=' + @SqlValue; 

			-- ������־��ָ����
			UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL WHERE tid = @SqlID;
			-- ɾ������־��¼
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END

	-- ������Ϣ
	SET @SqlStart = PATINDEX('%(eid=%)%', @SqlMessage);
	-- PRINT 'Start = ' + CONVERT(NVARCHAR(MAX), @SqlStart);
	-- �����
	IF @SqlStart > 0
	BEGIN
		-- Ѱ�ҽ�β
		SET @SqlEnd = CHARINDEX(')', @SqlMessage, @SqlStart);
		-- PRINT 'End = ' + CONVERT(NVARCHAR(MAX), @SqlEnd);
		-- �����
		IF @SqlEnd > 0
		BEGIN
			-- ��ñ�ʶ����
			SET @SqlValue =
				SUBSTRING(@SqlMessage, @SqlStart + 5, @SqlEnd - @SqlStart - 5);
			-- ��ñ�ʶ
			SET @SqlID = CONVERT(INT, @SqlValue);
			-- ��ӡ
			-- PRINT '�����쳣��־> eid=' + @SqlValue;

			-- ������־��ָ����
			UPDATE dbo.ExternalContent SET type = 0 WHERE eid = @SqlID;
			-- ɾ������־��¼
			DELETE dbo.ExceptionLog WHERE eid = @SqlEID;
		END
	END
END
GO
