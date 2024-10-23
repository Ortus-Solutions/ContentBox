<cfscript>
/**
 * This utility file is a collection of migration utilities that ContentBox will use
 */

/**
 * Get a new java based UUID
 */
function getUUID(){
	if( isNull( variables.uuidLib ) ){
		variables.uuidLib = createObject( "java", "java.util.UUID" );
	}
	return variables.uuidLib.randomUUID().toString();
}

/**
 * Verify if a table has a column or not
 *
 * @targetTable The table to check
 * @targetcolumn The column to check
 */
boolean function hasColumn( targetTable, targetColumn ){
	// Check for column created
	cfdbinfo(
		name  = "local.qSettingColumns",
		type  = "columns",
		table = arguments.targetTable
	);

	if (
		qSettingColumns.filter( ( thisRow ) => {
			// systemOutput( thisRow, true );
			return thisRow.column_name == targetColumn
		} ).recordCount > 0
	) {
		return true;
	}
	return false;
}

/**
 * Generate a list of indexes from the database
 *
 * @schemaName     The name of database
 * @tableName      The name of table from database
 * @indexName      The index name to search
 * @qb             QB instance
 * @selectOptions  The Index columns that we need to show
 *
 * @return array with database index information
 * */
Array function listIndexesFromSchema(
	required string schemaName,
	required string tableName,
	required string indexName,
	required qb,
	string selectOptions = "index_name"
){
	return qb.select( arguments.selectOptions )
		.distinct()
		.from( "information_schema.statistics" )
		.where( "table_schema", arguments.schemaName )
		.where( "table_name", arguments.tableName )
		.where( "index_name", "like", "%#indexName#%" )
		.get();
}

/**
 * Drop indexes fron database
 *
 * @indexes   The Array of indexes to delete
 * @schema    The schema instance from QB
 * @tableName  The name of table from database
 *
 * @return void
 * */
function dropIndexesFromSchema(
	required array indexes,
	required schema,
	required string tableName
){
	indexes.each( ( index ) => {
		schema.alter( "#tableName#", function( table ) {
			table.dropConstraint( table.index( [], "#index.index_name#" ) );
		} );
	} );
}

/**
 * Add permission for a specific role
 *
 * @query   The query instance from QB
 * @roleId  The roleId
 * @permission  The permission name
 *
 * @return void
 * */
function addPermissionToRole( query, roleId, permission ){
	var permissionId = arguments.query
		.newQuery()
		.select( "permissionID" )
		.from( "cb_permission" )
		.where( "permission", arguments.permission )
		.first()
		.permissionId;
	arguments.query
		.newQuery()
		.from( "cb_rolePermissions" )
		.insert( {
			"FK_roleID"       : arguments.roleId,
			"FK_permissionID" : permissionId
		} );
}

/**
 * Remove permission for a specific role
 *
 * @query   The query instance from QB
 * @roleId  The roleId
 * @permission  The permission name
 *
 * @return void
 * */
function removePermissionFromRole( query, roleId, permission ){
	var permissionId = arguments.query
		.newQuery()
		.select( "permissionID" )
		.from( "cb_permission" )
		.where( "permission", arguments.permission )
		.first()
		.permissionId;
	arguments.query
		.newQuery()
		.from( "cb_rolePermissions" )
		.where( "FK_roleID", arguments.roleId )
		.andWhere( "FK_permissionID", permissionId )
		.delete();
}

/**
 * Remove a permission from the system
 *
 * @query QB
 * @permission A slug or a list of slugs or an array of permissions
 */
function removePermission( query, permission ){
	if( isSimpleValue( arguments.permission ) ){
		arguments.permission = listToArray( arguments.permission )
	}
	arguments.query
			.newQuery()
			.from( "cb_permissions" )
			.whereIn( "permission", arguments.permission )
			.delete();
}
</cfscript>
