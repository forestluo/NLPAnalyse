DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*SQL�ű���ʼ*/
--EXEC dbo.OuterAddSentence '��Σ���Ǯӵ���û�����ϸ�������ϣ�����ʵ�����ݿ�Ӫ����Ϊ�ͻ��ṩ��ֵ��������֧�ֿͻ��Ĵ������ƹ�ȣ�����Ϊ�ͻ�������ҵ���ᡣ', '$a��$b��$c��$d��$e��$f��';
--EXEC dbo.OuterAddSentence '����֧�ֿͻ��Ĵ������ƹ��', '����$a��$b��';
--EXEC dbo.OuterAddSentence '����֧�ֿͻ��Ĵ������ƹ��', '����$a��$b��$c��';
--EXEC dbo.[�����ⲿ�����ļ�] 'E:\SQLServerProjects\nldb\����.txt';
--SELECT dbo.MatchContent('��ã�');

EXEC dbo.[����TextPool] 1;

--SELECT dbo.LeftTrim('���������£����յ�');

--SELECT TOP 100 * FROM dbo.OuterContent ORDER BY oid DESC;

--EXEC dbo.AddGeneralRule '$a��$b����$c��$d��';
--EXEC dbo.AddSentenceRule '$a����$b��$c��$d��$e��$f��$g����';

-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;

--DECLARE @SqlReduceTable UReduceTable;
---- ����ԭʼ��¼
--INSERT INTO @SqlReduceTable (id, parse_rule) VALUES (1,'$a');
--INSERT INTO @SqlReduceTable (id, parse_rule) VALUES (2,'$b');
--SELECT dbo.GetReduceRules(@SqlReduceTable);

--SELECT * FROM dbo.OuterContent WHERE content like '%��Ϊ%' AND content like '%����%' AND (classification = '����');
--SELECT dbo.ParseContent('��Ϊ$a������$b', '��Ϊ��������������Ϊһ�ֳ��������Զ���������˵�Ǹ�����Ϣ��');

--EXEC dbo.[����RulePool];
--EXEC dbo.[������LogicRule];

--SELECT TOP (100) tid, content	FROM dbo.TextPool WHERE parsed = 0;
--SELECT COUNT(*) FROM dbo.[TextPool��20201208���ݣ�];

--INSERT INTO dbo.TextPool
--(content, length)
--SELECT content, LEN(content) FROM dbo.[TextPool��20201212���ݣ�];

--TRUNCATE TABLE dbo.TextPool;
--TRUNCATE TABLE dbo.OuterContent;

--UPDATE dbo.[TextPool��20201208���ݣ�] SET content = REPLACE(content, '��', '');
--UPDATE dbo.[TextPool��20201208���ݣ�] SET content = dbo.XMLUnescape(content);

--SELECT * FROM dbo.ParseRule ORDER BY rid;
--INSERT INTO dbo.RulePool
--(parse_rule, classification)
--SELECT parse_rule, classification FROM dbo.ParseRule ORDER BY rid;
--SELECT * FROM dbo.RulePool;
--EXEC dbo.[����RulePool];
--EXEC dbo.[�ؽ�WordRules];

--SELECT dbo.XMLCutSentence('�����ݵ�۸ĸ������������˼��ѵ�һ�������ǵ�۸ĸ���ȫ�����г�����ңԶ����Ҫһ������������δ��������г���������������Ҫ��ܡ����ֲ�ǿ�Լ��߱�ʾ��');

--EXEC dbo.InnerAddSentence '�ǳ���л��';
--DECLARE @SqlXML XML = dbo.XMLConvertRule('$a��$b');
--DECLARE @SqlContent UString = '��ã���գ�';
--SELECT dbo.XMLParseContent(@SqlXML, @SqlContent);

--SELECT COUNT(*) FROM dbo.TextPool
--SELECT COUNT(*) FROM dbo.OuterContent;

--DECLARE @SqlResult XML ;
--DECLARE @SqlReduceRule UString;
---- ���ü򻯹���
--SET @SqlReduceRule = '$a��$b';
---- ��ȡһ�����ݣ�������ؽ��
--SET @SqlResult = dbo.XMLReadContent('�����ݵ�۸ĸ������������˼��ѵ�һ�������ǵ�۸ĸ���ȫ�����г�����ңԶ����Ҫһ������������δ��������г���������������Ҫ��ܡ����ֲ�ǿ�Լ��߱�ʾ��');
--SET @SqlResult = dbo.GetReducedResult(@SqlResult, @SqlReduceRule);
--SELECT dbo.XMLGetContent(@SqlResult);

/*SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DATEDIFF(ms, @SqlDate,GetDate());

-- SELECT dbo.ClearParameters('$a$b��$c������$d');
-- SELECT TOP 100 * FROM dbo.OuterContent ORDER BY oid desc;
-- DELETE FROM dbo.OuterContent WHERE cid = -1;
-- SELECT * FROM dbo.InnerContent WHERE cid = 91612;
-- SELECT * FROM dbo.InnerContent WHERE cid = 19901 OR cid = 120479;
-- DELETE FROM dbo.OuterContent;
-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL;
-- SELECT parsed, result, remark from dbo.TextPool WHERE parsed > 0;
-- SELECT result as a, count(*) as b from dbo.TextPool WHERE parsed > 0 group by result
-- SELECT count(*) from dbo.TextPool WHERE parsed > 0 AND result > 0 UNION SELECT count(*) from dbo.TextPool WHERE parsed > 0 AND result = 0;

-- DELETE FROM dbo.OuterContent WHERE classification = '����' OR classification = '�־�' OR classification = 'ԭ��';
-- UPDATE dbo.TextPool SET parsed = 0, result = 0, remark = NULL WHERE tid = 585;
-- SELECT parse_rule,count(*) as count FROM dbo.OuterContent  WHERE parse_rule IS NOT NULL GROUP BY parse_rule ORDER BY count DESC;
-- SELECT dbo.XMLConvertRule('����$a$b����$c��$d��');
-- SELECT * FROM dbo.InnerContent WHERE classification = '����' OR classification = '�־�';
-- UPDATE dbo.TextPool SET content = REPLACE(content, '���������� ������������������� ���������', '') WHERE tid = 28069