USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlDID INT;
DECLARE @SqlRemark UString;
DECLARE @SqlContent UString;
DECLARE @SqlAttribute UString;

-- 声明临时变量
DECLARE @SqlIndex INT;
DECLARE @SqlValue UString;

-- 声明游标
DECLARE SqlCursor CURSOR
	STATIC FORWARD_ONLY LOCAL FOR
	SELECT did, content, remark
	FROM dbo.Dictionary WHERE classification = '分词35万';
-- 打开游标
OPEN SqlCursor;
-- 取第一条记录
FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent, @SqlRemark;
-- 循环处理游标
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 查找位置
	SET @SqlIndex = CHARINDEX(',', @SqlRemark);
	-- 检查结果
	IF @SqlIndex > 0
		SET @SqlRemark = LEFT(@SqlRemark, @SqlIndex - 1);

	-- 剪裁
	SET @SqlRemark = TRIM(@SqlRemark);
	-- 检查结果
	SET @SqlAttribute = 
		CASE @SqlRemark
			WHEN 'ag' THEN '语素'
			WHEN 'a' THEN '形容词'
			WHEN 'ad' THEN '副词'
			WHEN 'an' THEN '形名词'
			WHEN 'b' THEN '区别词'
			WHEN 'c' THEN '连词'
			WHEN 'd' THEN '副词'
			WHEN 'dg' THEN '副语素'
			WHEN 'df' THEN '否定副词'
			WHEN 'e' THEN '叹词'
			WHEN 'f' THEN '方位词'
			WHEN 'g' THEN '语素'
			WHEN 'h' THEN '前缀'
			WHEN 'i' THEN '成语'
			WHEN 'j' THEN '略缩语'
			WHEN 'k' THEN '后缀'
			WHEN 'l' THEN '习惯用语'
			WHEN 'm' THEN '数词'
			WHEN 'mg' THEN '数词语素'
			WHEN 'mq' THEN '数量词'
			WHEN 'ng' THEN '名语素'
			WHEN 'n' THEN '名词'
			WHEN 'nr' THEN '人名'
			WHEN 'nrt' THEN '英文名'
			WHEN 'nrfg' THEN '历史名人'
			WHEN 'ns' THEN '地名'
			WHEN 'nt' THEN '团体机构'
			WHEN 'nz' THEN '专有名'
			WHEN 'o' THEN '拟声词'
			WHEN 'p' THEN '介词'
			WHEN 'q' THEN '量词'
			WHEN 'r' THEN '代词'
			WHEN 'rg' THEN '代词语素'
			WHEN 'rr' THEN '人称代词'
			WHEN 'rz' THEN '指示代词'
			WHEN 's' THEN '处所词'
			WHEN 'tg' THEN '时语素'
			WHEN 't' THEN '时间词'
			WHEN 'u' THEN '助词'
			WHEN 'vg' THEN '动语素'
			WHEN 'v' THEN '动词'
			WHEN 'vd' THEN '副动词'
			WHEN 'vn' THEN '名动词'
			WHEN 'vi' THEN '动词常用语'
			WHEN 'vq' THEN '含过的动词'
			WHEN 'w' THEN '标点符号'
			WHEN 'x' THEN '非语素字'
			WHEN 'y' THEN '语气词'
			WHEN 'z' THEN '状态词'
			WHEN 'zg' THEN '状态语素'
			WHEN 'un' THEN '未知词'
			WHEN 'uv' THEN '结构助词地'
			WHEN 'uz' THEN '结构助词着'
			WHEN 'uj' THEN '结构助词的'
			WHEN 'ug' THEN '时态助词'
			WHEN 'ud' THEN '结构助词'
			WHEN 'ul' THEN '结构助词了'
			ELSE '？' END;

	-- 打印
	PRINT '导入词性(did=' + CONVERT(NVARCHAR(MAX), @SqlDID) + ') > {' + @SqlContent + '}:' + @SqlRemark + ',' + @SqlAttribute;

--	IF @SqlAttribute IN ('名词', '形名词')
--		SET @SqlAttribute = '名词';
--	ELSE IF @SqlAttribute IN ('人名', '英文名', '历史名人')
--		SET @SqlAttribute = '人名';
--	ELSE IF @SqlAttribute IN ('专有名', '团体机构')
--		SET @SqlAttribute = '专有名';
--	ELSE IF @SqlAttribute IN ('动词', '名动词', '副动词')
--		SET @SqlAttribute = '动词';
--	ELSE IF @SqlAttribute IN ('代词', '人称代词', '指示代词')
--		SET @SqlAttribute = '代词';
--	ELSE IF @SqlAttribute IN ('副词', '否定副词')
--		SET @SqlAttribute = '副词';
--	ELSE IF @SqlAttribute IN ('前缀', '成语', '略缩语', '后缀', '习惯用语')
--		SET @SqlAttribute = '习惯用语';
--	ELSE IF @SqlAttribute IN ('连词', '介词', '叹词', '助词', '数词', '量词', '数量词', '形容词', '方位词')
--		GOTO NEXT_STEP;
--	ELSE
--		SET @SqlAttribute = NULL;
--NEXT_STEP:
	UPDATE dbo.InnerContent SET attribute = @SqlAttribute WHERE content = @SqlContent;

	-- 取下一条记录 
	FETCH NEXT FROM SqlCursor INTO @SqlDID, @SqlContent, @SqlRemark;
END
-- 关闭游标
CLOSE SqlCursor;
-- 释放游标
DEALLOCATE SqlCursor; 

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());

PRINT '导入词性 > 全部导入完毕！';
