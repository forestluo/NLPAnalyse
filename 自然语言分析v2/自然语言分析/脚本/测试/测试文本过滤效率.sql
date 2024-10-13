USE [nldb]
GO

DECLARE @SqlRules XML;
-- 加载所有过滤规则
SET @SqlRules = dbo.LoadFilterRules();

DECLARE @SqlContent UString;
SET @SqlContent = '“这图书馆里有几种现代语译本，不妨读读。例如光源氏的情人六条御息所强烈地嫉妒正室葵上，在这种妒意的折磨下化为恶灵附在她身上每夜偷袭葵上的寝宫，终于把葵上折腾死了。葵上怀了源氏之子，是这条消息启动了六条御息所嫉恨的开关。光源氏招集僧侣，企图通过祈祷驱除恶灵，但由于那嫉恨过于强烈，任凭什么手段都阻止不了。';

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlCount INT = 10000;
WHILE @SqlCount > 0
BEGIN
	SET @SqlCount = @SqlCount - 1;
	SET @SqlContent = dbo.XMLUnescape(@SqlContent);
	SET @SqlContent = dbo.FilterContent(@SqlContent,NULL);
END

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());
