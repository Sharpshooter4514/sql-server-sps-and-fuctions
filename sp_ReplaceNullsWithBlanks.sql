CREATE PROCEDURE sp_ReplaceNullWithBlank (@TableName NVARCHAR(256))
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)

    SET @SQL = N'UPDATE ' + @TableName + ' SET '

    DECLARE @ColumnName NVARCHAR(256)

    DECLARE column_cursor CURSOR FOR
        SELECT c.name
          FROM sys.columns c
         WHERE object_id = OBJECT_ID(@TableName)
           AND c.is_identity = 0

    OPEN column_cursor
    FETCH NEXT FROM column_cursor INTO @ColumnName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SQL = @SQL + @ColumnName + ' = COALESCE(' + @ColumnName + ', ''''), '

        FETCH NEXT FROM column_cursor INTO @ColumnName
    END

    CLOSE column_cursor
    DEALLOCATE column_cursor
	
    -- Remove trailing comma from end of UPDATE statement.
    SET @SQL = LEFT(@SQL, LEN(@SQL) - 1)

    PRINT @SQL
    EXEC sp_executesql @SQL
END
