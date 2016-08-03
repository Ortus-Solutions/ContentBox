/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ForgeBox Installer
*/
component singleton{

	// DI
	property name="zipUtil" 		inject="zipUtil@cb";

	/**
	* Constructor
	*/
	function init(){
		variables.tmpDir = createObject( "java", "java.lang.System" ).getProperty( "java.io.tmpdir" );
		return this;
	}

	/**
	* Install ForgeBox entries
	* @downloadURL The download URL
	* @destinationDir The destination for installation
	* 
	* @results struct = { error:boolean, logInfo }
	*/
	function install( required downloadURL, required destinationDir ){
		var log 			= createObject( "java","java.lang.StringBuilder" ).init( "Starting Download...<br />" );
		var destination  	= arguments.destinationDir;
		var fileName		= getFileFromPath( arguments.downloadURL );
		var results 		= { error=true, logInfo="" };
		
		// Append zip, if not found
		if( listLast( filename, "." ) neq "zip" ){
			filename &= ".zip";
		}
		
		try{
			var oHTTP = new HTTP( 
				url 			= arguments.downloadURL,
				method 			= "GET",
				file 			= fileName,
				path 			= variables.tmpDir,
				timeout			= 30,
				throwOnError 	= true
			).send();
		} catch( any e ) {
			log.append( "<strong>Error downloading file: #e.message# #e.detail#</strong><br />" );
			results.logInfo = log.toString();
			return results;
		}
		
		// has file size?
		if( getFileInfo( variables.tmpDir & "/" & fileName ).size LTE 0 ){	
			log.append( "<strong>Cannot install file as it has a file size of 0.</strong>" );
			results.logInfo = log.toString();
			fileDelete( variables.tmpDir & "/" & fileName );
			return results;
		}
		
		log.append( "File #fileName# downloaded successfully, checking type for extraction.<br />" );
		
		// Unzip it
		if( listLast( filename, "." ) eq "zip" ){
			log.append( "Zip archive detected, beginning to uncompress.<br />" );

			// extract it
			zipUtil.extract(
				zipFilePath		= variables.tmpDir & "/" & fileName, 
				extractPath		= destination, 
				overwriteFiles	= "true" 
			);

			log.append( "Archive uncompressed and installed at #destination#. Performing cleanup.<br />" );

			fileDelete( variables.tmpDir & "/" & filename );
		}  else {
			log.append( "File is not a zip, skipping and removing<br/>" );
			fileDelete( variables.tmpDir & "/" & fileName );
		}
		
		log.append( "Entry: #filename# successfully installed at #destination#.<br />" );
		results = { error=false, logInfo=log.toString() };
		
		return results;
	}

}