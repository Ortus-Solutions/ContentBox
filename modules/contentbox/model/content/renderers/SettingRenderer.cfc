/**
* A content renderer that transforms ${setting} into the actual setting displayed
*/
component accessors="true"{
	
	// DI
	property name="cb" 				inject="CBHelper@cb";
	property name="settingService" 	inject="settingService@cb";
	property name="log"				inject="logbox:logger:{this}";
	
	/**
	* Configure this renderer
	*/
	void function configure(){}
	
	/**
	* Execute on content translations for pages and blog entries
	*/
	void function cb_onContentRendering( required event, struct interceptData={} ){
		translateContent( builder=arguments.interceptData.builder, content=arguments.interceptData.content );
	}

	/**
	* Translate the content
	*/
	private function translateContent( required builder, required content ){
		// our mustaches pattern
		var regex 		= "\$\{([^\}])+\}";
		// match contentbox links in our incoming builder and build our targets array and len
		var targets 	= reMatch( regex, builder.toString() );
		var targetLen 	= arrayLen( targets );
		var thisSetting	= "";
		var thisValue 	= "";
		
		// Loop over found variables
		for( var x=1; x lte targetLen; x++ ){
			
			try{
				// get the setting defined in ${}
				thisSetting = mid( targets[ x ], 3, len( targets[ x ] ) - 3 );
				thisValue 	= settingService.getSetting( name=thisSetting, defaultValue="${Setting: #thisSetting# not found}" );
			}
			catch(Any e){
				thisValue = "Error translating setting on target #targets[ x ]#: #e.message# #e.detail#";
				log.error( "Error translating setting on target: #targets[ x ]#", e );
			}
			
			// PROCESS REPLACING 
			
			// get location of target
			var rLocation 	= builder.indexOf( targets[ x ] );
			var rLen 		= len( targets[ x ] );
			
			// Loop findings of same instances to replace
			while( rLocation gt -1 ){
				// Replace it
				builder.replace( javaCast( "int", rLocation ), javaCast( "int", rLocation + rLen ), thisValue );
				// look again
				rLocation = builder.indexOf( targets[ x ], javaCast( "int", rLocation) );
			}
			
		}
	}
	
}
