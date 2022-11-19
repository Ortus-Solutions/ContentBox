component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ContentBox Runtime Config
		 * --------------------------------------------------------------------------
		 */
		return {
			// Array of mixins (eg: /includes/contentHelpers.cfm) to inject into all content objects
			"contentHelpers" : [],
			// Setting Overrides
			"settings"       : {
				// Global settings
				"global" : {},
				// Site specific settings according to site slug
				"sites"  : {
					 // siteSlug : { ... }
				}
			}
		};
	}

}
