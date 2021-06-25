/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Exporter for Data-based content
 */
component
	extends   ="BaseExporter"
	implements="contentbox.models.exporters.ICBExporter"
	accessors =true
{

	/**
	 * The records this exporter will export
	 */
	property name="content" type="any";

	/**
	 * Constructor
	 */
	DataExporter function init(){
		super.init();
		variables.format         = "json";
		variables.name           = "DataExporter";
		variables.allowedFormats = "json,xml";
		return this;
	}

	/**
	 * Gets "total" based on content type
	 */
	numeric function getTotal(){
		var total = 0;
		if ( !isNull( variables.content ) ) {
			if ( isArray( variables.content ) ) {
				total = arrayLen( variables.content );
			}
			if ( isStruct( variables.content ) ) {
				total = structCount( variables.content );
			}
			if ( isSimpleValue( variables.content ) ) {
				total = len( variables.content );
			}
		}
		return total;
	}

	/**
	 * Custom validator for this exporter...any rules can be applied
	 */
	array function validate(){
		var errors = [];
		if ( isNull( getContent() ) || isSimpleValue( getContent() ) ) {
			arrayAppend( errors, "The data exporter does not contain any content!" );
		}
		if ( !listFindNoCase( variables.allowedFormats, getFormat() ) ) {
			arrayAppend(
				errors,
				"The specifed export format (#getFormat()#) is not allowed, and must be one of the following types: #variables.allowedFormats#"
			);
		}
		if ( isNull( getFileName() ) || !len( getFileName() ) ) {
			arrayAppend( errors, "A valid file name for the export must be specified!" );
		}
		return errors;
	}

}
