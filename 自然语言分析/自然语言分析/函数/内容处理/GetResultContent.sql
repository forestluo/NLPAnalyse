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
-- Create date: <2020��12��7��>
-- Description:	<�����е�������װ����>
-- =============================================
CREATE OR ALTER FUNCTION GetResultContent
(
	-- Add the parameters for the function here
	@SqlResult XML
)
RETURNS UString
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlType UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlContent UString = '';

	-- ������
	IF @SqlResult IS NULL RETURN NULL;
	-- ƴ������
	SET @SqlContent =
	(
		(
			SELECT nodeValue + '' FROM
			(
				SELECT
					Nodes.value('(@id)[1]','int') AS nodeID,
					Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
					Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
					Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
					FROM @SqlResult.nodes('//result/*') AS N(Nodes)
			) AS NodesTable WHERE nodeID IS NOT NULL ORDER BY nodeID FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
	);
	-- ������ֵ
	RETURN @SqlContent;
END
GO

