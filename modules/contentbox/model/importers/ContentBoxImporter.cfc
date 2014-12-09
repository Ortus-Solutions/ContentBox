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
* Import a .cbox package into contentbox
*/
component accessors=true {
    property name="fileNames" type="array";
    property name="ContentBoxPackagePath" type="any";
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
    property name="layoutService"       inject="id:layoutService@cb";
    property name="widgetService"       inject="id:widgetService@cb";
    property name="templateService"     inject="id:emailtemplateService@cb";
    property name="log"                 inject="logbox:logger:{this}";
    property name="zipUtil"             inject="zipUtil@cb";
    property name="fileUtils"           inject="coldbox:plugin:FileUtils";

    /**
    * Constructor
    */
    ContentBoxImporter function init(){
        setFileNames( [] );
        setContentBoxPackagePath("");
        dataServiceMappings = {};
        fileServiceMappings = {};
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
            var fileList = listToArray( valueList( files.entry ) );
            var contentBoxPath = moduleSettings["contentbox"].path;
            // now set values
            setFileNames( fileList );
            setContentBoxPackagePath( arguments.importFile );
            // set some cheat mappings
            dataServiceMappings = {
                "Authors" = "authorService",
                "Categories" = "categoryService",
                "Content Store" = "contentStoreService",
                "Menus" = "menuService",
                "Permissions" = "permissionService",
                "Roles" = "roleService",
                "Security Rules" = "securityRuleService",
                "Settings" = "settingService",
                "Entries" = "entryService",
                "Pages" = "pageService"
            };
            filePathMappings = {
                "Email Templates" = contentBoxPath & "/email_templates",
                "Layouts" = contentBoxPath & "/layouts",
                "Media Library" = expandPath( settingService.getSetting( "cb_media_directoryRoot" ) ),
                "Modules" = contentBoxPath & "/modules",
                "Widgets" = contentBoxPath & "/widgets"
            };
        }
        catch( any e ) {
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
            descriptorContents = fileUtils.readFile( getTempDirectory() & "descriptor.json" );
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
        var importLog = createObject("java", "java.lang.StringBuilder").init("Starting ContentBox package import with override = #arguments.overrideContent#...<br>");
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