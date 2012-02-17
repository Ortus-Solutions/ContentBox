/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
*/
component accessors="true"{

	// DI
	property name="zipUtil" inject="coldbox:plugin:Zip";
	property name="wirebox" inject="wirebox";
	property name="appPath" inject="coldbox:setting:ApplicationPath";
	
	// properties
	property name="patchesLocation";
	
	/************************************** CONSTRUCTOR *********************************************/
	
	// Constructor
	UpdateService function init(){
		patchesLocation = getDirectoryFromPath( getmetadata(this).path ) & "patches";
		return this;
	}
	
	/************************************** PUBLIC *********************************************/
	
	
	// Apply updates from a download URL, return results struct: [error,logInfo]
	struct function applyUpdateFromURL(required string downloadURL){
		var log 			= createObject("java","java.lang.StringBuilder").init("");
		var results 		= {error=true,logInfo=""};
		var fileName 		= getFileFromPath(arguments.downloadURL);
		
		// download patch and extracted?
		if( downloadPatch(arguments.downloadURL,log) ){
			// Apply Patch
			if( applyUpdateOnDisk(log) ){
				results.error = false;
			}
		}
		
		// finalize the results
		results.log = log.toString();
		return results;	
	}
	
	// Apply updates from an upload, return results struct: [error,logInfo]
	struct function applyUpdateFromUpload(required fileField){
		var log 			= createObject("java","java.lang.StringBuilder").init("");
		var results 		= {error=true,logInfo=""};
		
		try{
			// upload patch 
			log.append("Starting upload of patch.<br/>");
			var uploadResults = uploadUpdate( arguments.fileField );
			log.append("Upload of patch completed, starting to uncompress it.<br/>");
			
			// extract patch
			extractPatch( uploadResults.clientfile, log);
			
			// Apply Patch
			if( applyUpdateOnDisk(log) ){
				results.error = false;
			}	
		}
		catch(any e){
			log.append("Exception uploading patch: #e.message# #e.detail#<br/>");
		}
		
		// finalize the results
		results.log = log.toString();
		return results;	
	}
	
	// processRemovals
	function processRemovals(required path,required log){
		
		if( !fileExists( arguments.path ) ){
			log.append("Skipping file removals as file does not exist: #arguments.path#<br/>");
			return;
		}
		
		var removalText = fileRead( arguments.path );
		
		log.append("Starting to process removals from: #arguments.path#<br/>");
		
		if( len(removalText) ){
			var files = listToArray( removalText, chr(10) );
			for(var thisFile in files){
				if( fileExists( expandPath("/#thisFile#" ) ) ){
					fileDelete( expandPath("/#thisFile#" ) );
					log.append("Removed: #thisFile#<br/>");
				}
				else{
					log.append("File Not Found, so not removed: #thisFile#<br/>");
				}
			}
		}
		else{
			log.append("No updated files to remove. <br/>");
		}
		
		// remove deletes
		fileDelete( arguments.path );
	}
	
	// processUpdates
	function processUpdates(required path, required log){
		
		// Verify patch exists
		if( !fileExists( arguments.path ) ){
			log.append("Skipping patch extraction as no patch.zip found in update patch.<br/>");
			return;
		}
		
		// test zip has files?
		try{
			var listing = zipUtil.list( arguments.path );
		}
		catch(Any e){
			// bad zip file.
			log.append("Error getting listing of zip archive, bad zip.<br />");
			rethrow;
		}
		
		// good zip file
		log.append("Patch Zip archive detected, beginning to expand update: #arguments.path#<br />");
		// extract it
		zipUtil.extract(zipFilePath=arguments.path, extractPath=appPath, overwriteFiles="true");
		// more logging
		log.append("Patch Updates uncompressed.<br />");
		
		// remove patch
		fileDelete( arguments.path );
	}
	
	// Build an updater cfc
	contentbox.model.updates.IUpdate function buildUpdater(){
		var updater = wirebox.getInstance("contentbox.model.updates.patches.Update");
		return updater;
	}
	
	// Download the patch from URL and mark it as ok or not
	boolean function downloadPatch(required string downloadURL,required log){
		var fileName = getFileFromPath(arguments.downloadURL);
		
		try{
			log.append("Starting Download...<br />");
			//Download File
			var httpService = new http(url="#arguments.downloadURL#",
									   method="GET",
									   file="#fileName#",
									   path="#getPatchesLocation()#",
									   throwOnError=true);
			httpService.send();
		}
		catch(Any e){
			log.append("<strong>Error downloading file: #e.message# #e.detail#</strong><br />");
			return false;
		}
		
		// log it
		log.append("File #fileName# downloaded succesfully at #getPatchesLocation()#, checking type for extraction.<br />");
		
		// Uncompress Patch?
		return extractPatch(filename,log);
	}
	
	// extract a patch
	boolean function extractPatch(required string filename, required log){
		// Unzip File?
		if ( listLast(arguments.filename,".") eq "zip" ){
			
			// test zip has files?
			try{
				var listing = zipUtil.list( "#getPatchesLocation()#/#arguments.filename#" );
			}
			catch(Any e){
				// bad zip file.
				log.append("Error getting listing of zip archive (#getPatchesLocation()#/#arguments.filename#), bad zip.<br />");
				fileDelete( getPatchesLocation() & "/" & arguments.filename );
				return false;
			}
			
			// good zip file
			log.append("Zip archive detected, beginning to uncompress.<br />");
			// extract it
			zipUtil.extract(zipFilePath="#getPatchesLocation()#/#arguments.filename#", extractPath="#getPatchesLocation()#", overwriteFiles="true");
			// more logging
			log.append("Patch Update uncompressed at #getPatchesLocation()#.<br />");
			
			return true;
		}
		else{
			log.append("File #arguments.fileName# is not a zip file, so cannot extract it.");
			fileDelete( getPatchesLocation() & "/" & arguments.filename );
			return false;
		}
	}
	
	/**
	* Check for version updates
	*/
	function isNewVersion(cVersion,nVersion){
		var cMajor 		= getToken(arguments.cVersion,1,".");
		var cMinor		= getToken(arguments.cVersion,2,".");
		var cRevision	= getToken(arguments.cVersion,3,".");
		// new version info
		var nMajor 		= getToken(arguments.nVersion,1,".");
		var nMinor		= getToken(arguments.nVersion,2,".");
		var nRevision	= getToken(arguments.nVersion,3,".");
		
		// Major check
		if( nMajor gt cMajor ){
			return true;				
		}
		
		// Minor Check
		if( nMajor eq cMajor AND nMinor gt cMinor ){
			return true;
		}
		
		// Revision Check
		if( nMajor eq cMajor AND nMinor eq cMinor AND nRevision gt cRevision){
			return true;
		}
		
		return false;
	}
	
	/**
	* Activate ORM Update
	*/
	function activateORMUpdate(){
		var appCFCPath = appPath & "Application.cfc";
		var c = fileRead(appCFCPath);
		c = replacenocase(c, 'dbcreate = "none"','dbcreate = "update"');
		fileWrite(appCFCPath, c);
	}
	
	/**
	* Deactivate ORM Update
	*/
	function deactivateORMUpdate(){
		var appCFCPath = appPath & "Application.cfc";
		var c = fileRead(appCFCPath);
		c = replacenocase(c, 'dbcreate = "update"','dbcreate = "none"');
		fileWrite(appCFCPath, c);
	}
	
	/**
	* Upload Update
	*/
	struct function uploadUpdate(required fileField){
		var destination = getPatchesLocation();
		return fileUpload(destination, arguments.fileField, "application/zip", "overwrite");
	}
	
	/************************************** PRIVATE *********************************************/

	// Apply an already downloaded update
	private boolean function applyUpdateOnDisk(required log){
		var results = false;
		
		// Verify Patch integrity
		if( !fileExists( getPatchesLocation() & "/Update.cfc" ) ){
			log.append("Update.cfc not found in downloaded package, skipping patch update.<br/>");
		}
		else{
			try{
				var updater = buildUpdater();
				
				// do preInstallation
				updater.preInstallation();
				log.append("Update.cfc - called preInstallation() method.<br/>");
				
				// Do deletes first
				processRemovals( getPatchesLocation() & "/deletes.txt", log );
				
				// Do updates second
				processUpdates( getPatchesLocation() & "/patch.zip", log );
				
				// Post Install
				updater.postInstallation();
				log.append("Update.cfc - called postInstallation() method.<br/>");
				
				results = true;
			}
			catch(any e){
				log.append("Error applying update: #e.message# #e.detail#<br/>");
			}
			finally{
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