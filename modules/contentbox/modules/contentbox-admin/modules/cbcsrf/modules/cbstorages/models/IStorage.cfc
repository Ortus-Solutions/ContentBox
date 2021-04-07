/**
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This is the main storage interface all cbStorages should implement
 */
interface {

	/**
	 * Set a new variable in storage
	 *
	 * @name The name of the data key
	 * @value The value of the data to store
	 *
	 * @return cbstorages.models.IStorage
	 */
	any function set( required name, required value );

	/**
	 * Do a multi-set using a target structure of name-value pairs
	 *
	 * @map A struct of name value pairs to store
	 *
	 * @return cbstorages.models.IStorage
	 */
	any function setMulti( required struct map );

	/**
	 * Get a new variable in storage if it exists, else return default value, else will return null.
	 *
	 * @name The name of the data key
	 * @defaultValue The default value to return if not found in storage
	 */
	any function get( required name, defaultValue );

	/**
	 * Triest to get a value from the storage, if it does not exist, then it will
	 * call the `produce` closure/lambda to produce the required value and store it
	 * in the storage using the passed named key.
	 *
	 * @name The name of the key to get
	 * @produce The closure/lambda to execute that should produce the value
	 */
	any function getOrSet( required name, required any produce );

	/**
	 * Get multiple values from the storage using the keys argument which can be a list or an array
	 *
	 * @keys A list or array of keys to get from the storage
	 */
	struct function getMulti( required keys );

	/**
	 * Delete a variable in the storage
	 *
	 * @name The name of the data key
	 */
	boolean function delete( required name );

	/**
	 * Delete multiple keys from the storage
	 *
	 * @keys A list or array of keys to delete from the storage
	 *
	 * @return A struct of the keys and a boolean value if they where removed or not
	 */
	struct function deleteMulti( required keys );

	/**
	 * Verifies if the named storage key exists
	 *
	 * @name The name of the data key
	 */
	boolean function exists( required name );

	/**
	 * Clear the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	any function clearAll();

	/**
	 * Get the size of the storage
	 */
	numeric function getSize();

	/**
	 * Get the list of keys stored in the storage
	 */
	array function getKeys();

	/**
	 * Verifies if the storage is empty or not
	 */
	boolean function isEmpty();

	/****************************************** STORAGE METHODS ******************************************/

	/**
	 * Get the entire storage scope structure, basically means return all the keys
	 */
	struct function getStorage();

	/**
	 * Remove the storage completely, different from clear, this detaches the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	any function removeStorage();

	/**
	 * Check if storage exists
	 */
	boolean function storageExists();

	/**
	 * Create the storage
	 *
	 *
	 * @return cbstorages.models.IStorage
	 */
	any function createStorage();

}