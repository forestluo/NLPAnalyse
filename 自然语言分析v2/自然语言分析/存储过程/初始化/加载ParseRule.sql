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
-- Author:		<罗堃>
-- Create date: <2020年12月27日>
-- Description:	<往表中增加解析规则>
-- =============================================

CREATE OR ALTER PROCEDURE [加载ParseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- 声明临时变量
	DECLARE @SqlIndex INT;
	DECLARE @SqlRule UString;

	EXEC dbo.AddParseRule '配对','〈$a〉';
	EXEC dbo.AddParseRule '配对','《$a》';
	EXEC dbo.AddParseRule '配对','“$a”';
	EXEC dbo.AddParseRule '配对','【$a】';
	EXEC dbo.AddParseRule '配对','（$a）';
	EXEC dbo.AddParseRule '配对','‘$a’';
	-- 禁止加入
	-- EXEC dbo.AddParseRule '拼接','$a';
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '拼接', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '拼接','$a$b';
	EXEC dbo.AddParseRule '拼接','$a$b$c';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y';
	EXEC dbo.AddParseRule '拼接','$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o$p$q$r$s$t$u$v$w$x$y$z';
	*/
	-- 禁止加入
	-- EXEC dbo.AddParseRule '通用','$a，';
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'，$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '通用', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '通用','$a，$b';
	EXEC dbo.AddParseRule '通用','$a，$b，$c';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x，$y';
	EXEC dbo.AddParseRule '通用','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x，$y，$z';
	*/
	-- 禁止加入
	-- EXEC dbo.AddParseRule '通用','$a：';
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'：$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '通用', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '通用','$a：$b';
	EXEC dbo.AddParseRule '通用','$a：$b：$c';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u：$v';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u：$v：$w';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u：$v：$w：$x';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u：$v：$w：$x：$y';
	EXEC dbo.AddParseRule '通用','$a：$b：$c：$d：$e：$f：$g：$h：$i：$j：$k：$l：$m：$n：$o：$p：$q：$r：$s：$t：$u：$v：$w：$x：$y：$z';
	*/
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'；$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '复句', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '复句','$a；$b';
	EXEC dbo.AddParseRule '复句','$a；$b；$c';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m；$n';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m；$n；$o';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m；$n；$o；$p';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m；$n；$o；$p；$q';
	EXEC dbo.AddParseRule '复句','$a；$b；$c；$d；$e；$f；$g；$h；$i；$j；$k；$l；$m；$n；$o；$p；$q；$r';
	*/
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'！$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '复句', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '复句','$a！$b';
	EXEC dbo.AddParseRule '复句','$a！$b！$c';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e！$f';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e！$f！$g';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e！$f！$g！$h';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e！$f！$g！$h！$i';
	EXEC dbo.AddParseRule '复句','$a！$b！$c！$d！$e！$f！$g！$h！$i！$j';
	*/
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'？$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '复句', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '复句','$a？$b';
	EXEC dbo.AddParseRule '复句','$a？$b？$c';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e？$f';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e？$f？$g';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e？$f？$g？$h';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e？$f？$g？$h？$i';
	EXEC dbo.AddParseRule '复句','$a？$b？$c？$d？$e？$f？$g？$h？$i？$j';
	*/
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'。$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '复句', @SqlRule;
	END
	/*
	EXEC dbo.AddParseRule '复句','$a。$b';
	EXEC dbo.AddParseRule '复句','$a。$b。$c';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u。$v';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u。$v。$w';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u。$v。$w。$x';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u。$v。$w。$x。$y';
	EXEC dbo.AddParseRule '复句','$a。$b。$c。$d。$e。$f。$g。$h。$i。$j。$k。$l。$m。$n。$o。$p。$q。$r。$s。$t。$u。$v。$w。$x。$y。$z';
	*/
	-- 设置初始值
	SET @SqlIndex = 1;
	SET @SqlRule = '$a';
	-- 循环处理
	WHILE @SqlIndex < 26
	BEGIN
		-- 增加计数器
		SET @SqlIndex = @SqlIndex + 1;
		-- 增加参数
		SET @SqlRule = @SqlRule +
			'，$' + dbo.GetLowercase(@SqlIndex);
		-- 加入规则
		SET @SqlRule = @SqlRule + '。';/*加上结尾*/
		-- PRINT @SqlRule;
		EXEC dbo.AddParseRule '单句', @SqlRule;
		SET @SqlRule = LEFT(@SqlRule, LEN(@SqlRule) - 1);/*尾部还原*/
	END
	/*
	EXEC dbo.AddParseRule '单句','$a，$b。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x，$y。';
	EXEC dbo.AddParseRule '单句','$a，$b，$c，$d，$e，$f，$g，$h，$i，$j，$k，$l，$m，$n，$o，$p，$q，$r，$t，$u，$v，$w，$x，$y，$z。';
	*/

	EXEC dbo.AddParseRule '单句','$a；';
	EXEC dbo.AddParseRule '单句','$a。';
	EXEC dbo.AddParseRule '单句','$a？';
	EXEC dbo.AddParseRule '单句','$a！';
	EXEC dbo.AddParseRule '单句','$a？！';

	EXEC dbo.AddParseRule '通用','“$a，”';
	EXEC dbo.AddParseRule '通用','“$a：”';

	EXEC dbo.AddParseRule '单句','“$a；”';
	EXEC dbo.AddParseRule '单句','“$a。”';
	EXEC dbo.AddParseRule '单句','“$a！”';
	EXEC dbo.AddParseRule '单句','“$a？”';

	EXEC dbo.AddParseRule '单句','（$a。）';
	EXEC dbo.AddParseRule '单句','（$a！）';
	EXEC dbo.AddParseRule '单句','（$a？）';

	EXEC dbo.AddParseRule '单句','‘$a。’';
	EXEC dbo.AddParseRule '单句','‘$a！’';
	EXEC dbo.AddParseRule '单句','‘$a？’';

	EXEC dbo.AddParseRule '单句','“‘$a。’”';
	EXEC dbo.AddParseRule '单句','“‘$a！’”';
	EXEC dbo.AddParseRule '单句','“‘$a？’”';

	EXEC dbo.AddParseRule '单句','《$a。》';
	EXEC dbo.AddParseRule '单句','《$a！》';
	EXEC dbo.AddParseRule '单句','《$a？》';

	EXEC dbo.AddParseRule '通用','【$a：】';
	EXEC dbo.AddParseRule '单句','【$a。】';
	EXEC dbo.AddParseRule '单句','【$a！】';
	EXEC dbo.AddParseRule '单句','【$a？】';

	EXEC dbo.AddParseRule '单句','$a：$b。';
	EXEC dbo.AddParseRule '单句','$a：$b！';
	EXEC dbo.AddParseRule '单句','$a：$b？';

	EXEC dbo.AddParseRule '单句','$a：“$b”';
	EXEC dbo.AddParseRule '单句','“$a，”$b。';
	EXEC dbo.AddParseRule '单句','“$a：”$b。';
	EXEC dbo.AddParseRule '单句','“$a；”$b。';
	EXEC dbo.AddParseRule '单句','“$a。”$b。';
	EXEC dbo.AddParseRule '单句','“$a？”$b。';
	EXEC dbo.AddParseRule '单句','“$a！”$b。';

	EXEC dbo.AddParseRule '单句','$a“$b。”';
	EXEC dbo.AddParseRule '单句','$a“$b？”';
	EXEC dbo.AddParseRule '单句','$a“$b！”';

	EXEC dbo.AddParseRule '单句','$a，“$b；”';
	EXEC dbo.AddParseRule '单句','$a，“$b。”';
	EXEC dbo.AddParseRule '单句','$a，“$b？”';
	EXEC dbo.AddParseRule '单句','$a，“$b！”';

	EXEC dbo.AddParseRule '单句','$a：“$b。”';
	EXEC dbo.AddParseRule '单句','$a：“$b？”';
	EXEC dbo.AddParseRule '单句','$a：“$b！”';
	
	EXEC dbo.AddParseRule '单句','$a（$b。）';
	EXEC dbo.AddParseRule '单句','$a（$b？）';
	EXEC dbo.AddParseRule '单句','$a（$b！）';

	EXEC dbo.AddParseRule '单句','$a：（$b。）';
	EXEC dbo.AddParseRule '单句','$a：（$b？）';
	EXEC dbo.AddParseRule '单句','$a：（$b！）';

	EXEC dbo.AddParseRule '单句','$a‘$b。’';
	EXEC dbo.AddParseRule '单句','$a‘$b？’';
	EXEC dbo.AddParseRule '单句','$a‘$b！’';
	
	EXEC dbo.AddParseRule '单句','‘$a，’$b。';
	EXEC dbo.AddParseRule '单句','‘$a。’$b。';
	EXEC dbo.AddParseRule '单句','‘$a？’$b。';
	EXEC dbo.AddParseRule '单句','‘$a！’$b。';

	EXEC dbo.AddParseRule '单句','$a：‘$b。’';
	EXEC dbo.AddParseRule '单句','$a：‘$b？’';
	EXEC dbo.AddParseRule '单句','$a：‘$b！’';

	EXEC dbo.AddParseRule '单句','“$a‘$b。’”';
	EXEC dbo.AddParseRule '单句','“$a‘$b？’”';
	EXEC dbo.AddParseRule '单句','“$a‘$b！’”';

	EXEC dbo.AddParseRule '单句','“$a！‘$b！’”';
	EXEC dbo.AddParseRule '单句','“$a‘$b？’。”';

	EXEC dbo.AddParseRule '单句','“$a，‘$b。’”';
	EXEC dbo.AddParseRule '单句','“$a，‘$b？’”';
	EXEC dbo.AddParseRule '单句','“$a，‘$b！’”';

	EXEC dbo.AddParseRule '单句','“$a：‘$b。’”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b？’”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b！’”';

	EXEC dbo.AddParseRule '单句','“$a。‘$b。’”'
	EXEC dbo.AddParseRule '单句','“$a。‘$b？’”'
	EXEC dbo.AddParseRule '单句','“$a。‘$b！’”'

	EXEC dbo.AddParseRule '单句','“‘$a，’”$b。';
	EXEC dbo.AddParseRule '单句','“‘$a，’”$b？';
	EXEC dbo.AddParseRule '单句','“‘$a，’”$b！';

	EXEC dbo.AddParseRule '复句','$a《$b。》$c';
	EXEC dbo.AddParseRule '复句','$a《$b！》$c';
	EXEC dbo.AddParseRule '复句','$a《$b？》$c';

	EXEC dbo.AddParseRule '复句','$a（$b。）$c';
	EXEC dbo.AddParseRule '复句','$a（$b！），$c';
	EXEC dbo.AddParseRule '复句','$a（$b？），$c';

	EXEC dbo.AddParseRule '复句','$a！（$b。）$c';
	EXEC dbo.AddParseRule '复句','$a！（$b！）$c';
	EXEC dbo.AddParseRule '复句','$a！（$b？）$c';

	EXEC dbo.AddParseRule '单句','‘$a，’$b。‘$c。’';

	EXEC dbo.AddParseRule '单句','‘$a，’$b，‘$c。’';
	EXEC dbo.AddParseRule '单句','‘$a，’$b，‘$c？’';
	EXEC dbo.AddParseRule '单句','‘$a，’$b，‘$c！’';
	EXEC dbo.AddParseRule '单句','‘$a！’$b，‘$c。’';
	EXEC dbo.AddParseRule '单句','‘$a！’$b。‘$c！’';
	
	EXEC dbo.AddParseRule '单句','“$a：‘$b？’$c”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b！’$c”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b。’$c”';
	
	EXEC dbo.AddParseRule '单句','“$a：‘$b？’$c。”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b！’$c。”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b。’$c。”';

	EXEC dbo.AddParseRule '单句','“$a‘$b！’，$c。”';
	EXEC dbo.AddParseRule '单句','“$a。（$b。）$c！”';
	EXEC dbo.AddParseRule '单句','“$a：‘$b！’$c。”';

	EXEC dbo.AddParseRule '单句','“$a：”$b。“$c？”';

	EXEC dbo.AddParseRule '单句','$a，“$b，”$c。';

	EXEC dbo.AddParseRule '单句','$a：“$b；$c。”';
	EXEC dbo.AddParseRule '单句','$a：“$b。$c。”';
	EXEC dbo.AddParseRule '单句','$a：“$b？$c。”';
	EXEC dbo.AddParseRule '单句','$a：“$b！$c。”';
	EXEC dbo.AddParseRule '单句','$a：“$b。$c？”';
	EXEC dbo.AddParseRule '单句','$a：“$b。$c！”';
		
	EXEC dbo.AddParseRule '单句','“$a？！$b！”$c。';
	EXEC dbo.AddParseRule '单句','“$a。”$b，“$c。”';
	EXEC dbo.AddParseRule '单句','“$a，”$b，“$c。”';
	EXEC dbo.AddParseRule '单句','“$a？”$b，“$c。”';
	EXEC dbo.AddParseRule '单句','“$a！”$b，“$c。”';
	EXEC dbo.AddParseRule '单句','“$a，”$b；“$c。”';
	EXEC dbo.AddParseRule '单句','“$a，”$b：“$c。”';
	EXEC dbo.AddParseRule '单句','“$a，”$b，“$c？”';
	EXEC dbo.AddParseRule '单句','“$a！$b，”“$c！”';

	EXEC dbo.AddParseRule '单句','$a，“$b；$c，”$d。';
	EXEC dbo.AddParseRule '单句','$a，“$b，”$c，“$d。”';
	EXEC dbo.AddParseRule '单句','$a，“$b‘$c，’$d。”';
	EXEC dbo.AddParseRule '单句','$a：“$b：‘$c!’$d。”';
	EXEC dbo.AddParseRule '单句','$a：“$b：‘$c。’$d！”';

	EXEC dbo.AddParseRule '单句','“$a：‘$b。’$c：‘$d？’$e：‘$f。’”';

END
GO
