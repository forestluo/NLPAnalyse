USE [nldb]
GO

/****** Object:  UserDefinedTableType [dbo].[UMatchTable]    Script Date: 2020/12/16 9:45:28 ******/
CREATE TYPE UMatchTable AS TABLE
(
	-- ���
	id			INT			NOT NULL			IDENTITY(1,1),
	-- ����
	expression	UString		NULL,
	-- ƥ����
	value		UString		NULL,
	-- ƥ��������
	length		INT			NOT NULL			DEFAULT 0,
	-- ƥ����ʼλ��
	position	INT			NOT NULL			DEFAULT 0
)
GO
