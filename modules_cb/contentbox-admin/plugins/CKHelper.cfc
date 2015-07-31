/**
* Helps with CK Editor operations
*/
component cache="true"{
	
	CKHelper function init(){
		
		// Plugin Properties
		setPluginName("CKHelper");
		setPluginVersion("1.0");
		setPluginDescription("Helps with CK Editor operations");
		setPluginAuthor("Ortus Solutions");
		setPluginAuthorURL("www.ortussolutions.com");
		
		return this;
	}
	
	function toCKDate(inDate){
		return dateFormat(arguments.inDate,"yyyy-mm-dd");
	}
	
	function ckHour(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"HH");
	}
	
	function ckMinute(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"mm");
	}
	
}
