USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[GetVarCount]    Script Date: 2020/12/12 13:18:40 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2020��12��12��>
-- Description:	<��ò�����ͳ����Ŀ>
-- =============================================

CREATE OR ALTER FUNCTION [dbo].[GetVarCount]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
RETURNS INT
AS
BEGIN
	-- ���ؽ��
	RETURN dbo.GetCharCount(@SqlContent, '$');
END
