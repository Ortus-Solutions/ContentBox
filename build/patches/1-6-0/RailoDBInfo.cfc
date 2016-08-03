component{

	function getTableColumns(required table, required datasource){
		dbinfo datasource=arguments.datasource table=arguments.table type="columns" name="local.results";
		return local.results;
	}
	
	function getDatabaseType(required datasource){
		dbinfo datasource=arguments.datasource type="version" name="local.results";
		return local.results;
	}
}