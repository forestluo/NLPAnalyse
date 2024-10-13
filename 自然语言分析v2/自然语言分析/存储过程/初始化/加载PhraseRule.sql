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
-- Description:	<���������Ӷ������>
-- =============================================

CREATE OR ALTER PROCEDURE [����PhraseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ��ʱ����
	DECLARE @SqlValue UString;
	DECLARE @SqlPrefix UString;
	DECLARE @SqlSuffix UString;

	--------------------------------------------------------------------------------
	--
	-- �����������
	--
	--------------------------------------------------------------------------------

	-- ������ʽ
	-- ���
	EXEC dbo.AddPhraseRule '����', '0\d*', '���';
	EXEC dbo.AddPhraseRule '����', 'No.\d*', '���';
	-- ����
	EXEC dbo.AddPhraseRule '����', '-?[1-9]\d*', '����';
	EXEC dbo.AddPhraseRule '����', '[1-9]\d*[\s]?-[\s]?[1-9]\d*', '����';
	EXEC dbo.AddPhraseRule '����', '[1-9]\d{0,2}(,\d{3})+', '����';
	EXEC dbo.AddPhraseRule '����', '[1-9]\d*[\s]?[ʮ|��|ǧ|��|��]', '����';
	EXEC dbo.AddPhraseRule '����', '[1-9]\d*[\s]?[ʮ|��|ǧ|��|��|��]��', '����';
	-- �ٷ���
	EXEC dbo.AddPhraseRule '����', '\d+(\.\d+)?%', '�ٷ���';
	EXEC dbo.AddPhraseRule '����', '\d+(\.\d+)?%-\d+(\.\d+)?%', '�ٷ���';
	-- ����
	EXEC dbo.AddPhraseRule '����', '[1-9]\d*[\s]?/[\s]?[1-9]\d*', '����';
	EXEC dbo.AddPhraseRule '����', '[1-9]\d*[\s]?/[\s]?[1-9]\d*-[1-9]\d*/[1-9]\d*', '����';
	-- Ӣ�ĵ���
	EXEC dbo.AddPhraseRule '����', '[A-Za-z][''A-Za-z]*', 'Ӣ��';
	-- ������
	EXEC dbo.AddPhraseRule '����', '-?([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)', '������';
	EXEC dbo.AddPhraseRule '����', '([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)[\s]?[ʮ|��|ǧ|��|��]', '������';
	EXEC dbo.AddPhraseRule '����', '([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)[\s]?[ʮ|��|ǧ|��|��|��]��', '������';

	-- ����
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '(0?[1-9]|1[0-2])[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?��[\s]?((1[0-2])|(0?[1-9]))[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '(0?[1-9]|1[0-2])[\s]?��((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��', '����';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))[\s]?-[\s]?(([12][0-9])|(3[01])|(0?[1-9]))', '����';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?��((1[0-2])|(0?[1-9]))[\s]?��(([12][0-9])|(3[01])|(0?[1-9]))[\s]?��', '����';
	-- ʱ��
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?ʱ', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?:[\s]?([0-5][0-9])', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?ʱ([0-5][0-9])[\s]?��', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?��([0-5][0-9])[\s]?��', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?:[\s]?([0-5][0-9])[\s]?:[\s]?([0-5][0-9])', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?ʱ[\s]?([0-5][0-9])��([0-5][0-9])[\s]?��', 'ʱ��';
	EXEC dbo.AddPhraseRule '����', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��[\s]?((1|0?)[0-9]|2[0-3])[\s]?ʱ[\s]?([0-5][0-9])[\s]?��', 'ʱ��';
	-- ʱ���
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?��[\s]?-[\s]?(\d{4}|\d{2})[\s]?��', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?/[\s]?(\d{4}|\d{2})[\s]?����', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '((1|0?)[0-9]|2[0-3])[\s]?[��|ʱ][\s]?-[\s]?((1|0?)[0-9]|2[0-3])[\s]?[��|ʱ]', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?[��|��][\s]?-[\s]?((0?[1-9])|((1|2)[0-9])|30|31)[\s]?[��|��]', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})��((1[0-2])|(0?[1-9]))[\s]?��[\s]?-[\s]?(\d{4}|\d{2})��((1[0-2])|(0?[1-9]))[\s]?��', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '((1[0-2])|(0?[1-9]))[\s]?��[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?��[\s]?-[\s]?((1[0-2])|(0?[1-9]))[\s]?��[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?��', 'ʱ���';
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{2})[\s]?��[\s]?((1[0-2])|(0?[1-9]))[\s]?��[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?��[\s]?-[\s]?(\d{4}|\d{2})[\s]?��[\s]?((1[0-2])|(0?[1-9]))[\s]?��[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?��', 'ʱ���';

	-- �����ʶ
	-- ���֤����
	EXEC dbo.AddPhraseRule '����', '\d{15}(\d\d[0-9xX])?', '���֤';
	-- ���ڵ绰���루�׻�����
	EXEC dbo.AddPhraseRule '����', '(\d{4}|\d{3})?[\s]?-[\s]?(\d{8}|\d{7})', '�绰';
	-- HTML��ǣ��׻���������ѭ�����ܣ�
	-- EXEC dbo.AddPhraseRule '����', '<(.*)(.*)>.*<\/\1>|<(.*) \/>', 'HTML���';
	-- EMail��ַ
	EXEC dbo.AddPhraseRule '����', '\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*', '��������';
	-- IP��ַ
	EXEC dbo.AddPhraseRule '����', '((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)', 'IP��ַ';
	-- URL��ַ���׻�����
	EXEC dbo.AddPhraseRule '����', '\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))', 'URL��ַ';

	--------------------------------------------------------------------------------
	--
	-- �������ʹ���
	--
	--------------------------------------------------------------------------------

	-- ����
	EXEC dbo.AddPhraseRule '����', '$n[\.|\)]', '���';
	EXEC dbo.AddPhraseRule '����', '��[\s]?$n[\s]?��', '���';
	EXEC dbo.AddPhraseRule '����', '[0-9][\dA-Za-z]*', '���';
	EXEC dbo.AddPhraseRule '����', '$e+$n', '���';
	EXEC dbo.AddPhraseRule '����', '$e+$n$e*', '���';
	EXEC dbo.AddPhraseRule '����', '��[\s]?$n[\s]?��$n[\s]?��', '���';
	EXEC dbo.AddPhraseRule '����', '\([\s]?$n[\s]?\)|\<[\s]?$n[\s]?\>|\{[\s]?$n[\s]?\}', '���';

	EXEC dbo.AddPhraseRule '����', '$d[��|��](��|��)', '����';
	EXEC dbo.AddPhraseRule '����', '$d[\s]?:[\s]?$d', '����';
	EXEC dbo.AddPhraseRule '����', '$d[\s]?(~|��)[\s]?$d', '����';

	EXEC dbo.AddPhraseRule '����', '(��|$c){2,}', '���';
	EXEC dbo.AddPhraseRule '����', 'ʮ$c', 'ʮλ��';
	EXEC dbo.AddPhraseRule '����', '$cʮ$c?', 'ʮλ��';
	EXEC dbo.AddPhraseRule '����', '$c��(��|$cʮ)?$c?', '��λ��';
	EXEC dbo.AddPhraseRule '����', '$cǧ((��|$c��)?(��|$cʮ)?$c?)', 'ǧλ��';
	EXEC dbo.AddPhraseRule '����', '$cǧ((��|$c��)?(��|$cʮ)?$c?)��', '��λ��';
	EXEC dbo.AddPhraseRule '����', '$c��((��|$cǧ)?((��|$c��)?(��|$cʮ)?$c?))', '��λ��';

	EXEC dbo.AddPhraseRule '����', '$f���ٷֵ�', '�ٷֵ�';
	EXEC dbo.AddPhraseRule '����', '�ٷ�֮���(��|(��|$c)+)', '�ٷ���';
	EXEC dbo.AddPhraseRule '����', '�ٷ�֮(($c?��)|((($cʮ)|ʮ)?$c?))', '�ٷ���';
	EXEC dbo.AddPhraseRule '����', '�ٷ�֮(($c?��)|((($cʮ)|ʮ)?$c?))($c|��|����)?', '�ٷ���';

	--------------------------------------------------------------------------------
	--
	-- ������Ź���
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '$q';

	SET @SqlValue = '��$d';
	EXEC dbo.AddPhraseRule '����', @SqlValue, '����';
	SET @SqlValue = '��[\s]?$d[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '��$c';
	EXEC dbo.AddPhraseRule '����', @SqlValue, '����';
	SET @SqlValue = '��[\s]?$c[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '��ʮ$c?';
	EXEC dbo.AddPhraseRule '����', @SqlValue, '����';
	SET @SqlValue = '��[\s]?ʮ$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '��$cʮ$c?';
	EXEC dbo.AddPhraseRule '����', @SqlValue, '����';
	SET @SqlValue = '��[\s]?$cʮ$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '��$c��(��|$cʮ)?$c?';
	EXEC dbo.AddPhraseRule '����', @SqlValue, '����';
	SET @SqlValue = '��[\s]?$c��(��|$cʮ)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	--------------------------------------------------------------------------------
	--
	-- ���������ʹ���
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '($q|$u)';

	SET @SqlValue = '$d' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '$d[\s]?[��|��]' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, 'Լ��';

	SET @SqlValue = '��(��|��|ǧ|��|ʮ)[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, 'Լ��';

	SET @SqlValue = '$c[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = 'ʮ$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '$cʮ$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '$c��(��|$cʮ)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '$cǧ(��|$c��)?(��|$cʮ)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '(ʮ|$c)��(��|$cǧ)?(��|$c��)?(��|$cʮ)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlSuffix = '$v';
	SET @SqlValue = '$f[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	--------------------------------------------------------------------------------
	--
	-- ����Լ������
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '($q|$u)';

	SET @SqlValue = '$f[\s]?(��|��|ǧ|��)?(��|��)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, 'Լ��';

	SET @SqlValue = '(ʮ|$c)[\s]?(��|��|ǧ|��|ʮ)(��|��)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, 'Լ��';

	--------------------------------------------------------------------------------
	--
	-- ���ػ��ҹ���
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '$y';

	SET @SqlValue = '$f[\s]?(��|ǧ|��)?(��|��)?(��|��)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '$f[\s]?[��|��]?(��|ǧ|��)?(��|��)?(��|��)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	SET @SqlValue = '[1-9]\d{0,2}(,\d{3})+(��|ǧ|��)?(��|��)?(��|��)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	--------------------------------------------------------------------------------
	--
	-- ���ص�λ����
	--
	--------------------------------------------------------------------------------

	-- ��λ
	-- ��������
	SET @SqlPrefix = '($q|$u|$v|$y)';
	SET @SqlSuffix = '($q|$u|$v|$y)';
	
	SET @SqlValue = @SqlPrefix + '[\s]?/[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '��λ';

	SET @SqlValue = @SqlPrefix + '[\s]?ÿ[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '��λ';

	--------------------------------------------------------------------------------
	--
	-- ����ʱ�����
	--
	--------------------------------------------------------------------------------

	-- ʱ��
	EXEC dbo.AddPhraseRule '������', '[1-9]\d*[\s]?����', '��';
	EXEC dbo.AddPhraseRule '������', '[��]?��[ǰ|��|��|��]', '��'; 
	EXEC dbo.AddPhraseRule '������', '(��)?(һ|��|��|��)��[��]?', '����'; 
	EXEC dbo.AddPhraseRule '������', '��[һ|��|��|��|��|��|��]', '��';
	EXEC dbo.AddPhraseRule '������', '����[һ|��|��|��|��|��|��]', '����';
	EXEC dbo.AddPhraseRule '������', '((1[0-2])|(0?[1-9]))[\s]?�·�', '�·�';
	EXEC dbo.AddPhraseRule '������', '([1-9]\d*[\s]?��)+([1-9]\d*[\s]?)(һ|��|��|��|��|��|��|��|��|ʮ|ʮһ|ʮ��)����', '��';
	EXEC dbo.AddPhraseRule '������', '(((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��)*((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��', '����';
	EXEC dbo.AddPhraseRule '������', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��[\s]?((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��', '����';
	EXEC dbo.AddPhraseRule '������', '((1[0-2])|(0?[1-9]))[\s]?��[\s]?(((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��)(��((0?[1-9])|((1|2)[0-9])|30|31)[\s]?��)*', '����';

	--------------------------------------------------------------------------------
	--
	-- ������������
	--
	--------------------------------------------------------------------------------

	-- ����ʻ�
	SET @SqlSuffix = '(��|��|��|��|��|��|��|��|��|��|��)';
	SET @SqlValue = '[˫|��|��|��][\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '������', @SqlValue, '����';

	-- ����
	EXEC dbo.AddPhraseRule '������', '$e+$n��[\s]?����', '����';
	-- ��Ʊ
	EXEC dbo.AddPhraseRule '������', '(A|B|H)��', '��Ʊ';
	-- ����
	EXEC dbo.AddPhraseRule '������', '$n#', '����';
	EXEC dbo.AddPhraseRule '������', '$f����', '�ͺ�';
	-- ά����
	EXEC dbo.AddPhraseRule '������', 'ά����(A|B|C|D|E|K|H|P|M|T|U)\d{0,2}', 'ά����';

	--------------------------------------------------------------------------------
	--
	-- ���ض������
	--
	--------------------------------------------------------------------------------

	EXEC dbo.AddPhraseRule '����', '(��$b����)+��$b��', '�ṹ';
	EXEC dbo.AddPhraseRule '����', '(��$b����)+��$b��', '�ṹ';

END
GO
