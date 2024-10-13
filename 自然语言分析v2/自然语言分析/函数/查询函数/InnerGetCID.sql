USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��9��>
-- Description:	<�Ƿ�������ڲ�������>
-- =============================================

CREATE OR ALTER FUNCTION InnerGetCID
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlCID INT = -1;
	-- ִ�в�ѯ���
	SELECT TOP 1 @SqlCID = cid
		FROM dbo.InnerContent
		WHERE content = @SqlContent;
	-- ���ؽ��
	RETURN CASE WHEN @SqlCID > 0 THEN @SqlCID ELSE 0 END;
END
GO

