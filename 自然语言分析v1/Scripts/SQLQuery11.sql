--SELECT rid, parse_rule, classification
--FROM dbo.ParseRule
--WHERE classification IN ('拼接', '配对', '单句', '通用')
--ORDER BY dbo.GetRuleLevel(classification),
--minimum_length DESC, static_suffix DESC, static_prefix DESC, parameter_count DESC, controllable_priority DESC;

--SELECT * FROM dbo.ParseRule WHERE parse_rule = '$a：“$b。”';

--DECLARE @SqlResult XML;
--DECLARE @SqlContent UString;
--SET @SqlContent = '在关国光看来，快钱平台可以提供详细的用户行为记录，进而方便商户掌握用户的!';

--DECLARE @SqlSentence UString;
--SET @SqlSentence = dbo.CutSentence(@SqlContent);
--PRINT 'Sentence = ' + @SqlSentence;

-- SELECT * FROM dbo.ParseRule
-- UPDATE dbo.ParseRule SET classification = '单句' WHERE parse_rule = '$a；';
-- SELECT COUNT(*) FROM dbo.TextPool
EXEC dbo.ParseTextPool;

