--SELECT * FROM dbo.ParseRule WHERE classification = '����' ORDER BY parameter_count DESC;
--SELECT parameter_count,COUNT(*) FROM dbo.ParseRule GROUP BY parameter_count;
--SELECT COUNT(*) FROM dbo.TextPool WHERE parsed = 1;
--SELECT result, COUNT(*) AS result_count FROM dbo.TextPool WHERE parsed = 1 GROUP BY result ORDER BY result_count DESC;
--SELECT remark FROM dbo.TextPool WHERE parsed = 1 AND result > 0 order by tid DESC;

--SELECT * FROM dbo.TextContent WHERE classification = '����' OR classification = '�־�' order by cid desc;
--SELECT * FROM dbo.TextContent WHERE content like '% ��%';

--SELECT * FROM dbo.TextContent WHERE parse_rule = '$a��$b��$c��$d��$e��$f��$g��$h��$i��$j��$k��$l��$m��';

--SELECT * FROM dbo.TextContent WHERE content IN ('����', '˲��', '������','ͼΪ','����˲��');

--DECLARE @SqlResult XML;
--SET @SqlResult = dbo.XMLGetWordRule('���������·��������ضȻ���');
--PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

--SELECT COUNT(*) FROM dbo.TextPool WHERE parsed = 1 AND result > 0 AND dbo.HasPunctuation(remark) = 0
--SELECT * FROM dbo.TextPool WHERE parsed = 1 AND result > 0 AND dbo.HasPunctuation(remark) = 0

--Select ObjectProperty(Object_ID('ParseRule'),'TableIsPinned')
SELECT * FROM dbo.TextContent WHERE content like '%����%' AND content like '%����%'