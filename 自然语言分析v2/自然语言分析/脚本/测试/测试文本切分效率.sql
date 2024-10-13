USE [nldb]
GO

DECLARE @SqlDate DATETIME;
SET @SqlDate = GetDate();
/*你的SQL脚本开始*/

DECLARE @SqlTID INT;
DECLARE @SqlResult XML;
DECLARE @SqlCount INT = 1000;
DECLARE @SqlContent UString = '因此，不用特意分解连成一体的圆锥体的各个部分——一支军队的所有官职，或任何行政机关或公共事业中由最低级到最高级的职称和职位，我们就可以看出一种法则，根据这种法则，采取联合行动的人们结成下面的关系：愈多地直接参与行动的人，他们的指挥权就愈小，他们的人数就愈多；而愈少地直接参与行动的人，他们的指挥权就愈大，他们的人数也就愈少；照这样从底层上升到最后那个人，那个人最少地直接参与行动，最多地发号施令。';

-- 获得最小编号
SELECT @SqlTID = MIN(tid) FROM [nldb].dbo.[TextPool];

WHILE @SqlCount > 0
BEGIN
	SET @SqlTID = @SqlTID + 1;
	SET @SqlCount = @SqlCount - 1;
	SELECT TOP 1 @SqlResult = dbo.XMLCutSentence(content) FROM [nldb].dbo.[TextPool] WHERE tid = @SqlTID;
END

/*你的SQL脚本结束*/
SELECT [语句执行花费时间(毫秒)] = DateDiff(ms, @SqlDate, GetDate());
