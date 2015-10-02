/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Import a .cbox package into ContentBOx
*/
component accessors=true {

	/**
	* The import file names found
	*/
    property name="fileNames" 				type="array";
    /**
    * The location of the import file (zip|box)
    */
    property name="ContentBoxPackagePath" 	type="any";
    /**
    * The location of the data services used for exporting
    */
    property name="dataServiceMappings" 	type="struct";
    /**
    * The location of the file mappings used for exporting
    */
    property name="filePathMappings"		type="struct";

    // DI
    property name="moduleSettings"      inject="coldbox:setting:modules";
    property name="entryService"        inject="id:entryService@cb";
    property name="pageService"         inject="id:pageService@cb";
    property name="categoryService"     inject="id:categoryService@cb";
    property name="contentStoreService" inject="id:contentStoreService@cb";
    property name="menuService"         inject="id:menuService@cb";
    property name="securityRuleService" inject="id:securityRuleService@cb";
    property name="authorService"       inject="id:authorService@cb";
    property name="roleService"         inject="id:roleService@cb";
    property name="permissionService"   inject="id:permissionService@cb";
    property name="settingService"      inject="id:settingService@cb";
    property name="securityService"     inject="id:securityService@cb";
    property name="moduleService"       inject="id:moduleService@cb";
    property name="themeService"       inject="id:themeService@cb";
    property name="widgetService"       inject="id:widgetService@cb";
    property name="templateService"     inject="id:emailtemplateService@cb";
    property name="log"                 inject="logbox:logger:{this}";
    property name="zipUtil"             inject="zipUtil@cb";

    /**
    * Constructor
    */
    ContentBoxImporter function init(){
    	fileNames 				= [];
    	contentBoxPackagePath 	= "";
        dataServiceMappings 	= {};
        fileServiceMappings 	= {};
        return this;
    }

    /**
     * Setup method to configure service
     * @importFile.hint The uploaded .cbox package
     */
    public void function setup( required any importFile ) {
        try {
            var files = zipUtil.list( zipFilePath=arguments.importFile );
            // convert files query to array
            var fileList 		= listToArray( valueList( files.entry ) );
            var contentBoxPath 	= moduleSettings[ "contentbox" ].path;
            // now set values
            setFileNames( fileList );
            setContentBoxPackagePath( arguments.importFile );
            // set some cheat mappings
            dataServiceMappings = {
                "Authors" 			= "authorService",
                "Categories" 		= "categoryService",
                "Content Store" 	= "contentStoreService",
                "Menus" 			= "menuService",
                "Permissions" 		= "permissionService",
                "Roles" 			= "roleService",
                "Security Rules" 	= "securityRuleService",
                "Settings" 			= "settingService",
                "Entries" 			= "entryService",
                "Pages" 			= "pageService"
            };
            filePathMappings = {
                "Email Templates" 	= contentBoxPath & "/email_templates",
                "Themes" 			= contentBoxPath & "/themes",
                "Media Library" 	= expandPath( settingService.getSetting( "cb_media_directoryRoot" ) ),
                "Modules" 			= contentBoxPath & "/modules_user",
                "Widgets" 			= contentBoxPath & "/widgets"
            };
        } catch( any e ) {
            log.error( "Error processing ContentBox import package: #e.message# #e.detail#", e );
        }
    }

    /**
     * Retrieves contents of descriptor file
     */
    public any function getDescriptorContents( required boolean asObject=false ) {
        var descriptorContents = "";
        if( hasFile( "descriptor.json" ) ) {
            // if we have a descriptor, extract it
            zipUtil.extract( 
                zipFilePath=getContentBoxPackagePath(), 
                extractPath=getTempDirectory(), 
                extractFiles="descriptor.json", 
                overwriteFiles=true 
            );
            descriptorContents = fileRead( getTempDirectory() & "descriptor.json" );
        }
        return !arguments.asObject ? descriptorContents : deserializeJSON( descriptorContents );
    }

    /**
     * Method which analyzes the uploaded package and determines whether or not the descriptor file documents what is being uploaded
     * @importFile.hint The uploaded .cbox package
     */
    public boolean function isValid() {
        var isVerified = false;
        var rawDescriptorContent = getDescriptorContents();
        // if this is JSON data (as it is expected to be...), deserialize and start verifying package contents
        if( isJSON( rawDescriptorContent ) ) {
            var descriptorContent = deserializeJSON( rawDescriptorContent );
            // now the verification: loop over content def and make sure that entries exist in the .cbox package
            for( var contentSection in descriptorContent.content ) {
                // each match must be found, otherwise we invalidate the package
                isVerified = hasFile( descriptorContent.content[ contentSection ].filename );
            }
        }
        else {
            log.error( "ContentBox package import not valid: #rawDescriptorContent#" );
        }
        return isVerified;
    }

    /**
     * Main method for processing import
     * @overrideContent.hint Whether or not to override existing content with uploaded data (default=false)
     */
    public string function execute( required boolean overrideContent=false ) {
        var importLog = createObject( "java", "java.lang.StringBuilder" ).init( "Starting ContentBox package import with override = #arguments.overrideContent#...<br>" );
        // first, unzip entire package
        zipUtil.extract( 
            zipFilePath=getContentBoxPackagePath(), 
            extractPath=getTempDirectory(),
            overwriteFiles=true 
        );
        // get all content
        var descriptorContents = getDescriptorContents( true );
        // prioritize keys
        var priorityOrder = structSort( descriptorContents.content, "numeric", "asc", "priority" );
        // loop over content areas
        for( key in priorityOrder ) {
            var content = descriptorContents.content[ key ];
            var filePath = getTempDirectory() & content.filename;
            // handle json (data) imports
            if( content.format == "json" ) {
                var service = dataServiceMappings[ content.name ];
                var importResults = variables[ service ].importFromFile( importFile=filePath, override=arguments.overrideContent );
                importLog.append( importResults );
            }
            // handle zip (file) imports
            if( content.format == "zip" ) {
                importLog.append( "<br>Extracting #content.name#...<br>" );
                var path = filePathMappings[ content.name ];
                zipUtil.extract( 
                    zipFilePath=filePath, 
                    extractPath=path,
                    overwriteFiles=true 
                );
                importLog.append( "Finished extracting #content.name#...<br>" );
            }
        }
        var flattendImportLog = importLog.toString();
        log.info( flattendImportLog );
        return flattendImportLog;
    }

    /**
     * Determines if passed file name exists in zip collection
     * @fileName.hint The file name to validate
     */
    private boolean function hasFile( required string fileName ) {
        // try to find
        return arrayContains( getFileNames(), arguments.fileName );
    }
}