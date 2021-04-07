<cfscript>
	/**
	 * Provides a random token and stores it in the coldbox cache storages. You can also provide a specific key to store.
	 *
	 * @key A random token is generated for the key provided.
	 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
	 *
	 * @return csrf token
	 */
	string function csrfToken( string key='', boolean forceNew=false ) {
		return getInstance( '@cbcsrf' ).generate( argumentCollection = arguments );
	}

	/**
	 * Validates the given token against the same stored in the session for a specific key.
	 *
	 * @token Token that to be validated against the token stored in the session.
	 * @key The key against which the token be searched.
	 *
	 * @return Valid or Invalid Token
	 */
	boolean function csrfVerify( required string token='', string key='' ) {
		return getInstance( '@cbcsrf' ).verify( argumentCollection = arguments );
	}

	/**
	 * Generate a random token and build a hidden form element so you can submit it with your form
	 *
	 * @key A random token is generated for the key provided.
	 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
	 *
	 * @return HTML of the hidden field (csrf)
	 */
	string function csrf( string key='', boolean forceNew=false ){
		return "<input type='hidden' name='csrf' id='csrf' value='#csrfToken( argumentCollection=arguments )#'>";
	}

	/**
	 * Generate a random token in a hidden form element and javascript that will refresh the page automatically when the token expires
	 * 
	 * @key A random token is generated for the key provided. CFID is the default
	 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
	 *
	 * @return HTML of the hidden field (csrf)
	 */
	string function csrfField( string key='', boolean forceNew=false ){
		if (!event.getPrivateValue('csrfFieldGen', false)){
			savecontent variable="block" {
				writeOutput("
				<script>
					var check = Date.now();
					var timeout = #getModuleSettings( 'cbcsrf' ).rotationTimeout#; // expiration is set in /config/coldbox.cfc moduleSettings.cbcsrf.rotationTimeout
					document.addEventListener('focus',function(){
						if (Date.now() - check >= timeout * 60000 ){ 
							location.reload();
						}
					})
				</script>");
			}
			
			cfhtmlbody( text=block );

			event.setPrivateValue('csrfFieldGen', true);

			return "<input type='hidden' name='csrf' id='csrf' value='#csrfToken( arguments.key, true )#'>";
		}
		
		return "<input type='hidden' name='csrf' id='csrf' value='#csrfToken( argumentCollection=arguments )#'>";
	}

	/**
	 * Clears out all csrf token stored
	 */
	function csrfRotate(){
		getInstance( '@cbcsrf' ).rotate();
		return this;
	}
</cfscript>