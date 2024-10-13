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
-- Create date: <2020��12��27��>
-- Description:	<���������ӽ�������>
-- =============================================

CREATE OR ALTER PROCEDURE [����ParseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- ������ʱ����
	DECLARE @SqlIndex INT;
	DECLARE @SqlRule UString;

	EXEC dbo.AddParseRule '���','��$a��';
	EXEC dbo.AddParseRule '���','��$a��';
	EXEC dbo.AddParseRule '���','��$a��';
	EXEC dbo.AddParseRule '���','��$a��';
	EXEC dbo.AddParseRule '���','��$a��';
	EXEC dbo.AddParseRule '���','��$a��';
	-- ��ֹ����
	-- EXEC dbo.AddParseRule 'ƴ��','$a';
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule 'ƴ��', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule 'ƴ��','$a$b';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y';
	EXEC dbo.AddParseRule 'ƴ��','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y$z';
	*/
	-- ��ֹ����
	-- EXEC dbo.AddParseRule 'ͨ��','$a��';
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule 'ͨ��', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule 'ͨ��','$a��$b';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x��$y';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x��$y��$z';
	*/
	-- ��ֹ����
	-- EXEC dbo.AddParseRule 'ͨ��','$a��';
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule 'ͨ��', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule 'ͨ��','$a��$b';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x��$y';
	EXEC dbo.AddParseRule 'ͨ��','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x��$y��$z';
	*/
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '����', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '����','$a��$b';
	EXEC dbo.AddParseRule '����','$a��$b��$c';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r';
	*/
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '����', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '����','$a��$b';
	EXEC dbo.AddParseRule '����','$a��$b��$c';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	*/
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '����', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '����','$a��$b';
	EXEC dbo.AddParseRule '����','$a��$b��$c';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	*/
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '����', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '����','$a��$b';
	EXEC dbo.AddParseRule '����','$a��$b��$c';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x��$y';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$s��$t��$u��$v��$w��$x��$y��$z';
	*/
	-- ���ó�ʼֵ
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- ѭ������
	WHILE @SqlIndex < 26
	BEGIN
		-- ���Ӽ�����
		SET @SqlIndex = @SqlIndex + 1;
		-- ���Ӳ���
		SET @SqlRule = @SqlRule +
			'��$' + dbo.GetLowercase(@SqlIndex);
		-- �������
		SET @SqlRule = @SqlRule + '��';/*���Ͻ�β*/
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '����', @SqlRule;
		SET @SqlRule = LEFT(@SqlRule, LEN(@SqlRule) - 1);/*β����ԭ*/
	END
	/*
	EXEC dbo.AddParseRule '����','$a��$b��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x��$y��';
	EXEC dbo.AddParseRule '����','$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��$n��$o��$p��$q��$r��$t��$u��$v��$w��$x��$y��$z��';
	*/

	EXEC dbo.AddParseRule '����','$a��';
	EXEC dbo.AddParseRule '����','$a��';
	EXEC dbo.AddParseRule '����','$a��';
	EXEC dbo.AddParseRule '����','$a��';
	EXEC dbo.AddParseRule '����','$a����';

	EXEC dbo.AddParseRule 'ͨ��','��$a����';
	EXEC dbo.AddParseRule 'ͨ��','��$a����';

	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';

	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';

	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';

	EXEC dbo.AddParseRule '����','����$a������';
	EXEC dbo.AddParseRule '����','����$a������';
	EXEC dbo.AddParseRule '����','����$a������';

	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';

	EXEC dbo.AddParseRule 'ͨ��','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';
	EXEC dbo.AddParseRule '����','��$a����';

	EXEC dbo.AddParseRule '����','$a��$b��';
	EXEC dbo.AddParseRule '����','$a��$b��';
	EXEC dbo.AddParseRule '����','$a��$b��';

	EXEC dbo.AddParseRule '����','$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';

	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';

	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';

	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	
	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';

	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';

	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';
	EXEC dbo.AddParseRule '����','$a��$b����';
	
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';
	EXEC dbo.AddParseRule '����','��$a����$b��';

	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';
	EXEC dbo.AddParseRule '����','$a����$b����';

	EXEC dbo.AddParseRule '����','��$a��$b������';
	EXEC dbo.AddParseRule '����','��$a��$b������';
	EXEC dbo.AddParseRule '����','��$a��$b������';

	EXEC dbo.AddParseRule '����','��$a����$b������';
	EXEC dbo.AddParseRule '����','��$a��$b��������';

	EXEC dbo.AddParseRule '����','��$a����$b������';
	EXEC dbo.AddParseRule '����','��$a����$b������';
	EXEC dbo.AddParseRule '����','��$a����$b������';

	EXEC dbo.AddParseRule '����','��$a����$b������';
	EXEC dbo.AddParseRule '����','��$a����$b������';
	EXEC dbo.AddParseRule '����','��$a����$b������';

	EXEC dbo.AddParseRule '����','��$a����$b������'
	EXEC dbo.AddParseRule '����','��$a����$b������'
	EXEC dbo.AddParseRule '����','��$a����$b������'

	EXEC dbo.AddParseRule '����','����$a������$b��';
	EXEC dbo.AddParseRule '����','����$a������$b��';
	EXEC dbo.AddParseRule '����','����$a������$b��';

	EXEC dbo.AddParseRule '����','$a��$b����$c';
	EXEC dbo.AddParseRule '����','$a��$b����$c';
	EXEC dbo.AddParseRule '����','$a��$b����$c';

	EXEC dbo.AddParseRule '����','$a��$b����$c';
	EXEC dbo.AddParseRule '����','$a��$b������$c';
	EXEC dbo.AddParseRule '����','$a��$b������$c';

	EXEC dbo.AddParseRule '����','$a����$b����$c';
	EXEC dbo.AddParseRule '����','$a����$b����$c';
	EXEC dbo.AddParseRule '����','$a����$b����$c';

	EXEC dbo.AddParseRule '����','��$a����$b����$c����';

	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	
	EXEC dbo.AddParseRule '����','��$a����$b����$c��';
	EXEC dbo.AddParseRule '����','��$a����$b����$c��';
	EXEC dbo.AddParseRule '����','��$a����$b����$c��';
	
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';

	EXEC dbo.AddParseRule '����','��$a��$b������$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';

	EXEC dbo.AddParseRule '����','��$a����$b����$c����';

	EXEC dbo.AddParseRule '����','$a����$b����$c��';

	EXEC dbo.AddParseRule '����','$a����$b��$c����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����';
		
	EXEC dbo.AddParseRule '����','��$a����$b����$c��';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a����$b����$c����';
	EXEC dbo.AddParseRule '����','��$a��$b������$c����';

	EXEC dbo.AddParseRule '����','$a����$b��$c����$d��';
	EXEC dbo.AddParseRule '����','$a����$b����$c����$d����';
	EXEC dbo.AddParseRule '����','$a����$b��$c����$d����';
	EXEC dbo.AddParseRule '����','$a����$b����$c!��$d����';
	EXEC dbo.AddParseRule '����','$a����$b����$c����$d����';

	EXEC dbo.AddParseRule '����','��$a����$b����$c����$d����$e����$f������';

END
GO
