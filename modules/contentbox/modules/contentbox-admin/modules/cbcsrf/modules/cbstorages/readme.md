[![Build Status](https://travis-ci.org/coldbox-modules/cbstorages.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbstorages)

# Welcome to the cbStorages Module

The `cbstorages` module will provide you with a collection of **smart** :wink: storage services that will enhance the capabilities of the major ColdFusion (CFML) scopes:

- Application
- Cache
- Cgi
- Client
- Cookie
- Request
- Session

## Enhancement Capabilities

- Consistent API for dealing with all persistent scopes
- The `CacheStorage` allows you to leverage distributed caches like Couchbase, Redis, ehCache, etc for distributed session management. It can act as a distributed session scope.
- The `CookieStorage` can do automatic encryption/decryption, httpOnly, security and much more.
- Ability to retrieve and clear all values stored in a scope
- Ability to deal with complex and simple values by leveraging JSON serialization
- Much More

## License

Apache License, Version 2.0.

## Important Links

- Source: https://github.com/coldbox-modules/cbstorages
- Issues: https://github.com/coldbox-modules/cbstorages#issues
- ForgeBox: https://forgebox.io/view/cbstorages
- [Changelog](changelog.md)

## Requirements

- Lucee 5+
- ColdFusion 2016+

## Installation

Use CommandBox to install

`box install cbstorages`

## WireBox Mappings

The module registers the following storage mappings:

- `applicationStorage@cbstorages` - For application based storage
- `CGIStorage@cbstorages` - For cgi based storage (read-only)
- `clientStorage@cbstorages` - For client based storage
- `cookieStorage@cbstorages` - For cookie based storage
- `sessionStorage@cbstorages` - For session based storage
- `cacheStorage@cbstorages` - For CacheBox based storage simulating session/client
- `requestStorage@cbstorages` - For request based storage

You can check out the included [API Docs](https://apidocs.ortussolutions.com/#/coldbox-modules/cbstorages/) to see all the functions you can use for persistence.

## Settings

Some storages require further configuration via your configuration file `config/ColdBox.cfc` under the `moduleSettings` in a `cbStorages` structure:

```js
cbStorages : {
	cacheStorage : {
		cachename   : "template", // The CacheBox registered cache to store data in
		timeout     : 60 // The default timeout of the session bucket, defaults to 60
	},

	// Cookie Storage settings
	cookieStorage : {
		// Matches the secure attribute of cfcookie, ssl only
		secure 				: false,
		// If yes, sets cookie as httponly so that it cannot be accessed using JavaScripts
		httpOnly			: true,
		// Applicable global cookie domain
		domain 				: "",
		// Use encryption of values
		useEncryption 		: false,
		// The unique seeding key to use: keep it secret, keep it safe
		encryptionSeed 		: "CBStorages",
		// The algorithm to use: https://cfdocs.org/encrypt
		encryptionAlgorithm : "CFMX_COMPAT",
		// The encryption encoding to use
		encryptionEncoding 	: "Base64"
	}
}
```

## Storage Methods

All storages must adhere to our interface, but each of them can extend as they see please.  Here is the basic interface for all storages:

```java
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
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

### HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
