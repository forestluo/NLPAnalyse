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
-- Author:		<ÂÞˆÒ>
-- Create date: <2020Äê12ÔÂ27ÈÕ>
-- Description:	<Íù±íÖÐÔö¼Ó¹ýÂË¹æÔò>
-- =============================================

CREATE OR ALTER PROCEDURE [¼ÓÔØFilterRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ³õÊ¼»¯¹ýÂË¹æÔò
	-- ÆäÖÐb´ú±í¿Õ°××Ö·û
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'bbb', 'b'; /*Èý¸ö¿Õ¸ñ¸ü»»³ÉÒ»¸ö¿Õ¸ñ*/
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡£¡£¡£', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£¬£¬', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£¡£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£¿£¿', '£¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£®£®£®', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡«¡«¡«', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '---', '¡ª';
	-- EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '~~~', '¡­';
	-- EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '...', '¡­';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'bb', 'b'; /*Á½¸ö¿Õ¸ñ¸ü»»³ÉÒ»¸ö¿Õ¸ñ*/
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬b', '£¬';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£¬', '£¬';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£ºb', '£º';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£º', '£º';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡£b', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡£', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»b', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£»', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡b', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿b', '£¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£¿', '£¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢b', '¡¢';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡¢', '¡¢';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡ªb', '¡ª';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡ª', '¡ª';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡«b', '¡«';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡«', '¡«';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡­b', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡­', '¡­';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¨b', '£¨';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b£¨', '£¨';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', ')b', ')';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b)', ')';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¶b', '¡¶';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡¶', '¡¶';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡·b', '¡·';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡·', '¡·';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡´b', '¡´';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡´', '¡´';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡µb', '¡µ';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡µ', '¡µ';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¾b', '¡¾';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡¾', '¡¾';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¿b', '¡¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡¿', '¡¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡°b', '¡°';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡°', '¡°';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡±b', '¡±';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡±', '¡±';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡®b', '¡®';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡®', '¡®';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¯b', '¡¯';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', 'b¡¯', '¡¯';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '--', '¡ª';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡«¡«', '¡«';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡ª¡ª', '¡ª';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡­¡­', '¡­';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢£¬', '£¬';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢£º', '£º';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢¡£', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢£»', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡¢£¿', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£¬', '£¬';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º£¬', '£º';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡££¬', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»£¬', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£¬', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£¬', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£º', '£¬';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º£º', '£º';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡££º', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»£º', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£º', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£º', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬¡£', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º¡£', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡£¡£', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»¡£', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡¡£', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿¡£', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£»', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º£»', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡££»', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»£»', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£»', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£»', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡££¡', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»£¡', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£¡', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£¡', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¬£¿', '£¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£º£¿', '£¿';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '¡££¿', '¡£';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£»£¿', '£»';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¡£¿', '£¡';
	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '£¿£¿', '£¿';

	EXEC dbo.AddFilterRule '×Ö·ûÌæ»»', '<br/>', '';

END
GO
