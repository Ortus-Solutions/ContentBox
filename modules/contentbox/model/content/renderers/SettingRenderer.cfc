/**
* A content renderer that transforms ${setting} into the actual setting displayed
* You can also prefix the markup with rc or prc to render from the request contexts as well:
* ${rc:key} ${prc:key}
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
		translateContent( 
			builder	= arguments.interceptData.builder, 
			content = arguments.interceptData.content, 
			event	= arguments.event 
		);
	}

	/**
	* Translate the content
	*/
	private function translateContent( required builder, required content, required event ){
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
				// Do we have rc or prc prefix?
				if( reFindNoCase( "^p?rc\:", thisSetting ) ){

					thisValue = event.getValue( 
						name 	= listLast( thisSetting, ":" ), 
						private = ( listFirst( thisSetting, ":" ) eq "rc" ? false : true )
					);

				} 
				// Normal Setting
				else {
					thisValue = settingService.getSetting( name=thisSetting, defaultValue="${Setting: #thisSetting# not found}" );
				}
			}
			catch(Any e){
				thisValue = "Error translating setting on target #thisSetting#: #e.message# #e.detail#";
				log.error( "Error translating setting on target: #thisSetting#", e );
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
