--DECLARE @SqlSentence UString = 'Ȼ������֧��ģʽ�ʹ�ͳ������֧�����ޱ��ʵ�������Ϊÿһ���ֻ�������ʼ���ַ���󶼻��Ӧ��һ���˻���������˻����������ÿ��˻�����ǿ��˻���Ҳ�����ʾֻ��ֻ����ա��绰���ա�Ԥ���ѿ��͵㿨�ȶ�����ʽ��';
--DECLARE @SqlRule UString;
--SET @SqlRule = dbo.GetSentenceRule(@SqlSentence);
--PRINT @SqlRule;

--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLReadContent(@SqlSentence);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--SELECT dbo.HasPunctuation('�ҵĶ�������');

--DECLARE @SqlChar NCHAR(1);
--SET @SqlChar = SUBSTRING('�ҵĶ�������', 1, 1);
--PRINT @SqlChar;

--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLConvertRule('��$a��$b����$c������$d');
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--DECLARE @SqlContent UString = '����ã���ã�����ģ������ҵĶ�������';
--SET @SqlXML = dbo.XMLParseContent(@SqlXML, @SqlContent);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--DECLARE @SqlWord UString = 'Ȼ������֧��ģʽ�ʹ�ͳ������֧�����ޱ��ʵ�����';
--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLGetWordRule(@SqlWord);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--SELECT * FROM dbo.TextContent WHERE classification = '�ִ�' ORDER BY length DESC;
--SELECT TOP 100 cid, content, a_id, parse_rule, dbo.VerifyWordRule(content) FROM dbo.TextContent
--	WHERE (classification = '�ִ�' or classification = '����') AND dbo.VerifyWordRule(content) <= 0;

--SELECT * FROM dbo.TextContent WHERE classification = '����' ORDER BY length DESC;

--SELECT TOP 100 cid, content, a_id, parse_rule, dbo.VerifyWordRule(content) FROM dbo.TextContent
--	WHERE classification = '����' AND dbo.VerifySentenceRule(content) <= 0;

--SELECT dbo.VerifyWordRule(content),* FROM dbo.TextContent WHERE cid IN (175121,175140,175037,12698,175120,175139,175036);

--SELECT * FROM dbo.TextContent WHERE (classification = '����' OR classification = '�־�') AND content = '����Ѷ �����߳�����';

--SELECT * FROM dbo.ParseRule;
--SELECT * FROM dbo.ParseRule WHERE classification = '����';
--EXEC dbo.LoadSentenceFile 'E:\SQLServerProjects\nldb\Sample.txt';
--DELETE FROM dbo.TextContent WHERE classification IN ('����', '�־�');
--SELECT * FROM dbo.TextContent WHERE parse_rule = '$a��$b��$c��$d��$e��$f��$g��$h��';

--DECLARE @SqlResult XML;
--SET @SqlResult = dbo.XMLParseSentence('����Ϊʲôѡ�������֧����Ϊ��ҵ������������ý������˵�������ܿ��������ͬ������ʲô������ֻ�ܿ��������ͬ����');
--PRINT CONVERT(NVARCHAR(MAX), @SqlResult);