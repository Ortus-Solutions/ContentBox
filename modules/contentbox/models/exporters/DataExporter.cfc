/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
 * Exporter for Data-based content
 */
component implements="contentbox.models.exporters.ICBExporter" accessors=true {
    property name="fileName" type="string";
    property name="displayName" type="string";
    property name="content" type="any";
    property name="format" type="string";
    property name="priority" type="numeric";
    property name="log" inject="logbox:logger:{this}";

    /**
     * Constructor
     */
    public DataExporter function init() {
        setFileName( createUUID() );
        setFormat( "json" );
        setPriority( 1 );
        name = "DataExporter";
        allowedFormats = "json,xml";
        return this;
    }
    /**
     * Gets the name of the exporter
     */
    public string function getName() {
        return name;
    }

    /**
     * Gets "total" based on content type
     */ 
    public numeric function getTotal() {
        var total = 0;
        if( !isNull( content ) ) {
            if( isArray( content ) ) {
                total = arrayLen( content );
            }
            if( isStruct( content ) ) {
                total = structCount( content );
            }
            if( isSimpleValue( content ) ) {
                total = len( content );
            }
        }
        return total;
    }

    /**
     * Custom validator for this exporter...any rules can be applied
     */
    public array function validate() {
        var errors = [];
        if( isNull( getContent() ) || isSimpleValue( getContent() ) ) {
            arrayAppend( errors, "The data exporter does not contain any content!" );
        }
        if( !listFindNoCase( allowedFormats, getFormat() ) ) {
            arrayAppend( errors, "The specifed export format (#getFormat()#) is not allowed, and must be one of the following types: #allowedFormats#" );
        }
        if( isNull( getFileName() ) || !len( getFileName() ) ) {
            arrayAppend( errors, "A valid file name for the export must be specified!" );
        }
        return errors;
    }

    /**
     * Determines if exporter is valid based on validation criteria
     */
    public boolean function isValid() {
        return !arrayLen( validate() );
    }
}