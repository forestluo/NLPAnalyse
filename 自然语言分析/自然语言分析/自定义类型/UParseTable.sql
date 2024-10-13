USE [nldb]
GO

/****** Object:  UserDefinedTableType [dbo].[UParseTable]    Script Date: 2021/1/22 10:22:26 ******/
CREATE TYPE UParseTable AS TABLE
(
	id		INT				NOT NULL			PRIMARY KEY DEFAULT 0,
	pos		INT				NOT NULL						DEFAULT 0,
	seg		BIT				NOT NULL						DEFAULT 0,
	type	NVARCHAR(16)	NULL,
	name	NVARCHAR(16)	NULL,
	value	UString			NULL
)
GO
