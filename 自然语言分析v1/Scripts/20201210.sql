DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*SQL脚本开始*/
--EXEC dbo.OuterAddSentence '其次，快钱拥有用户的详细数据资料，可以实现数据库营销，为客户提供增值服务，例如支持客户的促销、推广等，或者为客户创造商业机会。', '$a，$b，$c，$d，$e，$f。';
--EXEC dbo.OuterAddSentence '例如支持客户的促销、推广等', '例如$a、$b等';
--EXEC dbo.OuterAddSentence '例如支持客户的促销、推广等', '例如$a的$b、$c等';
--EXEC dbo.[加载外部单句文件] 'E:\SQLServerProjects\nldb\句子.txt';
--SELECT dbo.MatchContent('你好！');

EXEC dbo.[加载TextPool] 1;

--SELECT dbo.LeftTrim('中新网７月３０日电');

--SELECT TOP 100 * FROM dbo.OuterContent ORDER BY oid DESC;

--EXEC dbo.AddGeneralRule '$a“$b”，$c“$d”';
--EXEC dbo.AddSentenceRule '$a：“$b。$c。$d。$e？$f？$g。”';

-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;

--DECLARE @SqlReduceTable UReduceTable;
---- 插入原始记录
--INSERT INTO @SqlReduceTable (id, parse_rule) VALUES (1,'$a');
--INSERT INTO @SqlReduceTable (id, parse_rule) VALUES (2,'$b');
--SELECT dbo.GetReduceRules(@SqlReduceTable);

--SELECT * FROM dbo.OuterContent WHERE content like '%因为%' AND content like '%所以%' AND (classification = '单句');
--SELECT dbo.ParseContent('因为$a，所以$b', '因为“暗能量”表现为一种斥力，所以对于宇宙来说是个坏消息。');

--EXEC dbo.[加载RulePool];
--EXEC dbo.[创建表LogicRule];

--SELECT TOP (100) tid, content	FROM dbo.TextPool WHERE parsed = 0;
--SELECT COUNT(*) FROM dbo.[TextPool（20201208备份）];

--INSERT INTO dbo.TextPool
--(content, length)
--SELECT content, LEN(content) FROM dbo.[TextPool（20201212备份）];

--TRUNCATE TABLE dbo.TextPool;
--TRUNCATE TABLE dbo.OuterContent;

--UPDATE dbo.[TextPool（20201208备份）] SET content = REPLACE(content, '', '');
--UPDATE dbo.[TextPool（20201208备份）] SET content = dbo.XMLUnescape(content);

--SELECT * FROM dbo.ParseRule ORDER BY rid;
--INSERT INTO dbo.RulePool
--(parse_rule, classification)
--SELECT parse_rule, classification FROM dbo.ParseRule ORDER BY rid;
--SELECT * FROM dbo.RulePool;
--EXEC dbo.[加载RulePool];
--EXEC dbo.[重建WordRules];

--SELECT dbo.XMLCutSentence('“阶梯电价改革总算是迈出了艰难的一步。但是电价改革完全交给市场还很遥远，需要一步步来。即便未来电价由市场决定，政府还是要监管。”林伯强对记者表示。');

--EXEC dbo.InnerAddSentence '非常感谢！';
--DECLARE @SqlXML XML = dbo.XMLConvertRule('$a，$b');
--DECLARE @SqlContent UString = '你好，天空！';
--SELECT dbo.XMLParseContent(@SqlXML, @SqlContent);

--SELECT COUNT(*) FROM dbo.TextPool
--SELECT COUNT(*) FROM dbo.OuterContent;

--DECLARE @SqlResult XML ;
--DECLARE @SqlReduceRule UString;
---- 设置简化规则
--SET @SqlReduceRule = '$a，$b';
---- 读取一段内容，生成相关结果
--SET @SqlResult = dbo.XMLReadContent('“阶梯电价改革总算是迈出了艰难的一步。但是电价改革完全交给市场还很遥远，需要一步步来。即便未来电价由市场决定，政府还是要监管。”林伯强对记者表示。');
--SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);
--SELECT dbo.XMLGetContent(@SqlResult);

/*SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DATEDIFF(ms, @SqlDate,GetDate());

-- SELECT dbo.ClearParameters('$a$b，$c，……$d');
-- SELECT TOP 100 * FROM dbo.OuterContent ORDER BY oid desc;
-- DELETE FROM dbo.OuterContent WHERE cid = -1;
-- SELECT * FROM dbo.InnerContent WHERE cid = 91612;
-- SELECT * FROM dbo.InnerContent WHERE cid = 19901 OR cid = 120479;
-- DELETE FROM dbo.OuterContent;
-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;
-- SELECT parsed, result, remark from dbo.TextPool WHERE parsed > 0;
-- SELECT result as a, count(*) as b from dbo.TextPool WHERE parsed > 0 group by result
-- SELECT count(*) from dbo.TextPool WHERE parsed > 0 AND result > 0 UNION SELECT count(*) from dbo.TextPool WHERE parsed > 0 AND result = 0;

-- DELETE FROM dbo.OuterContent WHERE classification = '单句' OR classification = '分句' OR classification = '原句';
-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL WHERE tid = 585;
-- SELECT parse_rule,count(*) as count FROM dbo.OuterContent  WHERE parse_rule IS NOT NULL GROUP BY parse_rule ORDER BY count DESC;
-- SELECT dbo.XMLConvertRule('……$a$b……$c，$d！');
-- SELECT * FROM dbo.InnerContent WHERE classification = '单句' OR classification = '分句';
-- UPDATE dbo.TextPool SET content = REPLACE(content, '＆ｌｔ；ｂｒ ／＆ｇｔ；＆ｌｔ；ｂｒ ／＆ｇｔ；', '') WHERE tid = 28069