USE [nldb]
GO

/****** Object: ������Ŵ�������� ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��3��9��>
-- Description:	<�������ݿ���־>
-- =============================================

USE [master]
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE WITH NO_WAIT
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE   --��ģʽ
GO

USE [nldb]
GO

DBCC SHRINKFILE (N'nldb_log' , 2, TRUNCATEONLY)  --����ѹ�������־��СΪ2M����������ָ��
GO

USE [master]
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE WITH NO_WAIT
GO

ALTER DATABASE [nldb] SET RECOVERY SIMPLE  --��ԭΪ��ȫģʽ
GO
