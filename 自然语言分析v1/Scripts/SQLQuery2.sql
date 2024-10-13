--DECLARE @SqlSentence UString = '然而这种支付模式和传统的网络支付并无本质的区别，因为每一个手机号码和邮件地址背后都会对应着一个账户——这个账户可以是信用卡账户、借记卡账户，也包括邮局汇款、手机代收、电话代收、预付费卡和点卡等多种形式。';
--DECLARE @SqlRule UString;
--SET @SqlRule = dbo.GetSentenceRule(@SqlSentence);
--PRINT @SqlRule;

--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLReadContent(@SqlSentence);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--SELECT dbo.HasPunctuation('我的东西。”');

--DECLARE @SqlChar NCHAR(1);
--SET @SqlChar = SUBSTRING('我的东西。”', 1, 1);
--PRINT @SqlChar;

--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLConvertRule('“$a，$b，”$c，：“$d');
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--DECLARE @SqlContent UString = '“你好，你好，”你的，：“我的东西。”';
--SET @SqlXML = dbo.XMLParseContent(@SqlXML, @SqlContent);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--DECLARE @SqlWord UString = '然而这种支付模式和传统的网络支付并无本质的区别';
--DECLARE @SqlXML XML;
--SET @SqlXML = dbo.XMLGetWordRule(@SqlWord);
--PRINT CONVERT(NVARCHAR(MAX), @SqlXML);

--SELECT * FROM dbo.TextContent WHERE classification = '分词' ORDER BY length DESC;
--SELECT TOP 100 cid, content, a_id, parse_rule, dbo.VerifyWordRule(content) FROM dbo.TextContent
--	WHERE (classification = '分词' or classification = '单词') AND dbo.VerifyWordRule(content) <= 0;

--SELECT * FROM dbo.TextContent WHERE classification = '单句' ORDER BY length DESC;

--SELECT TOP 100 cid, content, a_id, parse_rule, dbo.VerifyWordRule(content) FROM dbo.TextContent
--	WHERE classification = '单句' AND dbo.VerifySentenceRule(content) <= 0;

--SELECT dbo.VerifyWordRule(content),* FROM dbo.TextContent WHERE cid IN (175121,175140,175037,12698,175120,175139,175036);

--SELECT * FROM dbo.TextContent WHERE (classification = '单句' OR classification = '分句') AND content = '本报讯 （记者陈琰）';

--SELECT * FROM dbo.ParseRule;
--SELECT * FROM dbo.ParseRule WHERE classification = '单句';
--EXEC dbo.LoadSentenceFile 'E:\SQLServerProjects\nldb\Sample.txt';
--DELETE FROM dbo.TextContent WHERE classification IN ('单句', '分句');
--SELECT * FROM dbo.TextContent WHERE parse_rule = '$a，$b，$c，$d，$e：$f。$g，$h。';

--DECLARE @SqlResult XML;
--SET @SqlResult = dbo.XMLParseSentence('对于为什么选择第三方支付作为创业方向，他曾经对媒体这样说：“我能看到这个胡同对面是什么，别人只能看到这个胡同。”');
--PRINT CONVERT(NVARCHAR(MAX), @SqlResult);