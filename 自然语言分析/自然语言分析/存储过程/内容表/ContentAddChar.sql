USE [nldb]
GO

/****** Object:  StoredProcedure [dbo].[ContentAddChar]    Script Date: 2020/12/6 10:57:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2020年12月3日>
-- Description:	<加入汉字>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[ContentAddChar]
	-- Add the parameters for the stored procedure here
	@SqlCharacters UString
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlValue UChar;
	DECLARE @SqlPosition INT;

	-- 设置初始值
	SET @SqlPosition = 0;
	-- 循环处理
	WHILE @SqlPosition < LEN(@SqlCharacters)
	BEGIN
		-- 增加计数器
		SET @SqlPosition = @SqlPosition + 1;
		-- 截取字符
		SET @SqlValue = SUBSTRING(@SqlCharacters, @SqlPosition, 1);
		-- 检查结果
		IF @SqlValue IS NOT NULL AND LEN(@SqlValue) > 0
		BEGIN
			-- 检查是否存在
			IF NOT EXISTS
				(SELECT * FROM dbo.InnerContent	WHERE content = @SqlValue)
			BEGIN
				PRINT 'ContentAddChar > 加入汉字（' + @SqlValue + '）！';
				-- 插入数据
				INSERT INTO dbo.InnerContent
					(cid, content, length, classification, type)
					VALUES (NEXT VALUE FOR ContentSequence, @SqlValue, LEN(@SqlValue), '汉字', -1);
			END
		END
	END
END
GO

