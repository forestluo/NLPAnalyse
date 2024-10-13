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
-- Author:		<�ވ�>
-- Create date: <2021��2��19��>
-- Description:	<�����ݱ���ͳ������״��>
-- =============================================

CREATE OR ALTER PROCEDURE [ͳ�����ݱ�����״��]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlEID INT;
	DECLARE @SqlContent UString;
	
	DECLARE @SqlResult XML;
	DECLARE @SqlTable UMatchTable;

	-- װ���������ֹ���
	DECLARE @SqlRules XML;
	SET @SqlRules = dbo.LoadNumericalRules();

	-- ��ӡ����
	PRINT 'ͳ�����ݱ�����״��> ����' + CONVERT(NVARCHAR(MAX), @SqlCount) + '����¼��';

	-- �����α�
	DECLARE SqlCursor1 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) eid, content
			FROM dbo.ExternalContent WHERE type = 0;
	-- ���α�
	OPEN SqlCursor1;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ������ݱ�
		DELETE FROM @SqlTable;
		-- ��ӡ��¼
		--PRINT 'ͳ�����ݱ�����״��(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '")';

		BEGIN TRY

			--------------------------------------------------------------------------------
			--
			-- ������������
			--
			--------------------------------------------------------------------------------

			DECLARE @SqlValue UString;
			DECLARE @SqlAttribute UString;

			DECLARE @SqlExpressions XML;	
			-- ������ֽ������
			SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);

			-------------------------------------------------------------------------------
			--
			-- ��������з�
			--
			-------------------------------------------------------------------------------
			-- ��������з�
			SET @SqlResult = dbo.FMMSplitContent(1, @SqlContent, @SqlExpressions);
			-- ���뵽��ʱ����
			INSERT INTO @SqlTable
				(expression, position, value, length)
				SELECT
					'FMM',
					ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
					ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
					FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					WHERE Nodes.value('local-name(.)', 'nvarchar(max)') <> 'rule' ORDER BY nodePos;

			-------------------------------------------------------------------------------
			--
			-- ��������з�
			--
			-------------------------------------------------------------------------------
			-- ��������з�
			SET @SqlResult = dbo.BMMSplitContent(1, @SqlContent, @SqlExpressions);
			-- ���뵽��ʱ����
			INSERT INTO @SqlTable
				(expression, position, value, length)
				SELECT
					'BMM',
					ISNULL(Nodes.value('(@pos)[1]', 'int'), 0) AS nodePos,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue,
					ISNULL(LEN(Nodes.value('(text())[1]', 'nvarchar(max)')), 0)
					FROM @SqlResult.nodes('//result/*') AS N(Nodes)
					WHERE Nodes.value('local-name(.)', 'nvarchar(max)') <> 'rule' ORDER BY nodePos;

			-------------------------------------------------------------------------------
			--
			-- ȥ���ظ�����ȫ�ظ��Ľ�����һ�
			--
			-------------------------------------------------------------------------------

			DECLARE @SqlID INT;
			DECLARE @SqlMatch INT;
			DECLARE @SqlLength INT;
			DECLARE @SqlPosition INT;

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
				DECLARE SqlCursor2 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT id, length, position	FROM @SqlTable ORDER BY length;
				-- ���α�
				OPEN SqlCursor2;
				-- ȡ��һ����¼
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition;
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
					FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition;
				END
				-- �ر��α�
				CLOSE SqlCursor2;
				-- �ͷ��α�
				DEALLOCATE SqlCursor2;
			END

			-- SELECT *,dbo.GetFreqCount(value) AS freq FROM @SqlTable ORDER BY position;

			-------------------------------------------------------------------------------
			--
			-- �ϲ��໥�ص�����Ŀ
			--
			-------------------------------------------------------------------------------

			DECLARE @SqlMID INT;
			DECLARE @SqlMPosition INT;
			DECLARE @SqlMValue UString;
			DECLARE @SqlMAttribute UString;

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
				DECLARE SqlCursor2 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT id, length, position, value, expression FROM @SqlTable ORDER BY position;
				-- ���α�
				OPEN SqlCursor2;
				-- ȡ��һ����¼
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
				-- ѭ�������α�
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- ���ó�ʼֵ
					SET @SqlContent = NULL;

					SET @SqlMID = -1;
					SET @SqlMPosition = 0;
					SET @SqlMValue = NULL;
					SET @SqlMAttribute = NULL;
					-- ��ѯ��¼
					SELECT TOP 1
						@SqlMID = id,
						@SqlMPosition = position,
						@SqlMValue = value,
						@SqlMAttribute = expression
						FROM @SqlTable
						WHERE
						@SqlID <> id AND
						@SqlPosition < position AND
						(@SqlPosition + @SqlLength > position) AND
						(@SqlPosition + @SqlLength < position + length) ORDER BY position
					-- �����
					IF @SqlMID > 0
					BEGIN
						-- ���ñ��λ
						SET @SqlMatch = 1;

						-- ��ó���
						SET @SqlLength = @SqlMPosition - @SqlPosition + LEN(@SqlMValue);
						-- �������
						SET @SqlContent = LEFT(@SqlValue, @SqlMPosition - @SqlPosition) + @SqlMValue;

						-- �������
						UPDATE dbo.Ambiguity SET count = count + 1 WHERE eid = @SqlEID AND content = @SqlContent;
						-- �����
						IF @@ROWCOUNT <= 0
						BEGIN
							-- ��ӡ��¼
							PRINT 'ͳ�����ݱ�����״��(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
								'content("' + @SqlContent + '") = {' + CONVERT(NVARCHAR(MAX), @SqlPosition) + ':"' + @SqlValue + '",' + CONVERT(NVARCHAR(MAX), @SqlMPosition) + ':"' + @SqlMValue + '"}';
							-- ���뵽��¼����
							INSERT INTO dbo.Ambiguity
								(eid, position, length, content, fmm_content, bmm_content, freq, fmm_freq, bmm_freq)
								VALUES
								(@SqlEID,
									@SqlPosition, @SqlLength, @SqlContent, @SqlValue, @SqlMValue,
									dbo.GetFreqCount(@SqlContent), dbo.GetFreqCount(@SqlValue), dbo.GetFreqCount(@SqlMValue));
						END

						-- ��������
						UPDATE @SqlTable SET
							position = @SqlPosition,
							length = position - @SqlPosition + length,
							value = LEFT(@SqlValue, position - @SqlPosition) + value,
							expression = expression + '+' + @SqlAttribute
							WHERE id = @SqlMID;
						-- ɾ������������������
						DELETE FROM @SqlTable WHERE id = @SqlID; BREAK;
					END
					-- ȡ��һ����¼
					FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlLength, @SqlPosition, @SqlValue, @SqlAttribute;
				END
				-- �ر��α�
				CLOSE SqlCursor2;
				-- �ͷ��α�
				DEALLOCATE SqlCursor2;
			END

		END TRY
		BEGIN CATCH
			-- ������ʾ��ץȡ�쳣��¼
			SET @SqlContent = 'ͳ�����ݱ�����״��(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
		END CATCH

		---- �������ݼ�¼
		UPDATE dbo.ExternalContent SET type = type + 1 WHERE eid = @SqlEID;
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	END
	-- �ر��α�
	CLOSE SqlCursor1;
	-- �ͷ��α�
	DEALLOCATE SqlCursor1; 
	-- ���سɹ�
	PRINT 'ͳ�����ݱ�����״��> �����ı�ȫ��ͳ����ϣ�';

END
GO
