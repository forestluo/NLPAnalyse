USE [nldb]
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<�ވ�>
-- Create date: <2021��3��11��>
-- Description:	<������ϵ����׼��>
-- =============================================

CREATE OR ALTER FUNCTION GrammarGetAlphaDeviation
(
	-- Add the parameters for the function here
	@SqlPosition INT,
	@SqlContent UString,
	@SqlException UString
)
RETURNS
	@ResultTable
	TABLE (Average FLOAT,Deviation FLOAT)
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlAverage FLOAT;
	DECLARE @SqlDeviation FLOAT;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN;

	-- ���ó�ʼֵ
	SET @SqlDeviation = -1.0;
	-- ������
	IF @SqlPosition = 0
	BEGIN
		-- ����ȱʡֵ
		SET @SqlDeviation = 0.0;
	END
	ELSE IF @SqlPosition < 0
	BEGIN
		-- ��鳤��
		IF LEN(@SqlContent) = 1
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar2 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 2
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar3 WHERE rcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 3
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, lcontent
							FROM dbo.Grammar4 WHERE rcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						lcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
	END
	ELSE IF @SqlPosition > 0
	BEGIN
		-- ��鳤��
		IF LEN(@SqlContent) = 1
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar2 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 2
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar3 WHERE lcontent = @SqlContent
						UNION
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
							
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
		ELSE IF LEN(@SqlContent) = 3
		BEGIN
			-- ������
			IF @SqlException IS NULL OR
				LEN(@SqlException) <= 0
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND
						count > 0 AND NOT (invalid = 1 AND enable = 0);
			END
			ELSE
			BEGIN
				-- ��ѯ���
				SELECT
					@SqlAverage = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
				-- ��ѯ���
				SELECT
					@SqlDeviation = SQRT(SUM((alpha - @SqlAverage) *
						(alpha - @SqlAverage) * count) / SUM(count))
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
	END
	-- ������
	INSERT INTO @ResultTable (Average, Deviation) VALUES (@SqlAverage, ISNULL(@SqlDeviation, -1.0)); RETURN;
END
GO

