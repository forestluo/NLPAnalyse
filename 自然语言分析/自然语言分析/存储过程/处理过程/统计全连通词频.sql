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
-- Create date: <2021��2��28��>
-- Description:	<ͳ��ȫ��ͨ��Ƶ>
-- =============================================

CREATE OR ALTER PROCEDURE [ͳ��ȫ��ͨ��Ƶ]
	-- Add the parameters for the stored procedure here
	@SqlCount INT,
	@SqlLength INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlEID INT;
	DECLARE @SqlDate DATETIME;
	DECLARE @SqlContent UString;

	DECLARE @SqlRules XML;
	DECLARE @SqlExpressions XML;

	-- װ���������ֹ���
	SET @SqlRules = dbo.LoadNumericalRules();
	-- �����
	IF @SqlRules IS NULL OR
		ISNULL(@SqlRules.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- ���ؽ��
		PRINT 'ͳ��ȫ��ͨ��Ƶ> ���ع���ʧ�ܣ�'; RETURN 0;
	END

	-- ��ӡ����
	PRINT 'ͳ��ȫ��ͨ��Ƶ> ����' + CONVERT(NVARCHAR(MAX), @SqlCount) + '����¼��';

	-- ��ʼ��ʱ
	SET @SqlDate = GetDate();
	-- �����α�
	DECLARE SqlCursor1 CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) eid, content
			FROM dbo.ExternalContent WHERE type = @SqlLength - 1;
	-- ���α�
	OPEN SqlCursor1;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
	-- ��ʱ����
	PRINT 'ͳ��ȫ��ͨ��Ƶ> �����α��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ��ӡ��¼
		--PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '")';
		--PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ' +
		--	'content("' + @SqlContent + '": ' + master.dbo.fn_varbintohexstr(CONVERT(VARBINARY(MAX), @SqlContent)) + ')';

		-- ��ʼ��ʱ
		SET @SqlDate = GetDate();
		-- �����ɼ��ַ�
		SET @SqlContent = dbo.ClearInvisible(@SqlContent);
		-- ���ո����ת��
		SET @SqlContent = dbo.EscapeBlankspace(@SqlContent);
		-- ���Դ���
		BEGIN TRY
			-- ���ر��ʽ
			SET @SqlExpressions = dbo.ExtractExpressions(@SqlRules, @SqlContent);
			---- �����
			--IF @SqlExpressions IS NULL OR
			--	ISNULL(@SqlExpressions.value('(//result/@id)[1]', 'int'), 0) <= 0
			--BEGIN
			--	-- ���ؽ��
			--	PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> �������ʽʧ�ܣ�'; /*GOTO NEXT_ROW;*/
			--END

			DECLARE @SqlResult1 XML;
			-- ��ȡһ�����ݣ�������ؽ��
			SET @SqlResult1 = dbo.SplitContent(@SqlContent, @SqlExpressions);
			-- �����
			IF @SqlResult1 IS NULL OR
				ISNULL(@SqlResult1.value('(//result/@id)[1]', 'int'), 0) <= 0
			BEGIN
				-- ���ؽ��
				PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ��ȡ����ʧ�ܣ�'; GOTO NEXT_ROW;
			END

			-- ������ʱ����
			DECLARE @SqlID INT;
			DECLARE @SqlName UString;
			DECLARE @SqlValue UString;
			-- �����α�
			DECLARE SqlCursor2 CURSOR
				STATIC FORWARD_ONLY LOCAL FOR
				SELECT
					Nodes.value('(@id)[1]','int') AS nodeID,
					Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
					Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
					FROM @SqlResult1.nodes('//result/var') AS N(Nodes) ORDER BY nodeID; 
			-- ���α�
			OPEN SqlCursor2;
			-- ȡ��һ����¼
			FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			-- ѭ�������α�
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @SqlResult2 XML;
				-- �������Ķ�ȡ
				SET @SqlResult2 = dbo.ReadChinese(@SqlValue);

				-- �����α�
				DECLARE SqlCursor3 CURSOR
					STATIC FORWARD_ONLY LOCAL FOR
					SELECT
						Nodes.value('(@id)[1]','int') AS nodeID,
						Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
						Nodes.value('(text())[1]', 'nvarchar(max)') AS nodeValue
						FROM @SqlResult2.nodes('//result/var') AS N(Nodes) ORDER BY nodeID; 
				-- ���α�
				OPEN SqlCursor3;
				-- ȡ��һ����¼
				FETCH NEXT FROM SqlCursor3 INTO @SqlID, @SqlName, @SqlValue;
				-- ѭ�������α�
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- ������ʱ����
					-- DECLARE @SqlDate3 DATETIME;
					-- ��ȡʱ��
					-- SET @SqlDate3 = GETDATE();
					-- ���Դ���
					BEGIN TRY
						-- ȫ��ͨ�﷨ͳ��
						EXEC dbo.GrammarStatistics @SqlLength, @SqlValue;
					END TRY
					BEGIN CATCH
						-- ������ʾ��ץȡ�쳣��¼
						SET @SqlContent = 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
					END CATCH

					-- ��ʱ����
					-- PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> �����ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate3, GetDate())) + '����';

					-- ȡ��һ����¼
					FETCH NEXT FROM SqlCursor3 INTO @SqlID, @SqlName, @SqlValue;
				END
				-- �ر��α�
				CLOSE SqlCursor3;
				-- �ͷ��α�
				DEALLOCATE SqlCursor3;

				-- ȡ��һ����¼
				FETCH NEXT FROM SqlCursor2 INTO @SqlID, @SqlName, @SqlValue;
			END
			-- �ر��α�
			CLOSE SqlCursor2;
			-- �ͷ��α�
			DEALLOCATE SqlCursor2;

		END TRY
		BEGIN CATCH
			-- ������ʾ��ץȡ�쳣��¼
			SET @SqlContent = 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')'; EXEC dbo.CatchException @SqlContent;
		END CATCH

NEXT_ROW:
		------ �������ݼ�¼
		UPDATE dbo.ExternalContent
			SET type = @SqlLength WHERE eid = @SqlEID;
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor1 INTO @SqlEID, @SqlContent;
		-- ��ʱ����
		PRINT 'ͳ��ȫ��ͨ��Ƶ(eid=' + CONVERT(NVARCHAR(MAX), @SqlEID) + ')> ��ʱ' + CONVERT(NVARCHAR(MAX),DateDiff(ms, @SqlDate, GetDate())) + '����';
	END
	-- �ر��α�
	CLOSE SqlCursor1;
	-- �ͷ��α�
	DEALLOCATE SqlCursor1; 
	-- ���سɹ�
	PRINT 'ͳ��ȫ��ͨ��Ƶ> �����ı�ȫ��ͳ����ϣ�';

END
GO
