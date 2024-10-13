USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
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
-- Create date: <2021��2��16��>
-- Description:	<����ƥ������>
-- =============================================

CREATE OR ALTER FUNCTION ClearMatchTable
(	
	-- Add the parameters for the function here
	@SqlExpressions XML
)
RETURNS XML
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlMID INT;
	DECLARE @SqlMatch INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlPosition INT;
	DECLARE @SqlValue UString;
	DECLARE @SqlResult UString;
	DECLARE @SqlAttribute UString;

	DECLARE @SqlTable UMatchTable;

	-- ������
	IF @SqlExpressions IS NULL OR
		ISNULL(@SqlExpressions.value('(//result/@id)[1]', 'int'), 0) <= 0
		RETURN CONVERT(NVARCHAR(MAX), '<result id="-1">invalid expressions</result>');

	-- ���뵽��ʱ����
	INSERT INTO @SqlTable
		(expression, length, position, value)
		SELECT
			Nodes.value('(@type)[1]', 'nvarchar(max)') AS nodeType,
			ISNULL(Nodes.value('(@len)[1]', 'int'), 0) AS nodeLen,
			ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
			Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
			FROM @SqlExpressions.nodes('//result/*') AS N(Nodes) ORDER BY nodePos;
		
	-- ���ó�ʼֵ
	SET @SqlMatch = 1;
	-- ѭ������
	WHILE @SqlMatch > 0
	BEGIN
		-- ���ó�ʼֵ
		SET @SqlMatch = 0;
		-- �������ͬʱ����ʱ�Ż�����໥�ص�����
		-- �����໥�ص��Ľ������������ȥ�̣�
		-- �����α�
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT id, length, position	FROM @SqlTable ORDER BY length;
		-- ���α�
		OPEN SqlCursor;
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
		-- ѭ�������α�
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- �����
			IF EXISTS
				(SELECT * FROM @SqlTable WHERE
					@SqlID <> id AND
					@SqlPosition >= position AND
					(@SqlPosition + @SqlLength <= position + length))
			BEGIN
				-- ���ñ��λ
				SET @SqlMatch = 1;
				-- ɾ������������������
				DELETE FROM @SqlTable WHERE id = @SqlID;
			END
			-- ȡ��һ����¼
			FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition;
		END
		-- �ر��α�
		CLOSE SqlCursor;
		-- �ͷ��α�
		DEALLOCATE SqlCursor;
	END

	-- ���ó�ʼֵ
	SET @SqlMatch = 1;
	-- ѭ������
	WHILE @SqlMatch > 0
	BEGIN
		-- ���ó�ʼֵ
		SET @SqlMatch = 0;
		-- �������ͬʱ����ʱ�Ż�����໥�ص�����
		-- �����໥�ص��Ľ���������ںϴ�磩
		-- �����α�
		DECLARE SqlCursor CURSOR
			STATIC FORWARD_ONLY LOCAL FOR
			SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
		-- ���α�
		OPEN SqlCursor;
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
		-- ѭ�������α�
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- ���ó�ʼֵ
			SET @SqlMID = -1;
			-- ��ѯ��¼
			SELECT TOP 1 @SqlMID = id FROM @SqlTable WHERE
				@SqlID <> id AND
				@SqlPosition < position AND
				(@SqlPosition + @SqlLength > position) AND
				(@SqlPosition + @SqlLength < position + length) ORDER BY position;
			-- �����
			IF @SqlMID > 0
			BEGIN
				-- ���ñ��λ
				SET @SqlMatch = 1;
				-- ��������
				UPDATE @SqlTable SET
					position = @SqlPosition,
					length = position - @SqlPosition + length,
					value = LEFT(@SqlValue, position - @SqlPosition) + value,
					expression = CASE WHEN @SqlPosition > position THEN @SqlAttribute ELSE expression END
					WHERE id = @SqlMID;
				-- ɾ������������������
				DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
			END
			-- ȡ��һ����¼
			FETCH NEXT FROM SqlCursor INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
		END
		-- �ر��α�
		CLOSE SqlCursor;
		-- �ͷ��α�
		DEALLOCATE SqlCursor;
	END

	-- �γ�XML
	SET @SqlResult =
	(
		(
			SELECT '<exp id="' + CONVERT(NVARCHAR(MAX),id) + '" type="' + expression + '" pos="' + CONVERT(NVARCHAR(MAX), position) + '" '
				+ 'len="' + CONVERT(NVARCHAR(MAX), length) + '">' + dbo.XMLEscape(value) + '</exp>'
				FROM @SqlTable ORDER BY position FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(max)')
	);
	-- ���ؽ��
	RETURN CONVERT(XML, '<result id="1">' + @SqlResult + '</result>');
END
GO
