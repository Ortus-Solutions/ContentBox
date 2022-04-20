<cfscript>
/**
 * Checks to see if the column exists in a table
 */
boolean function hasColumn( targetTable, targetColumn ){
    // Check for column created
    cfdbinfo(
        name  = "local.qSettingColumns",
        type  = "columns",
        table = arguments.targetTable
    );

    return qSettingColumns.filter( ( thisRow ) => {
        // systemOutput( thisRow, true );
        return thisRow.column_name == targetColumn
    } ).recordCount > 0 ? true : false;
}
</cfscript>