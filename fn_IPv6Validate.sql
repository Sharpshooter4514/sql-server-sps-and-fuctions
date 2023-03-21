USE [database_name]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_IPv6Validate]    Script Date: 3/21/2023 12:18:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_IPv6Validate] (@inputString VARCHAR(45))
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0

    IF (@inputString NOT LIKE '%[^0-9A-Fa-f:]%') 
		AND (LEN(@inputString) != 1)
		AND (@inputString != '')
        SET @isValid = 1

    RETURN @isValid
END
GO


