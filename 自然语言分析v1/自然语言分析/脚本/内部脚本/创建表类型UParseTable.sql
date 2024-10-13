-- ================================
-- Create User-defined Table Type
-- ================================
USE [nldb]
GO

-- Create the data type
CREATE TYPE UParseTable AS TABLE
(
	id			INT					PRIMARY KEY			NOT NULL			DEFAULT 0,
	pos			INT					NOT NULL			DEFAULT 0,
	seg			BIT					NOT NULL			DEFAULT 0,
	type		NVARCHAR(16)		NULL,
	name		NVARCHAR(16)		NULL,
	value		UString				NULL
)
GO
