USE [nldb]
GO
/****** Object:  StoredProcedure [dbo].[AddSentence]    Script Date: 2020/12/9 16:14:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<加入一条句子到内容库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[InnerAddSentence]
	-- Add the parameters for the stored procedure here
	@SqlSentence UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlRuleID INT;
	DECLARE @SqlResult XML;

	DECLARE @SqlRule UString;
	DECLARE @SqlName UString;
	DECLARE @SqlValue UString;
	DECLARE @SqlNewValue UString;

	DECLARE @SqlAid INT = 0;
	DECLARE @SqlBid INT = 0;
	DECLARE @SqlCid INT = 0;
	DECLARE @SqlDid INT = 0;
	DECLARE @SqlEid INT = 0;
	DECLARE @SqlFid INT = 0;
	DECLARE @SqlGid INT = 0;
	DECLARE @SqlHid INT = 0;
	DECLARE @SqlIid INT = 0;
	DECLARE @SqlJid INT = 0;
	DECLARE @SqlKid INT = 0;
	DECLARE @SqlLid INT = 0;
	DECLARE @SqlMid INT = 0;
	DECLARE @SqlNid INT = 0;
	DECLARE @SqlOid INT = 0;
	DECLARE @SqlPid INT = 0;
	DECLARE @SqlQid INT = 0;
	DECLARE @SqlRid INT = 0;
	DECLARE @SqlSid INT = 0;
	DECLARE @SqlTid INT = 0;
	DECLARE @SqlUid INT = 0;
	DECLARE @SqlVid INT = 0;
	DECLARE @SqlWid INT = 0;
	DECLARE @SqlXid INT = 0;
	DECLARE @SqlYid INT = 0;
	DECLARE @SqlZid INT = 0;

	-- 检查参数
	IF @SqlSentence IS NULL
		OR LEN(@SqlSentence) <= 0
	BEGIN
		PRINT 'InnerAddSentence(result=-1):> 输入为空！'; RETURN -1;
	END
	-- 剪裁
	SET @SqlSentence = TRIM(@SqlSentence);
	-- 检查参数
	IF dbo.IsTooLong(@SqlSentence) = 1
	BEGIN
		PRINT 'InnerAddSentence(result=-2):> 句子太长！'; RETURN -2;
	END
	-- 检查可解析性
	-- IF dbo.IsParsable(@SqlSentence) <= 0 RETURN -2;
	-- 检查重复性
	SET @SqlID = dbo.InnerExists(@SqlSentence);
	-- 检查结果
	IF @SqlID > 0 RETURN @SqlID;/*直接返回已存在标识*/

	-- 获得句子的解析规则
	SET @SqlRule = dbo.GetParseRule(@SqlSentence);
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		PRINT 'InnerAddSentence(result=-3):> 无法获得解析规则！'; RETURN -3;
	END
	-- 如果句子就是自身，说明为分句或分词
	IF @SqlRule = '$a'
	BEGIN
		-- 设置初始值
		SET @SqlID = NEXT VALUE FOR ContentSequence;
		-- 插入一条记录
		INSERT INTO dbo.InnerContent
			(cid, classification, length, content, rid, hash_value)
			VALUES
			(@SqlID, '分句', LEN(@SqlSentence), @SqlSentence, -1, dbo.GetHash(@SqlSentence)); return @SqlID;
	END
	
	-- 验证解析规则
	-- 解析内容
	SET @SqlResult = dbo.ParseContent(@SqlRule, @SqlSentence, 0);
	-- 检查结果
	IF @SqlResult IS NULL
	BEGIN
		PRINT 'InnerAddSentence(result=-5):> 无结果{' + @SqlRule + '}{' + @SqlSentence + '}'; RETURN -5;
	END
	ELSE IF ISNULL(@SqlResult.value('(//result/@id)[1]','int'), 0) <> 1
	BEGIN
		PRINT CONVERT(NVARCHAR(MAX), @SqlResult);
		PRINT 'InnerAddSentence(result=-6):> 解析失败{' + @SqlRule + '}{' + @SqlSentence + '}'; RETURN -6;
	END
	ELSE IF ISNULL(@SqlResult.value('(//result/@start)[1]','int'), 0) <> 1
	BEGIN
		PRINT 'InnerAddSentence(result=-7):> 非对齐开头{' + @SqlRule + '}{' + @SqlSentence + '}'; RETURN -7;
	END
	ELSE IF ISNULL(@SqlResult.value('(//result/@end)[1]','int'), 0) <> LEN(@SqlSentence) + 1
	BEGIN
		PRINT 'InnerAddSentence(result=-8):> 非对齐结尾{' + @SqlRule + '}{' + @SqlSentence + '}'; RETURN -8;
	END
	-- PRINT CONVERT(NVARCHAR(MAX), @SqlResult);

	-- 声明静态游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR 
		SELECT nodeName, nodeValue FROM
		(
			SELECT
				Nodes.value('(@id)[1]','int') AS nodeID,
				Nodes.value('local-name(.)', 'nvarchar(max)') AS nodeType,
				Nodes.value('(@name)[1]', 'nvarchar(max)') AS nodeName,
				Nodes.value('(text())[1]','nvarchar(max)') AS nodeValue
				FROM @SqlResult.nodes('//result/*') AS N(Nodes)
		) AS NodesTable WHERE nodeType = 'var';
	-- 打开游标
	OPEN SqlCursor;
	-- 获取一行记录
	FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	-- 检查结果
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 检查结果
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- 剪裁
			SET @SqlNewValue = TRIM(@SqlValue);
			-- 检查结果
			IF LEN(@SqlNewValue) < LEN(@SqlValue)
			BEGIN
				-- 需要替换原句的内容
				SET @SqlSentence =
					REPLACE(@SqlSentence, @SqlValue, @SqlNewValue);
				-- 设置新的数值
				SET @SqlValue = @SqlNewValue;
			END
			-- 设置初始值
			SET @SqlID = dbo.InnerExists(@SqlValue);
			-- 检查结果
			IF @SqlID IS NULL OR @SqlID <= 0
			BEGIN
				-- 设置初始值
				SET @SqlID = NEXT VALUE FOR ContentSequence;
				-- 插入一条记录
				INSERT INTO dbo.InnerContent
					(cid, classification, length, content, rid, hash_value)
					VALUES
					(@SqlID, '分句', LEN(@SqlValue), @SqlValue, -1, dbo.GetHash(@SqlValue));
			END
			-- 获得ID数值
			IF @SqlName = 'a' SET @SqlAid = @SqlID;
			ELSE IF @SqlName = 'b' SET @SqlBid = @SqlID;
			ELSE IF @SqlName = 'c' SET @SqlCid = @SqlID;
			ELSE IF @SqlName = 'd' SET @SqlDid = @SqlID;
			ELSE IF @SqlName = 'e' SET @SqlEid = @SqlID;
			ELSE IF @SqlName = 'f' SET @SqlFid = @SqlID;
			ELSE IF @SqlName = 'g' SET @SqlGid = @SqlID;
			ELSE IF @SqlName = 'h' SET @SqlHid = @SqlID;
			ELSE IF @SqlName = 'i' SET @SqlIid = @SqlID;
			ELSE IF @SqlName = 'j' SET @SqlJid = @SqlID;
			ELSE IF @SqlName = 'k' SET @SqlKid = @SqlID;
			ELSE IF @SqlName = 'l' SET @SqlLid = @SqlID;
			ELSE IF @SqlName = 'm' SET @SqlMid = @SqlID;
			ELSE IF @SqlName = 'n' SET @SqlNid = @SqlID;
			ELSE IF @SqlName = 'o' SET @SqlOid = @SqlID;
			ELSE IF @SqlName = 'p' SET @SqlPid = @SqlID;
			ELSE IF @SqlName = 'q' SET @SqlQid = @SqlID;
			ELSE IF @SqlName = 'r' SET @SqlRid = @SqlID;
			ELSE IF @SqlName = 's' SET @SqlSid = @SqlID;
			ELSE IF @SqlName = 't' SET @SqlTid = @SqlID;
			ELSE IF @SqlName = 'u' SET @SqlUid = @SqlID;
			ELSE IF @SqlName = 'v' SET @SqlVid = @SqlID;
			ELSE IF @SqlName = 'w' SET @SqlWid = @SqlID;
			ELSE IF @SqlName = 'x' SET @SqlXid = @SqlID;
			ELSE IF @SqlName = 'y' SET @SqlYid = @SqlID;
			ELSE IF @SqlName = 'z' SET @SqlZid = @SqlID;
		END
		-- 获取一行记录
		FETCH NEXT FROM SqlCursor INTO @SqlName, @SqlValue;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

	-- 加入一条解析规则
	EXEC @SqlRuleID = dbo.AddSentenceRule @SqlRule;
	-- 检查结果
	IF @SqlRuleID <= 0
	BEGIN
		-- 提示错误
		PRINT 'InnerAddSentence(result=' + CONVERT(NVARCHAR(MAX), @SqlRuleID) + ')> 错误{' + @SqlRule + '}'; RETURN -9;
	END

	-- 设置初始值
	SET @SqlID = NEXT VALUE FOR ContentSequence;
	-- 插入一条记录
	INSERT INTO dbo.InnerContent
		(cid, classification, length, content, rid, hash_value, a_id,
		b_id, c_id, d_id, e_id, f_id, g_id, h_id, i_id, j_id, k_id, l_id, m_id,
		n_id, o_id, p_id, q_id, r_id, s_id, t_id, u_id, v_id, w_id, x_id, y_id, z_id)
		VALUES(@SqlID, '单句', LEN(@SqlSentence), @SqlSentence, @SqlRuleID, dbo.GetHash(@SqlSentence), @SqlAid,
		@SqlBid, @SqlCid, @SqlDid, @SqlEid, @SqlFid, @SqlGid, @SqlHid, @SqlIid, @SqlJid, @SqlKid, @SqlLid, @SqlMid,
		@SqlNid, @SqlOid, @SqlPid, @SqlQid, @SqlRid, @SqlSid, @SqlTid, @SqlUid, @SqlVid, @SqlWid, @SqlXid, @SqlYid, @SqlZid);
	-- 检查结果
	PRINT 'InnerAddSentence(result=' + CONVERT(NVARCHAR(MAX), @SqlID) + ')> ' + @SqlSentence;
	-- 返回成功
	RETURN @SqlID;
END
