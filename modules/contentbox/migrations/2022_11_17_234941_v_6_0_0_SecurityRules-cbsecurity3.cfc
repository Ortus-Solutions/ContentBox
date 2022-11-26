/**
 * Add the new columns for the security rules in cbsecurity 3.x
 */
component {

	function up( schema, qb ){
		if ( !schema.hasColumn( "cb_securityRule", "httpMethods" ) ) {
			schema.alter( "cb_securityRule", ( table ) => {
				table.addColumn( table.string( "httpMethods" ).default( "*" ) );
				table.addColumn( table.string( "allowedIPs" ).default( "*" ) );
			} );
		}
	}

	function down( schema, qb ){
	}

}
