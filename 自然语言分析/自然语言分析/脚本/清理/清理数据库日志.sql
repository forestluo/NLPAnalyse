USE [nldb]
GO

/****** Object: 清理符号错误的内容 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<罗堃>
-- Create date: <2021年3月9日>
-- Description:	<清理数据库日志>
-- =============================================

USE [master]
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE WITH NO_WAIT
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE   --简单模式
GO

USE [nldb]
GO

DBCC SHRINKFILE (N'nldb_log' , 2, TRUNCATEONLY)  --设置压缩后的日志大小为2M，可以自行指定
GO

USE [master]
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE WITH NO_WAIT
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE  --还原为完全模式
GO
