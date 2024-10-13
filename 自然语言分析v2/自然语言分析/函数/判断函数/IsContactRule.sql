USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月21日>
-- Description:	<是否为拼接规则>
-- =============================================

CREATE OR ALTER FUNCTION IsContactRule 
(
	-- Add the parameters for the function here
	@SqlRule UString
)
RETURNS INT
AS
BEGIN
	-- 返回结果
	RETURN CASE @SqlRule
	WHEN '$a$b' THEN 1
	WHEN '$a$b' THEN 1
	WHEN '$a$b$c' THEN 1
	WHEN '$a$b$c$d' THEN 1
	WHEN '$a$b$c$d$e' THEN 1
	WHEN '$a$b$c$d$e$f' THEN 1
	WHEN '$a$b$c$d$e$f$g' THEN 1
	WHEN '$a$b$c$d$e$f$g$h' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y' THEN 1
	WHEN '$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y$z' THEN 1
	ELSE 0 END;
END
GO

