/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages Auto-Updates in ContentBox
*/
component accessors="true" threadSafe{

	// DI
	property name="zipUtil" 		inject="zipUtil@cb";
	property name="wirebox" 		inject="wirebox";
	property name="appPath" 		inject="coldbox:setting:ApplicationPath";
	property name="moduleConfig"	inject="coldbox:moduleConfig:contentbox";

	/**
	* The patches location in the system
	*/
	property name="patchesLocation";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* Constructor
	*/
	UpdateService function init(){
		return this;
	}

	/**
	* onDIComplete startup the layouting services
	*/
	void function onDIComplete(){
		// setup location paths
		patcheslocation = moduleConfig.path & "/updates";
	}


	/************************************** PUBLIC *********************************************/


	/**
	* Apply updates from a download URL, return results struct: [error,logInfo]
	* @downloadURL The download URL for the update
	* 
	* @return results struct : { error:boolean, logInfo:string }
	*/
	struct function applyUpdateFromURL( required string downloadURL ){
		var log 			= createObject( "java", "java.lang.StringBuilder" ).init( "" );
		var results 		= { error=true, logInfo="" };
		var fileName 		= getFileFromPath( arguments.downloadURL );

		setting requestTimeout="999999";

		// download patch and extracted?
		if( downloadPatch( arguments.downloadURL, log ) ){
			// Apply Patch
			if( applyUpdateOnDisk( log ) ){
				results.error = false;
			}
		}

		// finalize the results
		results.log = log.toString();
		return results;
	}

	/**
	* Apply updates from an upload, return results struct: [error,logInfo]
	* @fileField The file field form name
	* 
	* @return results struct : { error:boolean, logInfo:string }
	*/
	struct function applyUpdateFromUpload( required fileField ){
		var log 			= createObject( "java","java.lang.StringBuilder" ).init( "" );
		var results 		= { error=true, logInfo="" };

		try{
			setting requestTimeout="999999";
			
			// upload patch
			log.append( "Starting upload of patch.<br/>" );
			var uploadResults = uploadUpdate( arguments.fileField );
			log.append( "Upload of patch completed, starting to uncompress it.<br/>" );

			// extract patch
			extractPatch( uploadResults.clientfile, log);

			// Apply Patch
			if( applyUpdateOnDisk( log ) ){
				results.error = false;
			}
		} catch( any e ) {
			log.append( "Exception uploading patch: #e.message# #e.detail#<br/>" );
		}

		// finalize the results
		results.log = log.toString();
		return results;
	}

	/**
	* Process patch update removals if any
	* @path The path of the patch
	* @log The log buffer
	*/
	function processRemovals(required path, required log){
		// verify the path exists on the incoming path
		if( !fileExists( arguments.path ) ){
			arguments.log.append( "Skipping file removals as file does not exist: #arguments.path#<br/>" );
			return;
		}
		// read the files to remove
		var removalText = fileRead( arguments.path );
		arguments.log.append( "Starting to process removals from: #arguments.path#<br/>" );

		// if there are files, then remove, else continue
		if( len( removalText ) ){
			var files = listToArray( removalText, chr(10) );
			for( var thisFile in files ){
				if( fileExists( expandPath( "/#thisFile#" ) ) ){
					fileDelete( expandPath( "/#thisFile#" ) );
					arguments.log.append( "Removed: #thisFile#<br/>" );
				} else {
					arguments.log.append( "File Not Found, so not removed: #thisFile#<br/>" );
				}
			}
		} else {
			arguments.log.append( "No updated files to remove. <br/>" );
		}

		// remove deletes.txt file
		fileDelete( arguments.path );
	}

	/**
	* Process updated files
	* @path The path of the patch
	* @log The log buffer
	*/
	function processUpdates(required path, required log){

		// Verify patch exists
		if( !fileExists( arguments.path ) ){
			arguments.log.append( "Skipping patch extraction as no patch.zip found in update patch.<br/>" );
			return;
		}

		// test zip has files?
		try{
			var listing = zipUtil.list( arguments.path );
		} catch( Any e ) {
			// bad zip file.
			arguments.log.append( "Error getting listing of zip archive, bad zip.<br />" );
			rethrow;
		}

		// good zip file
		arguments.log.append( "Patch Zip archive detected, beginning to expand update: #arguments.path#<br />" );
		// extract it
		zipUtil.extract(
			zipFilePath		= arguments.path, 
			extractPath		= appPath, 
			overwriteFiles	= "true" 
		);
		// more logging
		arguments.log.append( "Patch Updates uncompressed.<br />" );

		// remove patch
		fileDelete( arguments.path );
	}

	/**
	 * Build an updater CFC from our patch locations
	 * @return contentbox.models.updates.IUpdate
	 */
	any function buildUpdater(){
		return wirebox.getInstance( "contentbox.updates.Update" );
	}

	/**
	* Download the patch from URL and mark it as ok or not
	* @downloadURL The download URL
	* @log The log file buffer
	*/
	boolean function downloadPatch( required string downloadURL, required log ){
		var fileName = getFileFromPath( arguments.downloadURL );

		try{
			arguments.log.append( "Starting Download...<br />" );
			//Download File
			var httpService = new http(url="#arguments.downloadURL#",
									   method="GET",
									   file="#fileName#",
									   path="#getPatchesLocation()#",
									   throwOnError=true);
			httpService.send();
		}
		catch(Any e){
			arguments.log.append( "<strong>Error downloading file: #e.message# #e.detail#</strong><br />" );
			return false;
		}

		// log it
		arguments.log.append( "File #fileName# downloaded successfully at #getPatchesLocation()#, checking type for extraction.<br />" );

		// Uncompress Patch?
		return extractPatch(filename,log);
	}

	/**
	* extract a patch in the updates location
	* @fileName The file to extract
	* @log The log file buffer
	*/
	boolean function extractPatch( required string filename, required log ){
		// Unzip File?
		if ( listLast(arguments.filename,"." ) eq "zip" ){

			// test zip has files?
			try{
				var listing = zipUtil.list( "#getPatchesLocation()#/#arguments.filename#" );
			}
			catch(Any e){
				// bad zip file.
				arguments.log.append( "Error getting listing of zip archive (#getPatchesLocation()#/#arguments.filename#), bad zip, file will be removed.<br />" );
				fileDelete( getPatchesLocation() & "/" & arguments.filename );
				return false;
			}

			// good zip file
			arguments.log.append( "Zip archive detected, beginning to uncompress.<br />" );
			// extract it
			zipUtil.extract(zipFilePath="#getPatchesLocation()#/#arguments.filename#", extractPath="#getPatchesLocation()#", overwriteFiles="true" );
			// more logging
			arguments.log.append( "Patch Update uncompressed at #getPatchesLocation()#.<br />" );
			// return good and extracted
			return true;
		}
		else{
			arguments.log.append( "File #arguments.fileName# is not a zip file, so cannot extract it or use it, file will be removed.<br/>" );
			fileDelete( getPatchesLocation() & "/" & arguments.filename );
			return false;
		}
	}

	/**
	* Check for version updates
	* @cVersion The current version of the system
	* @nVersion The newer version received
	*/
	boolean function isNewVersion( required string cVersion, required string nVersion ){
		/**
		Semantic version: major.minor.revision-alpha.1+build
		**/

		var cVersionData 	= parseSemanticVersion( trim( arguments.cVersion ) );
		var nVersionData 	= parseSemanticVersion( trim( arguments.nVersion ) );

		// Major check
		if( nVersionData.major gt cVersionData.major ){
			return true;
		}

		// Minor Check
		if( nVersionData.major eq cVersionData.major AND nVersionData.minor gt cVersionData.minor ){
			return true;
		}

		// Revision Check
		if( nVersionData.major eq cVersionData.major AND
			nVersionData.minor gt cVersionData.minor AND
			nVersionData.revision gt cVersionData.revision ){
			return true;
		}

		// BuildID Check
		if( nVersionData.major eq cVersionData.major AND
			nVersionData.minor gt cVersionData.minor AND
			nVersionData.revision gt cVersionData.revision AND
			nVersionData.buildID gt cVersionData.buildID ){
			return true;
		}

		return false;
	}

	/**
	* Parse the semantic version
	* @version The version string
	* 
	* @return struct:{major,minor,revision,beid,buildid}
	*/
	private struct function parseSemanticVersion( required string version ){
		var results = { major = 1, minor = 0, revision = 0, beID = "", buildID = 0 };

		// Get build ID first
		results.buildID		= find( "+", arguments.version ) ? listLast( arguments.version, "+" ) : '0';
		// REmove build ID
		arguments.version 	= reReplace( arguments.version, "\+([^\+]*).$", "" );
		// Get BE ID Formalized Now we have major.minor.revision-alpha.1
		results.beID		= find( "-", arguments.version ) ? listLast( arguments.version, "-" ) : '';
		// Remove beID
		arguments.version 	= reReplace( arguments.version, "\-([^\-]*).$", "" );
		// Get Revision
		results.revision	= getToken( arguments.version, 3, "." );
		if( results.revision == "" ){ results.revision = 0; }

		// Get Minor + Major
		results.minor		= getToken( arguments.version, 2, "." );
		if( results.minor == "" ){ results.minor = 0; }
		results.major 		= getToken( arguments.version, 1, "." );

		return results;
	}

	/**
	* Activate ORM Update
	*/
	UpdateService function activateORMUpdate(){
		var appCFCPath = appPath & "Application.cfc";
		var c = fileRead(appCFCPath);
		c = replacenocase(c, 'dbcreate = "none"','dbcreate = "update"');
		fileWrite(appCFCPath, c);
		return this;
	}

	/**
	* Deactivate ORM Update
	*/
	UpdateService function deactivateORMUpdate(){
		var appCFCPath = appPath & "Application.cfc";
		var c = fileRead(appCFCPath);
		c = replacenocase(c, 'dbcreate = "update"','dbcreate = "none"');
		fileWrite(appCFCPath, c);
		return this;
	}

	/**
	* Upload an update file to disk
	* @fileField The file field on the form
	*/
	struct function uploadUpdate( required fileField ){
		return fileUpload( 
			getPatchesLocation(), 
			arguments.fileField, 
			"application/zip,application/x-zip-compressed,application/octet-stream", 
			"overwrite" 
		);
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Apply an already downloaded update on disk
	* @log The log buffer
	*/
	private boolean function applyUpdateOnDisk( required log ){
		var results = false;

		// Verify Patch integrity
		if( !fileExists( getPatchesLocation() & "/Update.cfc" ) ){
			arguments.log.append( "Update.cfc not found in downloaded package, skipping patch update.<br/>" );
		} else {
			try{
				var updater = buildUpdater();

				// do preInstallation
				updater.preInstallation( arguments.log );
				arguments.log.append( "Update.cfc - called preInstallation() method.<br/>" );

				// Do deletes first
				processRemovals( getPatchesLocation() & "/deletes.txt", log );

				// Do updates second
				processUpdates( getPatchesLocation() & "/patch.zip", log );

				// Post Install
				updater.postInstallation( arguments.log );
				arguments.log.append( "Update.cfc - called postInstallation() method.<br/>" );

				results = true;
			} catch( any e ) {
				arguments.log.append( "Error applying update: #e.message# #e.detail#<br/>#e.stacktrace#" );
			} finally {
				// Finally Remove Updater
				if( fileExists( getPatchesLocation() & "/Update.cfc" ) ){
					fileDelete( getPatchesLocation() & "/Update.cfc" );
				}
				// Removal of Mac stuff
				if( directoryExists( getPatchesLocation() & "/__MACOSX" ) ){
					directoryDelete( getPatchesLocation() & "/__MACOSX", true);
				}
			}
		}

		return results;
	}

}