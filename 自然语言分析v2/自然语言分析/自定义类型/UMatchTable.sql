USE [nldb]
GO

/****** Object:  UserDefinedTableType [dbo].[UMatchTable]    Script Date: 2020/12/16 9:45:28 ******/
CREATE TYPE UMatchTable AS TABLE
(
	-- 编号
	id			INT			NOT NULL			IDENTITY(1,1),
	-- 规则
	expression	UString		NULL,
	-- 匹配结果
	value		UString		NULL,
	-- 匹配结果长度
	length		INT			NOT NULL			DEFAULT 0,
	-- 匹配起始位置
	position	INT			NOT NULL			DEFAULT 0
)
GO
