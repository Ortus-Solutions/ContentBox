component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox MailServices
		 * --------------------------------------------------------------------------
		 * configurations https://coldbox-mailservices.ortusbooks.com/essentials/configuration
		 */
		return {
			// The default token Marker Symbol
			tokenMarker     : "@",
			// Default protocol to use, it must be defined in the mailers configuration
			defaultProtocol : "files",
			// Here you can register one or many mailers by name
			mailers         : {
				"default" : { class : "CFMail" },
				"files"   : {
					class      : "File",
					properties : { filePath : "config/logs/mail" }
				}
			},
			// The defaults for all mail config payloads and protocols
			defaults : {
				 // from : "",
			},
			// Whether the scheduled task is running or not
			runQueueTask : true
		};
	}

}
