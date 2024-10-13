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
-- Create date: <2020��12��24��>
-- Description:	<���������ⲿ��Ų�����ڲ���>
-- =============================================
CREATE OR ALTER PROCEDURE [��������OuterContent]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ������ʱ����
	DECLARE @SqlID INT;
	DECLARE @SqlOID INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlContent UString;
	DECLARE @SqlFirstName UString;

	-- ���ðټ���
	SET @SqlFirstName =
		'��Ǯ��������֣��������������������������ʩ�ſײ��ϻ���κ�ս���л������ˮ��������˸��ɷ�����³Τ' +
		'������ﻨ������Ԭ��ۺ��ʷ�Ʒ����Ѧ�׺����������ޱϺ����������ʱ��Ƥ���뿵����Ԫ������ƽ�ƺ�������' +
		'Ҧ��տ����ë����ױ���갼Ʒ��ɴ�̸��é���ܼ�������ף������������ϯ����ǿ��·¦Σ��ͯ�չ�÷ʢ�ֵ�����' +
		'������Ĳ��﷮���R������֧���ù�¬Ī�·����Ѹɽ�Ӧ�ڶ����ڵ��������������ʯ�޼�ť�������ϻ���½����' +
		'�����ڻ������ҷ����ഢ���������ɾ��θ����ڽ��͹�����ɽ�ȳ������ȫۭ������������帳��ﱩ������������' +
		'������ղ����Ҷ��˾��۬�輻��ӡ�ް׻���ۢ�Ӷ����̼���׿�����ɳ����������ܲ�˫��ݷ����̷�����̼������' +
		'Ƚ��۪Ӻȴ�ɣ���ţ��ͨ�����༽����ũ�±�ׯ�̲����ֳ�Ľ����ϰ�°���������������������߾Ӻⲽ������' +
		'�����Ŀܹ�»�ڶ�ŷ�����εԽ��¡ʦ�������˹��������������Ǽ��Ŀ�����ɳؿ������ᳲ��������ᾣ����' +
		'��Ȩ�����滸����ٹ';
		-- '˾���Ϲ�ŷ���ĺ�������˶��������ʸ�ξ�ٹ����̨��ұ����������ڵ��̫����������������ԯ����������ĳ���Ľ��˾ͽ˾��';

	------------------------------------------------
	--
	-- �������
	--
	------------------------------------------------

	-- �����α�
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT oid, cid, content FROM dbo.OuterContent
			WHERE CHARINDEX(LEFT(content,1),@SqlFirstName) > 0	AND
			(length = 2 OR length = 3) AND dbo.IsChinese(content) = 1;
	-- ���ó�ʼֵ
	SET @SqlCount = 0;
	-- ���α�
	OPEN SqlCursor;
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	-- ѭ�������α�
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- �޸ļ�����
		SET @SqlCount = @SqlCount + 1;
		-- ���ó�ʼֵ
		SET @SqlID = - 1;
		-- ����ڱ��Ƿ���ڸü�¼
		SET @SqlID = dbo.InnerExists(@SqlContent);
		-- �����
		IF @SqlID IS NULL OR @SqlID <= 0
		BEGIN
			-- ���ڱ��в���һ����¼
			INSERT INTO dbo.InnerContent
				(cid, content, length, hash_value, classification, a_id)
				VALUES
				(@SqlCID, @SqlContent, LEN(@SqlContent), dbo.GetHash(@SqlContent), '����', -1);
		END
		-- �Ƴ������������ļ�¼
		DELETE FROM dbo.OuterContent
			WHERE content_hash = dbo.GetHash(@SqlContent);
		-- ��ӡ���
		PRINT '���������ⲿŲ�����ڲ���>�Ѵ���' + CONVERT(NVARCHAR(MAX), @SqlCount) + '�У�';
		PRINT CHAR(9) + 'cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + ', content=��' + @SqlContent + '��';
		-- ȡ��һ����¼
		FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	END
	-- �ر��α�
	CLOSE SqlCursor;
	-- �ͷ��α�
	DEALLOCATE SqlCursor;

END
GO
