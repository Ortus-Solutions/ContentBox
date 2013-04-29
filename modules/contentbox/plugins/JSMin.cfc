/********************************************************************************
Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	 :	Luis Majano
Description :

This is a plugin that interfaces with our own flavor of JSMin to minify
CSS and JavaScript files and also compress them into a single include file.  We
have also added LESS support for compiling LESS into CSS for you or on-demand.


Configuration Settings:

jsmin_enable : boolean (defaults to true)  
	- flag to enable disable the packaging process
jsmin_cacheLocation : string
	- the relative file location where cached minified js/css files will be stored,
	  this location will be expanded. ex: includes/cache

If any of the minify methods cannot find a location argument or the jsmin_cacheLocation setting
then an exception will be thrown.
	 
Usage:

* minify(assets:string, location:relativePath) : html script or link

The main method of operation is minify().  You pass to it a list of assets to compress,
but they have to be of the same type: js or css/less.  Do not alternate or weird results will
happen.  This method returns a script or link include that you would output on your layouts:

<head>
#getMyPlugin("JSMin").minify('includes/js/myscripts.js,includes/js/jquery.js')#
#getMyPlugin("JSMin").minify('includes/css/site.css,includes/css/boxes.css')#
#getMyPlugin("JSMin").minify('includes/css/site.less,includes/css/boxes.less')#

// With Location
#getMyPlugin("JSMin").minify(assets='includes/css/site.less,includes/css/boxes.less',
							 location='includes/mycache')#
</head>

As you can see from the example above, you can easily render the minified version of all
the assets.  This plugin will minify each asset and if more than 1 is declared, then it
will build a concatenated version of the js or css/less assets and cache them. If the files
are of LESS extension, then the plugin will compile the LESS into CSS files.

You can use the alternate 'location' argument to choose the location of the compressed and 
minified files.

* minifyToHead(assets:string, location:relativePath) : void

This method basically sends the HTML links and script tags to the head section using
cfhtmlhead.  You can use this method when calling JSMin via handlers or plugins or any other
location than layouts.

* compileLessSource(input:LESS, [ output:absolutePath ]) : CSS
This method compiles LESS source into CSS for you and returns it to you if no output argument is used, 
else the compiled source is sent to the output file. An extra goody about this method is that 
compilation only takes place if the source LESS file has been modified.

* compileLess(input:absolutePath, [ output:absolutePath ]) : [void | CSS]

This methods can compile an input LESS file into an output CSS file or you can omit passing 
the output file argument and the method will return to you the compiled CSS.

*/
component extends="coldbox.system.Plugin" singleton{

	/************************************** CONSTRUCTOR *********************************************/
	
	// Constructor
	JSMin function init(required controller){
		super.init( arguments.controller );

		// Plugin Properties
		setpluginName( "JSMin" );
		setpluginVersion( "3.0" );
		setpluginDescription( "A plugin that minifies js/css/less files with style!" );
		setpluginAuthor( "Ortus Solutions, Corp" );
		setpluginAuthorURL( "http://www.ortussolutions.com" );

		// local properties
		instance.cacheMap 				= {};
		instance.cacheLessMap			= {};
		instance.uuid 					= createobject("java", "java.util.UUID");
		instance.cacheDiskLocation 		= "";
		instance.cacheIncludeLocation 	= "";

		//Check settings
		if( settingExists( "jsmin_cacheLocation" ) ){
			instance.cacheDiskLocation 		= expandPath( getSetting( "jsmin_cacheLocation" ) );
			instance.cacheIncludeLocation 	= getSetting( "jsmin_cacheLocation" );
		}
		if( not settingExists( "jsmin_enable" ) ){
			setSetting( "jsmin_enable", true );
		}

		// load jars via javaloader
		instance.javaLoader = getPlugin( "JavaLoader" );
		instance.javaLoader.appendPaths( getDirectoryFromPath( getMetaData( this ).path ) & "lib" );

		// clean cachelocation on init
		cleanCache();

		return this;
	}
	
	/************************************** METHODS *********************************************/

	/**
	* Prepare source(s) statements using our fabulous jsmin compressor and send them to the head section
	* @assets.hint A list of js or css/less files to compress and add to the page. They will be concatenated in order
	* @location.hint The location to store the cached assets, else it defaults to the plugin's settings
	*/
	JSMin function minifyToHead(required assets, location=""){
		$htmlhead( minify( arguments.assets, arguments.location ) );
		return this;
	}

	/**
	* Prepare source(s) statements using our fabulous jsmin compressor and return back the include HTML
	* @assets.hint A list of js or css/less files to compress and add to the page. They will be concatenated in order
	* @location.hint The location to store the cached assets, else it defaults to the plugin's settings
	*/
	function minify(required assets, location=""){
		var cacheKey 				= hash( lcase( arguments.assets ) );
		var cachedFile 				= "";
		var cacheIncludeLocation 	= instance.cacheIncludeLocation;
		var cacheDiskLocation 		= instance.cacheDiskLocation;

		// Alternate cache location
		if( len( arguments.location ) ){
			cacheIncludeLocation 	= arguments.location;
			cacheDiskLocation 		= expandPath( arguments.location );
		}

		// Location Checks
		if( !len( cacheIncludeLocation ) AND !len( cacheDiskLocation ) ){
			$throw("There are no cache include locations so I have no clue where to put the cached assets.",
				   "Please use the jsmin_cacheLocation setting or the 'location' arguments",
				   "JSMin.InvalidCacheLocations");
		}
		
		// enabled? If not, just render out links
		if( not getSetting( "jsmin_enable" ) ){
			return renderLinks( arguments.assets );
		}

		// check if assets already in cachemap
		if( structKeyExists( instance.cacheMap, cacheKey ) ){
			return renderLinks( instance.cacheMap[ cacheKey ] );
		}

		//compress assets
		cachedFile = jsmin( cacheKey, arguments.assets, cacheDiskLocation );

		// save in cache map
		instance.cacheMap[ cacheKey ] = cacheIncludeLocation & "/" & cachedFile;

		//return rendered cache links
		return renderLinks( instance.cacheMap[ cacheKey ] );
	}
	
	/**
	* Renders links according to passed in assets
	* @assets.hint A list of js/css files to compress and add to the page
	*/
	function renderLinks(required assets){
		var sb = createObject("java","java.lang.StringBuilder").init('');
		var event = controller.getRequestService().getContext();

		// request assets storage
		event.paramValue(name="jsmin_assets", value="", private=true);

		for(var x=1; x lte listLen( arguments.assets ); x=x+1){
			// Get first asset
			var thisAsset 		= listGetAt( arguments.assets, x );
			var thisAssetExt 	= listLast(thisAsset,".");
			
			// Is asset already loaded
			if( NOT listFindNoCase( event.getValue(name="jsmin_assets", private=true), thisAsset ) ){

				// Load Asset
				if( thisAssetExt eq "js" ){
					sb.append('<script src="#thisAsset#" type="text/javascript"></script>');
				}
				else{
					// Do we have a LESS file?
					if( thisAssetExt eq "less" ){
						// Switch extensions on asset
						thisAssetExt 	= "css";
						thisAsset 		= replacenocase( thisAsset, ".less", ".css" );
						// Compile LESS in same directory as asset file
						compileLess(input=expandPath( replacenocase( thisAsset, ".css", ".less" ) ), output=expandPath( thisAsset ) ); 
					}
					// Append it to buffer.
					sb.append('<link href="#thisAsset#" type="text/css" rel="stylesheet" />');
				}

				// Store It as Loaded
				event.setValue(name="jsmin_assets",
							   value=listAppend( event.getValue(name="jsmin_assets", private=true), thisAsset),
							   private=true);
			}
		}

		return sb.toString();
	}
		
	/**
	* Clean the cache location for cached assets
	* @location.hint The location to store the cached assets, else it defaults to the plugin's settings
	*/
	JSMin function cleanCache(location=""){
		var qList = "";
		var cleanLocation = instance.cacheDiskLocation;

		// Location override
		if( len( arguments.location ) ){
			cleanLocation = expandPath( arguments.location );		
		}
		
		// Abort if no locations
		if( !len( cleanLocation ) ){
			return this;
		}
		
		qList = directoryList( cleanLocation, false, "path", "*.cache.*" );
		
		for(var thisFile in qList ){
			fileDelete( thisFile );
		}

		return this;
	}
	
	/**
	* Compile LESS into CSS either to an output file or return
	* @input.hint The input LESS absolute file location
	* @output.hint The output LESS absolute file location
	*/
	function compileLess(required input, output){
		var compiler = instance.javaLoader.create( "com.asual.lesscss.LessEngine" );
		
		// Do we have an output file
		if( structKeyExists( arguments, "output") ){
			
			// ONLY compile if output does not exist, or if it does, then if the timestamp has changed.
			if( !fileExists( arguments.output ) OR isLessModified( arguments.input ) ){
			
				// Compile directly to output file
				compiler.compile( createObject("java", "java.io.File").init( arguments.input ), 
							  	  createObject("java", "java.io.File").init( arguments.output ) );	
				
				// Store visited less file timestamp
				instance.cacheLessMap[ hash( arguments.input ) ] = getFileInfo( arguments.input ).lastmodified;			  	  
			}
		}
		else{
			// compile back to user
			return compiler.compile( createObject("java", "java.io.File").init( arguments.input ) );
		}
	}	
	
    /**
	* Compile LESS source string into CSS
	* @input.hint The input LESS source code to compile back to CSS
	* @output.hint The output LESS absolute file location
	*/
	function compileLessSource(required string input, output){
		// Compile it
		var results = instance.javaLoader.create( "com.asual.lesscss.LessEngine" ).compile( arguments.input );
		// Compile to output?
		if( structKeyExists( arguments, "output") ){
			fileWrite( arguments.output, results );
		}
		// Return it
		return results;		
	}
	
	/************************************** PRIVATE *********************************************/

	/**
	* JSMin a set of files and return the compressed version cache string file
	* @cacheKey.hint The cache key in use
	* @assets.hint A list of js or css files to compress and add to the page. They will be concatenated in order
	* @location.hint The location on disk to store the assets
	*/
	private function jsmin(required cacheKey, required assets, required location){
		var x=1;
		var thisAsset = "";
		var thisAssetExt = "";
		var thisType = "1";
		var tempFileName = "";
		var fis = "";
		var fos = "";
		var compressor = "";
		var compressedFiles = [];
		var sb = "";
		var returnAsset = "";

		lock name="jsmin.#arguments.cacheKey#" type="exclusive" timeout="20" throwOntimeout="true"{
			//Compress and cache files
			for(x=1; x lte listLen( arguments.assets ); x++){
				// Get first asset
				thisAsset 		= trim( listGetAt( arguments.assets, x ) );
				thisAssetExt 	= listLast( thisAsset, "." );
				
				// Is this a less file?
				if( thisAssetExt eq "less" ){ 
					// Switch extensions on asset
					thisAssetExt 	= "css";
					thisAsset 		= replacenocase( thisAsset, ".less", ".css" );
					// Compile LESS in same directory as asset file
					compileLess(input=expandPath( replacenocase( thisAsset, ".css", ".less" ) ), output=expandPath( thisAsset ) ); 
				}
				
				// File Type: 1=js, 2=css
				thisType = 1;
				if( thisAssetExt eq "css" ){
					thisType = 2;
				}

				//register temp file
				tempFileName = instance.uuid.randomUUID() & "." & thisAssetExt;

				// create inputs and outputs for compression
				fis = createObject("java", "java.io.FileInputStream").init( expandPath( thisAsset ) );
				fos = createObject("java", "java.io.FileOutputStream").init( arguments.location & "/" & tempFileName );

				//compress
				try{
					//Compress with coldbox jsmin
					compressor = instance.javaLoader.create( "org.coldbox.JSMin" )
						.init( fis, fos, javaCast( "int", thisType ) )
						.jsmin();
				}
				catch(any e){
					fis.close();
					fos.close();
					$throw("Error compression asset: #thisAsset#", e.detail & e.message & e.stackTrace, "JSMin.JavaCompressionException");
				}

				//Close Files
				fis.close();
				fos.close();

				// register compressed file
				arrayAppend( compressedFiles, tempFileName );
			}

			// Concatenate Files into a single compressed one
			sb = createObject("java", "java.lang.StringBuilder").init( '' );

			for(x=1; x lte arrayLen( compressedFiles ); x++){
				sb.append( fileRead( arguments.location & "/" & compressedFiles[ x ] ) );
				fileDelete( arguments.location & "/" & compressedFiles[ x ] );
			}

			// Create concatenated file according to content.
			// Media Query Fix
			var sbString = trim( replace( sb.toString(), " and(", " and (", "all" ) );
			// Class Select Fix
			sbString = trim( REreplace( sb.toString(), "\b\[class", " [class", "all" ) );
			
			// Write it out
			tempFileName = hash( sbString, "MD5" ) & ".cache." & listLast( compressedFiles[ 1 ], "." );

			//write out buffer
			fileWrite( arguments.location & "/" & tempFileName, sbString );
			returnAsset = tempFileName;
		}
		
		return returnAsset;
	}
	
	/**
	* Check if the LESS file has been modified or first time we see it.
	*/
	private function isLessModified(required input){
		var key = hash( arguments.input );
		
		if( structKeyExists( instance.cacheLessMap, key ) AND
			getFileInfo( arguments.input ).lastmodified EQ  instance.cacheLessMap[ key ] ){
			return false;
		}
		
		return true;
	}	
}