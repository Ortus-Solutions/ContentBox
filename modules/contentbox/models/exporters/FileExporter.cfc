/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
 * Exporter for file-based content
 */
component implements="contentbox.models.exporters.ICBExporter" accessors=true {
    property name="fileName" type="string";
    property name="displayName" type="string";
    property name="directory" type="string";
    property name="includeFiles" type="string";
    property name="format" type="string";
    property name="type" type="string";
    property name="extension" type="string";
    property name="priority" type="numeric";
    property name="log" inject="logbox:logger:{this}";

    /**
     * Constructor
     */
    public FileExporter function init() {
        setFileName( createUUID() );
        setFormat( "zip" );
        setIncludeFiles( "*" );
        setType( "component" );
        setExtension( "" );
        setPriority( 1 );
        name = "FileExporter";
        allowedFormats = "zip";
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
        if( getIncludeFiles() == "*" ) {
            total = arrayLen( directoryList( getDirectory(), true, "name" ) );
        }
        else {
            total = listLen( getIncludeFiles() );
        }
        return total;
    }

    /**
     * Custom validator for this exporter...any rules can be applied
     */
    public array function validate() {
        var errors = [];
        if( isNull( getDirectory() ) ) {
            arrayAppend( errors, "The files exporter does not have a configured directory!" );
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

    /**
     * Gets list of files (absolute paths) when not "all" options are chosen for export
     */
    public string function getFileList() {
        var files = "";
        var delimiter = type=="folder" ? "," : chr(124);
        for( var i=1; i<=listLen( getIncludeFiles() ); i++ ) {
            var includeFile = listGetAt( getIncludeFiles(), i );
            var fileName =  getDirectory() & "/" & includeFile & getExtension();
            files = listAppend( files, fileName, delimiter );
        }
        return files;
    }
}