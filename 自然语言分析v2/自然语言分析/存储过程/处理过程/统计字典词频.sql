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
-- Create date: <2020年12月17日>
-- Description:	<从语料库中统计内容的发生次数>
-- =============================================

CREATE OR ALTER PROCEDURE [统计字典词频]
	-- Add the parameters for the stored procedure here
	@SqlCount INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 声明临时变量
	DECLARE @SqlTID INT;
	DECLARE @SqlLength INT;
	DECLARE @SqlText UString;

	DECLARE @SqlPosition INT;
	DECLARE @SqlCheckLength INT;
	DECLARE @SqlStatisticCount INT;

	DECLARE @SqlRightText UString;
	DECLARE @SqlLeftContent UString;

	-- 打印空行
	PRINT '统计字典词频> 加载' + CONVERT(NVARCHAR(MAX), @SqlCount) + '条记录！';

	-- 获得最大长度
	SELECT @SqlLength = MAX(length) FROM dbo.Dictionary WHERE [enable] = 1;

	-- 声明游标
	DECLARE SqlCursor CURSOR
		STATIC FORWARD_ONLY LOCAL FOR
		SELECT TOP (@SqlCount) tid, content
			FROM dbo.TextPool WHERE parsed = 0;
	-- 打开游标
	OPEN SqlCursor;
	-- 取第一条记录
	FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	-- 循环处理游标
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 设置初始值
		SET @SqlPosition = 0;
		SET @SqlStatisticCount = 0;
		-- 循环处理
		WHILE @SqlPosition < LEN(@SqlText)
		BEGIN
			-- 修改计数器
			SET @SqlPosition = @SqlPosition + 1;
			-- 获得剩余右侧内容
			SET @SqlRightText = RIGHT(@SqlText, LEN(@SqlText) - @SqlPosition + 1);

			-- 设置初始值
			SET @SqlCheckLength = 0;
			-- 循环处理
			WHILE @SqlCheckLength < @SqlLength AND
				@SqlPosition + @SqlCheckLength < LEN(@SqlText)
			BEGIN
				-- 修改计数器
				SET @SqlCheckLength = @SqlCheckLength + 1;
				-- 获得左侧内容
				SET @SqlLeftContent = LEFT(@SqlRightText, @SqlCheckLength);

				-- 更新记录
				UPDATE dbo.Dictionary SET count = count + 1
					WHERE content = @SqlLeftContent;
				-- 设置统计数值
				SET @SqlStatisticCount = @SqlStatisticCount + @@ROWCOUNT;
			END
		END
		-- 打印结果
		PRINT '统计字典词频(tid=' +
			CONVERT(NVARCHAR(MAX), @SqlTID) + ')> 频次统计' +
			CONVERT(NVARCHAR(MAX), @SqlStatisticCount) + '次';
		---- 更新数据记录
		UPDATE dbo.TextPool	SET parsed = parsed + 1 WHERE tid = @SqlTid;
		-- 取下一条记录
		FETCH NEXT FROM SqlCursor INTO @SqlTID, @SqlText;
	END
	-- 关闭游标
	CLOSE SqlCursor;
	-- 释放游标
	DEALLOCATE SqlCursor; 
	-- 返回成功
	PRINT '统计字典词频> 所有文本全部统计完毕！';

END
GO
