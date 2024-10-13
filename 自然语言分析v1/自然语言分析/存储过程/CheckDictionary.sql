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
-- Create date: <2020��12��25��>
-- Description:	<���ֵ��в�ѯ����>
-- =============================================
CREATE OR ALTER PROCEDURE CheckDictionary 
(
	-- Add the parameters for the function here
	@SqlContent UString
)
AS
BEGIN
	-- �������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;
	-- ����ͳ��
	UPDATE dbo.Dictionary
		SET count = count + 1
		WHERE hash_value = dbo.GetHash(@SqlContent);
	-- �����
	RETURN @@ROWCOUNT;
END
GO

