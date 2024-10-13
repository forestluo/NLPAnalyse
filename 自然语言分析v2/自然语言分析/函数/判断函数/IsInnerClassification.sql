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
-- Create date: <2020��12��19��>
-- Description:	<�Ƿ�ΪInnerContent�����>
-- =============================================

CREATE OR ALTER FUNCTION IsInnerClassification
(
	-- Add the parameters for the function here
	@SqlClassification UString
)
RETURNS INT
AS
BEGIN
	-- ���ؽ��
	RETURN CASE @SqlClassification
		WHEN '����'		THEN 1
		WHEN '������' THEN 1
		WHEN 'Ӣ����ĸ'	THEN 1
		WHEN '��ѧ����' THEN 1
		WHEN '������' THEN 1
		WHEN '������ĸ' THEN 1
		WHEN '��λ����' THEN 1
		WHEN '�������' THEN 1
		WHEN '�Ʊ��'	THEN 1
		WHEN '���ҷ���'	THEN 1
		WHEN '����ƴ��' THEN 1
		WHEN '����ͼ��' THEN 1
		WHEN '�����ַ�' THEN 1
		WHEN 'ϣ����ĸ'	THEN 1
		WHEN '��ͷ����' THEN 1
		WHEN '����ƽ����Ƭ����' THEN 1
		ELSE 0 END;
END
GO

