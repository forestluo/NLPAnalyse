--SELECT rid, parse_rule, classification
--FROM dbo.ParseRule
--WHERE classification IN ('ƴ��', '���', '����', 'ͨ��')
--ORDER BY dbo.GetRuleLevel(classification),
--minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC;

--SELECT * FROM dbo.ParseRule WHERE parse_rule = '$a����$b����';

--DECLARE @SqlResult XML;
--DECLARE @SqlContent UString;
--SET @SqlContent = '�ڹع��⿴������Ǯƽ̨�����ṩ��ϸ���û���Ϊ��¼�����������̻������û���!';

--DECLARE @SqlSentence UString;
--SET @SqlSentence = dbo.CutSentence(@SqlContent);
--PRINT 'Sentence = ' + @SqlSentence;

-- SELECT * FROM dbo.ParseRule
-- UPDATE dbo.ParseRule SET classification = '����' WHERE parse_rule = '$a��';
-- SELECT COUNT(*) FROM dbo.TextPool
EXEC dbo.ParseTextPool;

