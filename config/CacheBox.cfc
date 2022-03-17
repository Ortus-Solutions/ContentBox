/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * CacheBox Configuration
 */
component {

	/**
	 * Configure CacheBox for ColdBox Application Operation
	 */
	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * CacheBox Configuration (https://cachebox.ortusbooks.com)
		 * --------------------------------------------------------------------------
		 */
		cacheBox = {
			/**
			 * --------------------------------------------------------------------------
			 * Default Cache Configuration
			 * --------------------------------------------------------------------------
			 * The defaultCache has an implicit name "default" which is a reserved cache name
			 * It also has a default provider of cachebox which cannot be changed.
			 * All timeouts are in minutes
			 */
			defaultCache : {
				objectDefaultTimeout           : 120, // two hours default
				objectDefaultLastAccessTimeout : 30, // 30 minutes idle time
				useLastAccessTimeouts          : true,
				reapFrequency                  : 5,
				freeMemoryPercentageThreshold  : 0,
				evictionPolicy                 : "LRU",
				evictCount                     : 5,
				maxObjects                     : 5000,
				objectStore                    : "ConcurrentStore", // guaranteed objects
				coldboxEnabled                 : true
			},
			/**
			 * --------------------------------------------------------------------------
			 * Custom Cache Regions
			 * --------------------------------------------------------------------------
			 * You can use this section to register different cache regions and map them
			 * to different cache providers
			 */
			caches : {
				/**
				 * --------------------------------------------------------------------------
				 * ColdBox Template Cache
				 * --------------------------------------------------------------------------
				 * The ColdBox Template cache region is used for event/view caching and
				 * other internal facilities that might require a more elastic cache.
				 */
				template : {
					provider   : "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
					properties : {
						objectDefaultTimeout           : 120,
						objectDefaultLastAccessTimeout : 30,
						useLastAccessTimeouts          : true,
						freeMemoryPercentageThreshold  : 0,
						reapFrequency                  : 5,
						evictionPolicy                 : "LRU",
						evictCount                     : 5,
						maxObjects                     : 5000,
						objectStore                    : "ConcurrentSoftReferenceStore" // memory sensitive
					}
				},
				/**
				 * --------------------------------------------------------------------------
				 * ContentBox Sessions
				 * --------------------------------------------------------------------------
				 * Sessions are managed by CacheBox and not CFML so we can distribute to any
				 * cache provider.
				 */
				sessions : {
					provider   : "coldbox.system.cache.providers.CacheBoxColdBoxProvider",
					properties : {
						objectDefaultTimeout           : 60,
						objectDefaultLastAccessTimeout : 0,
						useLastAccessTimeouts          : false,
						freeMemoryPercentageThreshold  : 0,
						reapFrequency                  : 5,
						evictionPolicy                 : "LRU",
						evictCount                     : 5,
						maxObjects                     : 5000, // Can support up to 5000 user sessions concurrently.  Modify if needed. 0 = unlimited
						objectStore                    : "ConcurrentStore"
					}
				}
			}
		};
	}

}
