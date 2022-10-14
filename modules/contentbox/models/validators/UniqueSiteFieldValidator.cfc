/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Validates if the field has a unique value by site in the database, this only applies to ORM objects
 */
component accessors="true" singleton {

	// Properties
	property name="name";
	property name="ormService";

	/**
	 * Constructor
	 */
	UniqueSiteFieldValidator function init(){
		variables.name       = "UniqueSiteField";
		variables.ORMService = new cborm.models.BaseORMService();
		return this;
	}

	/**
	 * Will check if an incoming value validates
	 *
	 * @validationResult         The result object of the validation
	 * @validationResult_generic cbvalidation.models.result.IValidationResult
	 * @target                   The target object to validate on
	 * @field                    The field on the target object to validate on
	 * @targetValue              The target value to validate
	 * @validationData           The validation data the validator was created with
	 */
	boolean function validate(
		required any validationResult,
		required any target,
		required string field,
		any targetValue,
		any validationData
	){
		// return true if no data to check, type needs a data element to be checked.
		if (
			isNull( arguments.targetValue ) || (
				isSimpleValue( arguments.targetValue ) && !len( arguments.targetValue )
			)
		) {
			return true;
		}

		// process entity setups.
		var entityName    = ORMService.getEntityGivenName( arguments.target );
		var identityField = ORMService.getKey( entityName );
		var identityValue = invoke( arguments.target, "get#identityField#" );

		// create criteria for uniqueness
		var c = ORMService.newCriteria( entityName ).isEq( "site", arguments.target.getSite() ).isEq( field, arguments.targetValue );

		// validate with ID? then add to restrictions
		if ( !isNull( identityValue ) ) {
			c.ne( identityField, identityValue );
		}

		// validate uniqueness
		if ( c.count() GT 0 ) {
			var args = {
				message        : "The '#arguments.field#' value '#arguments.targetValue#' is not unique for the site '#arguments.target.getSite().getName()#' in the database",
				field          : arguments.field,
				validationType : getName(),
				validationData : arguments.validationData,
				rejectedValue  : arguments.targetValue
			};
			validationResult.addError( validationResult.newError( argumentCollection = args ) );
			return false;
		}

		return true;
	}

	/**
	 * Get the name of the validator
	 */
	string function getName(){
		return name;
	}

}
