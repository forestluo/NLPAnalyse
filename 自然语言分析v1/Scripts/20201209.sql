declare @d datetime
set @d=getdate()
/*���SQL�ű���ʼ*/
--EXEC dbo.[������InnerContent];
--EXEC dbo.AddGeneralRule '��$a����$b������$c����$d��$e��$f��$g';
--SELECT dbo.XMLGetWordRule('�ú�������ǰ��');
--EXEC dbo.[�ؽ�WordRules];
--EXEC dbo.[VerifyWordRule] '������';
--DECLARE @SqlContent UString = '�鷳��';
--DECLARE @SqlXML XML;
--SELECT dbo.XMLParseSentence(@SqlContent);
EXEC dbo.AddSentence 'лл��';

/*���SQL�ű�����*/
select [���ִ�л���ʱ��(����)]=datediff(ms,@d,getdate())

-- SELECT * FROM dbo.InnerContent WHERE content = 'лл��';
-- DELETE FROM dbo.InnerContent WHERE content = '��ã�';
-- SELECT dbo.VerifyContentRule('��ã�');
-- SELECT * FROM dbo.InnerContent WHERE content = '��ã�' OR cid = 86100 OR cid = 86035 OR cid = 46989;

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

--DECLARE @SqlResult XML = '<result id="1" start="0" end="0"><var name="a" id="0" pos="0">$a</var><pad id="0" pos="0">��</pad><var name="b" id="0" pos="0">$b</var><pad id="0" pos="0">��</pad></result>';
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


	---- ������̬�α�
	--DECLARE SqlCursor CURSOR STATIC FOR 
	--	SELECT
	--		-- node.value('(@id)[1]','int') AS id,
	--		nodes.value('local-name(.)','nvarchar(max)') AS name,
	--		nodes.value('(text())[1]','nvarchar(max)') AS content
	--		FROM @SqlXML.nodes('//result/*') AS N(nodes); 
	---- ���α�
	--OPEN SqlCursor;
	---- ��ȡһ�м�¼
	--FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	---- �����
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	-- ��鱾������
	--	IF @SqlName = 'var'
	--	BEGIN
	--		-- ���ǰ��Ĳ�����
	--		IF @SqlPrevName = 'var'
	--		-- ��鱾������
	--		-- �����������������޷�ʵ���������
	--			SET @SqlNormalized = 0;
	--		-- ������С����
	--		SET @SqlLength = @SqlLength + 1;
	--	END
	--	ELSE IF @SqlName = 'pad'
	--	BEGIN
	--		-- ����Ƿ��ǿ�ͷ
	--		IF @SqlIndex = 1
	--			SET @SqlPrefix = 1;
	--		-- ����Ƿ��ǽ�β
	--		ELSE IF @SqlIndex = @SqlCount
	--		BEGIN
	--			-- ���ñ��λ
	--			SET @SqlSuffix = 1;
	--			-- ����β����
	--			SET @SqlPriority = dbo.GetPriority(dbo.XMLUnescape(@SqlValue));
	--		END
	--		-- ������С����
	--		SET @SqlLength = @SqlLength + dbo.GetLength(@SqlValue);
	--	END
	--	-- �ϴε�����
	--	SET @SqlPrevName = @SqlName;
	--	-- ��ȡһ�м�¼
	--	FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	--END
	---- �ر��α�
	--CLOSE SqlCursor;
	---- �ͷ��α�
	--DEALLOCATE SqlCursor;

--SELECT classification, count(*) FROM dbo.TextContent GROUP BY classification;
--SELECT * FROM dbo.TextContent WHERE classification = '����' OR classification = '�ִ�';
--DELETE FROM dbo.TextContent WHERE classification = '����' OR classification = '�־�';

--INSERT INTO dbo.InnerContent (cid, content, classification, hash_value, length,
--	a_id, b_id, c_id, d_id, e_id, f_id, g_id, h_id, i_id, j_id, k_id, l_id, m_id, n_id, o_id, p_id, q_id, r_id, s_id, t_id, u_id, v_id, w_id, x_id, z_id)
--	SELECT (NEXT VALUE FOR ContentSequence), content, classification, dbo.GetHash(content), LEN(content),
--	a_id, b_id, c_id, d_id, e_id, f_id, g_id, h_id, i_id, j_id, k_id, l_id, m_id, n_id, o_id, p_id, q_id, r_id, s_id, t_id, u_id, v_id, w_id, x_id, z_id FROM dbo.TextContent;

--SELECT * FROM dbo.InnerContent WHERE a_id = 0;
--SELECT * FROM dbo.InnerContent WHERE cid = 9693;
--UPDATE dbo.InnerContent SET
--a_id = 0, b_id = 0, c_id = 0, d_id = 0, e_id = 0, f_id = 0, g_id = 0, h_id = 0, i_id = 0, j_id = 0, k_id = 0, l_id = 0, m_id = 0, n_id = 0, o_id = 0, p_id = 0, q_id = 0, r_id = 0, s_id = 0, t_id = 0, u_id = 0, v_id = 0, w_id = 0, x_id = 0, z_id = 0
--WHERE a_id <> -1

--SELECT * FROM InnerContent WHERE classification = '�ִ�';
--SELECT * FROM InnerContent WHERE cid =

	--SELECT TOP 1
	--	a.*,
	--	b.parse_rule
	--	FROM dbo.InnerContent AS a 
	--	INNER JOIN dbo.ParseRule AS b ON a.rid = b.rid
	--	WHERE (a.classification = '����' OR a.classification = '�ִ�') AND a.content = '������'