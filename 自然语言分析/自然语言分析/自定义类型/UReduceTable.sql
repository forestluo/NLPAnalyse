USE [nldb]
GO

/****** Object:  UserDefinedTableType [dbo].[UReduceTable]    Script Date: 2021/1/22 11:13:02 ******/
CREATE TYPE UReduceTable AS TABLE
(
	id			INT				IDENTITY(1,1)	NOT NULL,
	parse_rule	NVARCHAR(256)					NOT NULL
)
GO


