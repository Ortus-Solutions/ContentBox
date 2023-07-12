/**
 * Add the new columns for the security rules in cbsecurity 3.x
 */
component {

	// Include Utils
	include template="./_MigrationUtils.cfm";

	function up( schema, qb ){
		if ( !hasColumn( "cb_securityRule", "httpMethods" ) ) {
			schema.alter( "cb_securityRule", ( table ) => {
				table.addColumn( table.string( "httpMethods" ).default( "*" ) );
			} );
		}

		if ( !hasColumn( "cb_securityRule", "allowedIPs" ) ) {
			schema.alter( "cb_securityRule", ( table ) => {
				table.addColumn( table.string( "allowedIPs" ).default( "*" ) );
			} );
		}
	}

	function down( schema, qb ){
	}

}
