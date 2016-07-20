/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Security rules manager
*/
component extends="cborm.models.VirtualEntityService" singleton{
	
	// DI
	property name="populator" inject="wirebox:populator";
	property name="dateUtil"  inject="DateUtil@cb";

	/**
	* Constructor
	*/
	SecurityRuleService function init(){
		// init it
		super.init( entityName="cbSecurityRule" );

		return this;
	}

	/**
	* Get the maximum used order
	*/
	numeric function getMaxOrder(){
		var q = executeQuery( query="select max( sr.order ) from cbSecurityRule as sr", asQuery=false );
		if( ArrayIsDefined( q, 1 ) ){ 
			return q[ 1 ]; 
		}
		return 0;
	}

	/**
	* Get the next maximum used order
	*/
	numeric function getNextMaxOrder(){
		return getMaxOrder() + 1;
	}

	/**
    * Save rule
    */
	any function saveRule(
		required any entity, 
		boolean forceInsert=false, 
		boolean flush=false, 
		boolean transactional=getUseTransactions()
	){

		// determine new or not
		if( !arguments.entity.isLoaded() ){
			// new, so add next max order if not default
			if( arguments.entity.getOrder() EQ 0 ){
				arguments.entity.setOrder( getNextMaxOrder() );
			}
		}

		return save( argumentCollection=arguments );
	}

	/**
	* Get all rules in firing order
	*/
	query function getSecurityRules(){
		return list( sortOrder="order asc" );
	}

	/**
	* Reset rules to factory shipping standards, this will remove all rules also
	*/
	any function resetRules(){
		transaction{
			// Get rules path
			var rulesPath = getDirectoryFromPath( getMetadata( this ).path ) & "data/securityRules.json";
			// remove all rules first
			//var q = new query(sql="delete from cb_securityRule" ).execute();
			deleteAll( transactional = false );
			// now re-create them
			var securityRules = deserializeJSON( fileRead( rulesPath ) );
			// iterate over array
			for( var thisRule in securityRules ){
				if( structKeyExists( thisRule, "ruleID" ) ){
					structDelete( thisRule, "ruleID" );
				}
				var oRule = new( properties=thisRule );
				save( entity=oRule, transactional=false );
			}
		}
		
		return this;
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var c 			= newCriteria();
		var propList 	= "ruleID,whitelist,securelist,roles,permissions,redirect,useSSL,order,match,createdDate,modifiedDate,isDeleted";
		
		return c.withProjections( property=propList )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="order" );
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	* @importFile The file to import
	* @override Override data
	*/
	string function importFromFile( required importFile, boolean override=false ){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
		if( !isJSON( data ) ){
			throw( message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
	}
	
	/**
	* Import data from an array of structures 
	* @importData data to import
	* @override Override data
	* @importLog The import log
	*/
	string function importFromData( required importData, boolean override=false, importLog ){
		var allRules = [];
		
		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}
		
		// iterate and import
		for( var thisRule in arguments.importData ){
			// Get new or persisted with enough info to match
			var args = { 
				match 			= thisRule.match, 
				whitelist 		= thisRule.whitelist, 
				securelist 		= thisRule.securelist, 
				redirect 		= thisRule.redirect, 
				roles 			= thisRule.roles, 
				permissions 	= thisRule.permissions 
			};
			var oRule = this.findWhere( criteria=args );
			oRule = ( isNull( oRule ) ? new() : oRule );
			
			// date cleanups, just in case.
			var badDateRegex  		= " -\d{4}$";
			thisRule.createdDate 	= reReplace( thisRule.createdDate, badDateRegex, "" );
			thisRule.modifiedDate 	= reReplace( thisRule.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisRule.createdDate 	= dateUtil.epochToLocal( thisRule.createdDate );
			thisRule.modifiedDate 	= dateUtil.epochToLocal( thisRule.modifiedDate );

			// populate content from data
			populator.populateFromStruct( 
				target=oRule, 
				memento=thisRule, 
				exclude="ruleID", 
				composeRelationships=false 
			);
			
			// if new or persisted with override then save.
			if( !oRule.isLoaded() ){
				arguments.importLog.append( "New security rule imported: #thisRule.toString()#<br>" );
				arrayAppend( allRules, oRule );
			}
			else if( oRule.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted security rule overriden: #thisRule.toString()#<br>" );
				arrayAppend( allRules, oRule );
			}
			else{
				arguments.importLog.append( "Skipping persisted security rule: #thisRule.toString()#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allRules ) ){
			saveAll( allRules );
			arguments.importLog.append( "Saved all imported and overriden security rules!" );
		} else{
			arguments.importLog.append( "No security rules imported as none where found or able to be overriden from the import file." );
		}
		
		return arguments.importLog.toString(); 
	}

}
