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
-- Create date: <2020��12��21��>
-- Description:	<Ѱ�����ƥ��Ĵʻ�>
-- =============================================
CREATE OR ALTER FUNCTION GetLeftMatchWords 
(
	-- Add the parameters for the function here
	@SqlBase UString
)
RETURNS XML
AS
BEGIN
	--������ʱ����
	DECLARE @SqlOID INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlStart INT;
	DECLARE @SqlIndex INT;
	DECLARE @SqlPosition INT;

	DECLARE @SqlWord UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlContent UString;
	DECLARE @SqlTable UMatchTable;

	-- ����
	SET @SqlBase = TRIM(@SqlBase);
	-- ������
	IF @SqlBase IS NULL OR LEN(@SqlBase) <= 0
	BEGIN
		RETURN CONVERT(XML, '<result id="-1">input is null.</result>');
	END

	-- ���ó�ʼֵ
	SET @SqlPosition = 1;
	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT oid, cid, content FROM dbo.OuterContent
			WHERE classification = 'ԭ��' AND content like ('%' + @SqlBase + '%');
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Ѱ��ƥ�����Ŀ
		SET @SqlIndex =
			CHARINDEX(@SqlBase, @SqlContent, @SqlPosition);
		-- �����
		IF @SqlIndex IS NOT NULL AND @SqlIndex > 0
		BEGIN
			-- ��ȡ��������
			SET @SqlValue =
				LEFT(@SqlContent, @SqlIndex - 1);
			-- �����
			IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
			BEGIN
				-- ���ó�ʼֵ
				SET @SqlStart = 0;
				-- Ѱ��ƥ����ַ�
				WHILE @SqlStart < LEN(@SqlValue)
				BEGIN
					-- �޸ļ�����
					SET @SqlStart = @SqlStart + 1;
					-- ���ƥ����ַ�
					SET @SqlWord = RIGHT(@SqlValue, LEN(@SqlValue) - @SqlStart + 1);
					-- ���CID
					SET @SqlCID = dbo.GetContentID(@SqlWord);
					-- �����
					IF @SqlCID > 0
					BEGIN
						-- ��������뵽��¼��֮��
						INSERT INTO @SqlTable
							(expression, value, length, position)
							VALUES (CONVERT(NVARCHAR(MAX), @SqlCID), @SqlWord, LEN(@SqlWord), @SqlStart); BREAK;
					END
				END
			END
		END
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;

	-- ȥ���ظ�������
	DELETE FROM @SqlTable
		WHERE id NOT IN (SELECT MIN(id) FROM @SqlTable GROUP BY value HAVING COUNT(0) > 1);
	-- ��ʽ�����
	SET @SqlContent =
	(
		(
			SELECT '<var id="' + CONVERT(NVARCHAR(MAX), id) + '" ' +
				'cid="' + expression + '" ' +
				'pos="' + CONVERT(NVARCHAR(MAX), position) + '">' + value + '</var>'
				FROM @SqlTable FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlContent + '</result>');
END
GO

