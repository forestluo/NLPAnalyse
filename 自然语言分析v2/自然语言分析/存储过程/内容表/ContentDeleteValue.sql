USE [nldb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年1月1日>
-- Description:	<删除指定的内容>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[ContentDeleteValue]
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

	-- 设置缺省值
	SET @SqlCID = 0;
	---- 获得标识
	--SET @SqlCID = dbo.ContentGetCID(@SqlContent);
	---- 检查结果
	--IF @SqlCID > 0
	--BEGIN
	--	-- 更新外部表
	--	UPDATE dbo.OuterContent
	--		SET type = 0, [rule] = NULL, a_id = 0,
	--		b_id = 0, c_id = 0, d_id = 0, e_id = 0, f_id = 0,
	--		g_id = 0, h_id = 0, i_id = 0, j_id = 0, k_id = 0,
	--		l_id = 0, m_id = 0, n_id = 0, o_id = 0, p_id = 0,
	--		q_id = 0, r_id = 0, s_id = 0, t_id = 0, u_id = 0,
	--		v_id = 0, w_id = 0, x_id = 0, y_id = 0, z_id = 0
	--		WHERE a_id = @SqlCID OR
	--		b_id = @SqlCID OR c_id = @SqlCID OR d_id = @SqlCID OR e_id = @SqlCID OR f_id = @SqlCID OR
	--		g_id = @SqlCID OR h_id = @SqlCID OR i_id = @SqlCID OR j_id = @SqlCID OR k_id = @SqlCID OR
	--		l_id = @SqlCID OR m_id = @SqlCID OR n_id = @SqlCID OR o_id = @SqlCID OR p_id = @SqlCID OR
	--		q_id = @SqlCID OR r_id = @SqlCID OR s_id = @SqlCID OR t_id = @SqlCID OR u_id = @SqlCID OR
	--		v_id = @SqlCID OR w_id = @SqlCID OR x_id = @SqlCID OR y_id = @SqlCID OR z_id = @SqlCID;
	--END

	-- 先从内部表删除
	DELETE FROM dbo.InnerContent WHERE content = @SqlContent;
	-- 再从外部表删除
	DELETE FROM dbo.OuterContent WHERE content = @SqlContent;
	-- 从词典中“删除”该内容
	UPDATE dbo.Dictionary SET [enable] = 0 WHERE content = @SqlContent;
	-- 返回结果
	RETURN @SqlCID;
END
