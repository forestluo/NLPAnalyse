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
-- Create date: <2021��3��6��>
-- Description:	<���ƽ�����ϵ��>
-- =============================================

CREATE OR ALTER FUNCTION GrammarGetAlphaAverage
(
	-- Add the parameters for the function here
	@SqlPosition INT,
	@SqlContent UString,
	@SqlException UString
)
RETURNS FLOAT
AS
BEGIN
	-- ������ʱ����
	DECLARE @SqlValue FLOAT;

	-- ������
	IF @SqlContent IS NULL OR
		LEN(@SqlContent) <= 0 RETURN -1;

	-- ���ó�ʼֵ
	SET @SqlValue = -1.0;
	-- ������
	IF @SqlPosition < 0
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
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
					@SqlValue = SUM(alpha * count) / SUM(count)
					FROM
					(
						SELECT alpha, count, invalid, enable, rcontent
							FROM dbo.Grammar4 WHERE lcontent = @SqlContent
					) AS T WHERE alpha > 0 AND count > 0 AND
						rcontent <> @SqlException AND NOT (invalid = 1 AND enable = 0);
			END
		END
	END
	ELSE
	BEGIN
		-- ��鳤��
		IF LEN(@SqlContent) = 1
			-- ���ý��
			SET @SqlValue = 1.0;
		ELSE IF LEN(@SqlContent) = 2
			-- ��ѯ���
			SELECT @SqlValue = alpha
			FROM
			(
				SELECT alpha, invalid, enable
					FROM dbo.Grammar2 WHERE content = @SqlContent
			) AS T WHERE NOT (invalid = 1 AND enable = 0);
		ELSE IF LEN(@SqlContent) = 3
			-- ��ѯ���
			SELECT @SqlValue = SUM(alpha * count) / SUM(count)
			FROM 
			(
				SELECT alpha, count, invalid, enable
					FROM dbo.Grammar3 WHERE content = @SqlContent
			) AS T WHERE count > 0 AND alpha > 0 AND NOT (invalid = 1 AND enable = 0);
		ELSE IF LEN(@SqlContent) = 4
			-- ��ѯ���
			SELECT @SqlValue = SUM(alpha * count) / SUM(count)
			FROM 
			(
				SELECT alpha, count, invalid, enable
					FROM dbo.Grammar4 WHERE content = @SqlContent
			) AS T WHERE count > 0 AND alpha > 0 AND NOT (invalid = 1 AND enable = 0);
	END
	-- ���ؽ��
	RETURN ISNULL(@SqlValue, -1.0);
END
GO

