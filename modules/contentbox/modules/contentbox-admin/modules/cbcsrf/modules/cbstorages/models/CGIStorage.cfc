/**
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This storage leverages the cgi scope
 */
component
	accessors   ="true"
	serializable="false"
	extends     ="AbstractStorage"
	threadsafe
	singleton
{

	/**
	 * Constructor
	 */
	function init(){
		variables.lockName    = hash( now() ) & "_CGI_STORAGE";
		variables.lockTimeout = 20;

		createStorage();

		return this;
	}

	/**
	 * Set a new variable in storage
	 *
	 * @name The name of the data key
	 * @value The value of the data to store
	 *
	 * @return cbstorages.models.IStorage
	 */
	CGIStorage function set( required name, required value ){
		// Ignored, not setting cgi vars

		return this;
	}

	/**
	 * Get a new variable in storage if it exists, else return default value, else will return null.
	 *
	 * @name The name of the data key
	 * @defaultValue The default value to return if not found in storage
	 */
	any function get( required name, defaultValue ){
		var storage = getStorage();

		// check if exists
		if ( structKeyExists( storage, arguments.name ) ) {
			return storage[ arguments.name ];
		}

		// default value
		if ( !isNull( arguments.defaultValue ) ) {
			return arguments.defaultValue;
		}

		// if we get here, we return null
	}

	/**
	 * Delete a variable in the storage
	 *
	 * @name The name of the data key
	 */
	boolean function delete( required name ){
		// Can't delete cgi vars
		return true;
	}

	/**
	 * Clear the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	CGIStorage function clearAll(){
		// Can't do this

		return this;
	}

	/****************************************** STORAGE METHODS ******************************************/

	/**
	 * Get the entire storage scope structure
	 */
	struct function getStorage(){
		// Verify Storage Exists
		createStorage();

		// Return Storage now that it is guaranteed to exist
		return cgi;
	}

	/**
	 * Remove the storage completely, different from clear, this detaches the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	CGIStorage function removeStorage(){
		// Can't do this

		return this;
	}

	/**
	 * Check if storage exists
	 */
	boolean function storageExists(){
		return !isNull( cgi );
	}

	/**
	 * Create the storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	CGIStorage function createStorage(){
		// Nothing to create it's part of the engine

		return this;
	}

}
