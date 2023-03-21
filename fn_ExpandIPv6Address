USE [database_name]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_ExpandIPv6Address]    Script Date: 3/21/2023 12:17:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_ExpandIPv6Address](@compressedIPv6Address NVARCHAR(45))
RETURNS NVARCHAR(45)
AS
BEGIN
    DECLARE @expandedIPv6Address NVARCHAR(45)
    DECLARE @zeroGroupsToFill INT
    DECLARE @groups TABLE (grp NVARCHAR(4))

    -- Split the compressed IPv6 address into groups
    DECLARE @startIdx INT = 1
    DECLARE @endIdx INT = CHARINDEX(':', @compressedIPv6Address)
    WHILE @startIdx <= LEN(@compressedIPv6Address)
    BEGIN
        IF @endIdx = 0 SET @endIdx = LEN(@compressedIPv6Address) + 1
        INSERT INTO @groups (grp)
        VALUES (SUBSTRING(@compressedIPv6Address, @startIdx, @endIdx - @startIdx))
        SET @startIdx = @endIdx + 1
        SET @endIdx = CHARINDEX(':', @compressedIPv6Address, @startIdx)
    END

    -- Count the number of zero groups to fill
    SET @zeroGroupsToFill = 8 - (SELECT COUNT(*) FROM @groups WHERE grp <> '')

    -- Expand the compressed IPv6 address
    SET @expandedIPv6Address = ''
    DECLARE cur CURSOR FOR SELECT grp FROM @groups
    DECLARE @grp NVARCHAR(4)
    OPEN cur
    FETCH NEXT FROM cur INTO @grp
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @grp = ''
        BEGIN
            WHILE @zeroGroupsToFill > 0
            BEGIN
                SET @expandedIPv6Address = @expandedIPv6Address + '0000:'
                SET @zeroGroupsToFill = @zeroGroupsToFill - 1
            END
        END
        ELSE
        BEGIN
            SET @expandedIPv6Address = @expandedIPv6Address + RIGHT('0000' + @grp, 4) + ':'
        END
        FETCH NEXT FROM cur INTO @grp
    END
    CLOSE cur
    DEALLOCATE cur

    -- Remove the trailing colon
    SET @expandedIPv6Address = LEFT(@expandedIPv6Address, LEN(@expandedIPv6Address) - 1)

    RETURN @expandedIPv6Address
END

GO


