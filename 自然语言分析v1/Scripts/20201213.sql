DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*SQL脚本开始*/

DECLARE @SqlXML XML;
DECLARE @SqlRule UString;
DECLARE @SqlContent UString;

SET @SqlRule = '因为$a所以$b';
SET @SqlContent = '因为他超喜欢游泳，所以我就给他报名了一个游泳班，有游泳教练专门教一个小时，然后再让他自由玩耍一个多小时。  ';

SET @SqlXML = dbo.XMLConvertRule(@SqlRule);
-- SELECT @SqlXML;
SELECT dbo.XMLParseContent(@SqlXML, @SqlContent, 1);

--SELECT * FROM OuterContent WHERE content like '%是%' and len(content) < 50

--EXEC dbo.[加载TextPool] 10000;
--SELECT * FROM ParseRule WHERE parse_rule = '$a？';
--查询OuterContent
--SELECT TOP 100 * FROM OuterContent ORDER BY oid DESC;
--SELECT TOP 100 * FROM dbo.TextPool WHERE parsed = 0  ORDER BY tid DESC;
--清理TextPool和OuterContent
--UPDATE TextPool SET parsed = 0, result = 0, remark = NULL;
--TRUNCATE TABLE OuterContent;
--EXEC dbo.[创建表ParseRule];
--EXEC dbo.[创建表RulePool];
--EXEC dbo.[加载RulePool];
--SELECT classification, parse_rule FROM dbo.ParseRule;
--SELECT * FROM dbo.RulePool
--UPDATE dbo.RulePool SET Classification = '复句' WHERE Classification = '复用';
--UPDATE dbo.TextPool SET content = dbo.XMLUnescape(content)
--SELECT dbo.ReplaceContent('&#9830;在公共浴室不乱放衣物；');
--UPDATE dbo.TextPool SET parsed = 0 WHERE tid = 2451351;
/*SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DATEDIFF(ms, @SqlDate,GetDate());
