component accessors="true" singleton{
	// Dependencies
	property name="settingService"		inject="id:settingService@bb";
	property name="moduleSettings"		inject="coldbox:setting:modules";
	property name="zipUtil"				inject="zipUtil@bb";
	property name="log"					inject="logbox:logger:{this}";
	
	// Local properties
	property name="layoutsPath";
	property name="layoutsIncludePath";
	property name="layoutsInvocationPath";
	property name="layoutRegistry";
	 
	/**
	* Constructor
	*/
	LayoutService function init(){
		setLayoutRegistry('');
		setLayoutsPath('');
		setLayoutsIncludePath('');
		setLayoutsInvocationPath('');
		return this;
	}
	
	/**
	* onDIComplete
	*/
	void function onDIComplete(){
		// setup location paths
		setLayoutsPath( moduleSettings["blogbox-ui"].path & "/layouts" );
		setLayoutsIncludePath( moduleSettings["blogbox-ui"].mapping & "/layouts" );
		setLayoutsInvocationPath( moduleSettings["blogbox-ui"].invocationPath & ".layouts" );
		// Register all layouts
		buildLayoutRegistry();
	}
	
	/**
	* Get active layout record
	*/
	query function getActiveLayout(){
		var activeLayout = settingService.getSetting("bb_site_layout");
		return new Query(dbtype="query",sql="SELECT * from layoutRegistry WHERE name='#activeLayout#'",layoutRegistry=getLayoutRegistry()).execute().getResult();	
	}
	
	/**
	* Is active layout check
	*/
	boolean function isActiveLayout(required layoutName){
		return ( compareNoCase( getActiveLayout().name, arguments.layoutName ) EQ 0 );
	}
	
	/**
	* Activate the current layout in the settings
	*/
	LayoutService function activateLayout(required layoutName) transactional{
		var layout = settingService.findWhere({name="bb_site_layout"});
		layout.setValue( arguments.layoutName );
		settingService.save( layout );
		settingService.flushSettingsCache();
		return this;
	}
	
	/**
	* Get all registered layouts
	*/ 
	query function getLayouts(){
		if( isSimpleValue( getLayoutRegistry() ) ){
			return buildLayoutRegistry();
		}
		return getLayoutRegistry();		
	}
	
	/**
	* Build layout registry
	*/
	query function buildLayoutRegistry(){
		var rawLayouts 	= directoryList(getLayoutsPath(),false,"query");
		// filter layout folders only
		var rawLayouts 	= new Query(dbtype="query",sql="SELECT directory,name from rawLayouts WHERE type = 'Dir'",rawlayouts=rawlayouts).execute().getResult();
		
		// Add Columns
		QueryAddColumn(rawLayouts,"layoutName",[]);
		QueryAddColumn(rawLayouts,"isValid",[]);
		QueryAddColumn(rawLayouts,"description",[]);
		QueryAddColumn(rawLayouts,"version",[]);
		QueryAddColumn(rawLayouts,"author",[]);
		QueryAddColumn(rawLayouts,"authorURL",[]);
		QueryAddColumn(rawLayouts,"screenShotURL",[]);
		QueryAddColumn(rawLayouts,"forgeBoxSlug",[]);
		QueryAddColumn(rawLayouts,"customInterceptionPoints",[]);
		
		// Register each layout CFC
		for(var x=1; x lte rawLayouts.recordCount; x++){
			var layoutName 	= rawLayouts.name[x];
			
			// Check if valid layout
			if( !fileExists(getLayoutsPath() & "/#layoutName#/#layoutName#.cfc") ){
				log.warn("The layout: #layoutName# is an invalid layout, skipping.");
				rawLayouts.isValid[x] = false;
				continue;
			}
			// construct layout descriptor
			var config 		= createObject("component", getLayoutsInvocationPath() & ".#layoutName#.#layoutName#");
		
			// Add custom descriptions
			rawLayouts.isValid[x] = true;
			rawLayouts.layoutName[x] = config.name;
			rawLayouts.description[x] = config.description;
			rawLayouts.version[x] = config.version;
			rawLayouts.author[x] = config.author;
			rawLayouts.authorURL[x] = config.authorURL;
			
			if( structKeyExists(config, "screenShotURL") ){
				rawLayouts.screenShotURL[x] = getLayoutsIncludePath() & "/#layoutName#/" & config.screenShotURL;
			}
			else{
				rawLayouts.screenShotURL[x] = "";
			}
			if( structKeyExists(config, "forgeBoxSlug") ){
				rawLayouts.forgeBoxSlug[x] = config.forgeBoxSlug;
			}
			else{
				rawLayouts.forgeBoxSlug[x] = "";
			}
			if( structKeyExists(config, "customInterceptionPoints") ){
				rawLayouts.customInterceptionPoints[x] = config.customInterceptionPoints;
			}
			else{
				rawLayouts.customInterceptionPoints[x] = "";
			}
		}
		
		var rawLayouts 	= new Query(dbtype="query",sql="SELECT * from rawLayouts WHERE isValid='true'",rawlayouts=rawlayouts).execute().getResult();
		
		// store it
		setLayoutRegistry( rawLayouts );
		
		return rawLayouts;
	}
	
	/**
	* Remove layout
	*/
	boolean function removeLayout(required layoutName){
		if( !len(arguments.layoutName) ){return false;}
		
		var lPath = getLayoutsPath() & "/" & arguments.layoutName;
		if( directoryExists( lPath ) ){ directoryDelete( lPath,true ); return true; }
		return false;
	}
	
	/**
	* Upload Layout, returns [error:boolean,messages:string]
	*/
	struct function uploadLayout(required fileField){
		var destination = getLayoutsPath();
		var results = {
			error = false, messages = ""
		};
		
		// upload file
		try{
			var fInfo 		= fileUpload(destination,arguments.fileField,"","overwrite");	
			var fFilePath 	= fInfo.serverDirectory & "/" & fInfo.serverFile;
		}
		catch(any e){
			log.error("Error uploading layout package",e);
			results.error = true;
			results.messages = "Error uploading layout package. #e.message# #e.detail#";
			return results;
		}
		
		try{
			// check if zip file
			if( fInfo.serverFileExt eq "zip" ){
				// expand it
				zipUtil.extract(zipFilePath=fFilePath,extractPath=destination,useFolderName=true);
			}
		}
		catch(Any e){
			log.error("Error expanding layout package: #fInfo.toString()#",e);
			results.error = true;
			results.messages = "Error expanding layout package. #e.message# #e.detail#";
		}
		finally{
			// remove zip file
			fileDelete( fFilePath );
		}
		
		return results;
	}
	
}