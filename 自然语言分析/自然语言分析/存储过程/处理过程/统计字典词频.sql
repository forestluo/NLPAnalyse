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
-- Create date: <2020��12��17��>
-- Description:	<�����Ͽ���ͳ�����ݵķ�������>
-- =============================================

CREATE OR ALTER PROCEDURE [ͳ���ֵ��Ƶ]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlTID INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlText UString;

	DECLARE @SqlPosition INT;
	DECLARE @SqlCheckLength INT;
	DECLARE @SqlStatisticCount INT;

	DECLARE @SqlRightText UString;
	DECLARE @SqlLeftContent UString;

	-- ��ӡ����
	PRINT 'ͳ���ֵ��Ƶ> ����' + CONVERT(NVARCHAR(MAX), @SqlCount) + '����¼��';

	-- �����󳤶�
	SELECT @SqlLength = MAX(length) FROM dbo.Dictionary WHERE [enable] = 1;

	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- ���ó�ʼֵ
		SET @SqlPosition = 0;
		SET @SqlStatisticCount = 0;
		-- ѭ������
		WHILE @SqlPosition < LEN(@SqlText)
		BEGIN
			-- �޸ļ�����
			SET @SqlPosition = @SqlPosition + 1;
			-- ���ʣ���Ҳ�����
			SET @SqlRightText = RIGHT(@SqlText, LEN(@SqlText) - @SqlPosition + 1);

			-- ���ó�ʼֵ
			SET @SqlCheckLength = 0;
			-- ѭ������
			WHILE @SqlCheckLength < @SqlLength AND
				@SqlPosition + @SqlCheckLength < LEN(@SqlText)
			BEGIN
				-- �޸ļ�����
				SET @SqlCheckLength = @SqlCheckLength + 1;
				-- ����������
				SET @SqlLeftContent = LEFT(@SqlRightText, @SqlCheckLength);

				-- ���¼�¼
				UPDATE dbo.Dictionary SET count = count + 1
					WHERE content = @SqlLeftContent;
				-- ����ͳ����ֵ
				SET @SqlStatisticCount = @SqlStatisticCount + @@ROWCOUNT;
			END
		END
		-- ��ӡ���
		PRINT 'ͳ���ֵ��Ƶ(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> Ƶ��ͳ��' +
			CONVERT(NVARCHAR(MAX), @SqlStatisticCount) + '��';
		---- �������ݼ�¼
		UPDATE dbo.TextPool	SET parsed = parsed + 1 WHERE tid = @SqlTid;
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor; 
	-- ���سɹ�
	PRINT 'ͳ���ֵ��Ƶ> �����ı�ȫ��ͳ����ϣ�';

END
GO
