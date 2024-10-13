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
-- Create date: <2020��12��16��>
-- Description:	<ȫ��ת������>
-- =============================================

CREATE OR ALTER FUNCTION UnicodeConvert 
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
    DECLARE @SqlStep INT;
    DECLARE @SqlIndex INT;
    DECLARE @SqlPattern NVARCHAR(8);

	-- ���ó�ʼֵ    
    SELECT
		@SqlStep = 65248,
		@SqlPattern = N'%[!-~]%',      --��ǵ�ͨ���
		@SqlValue = REPLACE(@SqlValue, N'   ', N'�� ');
    -- ָ���������
    SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	-- ѭ������
    WHILE @SqlIndex > 0
	BEGIN
      SELECT
        @SqlValue = REPLACE(@SqlValue,
                       SUBSTRING(@SqlValue, @SqlIndex, 1),
                       NCHAR(UNICODE(SUBSTRING(@SqlValue, @SqlIndex, 1)) + @SqlStep)),
        @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	END
	-- ���ؽ��
    RETURN @SqlValue;
END
GO

