component extends="coldbox.system.Interceptor"{

	function configure(){
	}

	/**
	* Fired on blogbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^blogbox"{
		// store module root	
		event.setValue("bbroot", event.getModuleRoot());
		// store module entry point
		event.setValue("bbEntryPoint", getProperty("entryPoint"));
	}	
				
}