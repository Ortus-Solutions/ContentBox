<cfscript>
	function cbAdminComponent( required component, struct args = {} ){
		return renderView(
			view 			: "_components/#arguments.component#",
			args 			: arguments.args,
			prePostExempt 	: true
		);
	}

	function cbAdminElixirPath( fileName ){
		var moduleRoot = event.getModuleRoot( "contentbox-admin" );
		var manifest = getCache( "template" ).getOrSet(
			"cbAdminElixirManifest",
			function(){
				return deserializeJSON( fileRead( expandPath( moduleRoot & "/includes/rev-manifest.json"  ) ) );
			}
		);

		var qualifiedPath = right( moduleRoot, len( moduleRoot ) - 1 ) & "/includes/" & fileName;

		return manifest.keyExists( qualifiedPath ) ? manifest[ qualifiedPath ] : '/' & qualifiedPath;

	}
</cfscript>