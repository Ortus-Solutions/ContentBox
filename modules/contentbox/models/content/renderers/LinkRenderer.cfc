/**
* A content renderer that transforms _page:XX_ and _entry:XX_ into page and entry links
*/
component accessors="true"{
	
	// DI
	property name="cb" 			inject="id:CBHelper@cb";
	property name="log"			inject="logbox:logger:{this}";
	
	void function configure(){}
	
	/**
	* Execute on content translations for pages and blog entries
	*/
	void function cb_onContentRendering(event, struct interceptData){
		translateContent(builder=arguments.interceptData.builder, content=arguments.interceptData.content);
	}

	private function determineSlug(required tagString){
		var slug = reReplaceNoCase(arguments.tagString,"(page|entry|pagessl|entryssl)\:\[","" );
		return reReplaceNoCase(slug,"\]$","" );
	}

	private function translateContent(required builder, content){
		// our mustaches pattern
		var regex 		= "(page|pagessl|entry|entryssl|root)\:\[[^\]]*]";
		// match contentbox links in our incoming builder and build our targets array and len
		var targets 	= reMatch( regex, builder.toString() );
		var targetLen 	= arrayLen( targets );
		var tagString	= "";
		var linkContent = "";
		
		// Loop over found links
		for(var x=1; x lte targetLen; x++){
			tagString = targets[ x ];
			
			// convert quotes to standards
			tagString = replace(tagString,"&##34;",'"',"all" );
			tagString = replace(tagString,"&##39;","'","all" );
			tagString = replace(tagString,"&quot;","'","all" );
			
			try{
				
				var linkType = getToken( tagString, 1, ":" );
				switch( linkType ){
					case "page" 	: { linkContent = cb.linkPage( page=determineSlug( tagString ) ); break; }
					case "pagessl" 	: { linkContent = cb.linkPage( page=determineSlug( tagString ), ssl=true ); break; }
					case "entry" 	: { linkContent = cb.linkEntry( entry=determineSlug( tagString ) ); break; }
					case "entryssl" : { linkContent = cb.linkEntry( entry=determineSlug( tagString ), ssl=true ); break; }
					case "root"  	: { linkContent = cb.themeRoot(); break; }
				}
				
			}
			catch(Any e){
				linkContent = "Error translating link: #e.message# #e.detail#";
				log.error( "Error translating link on target: #targets[ x ]#", e);
			}
			
			// PROCESS REPLACING 
			
			// get location of target
			var rLocation 	= builder.indexOf( targets[ x ] );
			var rLen 		= len( targets[ x ] );
			
			// Loop findings of same {{{}}} instances to replace
			while( rLocation gt -1 ){
				// Replace it
				builder.replace( javaCast( "int", rLocation), javaCast( "int", rLocation+rLen), linkContent);
				// look again
				rLocation = builder.indexOf( targets[ x ], javaCast( "int", rLocation) );
			}
			
		}
	}
	
}
