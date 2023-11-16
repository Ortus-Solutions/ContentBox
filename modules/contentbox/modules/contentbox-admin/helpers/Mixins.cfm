<cfscript>
	/**
	 * This will render a admin component from the _components directory in the module
	 *
	 * @component The name of the component to render
	 * @args The arguments to pass to the component
	 *
	 * @return The rendered component
	 */
	function cbAdminComponent( required component, struct args = {} ){
		return view(
			view 			: "_components/#arguments.component#",
			args 			: arguments.args,
			prePostExempt 	: true
		);
	}

	/**
	 * Shortcut to cbAdminComponent()
	 */
	function $cbc(){
		return cbAdminComponent( argumentCollection = arguments );
	}

	/**
	 * This function will return the path to the admin module's assets wihin the Elixir manifest
	 *
	 * @param fileName The name of the file to get the path for within the admin module
	 */
	function cbAdminElixirPath( required fileName ){
		var moduleRoot 	= event.getModuleRoot( "contentbox-admin" );
		var manifest 	= getCache( "template" ).getOrSet(
			"cbAdminElixirManifest",
			() => deserializeJSON( fileRead( expandPath( moduleRoot & "/includes/rev-manifest.json"  ) ) )
		);

		var qualifiedPath = right( moduleRoot, len( moduleRoot ) - 1 ) & "/includes/" & fileName;

		return manifest.keyExists( qualifiedPath ) ? manifest[ qualifiedPath ] : '/' & qualifiedPath;
	}
</cfscript>
