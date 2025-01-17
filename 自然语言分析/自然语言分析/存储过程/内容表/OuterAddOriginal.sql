USE [nldb2]
GO
/****** Object:  StoredProcedure [dbo].[OuterAddSentence]    Script Date: 2020/12/14 15:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<加入原始分句到外部内容库>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[OuterAddOriginal]
	-- Add the parameters for the stored procedure here
	@SqlOOID INT,
	@SqlOCID INT,
	@SqlResult XML,
	@SqlSentence UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
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
	IF @SqlOOID IS NULL OR @SqlOOID <= 0
	BEGIN
		-- 打印结果
		PRINT 'OuterAddOriginal > 无效参数！'; RETURN -1;
	END
	-- 检查参数
	IF @SqlOCID IS NULL OR @SqlOCID <= 0
	BEGIN
		-- 打印结果
		PRINT 'OuterAddOriginal > 无效参数！'; RETURN -2;
	END
	-- 检查参数
	IF @SqlSentence IS NULL OR
		LEN(@SqlSentence) <= 0
	BEGIN
		-- 打印结果
		PRINT 'OuterAddOriginal > 无效参数！'; RETURN -3;
	END
	-- 检查参数
	IF @SqlResult IS NULL OR
		ISNULL(@SqlResult.value('(//result/@id)[1]', 'int'), 0) <= 0
	BEGIN
		-- 打印结果
		PRINT 'OuterAddOriginal > 无效参数！'; RETURN -4;
	END
	-- 获得规则
	SET @SqlRule = @SqlResult.value('(//result/rule/text())[1]', 'nvarchar(max)');
	-- 检查结果
	IF @SqlRule IS NULL OR LEN(@SqlRule) <= 0
	BEGIN
		-- 打印结果
		PRINT 'OuterAddOriginal > 无效规则！'; RETURN -5;
	END

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
			SET @SqlID = dbo.ContentGetCID(@SqlValue);
			-- 检查结果
			IF @SqlID IS NULL OR @SqlID <= 0
			BEGIN
				-- 设置初始值
				SET @SqlID = NEXT VALUE FOR ContentSequence;
				-- 插入一条记录
				INSERT INTO dbo.OuterContent
					(cid, [classification], [length], content)
					VALUES
					(@SqlID, '分句', LEN(@SqlValue), @SqlValue);
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

	-- 更新一条记录
	UPDATE dbo.OuterContent
		SET [type] = CASE @SqlRule WHEN '$a' THEN -1 ELSE 1 END,
		[length] = LEN(@SqlSentence), content = @SqlSentence, [rule] = @SqlRule,
		a_id = @SqlAid, b_id = @SqlBid, c_id = @SqlCid, d_id = @SqlDid, e_id = @SqlEid, f_id = @SqlFid,
		g_id = @SqlGid, h_id = @SqlHid, i_id = @SqlIid, j_id = @SqlJid, k_id = @SqlKid, l_id = @SqlLid, m_id = @SqlMid,
		n_id = @SqlNid, o_id = @SqlOid, p_id = @SqlPid, q_id = @SqlQid, r_id = @SqlRid, s_id = @SqlSid,
		t_id = @SqlTid, u_id = @SqlUid, v_id = @SqlVid, w_id = @SqlWid, x_id = @SqlXid, y_id = @SqlYid, z_id = @SqlZid
		WHERE oid = @SqlOOID;
	-- 返回结果
	RETURN @SqlOCID;
END
GO
