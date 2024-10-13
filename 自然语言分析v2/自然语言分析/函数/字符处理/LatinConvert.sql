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
-- Description:	<���ת������>
-- =============================================

CREATE OR ALTER FUNCTION LatinConvert 
(
	-- Add the parameters for the function here
	@SqlValue UString
)
RETURNS UString
AS
BEGIN
    DECLARE @SqlStep INT;
    DECLARE @SqlIndex INT;
	DECLARE @SqlChar UChar;
	DECLARE @SqlContent UString;
    DECLARE @SqlPattern NVARCHAR(8);
   
	-- ���ó�ʼֵ
    SELECT
		@SqlContent = '',
		@SqlStep = -65248,
	    @SqlPattern = N'%[��-��]%',    --ȫ�ǵ�ͨ���
		@SqlValue = REPLACE(@SqlValue, N'�� ', N'   ');
    -- ָ���������
    SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	-- ѭ������
    WHILE @SqlIndex > 0
	BEGIN
		-- ����ַ�
		SET @SqlChar = SUBSTRING(@SqlValue, @SqlIndex, 1);
		-- ����ַ�
		IF UNICODE(@SqlChar) < 65248
		BEGIN
			-- ����ԭ������
			SET @SqlContent = @SqlContent + LEFT(@SqlValue, @SqlIndex);
		END
		ELSE
		BEGIN
			-- �ϲ��������
			IF @SqlIndex > 1
			SET @SqlContent = @SqlContent + LEFT(@SqlValue, @SqlIndex - 1);
			-- ת���ַ�����
			SET @SqlContent = @SqlContent + NCHAR(UNICODE(@SqlChar) + @SqlStep);
		END
		-- ��ȡʣ������
		SET @SqlValue = RIGHT(@SqlValue, LEN(@SqlValue) - @SqlIndex);
		-- ������һ��λ��
        SET @SqlIndex = PATINDEX(@SqlPattern COLLATE LATIN1_GENERAL_BIN, @SqlValue);
	END
	-- ���ؽ��
    RETURN @SqlContent + @SqlValue;
END
GO

