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
-- Description:	<往表中增加短语规则>
-- =============================================

CREATE OR ALTER PROCEDURE [加载PhraseRule]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 临时变量
	DECLARE @SqlValue UString;
	DECLARE @SqlPrefix UString;
	DECLARE @SqlSuffix UString;

	--------------------------------------------------------------------------------
	--
	-- 加载正则规则。
	--
	--------------------------------------------------------------------------------

	-- 正则表达式
	-- 编号
	EXEC dbo.AddPhraseRule '正则', '0\d*', '编号';
	EXEC dbo.AddPhraseRule '正则', 'No.\d*', '编号';
	-- 整数
	EXEC dbo.AddPhraseRule '正则', '-?[1-9]\d*', '整数';
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d*[\s]?-[\s]?[1-9]\d*', '整数';
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d{0,2}(,\d{3})+', '整数';
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d*[\s]?[十|百|千|万|亿]', '整数';
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d*[\s]?[十|百|千|万|亿|兆]亿', '整数';
	-- 百分数
	EXEC dbo.AddPhraseRule '正则', '\d+(\.\d+)?%', '百分数';
	EXEC dbo.AddPhraseRule '正则', '\d+(\.\d+)?%-\d+(\.\d+)?%', '百分数';
	-- 分数
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d*[\s]?/[\s]?[1-9]\d*', '分数';
	EXEC dbo.AddPhraseRule '正则', '[1-9]\d*[\s]?/[\s]?[1-9]\d*-[1-9]\d*/[1-9]\d*', '分数';
	-- 英文单词
	EXEC dbo.AddPhraseRule '正则', '[A-Za-z][''A-Za-z]*', '英文';
	-- 浮点数
	EXEC dbo.AddPhraseRule '正则', '-?([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)', '浮点数';
	EXEC dbo.AddPhraseRule '正则', '([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)[\s]?[十|百|千|万|亿]', '浮点数';
	EXEC dbo.AddPhraseRule '正则', '([1-9]\d*\.\d+|0\.\d*[1-9]\d*|0?\.0+)[\s]?[十|百|千|万|亿|兆]亿', '浮点数';

	-- 日期
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?年', '日期';
	EXEC dbo.AddPhraseRule '正则', '(0?[1-9]|1[0-2])[\s]?月', '日期';
	EXEC dbo.AddPhraseRule '正则', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?号', '日期';
	EXEC dbo.AddPhraseRule '正则', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日', '日期';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?年[\s]?((1[0-2])|(0?[1-9]))[\s]?月', '日期';
	EXEC dbo.AddPhraseRule '正则', '(0?[1-9]|1[0-2])[\s]?月((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日', '日期';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))[\s]?-[\s]?(([12][0-9])|(3[01])|(0?[1-9]))', '日期';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?年((1[0-2])|(0?[1-9]))[\s]?月(([12][0-9])|(3[01])|(0?[1-9]))[\s]?日', '日期';
	-- 时间
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?时', '时间';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?:[\s]?([0-5][0-9])', '时间';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?时([0-5][0-9])[\s]?分', '时间';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?点([0-5][0-9])[\s]?分', '时间';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?:[\s]?([0-5][0-9])[\s]?:[\s]?([0-5][0-9])', '时间';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?时[\s]?([0-5][0-9])分([0-5][0-9])[\s]?秒', '时间';
	EXEC dbo.AddPhraseRule '正则', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日[\s]?((1|0?)[0-9]|2[0-3])[\s]?时[\s]?([0-5][0-9])[\s]?分', '时间';
	-- 时间段
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?年[\s]?-[\s]?(\d{4}|\d{2})[\s]?年', '时间段';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?/[\s]?(\d{4}|\d{2})[\s]?财年', '时间段';
	EXEC dbo.AddPhraseRule '正则', '((1|0?)[0-9]|2[0-3])[\s]?[点|时][\s]?-[\s]?((1|0?)[0-9]|2[0-3])[\s]?[点|时]', '时间段';
	EXEC dbo.AddPhraseRule '正则', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?[日|号][\s]?-[\s]?((0?[1-9])|((1|2)[0-9])|30|31)[\s]?[日|号]', '时间段';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})年((1[0-2])|(0?[1-9]))[\s]?月[\s]?-[\s]?(\d{4}|\d{2})年((1[0-2])|(0?[1-9]))[\s]?月', '时间段';
	EXEC dbo.AddPhraseRule '正则', '((1[0-2])|(0?[1-9]))[\s]?月[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?日[\s]?-[\s]?((1[0-2])|(0?[1-9]))[\s]?月[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?日', '时间段';
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{2})[\s]?年[\s]?((1[0-2])|(0?[1-9]))[\s]?月[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?日[\s]?-[\s]?(\d{4}|\d{2})[\s]?年[\s]?((1[0-2])|(0?[1-9]))[\s]?月[\s]?(([12][0-9])|(3[01])|(0?[1-9]))[\s]?日', '时间段';

	-- 特殊标识
	-- 身份证号码
	EXEC dbo.AddPhraseRule '正则', '\d{15}(\d\d[0-9xX])?', '身份证';
	-- 国内电话号码（易混淆）
	EXEC dbo.AddPhraseRule '正则', '(\d{4}|\d{3})?[\s]?-[\s]?(\d{8}|\d{7})', '电话';
	-- HTML标记（易混淆、有死循环可能）
	-- EXEC dbo.AddPhraseRule '正则', '<(.*)(.*)>.*<\/\1>|<(.*) \/>', 'HTML标记';
	-- EMail地址
	EXEC dbo.AddPhraseRule '正则', '\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*', '电子邮箱';
	-- IP地址
	EXEC dbo.AddPhraseRule '正则', '((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)', 'IP地址';
	-- URL地址（易混淆）
	EXEC dbo.AddPhraseRule '正则', '\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))', 'URL地址';

	--------------------------------------------------------------------------------
	--
	-- 加载数词规则。
	--
	--------------------------------------------------------------------------------

	-- 数词
	EXEC dbo.AddPhraseRule '数词', '$n[\.|\)]', '编号';
	EXEC dbo.AddPhraseRule '数词', '“[\s]?$n[\s]?”', '编号';
	EXEC dbo.AddPhraseRule '数词', '[0-9][\dA-Za-z]*', '编号';
	EXEC dbo.AddPhraseRule '数词', '$e+$n', '编号';
	EXEC dbo.AddPhraseRule '数词', '$e+$n$e*', '编号';
	EXEC dbo.AddPhraseRule '数词', '“[\s]?$n[\s]?·$n[\s]?”', '编号';
	EXEC dbo.AddPhraseRule '数词', '\([\s]?$n[\s]?\)|\<[\s]?$n[\s]?\>|\{[\s]?$n[\s]?\}', '编号';

	EXEC dbo.AddPhraseRule '数词', '$d[多|余](万|亿)', '数量';
	EXEC dbo.AddPhraseRule '数词', '$d[\s]?:[\s]?$d', '比例';
	EXEC dbo.AddPhraseRule '数词', '$d[\s]?(~|至)[\s]?$d', '区间';

	EXEC dbo.AddPhraseRule '数词', '(零|$c){2,}', '序号';
	EXEC dbo.AddPhraseRule '数词', '十$c', '十位数';
	EXEC dbo.AddPhraseRule '数词', '$c十$c?', '十位数';
	EXEC dbo.AddPhraseRule '数词', '$c百(零|$c十)?$c?', '百位数';
	EXEC dbo.AddPhraseRule '数词', '$c千((零|$c百)?(零|$c十)?$c?)', '千位数';
	EXEC dbo.AddPhraseRule '数词', '$c千((零|$c百)?(零|$c十)?$c?)万', '万位数';
	EXEC dbo.AddPhraseRule '数词', '$c万((零|$c千)?((零|$c百)?(零|$c十)?$c?))', '万位数';

	EXEC dbo.AddPhraseRule '数词', '$f个百分点', '百分点';
	EXEC dbo.AddPhraseRule '数词', '百分之零点(几|(零|$c)+)', '百分数';
	EXEC dbo.AddPhraseRule '数词', '百分之(($c?百)|((($c十)|十)?$c?))', '百分数';
	EXEC dbo.AddPhraseRule '数词', '百分之(($c?百)|((($c十)|十)?$c?))($c|几|左右)?', '百分数';

	--------------------------------------------------------------------------------
	--
	-- 加载序号规则。
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '$q';

	SET @SqlValue = '第$d';
	EXEC dbo.AddPhraseRule '数词', @SqlValue, '序数';
	SET @SqlValue = '第[\s]?$d[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '序数';

	SET @SqlValue = '第$c';
	EXEC dbo.AddPhraseRule '数词', @SqlValue, '序数';
	SET @SqlValue = '第[\s]?$c[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '序数';

	SET @SqlValue = '第十$c?';
	EXEC dbo.AddPhraseRule '数词', @SqlValue, '序数';
	SET @SqlValue = '第[\s]?十$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '序数';

	SET @SqlValue = '第$c十$c?';
	EXEC dbo.AddPhraseRule '数词', @SqlValue, '序数';
	SET @SqlValue = '第[\s]?$c十$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '序数';

	SET @SqlValue = '第$c百(零|$c十)?$c?';
	EXEC dbo.AddPhraseRule '数词', @SqlValue, '序数';
	SET @SqlValue = '第[\s]?$c百(零|$c十)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '序数';

	--------------------------------------------------------------------------------
	--
	-- 加载数量词规则。
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '($q|$u)';

	SET @SqlValue = '$d' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '$d[\s]?[多|余]' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '约数';

	SET @SqlValue = '几(亿|万|千|百|十)[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '约数';

	SET @SqlValue = '$c[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '十$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '$c十$c?[\s]?' + @SqlSuffix;	
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '$c百(零|$c十)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '$c千(零|$c百)?(零|$c十)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlValue = '(十|$c)万(零|$c千)?(零|$c百)?(零|$c十)?$c?[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	SET @SqlSuffix = '$v';
	SET @SqlValue = '$f[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	--------------------------------------------------------------------------------
	--
	-- 加载约数规则。
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '($q|$u)';

	SET @SqlValue = '$f[\s]?(亿|万|千|百)?(余|多)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '约数';

	SET @SqlValue = '(十|$c)[\s]?(亿|万|千|百|十)(余|多)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '约数';

	--------------------------------------------------------------------------------
	--
	-- 加载货币规则。
	--
	--------------------------------------------------------------------------------

	SET @SqlSuffix = '$y';

	SET @SqlValue = '$f[\s]?(百|千|万)?(亿|万)?(余|多)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '货币';

	SET @SqlValue = '$f[\s]?[多|余]?(百|千|万)?(亿|万)?(余|多)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '货币';

	SET @SqlValue = '[1-9]\d{0,2}(,\d{3})+(百|千|万)?(亿|万)?(余|多)?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '货币';

	--------------------------------------------------------------------------------
	--
	-- 加载单位规则。
	--
	--------------------------------------------------------------------------------

	-- 单位
	-- 修正规则
	SET @SqlPrefix = '($q|$u|$v|$y)';
	SET @SqlSuffix = '($q|$u|$v|$y)';
	
	SET @SqlValue = @SqlPrefix + '[\s]?/[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '单位';

	SET @SqlValue = @SqlPrefix + '[\s]?每[\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '单位';

	--------------------------------------------------------------------------------
	--
	-- 加载时间规则。
	--
	--------------------------------------------------------------------------------

	-- 时间
	EXEC dbo.AddPhraseRule '数量词', '[1-9]\d*[\s]?个月', '月';
	EXEC dbo.AddPhraseRule '数量词', '[过]?年[前|中|底|后]', '年'; 
	EXEC dbo.AddPhraseRule '数量词', '(第)?(一|二|三|四)季[度]?', '季度'; 
	EXEC dbo.AddPhraseRule '数量词', '周[一|二|三|四|五|六|日]', '周';
	EXEC dbo.AddPhraseRule '数量词', '星期[一|二|三|四|五|六|日]', '星期';
	EXEC dbo.AddPhraseRule '数量词', '((1[0-2])|(0?[1-9]))[\s]?月份', '月份';
	EXEC dbo.AddPhraseRule '数量词', '([1-9]\d*[\s]?、)+([1-9]\d*[\s]?)(一|二|三|四|五|六|七|八|九|十|十一|十二)个月', '月';
	EXEC dbo.AddPhraseRule '数量词', '(((0?[1-9])|((1|2)[0-9])|30|31)[\s]?、)*((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日', '日期';
	EXEC dbo.AddPhraseRule '数量词', '((0?[1-9])|((1|2)[0-9])|30|31)[\s]?至[\s]?((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日', '日期';
	EXEC dbo.AddPhraseRule '数量词', '((1[0-2])|(0?[1-9]))[\s]?月[\s]?(((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日)(、((0?[1-9])|((1|2)[0-9])|30|31)[\s]?日)*', '日期';

	--------------------------------------------------------------------------------
	--
	-- 加载其他规则。
	--
	--------------------------------------------------------------------------------

	-- 特殊词汇
	SET @SqlSuffix = '(方|点|个|项|次|根|颗|条|名|套|份)';
	SET @SqlValue = '[双|两|叁|多][\s]?' + @SqlSuffix;
	EXEC dbo.AddPhraseRule '数量词', @SqlValue, '数量';

	-- 航班
	EXEC dbo.AddPhraseRule '数量词', '$e+$n次[\s]?航班', '航班';
	-- 股票
	EXEC dbo.AddPhraseRule '数量词', '(A|B|H)股', '股票';
	-- 油料
	EXEC dbo.AddPhraseRule '数量词', '$n#', '油料';
	EXEC dbo.AddPhraseRule '数量词', '$f个油', '油耗';
	-- 维生素
	EXEC dbo.AddPhraseRule '数量词', '维生素(A|B|C|D|E|K|H|P|M|T|U)\d{0,2}', '维生素';

	--------------------------------------------------------------------------------
	--
	-- 加载短语规则。
	--
	--------------------------------------------------------------------------------

	EXEC dbo.AddPhraseRule '短语', '(“$b”、)+“$b”', '结构';
	EXEC dbo.AddPhraseRule '短语', '(《$b》、)+《$b》', '结构';

END
GO
