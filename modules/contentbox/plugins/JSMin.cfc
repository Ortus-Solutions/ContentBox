<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author 	 :	Luis Majano
Description :

This is a plugin that interfaces with our own flavor of JSMin to minify
css and js files.

Configuration Settings Needed:

jsmin_enable : boolean (true)
	- flag to enable disable the packaging process
jsmin_cacheLocation : string
	- the relative file location where cached minified js/css files will be stored,
	  this location will be expanded

Usage:

* minify(assets:string) : html script or link

The main method of operation is minify().  You pass to it a list of assets to compress,
but they have to be of the same type: js or css.  Do not alternate or weird results will
happen.  This method returns a script or link include that you would output on your layouts:

<head>
#getMyPlugin("JSMin").minify('includes/js/myscripts.js','includes/js/jquery.js')#
#getMyPlugin("JSMin").minify('includes/css/site.css','includes/css/boxes.css')#
</head>

As you can see from the example above, you can easily render the minified version of all
the assets.  This plugin will minify each asset and if more than 1 is declared, then it
will build a concatenated version of the js or css assets and cache them.

* minifyToHead(assets:string) : void

This method basically sends the html links and script tags to the head section using
cfhtmlhead.  You can use this method when calling JSMin via handlers or plugins or any other
location than layouts.

----------------------------------------------------------------------->
<cfcomponent hint="This is a plugin that interfaces with our own flavor of JSMin to minify css and js files."
			 extends="coldbox.system.Plugin"
			 output="false"
			 singleton="true">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="JSMin" output="false" hint="Constructor.">
		<!--- ************************************************************* --->
		<cfargument name="controller" type="any" required="true" hint="coldbox.system.web.Controller">
		<!--- ************************************************************* --->
		<cfscript>
			super.init( arguments.controller );

			// Plugin Properties
			setpluginName( "JSMin" );
			setpluginVersion( "3.0" );
			setpluginDescription( "A plugin that minifies js/css files with style!" );
			setpluginAuthor( "Ortus Solutions, Corp" );
			setpluginAuthorURL( "http://www.ortussolutions.com" );

			// local properties
			instance.cacheMap = {};
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
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- compressToHead --->
	<cffunction name="minifyToHead" output="false" access="public" returntype="void" hint="Prepare source(s) statements using our fabulous jsmin compressor and send them to the head section">
		<cfargument name="assets"  type="string" required="true" hint="A list of js or css files to compress and add to the page. They will be concatenated in order"/>
		<cfargument name="location" type="string" required="false" default="" hint="The location to store the cached assets, else it defaults to the plugin's settings">
		<cfset var links = minify( arguments.assets, arguments.location )>
		<cfhtmlhead text="#links#">
	</cffunction>

	<!--- compress --->
	<cffunction name="minify" output="false" access="public" returntype="string" hint="Prepare source(s) statements using our fabulous jsmin compressor">
		<cfargument name="assets"  	type="string" required="true" hint="A list of js or css files to compress and add to the page. They will be concatenated in order"/>
		<cfargument name="location" type="string" required="false" default="" hint="The location to store the cached assets, else it defaults to the plugin's settings">
		<cfscript>
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
		</cfscript>
	</cffunction>

	<!--- renderLinks --->
	<cffunction name="renderLinks" output="false" access="public" returntype="string" hint="Renders links according to passed in assets">
		<cfargument name="assets"  type="string" required="false" default="" hint="A list of js/css files to compress and add to the page"/>
		<cfscript>
			var sb = createObject("java","java.lang.StringBuilder").init('');
			var x = 1;
			var thisAsset = "";
			var event = controller.getRequestService().getContext();

			// request assets storage
			event.paramValue(name="jsmin_assets",value="",private=true);

			for(x=1; x lte listLen(arguments.assets); x=x+1){
				thisAsset = listGetAt(arguments.assets,x);
				// Is asset already loaded
				if( NOT listFindNoCase(event.getValue(name="jsmin_assets",private=true),thisAsset) ){

					// Load Asset
					if( listLast(thisAsset,".") eq "js" ){
						sb.append('<script src="#thisAsset#" type="text/javascript"></script>');
					}
					else{
						sb.append('<link href="#thisAsset#" type="text/css" rel="stylesheet" />');
					}

					// Store It as Loaded
					event.setValue(name="jsmin_assets",value=listAppend(event.getValue(name="jsmin_assets",private=true),thisAsset),private=true);
				}
			}

			return sb.toString();
		</cfscript>
	</cffunction>

	<!--- cleanCache --->
	<cffunction name="cleanCache" output="false" access="public" returntype="void" hint="Clean the cache location">
		<cfargument name="location" type="string" required="false" default="" hint="The location to store the cached assets, else it defaults to the plugin's settings">
		<cfset var qList = "">
		<cfset var cleanLocation = instance.cacheDiskLocation>

		<!--- Location override --->
		<cfif len( arguments.location )>
			<cfset cleanLocation = expandPath( arguments.location )>		
		</cfif>
		
		<!--- Abort if no locations --->
		<cfif !len( cleanLocation )>
			<cfreturn>
		</cfif>	

		<cfdirectory action="list" directory="#cleanLocation#" name="qList">

		<cfloop query="qList">
			<cfif qList.type neq "Dir" and findNoCase( ".cache.", qList.name )>
				<cfset fileDelete( qList.directory & "/" & qList.name )>
			</cfif>
		</cfloop>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------>

	<!--- jsmin --->
	<cffunction name="jsmin" output="false" access="private" returntype="string" hint="JSMin a set of files and return the compressed version cache string file">
		<cfargument name="cacheKey" type="string" required="true" hint="The cache key in use"/>
		<cfargument name="assets"   type="string" required="true" hint="A list of js or css files to compress and add to the page. They will be concatenated in order"/>
		<cfargument name="location" type="string" required="true" hint="The location on disk to store the assets">
		
		<cfset var x=1>
		<cfset var thisAsset = "">
		<cfset var thisType = "1">
		<cfset var tempFileName = "">
		<cfset var fis = "">
		<cfset var fos = "">
		<cfset var compressor = "">
		<cfset var compressedFiles = []>
		<cfset var sb = "">
		<cfset var returnAsset = "">

		<cflock name="jsmin.#arguments.cacheKey#" type="exclusive" timeout="20" throwOntimeout="true">
		<cfscript>
			//Compress and cache files
			for(x=1; x lte listLen( arguments.assets ); x++){
				thisAsset = trim( listGetAt( arguments.assets, x ) );

				// File Type: 1=js, 2=css
				thisType = 1;
				if( listLast( thisAsset, "." ) eq "css" ){
					thisType = 2;
				}

				//register temp file
				tempFileName = instance.uuid.randomUUID() & "." & listLast( thisAsset, "." );

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
		</cfscript>
		</cflock>

		<cfreturn returnAsset>
	</cffunction>
</cfcomponent>