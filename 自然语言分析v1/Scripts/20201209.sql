declare @d datetime
set @d=getdate()
/*你的SQL脚本开始*/
--EXEC dbo.[创建表InnerContent];
--EXEC dbo.AddGeneralRule '…$a￥《$b》，…$c（…$d…$e《$f》$g';
--SELECT dbo.XMLGetWordRule('好汉不吃眼前亏');
--EXEC dbo.[重建WordRules];
--EXEC dbo.[VerifyWordRule] '阿巴拉';
--DECLARE @SqlContent UString = '麻烦。';
--DECLARE @SqlXML XML;
--SELECT dbo.XMLParseSentence(@SqlContent);
EXEC dbo.AddSentence '谢谢！';

/*你的SQL脚本结束*/
select [语句执行花费时间(毫秒)]=datediff(ms,@d,getdate())

-- SELECT * FROM dbo.InnerContent WHERE content = '谢谢！';
-- DELETE FROM dbo.InnerContent WHERE content = '你好！';
-- SELECT dbo.VerifyContentRule('你好！');
-- SELECT * FROM dbo.InnerContent WHERE content = '你好！' OR cid = 86100 OR cid = 86035 OR cid = 46989;

--Declare @Sample table
--(xmlCol xml)

--Insert into @Sample
--values
--('<dev:Doc xmlns:dev="http://www.w3.org/2001/XMLSchema" 
--                       SchemaVersion="0.1" Settings="Testing" Ttile="Ordering">
--        <Person id="1">
--            <FirstName>Name</FirstName>
--        </Person>
--      </dev:Doc>')
-- Select * from @Sample
-- Update @Sample
-- SET xmlCol.modify(
--                  'declare namespace ns="http://www.w3.org/2001/XMLSchema";
--                   replace value of (/ns:Doc/@Settings)[1]
--                   with "NewTest"')

-- Select * from @Sample

--SELECT * FROM dbo.ParseRule;

--DECLARE @SqlResult XML = '<result id="1" start="0" end="0"><var name="a" id="0" pos="0">$a</var><pad id="0" pos="0">（</pad><var name="b" id="0" pos="0">$b</var><pad id="0" pos="0">）</pad></result>';
--UPDATE @SqlResult
--	SET @SqlResult.modify('replace value of ((//result/*/@id)[1]) with "1"');
--SELECT @SqlResult;

--SELECT
--	Child.value('local-name(.)','nvarchar(max)') AS name,
--	Child.value('(@id)[1]','int') AS ID,
--	Child.value('(text())[1]','nvarchar(max)') AS Content
--FROM @SqlResult.nodes('//result/*') AS N(Child);

--DECLARE @XMLTable AS TABLE(xmlCol XML);
--INSERT INTO @XMLTable (xmlCol) VALUES (@SqlResult);

--UPDATE @XMLTable
--	SET xmlCol.modify('replace value of (//result/*/@id)[1] with "1"');
--SELECT @SqlResult;


	---- 声明静态游标
	--DECLARE SqlCursor CURSOR STATIC FOR 
	--	SELECT
	--		-- node.value('(@id)[1]','int') AS id,
	--		nodes.value('local-name(.)','nvarchar(max)') AS name,
	--		nodes.value('(text())[1]','nvarchar(max)') AS content
	--		FROM @SqlXML.nodes('//result/*') AS N(nodes); 
	---- 打开游标
	--OPEN SqlCursor;
	---- 获取一行记录
	--FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	---- 检查结果
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	-- 检查本地名称
	--	IF @SqlName = 'var'
	--	BEGIN
	--		-- 检查前面的参数名
	--		IF @SqlPrevName = 'var'
	--		-- 检查本地名称
	--		-- 连续两个变量，则无法实现正则解析
	--			SET @SqlNormalized = 0;
	--		-- 设置最小长度
	--		SET @SqlLength = @SqlLength + 1;
	--	END
	--	ELSE IF @SqlName = 'pad'
	--	BEGIN
	--		-- 检查是否是开头
	--		IF @SqlIndex = 1
	--			SET @SqlPrefix = 1;
	--		-- 检查是否是结尾
	--		ELSE IF @SqlIndex = @SqlCount
	--		BEGIN
	--			-- 设置标记位
	--			SET @SqlSuffix = 1;
	--			-- 检查结尾符号
	--			SET @SqlPriority = dbo.GetPriority(dbo.XMLUnescape(@SqlValue));
	--		END
	--		-- 设置最小长度
	--		SET @SqlLength = @SqlLength + dbo.GetLength(@SqlValue);
	--	END
	--	-- 上次的名称
	--	SET @SqlPrevName = @SqlName;
	--	-- 获取一行记录
	--	FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	--END
	---- 关闭游标
	--CLOSE SqlCursor;
	---- 释放游标
	--DEALLOCATE SqlCursor;

--SELECT classification, count(*) FROM dbo.TextContent GROUP BY classification;
--SELECT * FROM dbo.TextContent WHERE classification = '单词' OR classification = '分词';
--DELETE FROM dbo.TextContent WHERE classification = '单句' OR classification = '分句';

--INSERT INTO dbo.InnerContent (cid, content, classification, hash_value, length,
--	a_id, b_id, c_id, d_id, e_id, f_id, g_id, h_id, i_id, j_id, k_id, l_id, m_id, n_id, o_id, p_id, q_id, r_id, s_id, t_id, u_id, v_id, w_id, x_id, z_id)
--	SELECT (NEXT VALUE FOR ContentSequence), content, classification, dbo.GetHash(content), LEN(content),
--	a_id, b_id, c_id, d_id, e_id, f_id, g_id, h_id, i_id, j_id, k_id, l_id, m_id, n_id, o_id, p_id, q_id, r_id, s_id, t_id, u_id, v_id, w_id, x_id, z_id FROM dbo.TextContent;

--SELECT * FROM dbo.InnerContent WHERE a_id = 0;
--SELECT * FROM dbo.InnerContent WHERE cid = 9693;
--UPDATE dbo.InnerContent SET
--a_id = 0, b_id = 0, c_id = 0, d_id = 0, e_id = 0, f_id = 0, g_id = 0, h_id = 0, i_id = 0, j_id = 0, k_id = 0, l_id = 0, m_id = 0, n_id = 0, o_id = 0, p_id = 0, q_id = 0, r_id = 0, s_id = 0, t_id = 0, u_id = 0, v_id = 0, w_id = 0, x_id = 0, z_id = 0
--WHERE a_id <> -1

--SELECT * FROM InnerContent WHERE classification = '分词';
--SELECT * FROM InnerContent WHERE cid =

	--SELECT TOP 1
	--	a.*,
	--	b.parse_rule
	--	FROM dbo.InnerContent AS a 
	--	INNER JOIN dbo.ParseRule AS b ON a.rid = b.rid
	--	WHERE (a.classification = '单词' OR a.classification = '分词') AND a.content = '阿巴拉'