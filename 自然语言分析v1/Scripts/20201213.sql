DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*SQL�ű���ʼ*/

DECLARE @SqlXML XML;
DECLARE @SqlRule UString;
DECLARE @SqlContent UString;

SET @SqlRule = '��Ϊ$a����$b';
SET @SqlContent = '��Ϊ����ϲ����Ӿ�������Ҿ͸���������һ����Ӿ�࣬����Ӿ����ר�Ž�һ��Сʱ��Ȼ��������������ˣһ����Сʱ��  ';

SET @SqlXML = dbo.XMLConvertRule(@SqlRule);
-- SELECT @SqlXML;
SELECT dbo.XMLParseContent(@SqlXML, @SqlContent, 1);

--SELECT * FROM OuterContent WHERE content like '%��%' and len(content) < 50

--EXEC dbo.[����TextPool] 10000;
--SELECT * FROM ParseRule WHERE parse_rule = '$a��';
--��ѯOuterContent
--SELECT TOP 100 * FROM OuterContent ORDER BY oid DESC;
--SELECT TOP 100 * FROM dbo.TextPool WHERE parsed = 0  ORDER BY tid DESC;
--����TextPool��OuterContent
--UPDATE TextPool SET parsed = 0, result = 0, remark = NULL;
--TRUNCATE TABLE OuterContent;
--EXEC dbo.[������ParseRule];
--EXEC dbo.[������RulePool];
--EXEC dbo.[����RulePool];
--SELECT classification, parse_rule FROM dbo.ParseRule;
--SELECT * FROM dbo.RulePool
--UPDATE dbo.RulePool SET Classification = '����' WHERE Classification = '����';
--UPDATE dbo.TextPool SET content = dbo.XMLUnescape(content)
--SELECT dbo.ReplaceContent('&#9830;�ڹ���ԡ�Ҳ��ҷ����');
--UPDATE dbo.TextPool SET parsed = 0 WHERE tid = 2451351;
/*SQL�ű�����*/
SELECT [���ִ�л���ʱ��(����)] = DATEDIFF(ms, @SqlDate,GetDate());
