USE [nldb]
GO

/****** Object:  UserDefinedFunction [dbo].[ContentInsertValue]    Script Date: 2020/12/31 10:36:50 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月1日>
-- Description:	<增加指定的内容>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[ContentInsertValue]
(
	-- Add the parameters for the function here
	@SqlContent UString
)
AS
BEGIN
	-- 声明临时变量
	DECLARE @SqlCID INT;
	DECLARE @SqlResult INT;

	-- 检查参数
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;
	-- 获得标识
	SET @SqlCID = dbo.ContentGetCID(@SqlContent);
	-- 检查结果
	IF @SqlCID > 0 RETURN @SqlCID;

	-- 获得内容编号
	SET @SqlCID = NEXT VALUE FOR ContentSequence;
	-- 增加到内部表
	INSERT INTO dbo.OuterContent
		(cid, [classification], [length], content)
		VALUES (@SqlCID, '文本', LEN(@SqlContent), @SqlContent);
	---- 更新外部表
	--UPDATE dbo.OuterContent
	--	SET type = 0, [rule] = NULL, a_id = 0,
	--	b_id = 0, c_id = 0, d_id = 0, e_id = 0, f_id = 0,
	--	g_id = 0, h_id = 0, i_id = 0, j_id = 0, k_id = 0,
	--	l_id = 0, m_id = 0, n_id = 0, o_id = 0, p_id = 0,
	--	q_id = 0, r_id = 0, s_id = 0, t_id = 0, u_id = 0,
	--	v_id = 0, w_id = 0, x_id = 0, y_id = 0, z_id = 0
	--	WHERE content like '%' + @SqlContent + '%';
	-- 从词典中“开启”该内容
	UPDATE dbo.Dictionary SET [enable] = 1 WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCID;
END
GO