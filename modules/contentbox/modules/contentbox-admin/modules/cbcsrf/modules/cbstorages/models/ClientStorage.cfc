/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This storage leverages the client scope and will serialize complex objects into JSON if needed.
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
	ClientStorage function set( required name, required value ){
		if( isSimpleValue( arguments.value ) ){
			client[ arguments.name ] = arguments.value;
		} else {
			client[ arguments.name ] = serializeJSON( arguments.value );
		}

		return this;
	}

	/**
	 * Get a new variable in storage if it exists, else return default value, else will return null.
	 *
	 * @name The name of the data key
	 * @defaultValue The default value to return if not found in storage
	 */
	any function get( required name, defaultValue ){

		// Verify
		if( structKeyExists( client, arguments.name ) ){
			if( !isJson( client[ arguments.name ] ) ){
				return client[ arguments.name ];
			}

			return deserializeJSON( client[ arguments.name ] );
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
		return structDelete( client, arguments.name, true );
	}

	/**
	 * Clear the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	ClientStorage function clearAll(){
		structClear( client );
		return this;
	}

	/****************************************** STORAGE METHODS ******************************************/

	/**
	 * Get the entire storage scope structure
	 */
	struct function getStorage(){
		return client;
	}

	/**
	 * Remove the storage completely, different from clear, this detaches the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	ClientStorage function removeStorage(){
		return clearAll();
	}

	/**
	 * Check if storage exists
	 */
	boolean function storageExists(){
		return isDefined( "client" );
	}

	/**
	 * Create the storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	ClientStorage function createStorage(){
		return this;
	}


}