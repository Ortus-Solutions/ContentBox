/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This storage leverages the request scope and create a virtual storage within it
*/
component
	accessors="true"
	serializable="false"
	extends="AbstractStorage"
	threadsafe
	singleton
{
	/**
	 * Constructor
	 */
	function init(){
		variables.lockName 		= hash( now() ) & "_REQUEST_STORAGE";
		variables.lockTimeout 	= 20;

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
	RequestStorage function set( required name, required value ){
		var storage = getStorage();

		storage[ arguments.name ] = arguments.value;

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
		if( structKeyExists( storage, arguments.name ) ){
			return storage[ arguments.name ];
		}

		// default value
		if( !isNull( arguments.defaultValue ) ){
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
		return structDelete( getStorage(), arguments.name, true );
	}

	/**
	 * Clear the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	RequestStorage function clearAll(){
		var storage = getStorage();

		lock name="#variables.lockName#" type="exclusive" timeout="#variables.lockTimeout#" throwOnTimeout=true{
			structClear( storage );
		}

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
        return request.cbStorage;
	}

	/**
	 * Remove the storage completely, different from clear, this detaches the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	RequestStorage function removeStorage(){
		lock name="#variables.lockName#" type="exclusive" timeout="#variables.lockTimeout#" throwOnTimeout=true{
			structDelete( request, "cbStorage" );
		}

		return this;
	}

	/**
	 * Check if storage exists
	 */
	boolean function storageExists(){
		return !isNull( request.cbStorage );
	}

	/**
	 * Create the storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	RequestStorage function createStorage(){

		if( isNull( request.cbStorage ) ){

			lock name="#variables.lockName#" type="exclusive" timeout="#variables.lockTimeout#" throwOnTimeout=true{

				// Double Lock Race Conditions
				if( isNull( request.cbStorage ) ){
					request.cbStorage = {};
				}

			}

		}

		return this;
	}

}
