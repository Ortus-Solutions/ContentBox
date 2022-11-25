component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * CBFS Module Settings
		 * --------------------------------------------------------------------------
		 * configurations https://cbfs.ortusbooks.com/getting-started/configuration
		 */
		return {
			// The default disk
			"defaultDisk" : "contentbox",
			// Register the disks on the system
			"disks"       : {
				// Your default application storage
				"contentbox" : {
					provider   : "Local",
					properties : { path : "#controller.getAppRootPath()#/modules_app/contentbox-custom/_content" }
				}
			}
		};
	}

}
