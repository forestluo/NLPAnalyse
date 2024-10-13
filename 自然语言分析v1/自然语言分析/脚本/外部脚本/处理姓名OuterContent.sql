USE [nldb]
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月24日>
-- Description:	<将人名从外部表挪动到内部表>
-- =============================================
CREATE OR ALTER PROCEDURE [处理姓名OuterContent]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlID INT;
	DECLARE @SqlOID INT;
	DECLARE @SqlCID INT;
	DECLARE @SqlContent UString;
	DECLARE @SqlFirstName UString;

	-- 设置百家姓
	SET @SqlFirstName =
		'赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦' +
		'昌马苗凤花方俞任袁柳酆鲍史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐於时傅皮卞齐康伍余元卜顾孟平黄和穆萧尹' +
		'姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁锺徐' +
		'邱骆高夏蔡田樊胡淩霍虞万支柯昝管卢莫柯房裘缪干解应宗丁宣贲邓郁单杭洪包诸左石崔吉钮龚程嵇邢滑裴陆荣翁' +
		'荀羊于惠甄曲家封芮羿储靳汲邴糜松井段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫甯仇栾暴甘钭历戎祖武' +
		'符刘景詹束龙叶幸司韶郜黎蓟溥印宿白怀蒲邰从鄂索咸籍赖卓蔺屠蒙池乔阳郁胥能苍双闻莘党翟谭贡劳逄姬申扶堵' +
		'冉宰郦雍却璩桑桂濮牛寿通边扈燕冀浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈廖庾终暨居衡步都耿满' +
		'弘匡国文寇广禄阙东欧殳沃利蔚越夔隆师巩厍聂晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查後荆红游' +
		'竺权逮盍益桓公万俟';
		-- '司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台公冶宗政濮阳淳于单於太叔申屠公孙仲孙轩辕令狐徐离宇文长孙慕容司徒司空';

	------------------------------------------------
	--
	-- 清理程序
	--
	------------------------------------------------

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT oid, cid, content FROM dbo.OuterContent
			WHERE CHARINDEX(LEFT(content,1),@SqlFirstName) > 0	AND
			(length = 2 OR length = 3) AND dbo.IsChinese(content) = 1;
	-- 设置初始值
	SET @SqlCount = 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 修改计数器
		SET @SqlCount = @SqlCount + 1;
		-- 设置初始值
		SET @SqlID = - 1;
		-- 检查内表是否存在该记录
		SET @SqlID = dbo.InnerExists(@SqlContent);
		-- 检查结果
		IF @SqlID IS NULL OR @SqlID <= 0
		BEGIN
			-- 在内表中插入一条记录
			INSERT INTO dbo.InnerContent
				(cid, content, length, hash_value, classification, a_id)
				VALUES
				(@SqlCID, @SqlContent, LEN(@SqlContent), dbo.GetHash(@SqlContent), '名称', -1);
		END
		-- 移除该内容在外表的记录
		DELETE FROM dbo.OuterContent
			WHERE content_hash = dbo.GetHash(@SqlContent);
		-- 打印输出
		PRINT '将人名从外部挪动到内部表>已处理' + CONVERT(NVARCHAR(MAX), @SqlCount) + '行！';
		PRINT CHAR(9) + 'cid=' + CONVERT(NVARCHAR(MAX), @SqlCID) + ', content=“' + @SqlContent + '”';
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlOID, @SqlCID, @SqlContent;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor;

END
GO
