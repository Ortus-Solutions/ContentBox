/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
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