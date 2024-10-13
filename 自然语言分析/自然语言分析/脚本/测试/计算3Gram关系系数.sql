USE [nldb]
GO

SET NOCOUNT ON;

-- ������ʱ����
DECLARE @SqlGID INT;
DECLARE @SqlContent UString;

-- ��ϵϵ��
DECLARE @SqlAlpha FLOAT;
DECLARE @SqlLAlpha FLOAT;
DECLARE @SqlRAlpha FLOAT;

-- �����α�
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT gid, content
		FROM dbo.Grammar3 WHERE operations = 1;
-- ���α�
OPEN SqlCursor;
-- ȡ��һ����¼
FETCH NEXT FROM SqlCursor INTO @SqlGID, @SqlContent;
-- ѭ�������α�
WHILE @@FETCH_STATUS = 0
BEGIN
	-- ��ӡ���
	PRINT '����3Gram��ϵϵ��(gid=' + CONVERT(NVARCHAR(MAX), @SqlGID) + ')> ��' + @SqlContent + '��';	

	-- �������ϵ��
	SET @SqlLAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 2) + '|' + RIGHT(@SqlContent, 1));
	SET @SqlRAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 1) + '|' + RIGHT(@SqlContent, 2));
	SET @SqlAlpha = dbo.GrammarGetAlphaValue(LEFT(@SqlContent, 1) + '|' + SUBSTRING(@SqlContent, 2, 1) + '|' + RIGHT(@SqlContent, 1));

	-- ���½��
	IF @SqlLAlpha > @SqlRAlpha
	BEGIN
		-- ��������
		UPDATE dbo.Grammar3
			SET operations = 0,
				lcontent = LEFT(@SqlContent, 2),
				rcontent = RIGHT(@SqlContent, 1),
				alpha = @SqlAlpha,
				lalpha = @SqlLAlpha, ralpha = @SqlRAlpha WHERE gid = @SqlGID;
	END
	ELSE
	BEGIN
		-- ��������
		UPDATE dbo.Grammar3
			SET operations = 0,
				lcontent = LEFT(@SqlContent, 1),
				rcontent = RIGHT(@SqlContent, 2),
				alpha = @SqlAlpha,
				lalpha = @SqlLAlpha, ralpha = @SqlRAlpha WHERE gid = @SqlGID;
	END
	-- ȡ��һ����¼
	FETCH NEXT FROM SqlCursor INTO @SqlGID, @SqlContent;
END
-- �ر��α�
CLOSE SqlCursor;
-- �ͷ��α�
DEALLOCATE SqlCursor; 

SET NOCOUNT OFF;
