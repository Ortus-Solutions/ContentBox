/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* CacheBox Configuration
*/
component{
	
	/**
	* Configure CacheBox for ColdBox Application Operation
	*/
	function configure(){
		
		// The CacheBox configuration structure DSL
		cacheBox = {
			// LogBox config already in coldbox app, not needed
			// logBoxConfig = "coldbox.system.web.config.LogBox", 
			
			// The defaultCache has an implicit name "default" which is a reserved cache name
			// It also has a default provider of cachebox which cannot be changed.
			// All timeouts are in minutes
			defaultCache = {
				objectDefaultTimeout = 120, //two hours default
				objectDefaultLastAccessTimeout = 30, //30 minutes idle time
				useLastAccessTimeouts = true,
				reapFrequency = 2,
				freeMemoryPercentageThreshold = 0,
				evictionPolicy = "LRU",
				evictCount = 5,
				maxObjects = 5000,
				objectStore = "ConcurrentStore", //guaranteed objects
				coldboxEnabled = true
			},
			
			// Register all the custom named caches you like here
			caches = {
				// Named cache for all coldbox event and view template caching
				template = {
					provider = "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
					properties = {
						objectDefaultTimeout = 120,
						objectDefaultLastAccessTimeout = 30,
						useLastAccessTimeouts = true,
						freeMemoryPercentageThreshold = 0,
						reapFrequency = 2,
						evictionPolicy = "LRU",
						evictCount = 5,
						maxObjects = 5000,
						objectStore = "ConcurrentSoftReferenceStore" //memory sensitive
					}
				},
				// ContentBox Sessions
				sessions = 	{
					provider = "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
					properties = {
						objectDefaultTimeout = 60,
						objectDefaultLastAccessTimeout = 0,
						useLastAccessTimeouts = false,
						freeMemoryPercentageThreshold = 0,
						reapFrequency = 2,
						evictionPolicy = "LRU",
						evictCount = 5,
						maxObjects = 1000, // Can support up to 1000 user sessions concurrently.  Modify if needed. 0 = unlimited
						objectStore = "ConcurrentStore"
					}
				}
			}		
		};
	}	

}