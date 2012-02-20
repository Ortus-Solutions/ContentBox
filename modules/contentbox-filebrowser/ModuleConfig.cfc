<!---
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author      :	Luis Majano
Description :
File Browser can be used by either navigating to it or rendering it out as a widget:

#runEvent(event="filebrowser:home",eventArguments={widget=true})#

By default this module loads jquery, if you don't want to, update the setting

The arguments you can use are:

- widget:boolean[false] Displays as a self-contained widget

 --->
<cfcomponent output="false" hint="My Module Configuration">
<cfscript>
	// Module Properties
	this.title 				= "File Browser";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A file-directory browser and selector";
	this.version			= "1.4";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbFileBrowser";

	function configure(){

		// module settings - stored in modules.name.settings
		settings = {
			// The title name for usage inline and the layout
			title = "ColdBox FileBrowser v#this.version#",
			// the directory root path to start the visualizer on, absolute path, set it to contentbox default location
			directoryRoot = expandPath("/contentbox/content"),
			// Secure the visualization or creation of stuff above the directory root or not
			traversalSecurity = true,
			// Show files on the visualizer or not
			showFiles = true,
			// Ability to create folders
			createFolders = true,
			// Ability to remove stuff
			deleteStuff = true,
			// Allow downloads
			allowDownload = true,
			// Allow uploads
			allowUploads = true,
			// CFFile Upload accepted mime types, blank means all.
			acceptMimeTypes = "",
			// Name filtering applies to both files and directories. This is also a regex
			nameFilter = ".*",
			// Extension filtering that applies to file extensions to display, matches the filter argument to directoryList()
			extensionFilter = "",
			// Image Name filtering applies to both files and directories. This is also a regex.  Where the filterType=image.
			imgNameFilter = "^((?!\.).)*$|.+\.(jpg|jpeg|bmp|gif|png)/? *",
			// Flash Name filtering applies to both files and directories. This is also a regex.  Where the filterType=flash.
			flashNameFilter = "^((?!\.).)*$|.+\.(swf|fla)/? *",
			// Volume Chooser, display the volume navigator
			volumeChooser = false,
			// Load jQuery
			loadJQuery = true,
			// Load Select Callback hooks
			loadSelectCallbacks = true,
			// Quick View image width in pixels
			quickViewWidth = 400,
			// Uploadify Settings
			uploadify = {
				fileDesc = "All Files",
				fileExt	 = "*.*;",
				multi 	 = true,
				sizeLimit = 0,
				customJSONOptions = ""
			}
		};
		
		// clean directory root
		settings.directoryRoot = REReplace(settings.directoryRoot,"\\","/","all");
		if (right(settings.directoryRoot,1) EQ "/") {
			settings.directoryRoot = left(settings.directoryRoot,len(settings.directoryRoot)-1);
		}

		// Layout Settings
		layoutSettings = {
			defaultLayout = "filebrowser.cfm"
		};

		// SES Routes
		routes = [
			// create folder
			{pattern="/createFolder", handler="home",action="createfolder"},
			// remove stuff
			{pattern="/remove", handler="home",action="remove"},
			// download
			{pattern="/download", handler="home",action="download"},
			// rename
			{pattern="/rename", handler="home",action="rename"},
			// upload
			{pattern="/upload", handler="home",action="upload"},
			// traversal paths
			{pattern="/d/:path", handler="home",action="index"},
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = arrayToList( [
			"fb_preTitleBar", "fb_postTitleBar" ,"fb_preLocationBar" , "fb_postLocationBar", "fb_preBottomBar", "fb_postBottomBar", 
			"fb_preFileListing","fb_postFileListing","fb_preUploadBar","fb_postUploadBar", "fb_preQuickViewBar", "fb_postQuickViewBar",
			// folder creation
			"fb_postFolderCreation","fb_preFolderCreation",
			// removals
			"fb_preFileRemoval", "fb_postFileRemoval",
			// renameing
			"fb_preFileRename", "fb_postFileRename",
			// downloads
			"fb_preFileDownload", "fb_postFileDownload",
			// Uploads
			"fb_preFileUpload", "fb_postFileUpload"
			] )
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

</cfscript>
</cfcomponent>