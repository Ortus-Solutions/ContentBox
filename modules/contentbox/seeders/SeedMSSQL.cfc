/**
 * Task that seeds my database with test data
 */
component extends="BaseSeeder" {

	function init(){
		super.init();
		return this;
	}

	function keysOn(){
		queryExecute( "SET FOREIGN_KEY_CHECKS=1;" );
	}

	function KeysOff(){
		queryExecute( "SET FOREIGN_KEY_CHECKS=0;" );
	}

	function truncate( required table ){
		queryExecute( "truncate #arguments.table#" );
	}

}
