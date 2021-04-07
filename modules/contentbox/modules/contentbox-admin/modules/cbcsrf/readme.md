[![Build Status](https://travis-ci.org/coldbox-modules/cbcsrf.svg?branch=master)](https://travis-ci.org/coldbox-modules/cbcsrf)

# ColdBox Anti Cross Site Request Forgery Module (cbcsrf)

A module that protects you against [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) attacks by generating unique FORM/client tokens and providing your ColdBox application with new functions for verifying these tokens.  

Even though every CFML engine offers these functions natively, we have expanded them and have made them more flexible and more secure than the native CFML functions.

## Features

* Ability to generate security tokens based on your session
* Automatic token rotation when leveraging `cbauth` login and logout operations
* Ability to on-demand rotate all security tokens for specific users
* Leverages `cbStorages` to store your tokens in CacheBox, which can be easily distributed and clustered
* Ability to create multiple tokens via unique reference `keys`
* Auto-verification interceptor that will verify all non-GET operations to ensure a security token is passed via `rc` or headers
* Auto-sensing of integration testing so the verifier can allow testing calls
* Token automatic rotation on specific time periods for enhance security
* Helpers to automatically generate hidden fields for the token
* Automatic generation endpoint that can be used for Ajax applications to request tokens for users

## License

Apache License, Version 2.0.

## Links

- https://www.coldbox.org/forgebox/view/csrf
- https://github.com/coldbox-modules/cbcsrf
- https://en.wikipedia.org/wiki/Cross-site_request_forgery
- https://github.com/coldbox-modules/cbstorages#settings

## Requirements

- Lucee 5+
- ColdFusion 2016+

## Installation

Use CommandBox to install

`box install cbcsrf`

You can then continue to configure the module in your `config/Coldbox.cfc`.

## Settings

Below are the settings you can use for this module. Remember you must create the `cbcsrf` struct in your `ColdBox.cfc` under the `moduleSettings` structure:

```js
moduleSettings = {
	cbcsrf : {
		// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
		enableAutoVerifier : false,
		// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
		verifyExcludes : [
		],
		// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
		// If you do not want expiring tokens, then set this value to 0
		rotationTimeout : 30,
		// Enable the /cbcsrf/generate endpoint to generate cbcsrf tokens for secured users.
		enableEndpoint : false
	}
};
```

This module also relies on the cbstorages module which also requires a structure in moduleSettings.  Find the updated documentation here: https://github.com/coldbox-modules/cbstorages#settings

## Mixins

This module will add the following UDFs into any framework files: 

- `csrfToken()` : To generate a token, using the `default` or a custom key
- `csrfVerify()` : Verify a valid token or not
- `csrf()` : To generate a hidden field (`csrf`) with the token
- `csrfField()` : To generate a hidden field (`csrf`) with the token, force new token generation and include javascript that will reload the page if the token expires
- `csrfRotate()` : To wipe and rotate the tokens for the user

Here are the method signatures:

```js
/**
 * Provides a random token and stores it in the coldbox cache storages. You can also provide a specific key to store.
 *
 * @key A random token is generated for the key provided.
 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
 *
 * @return csrf token
 */
string function csrfToken( string key='', boolean forceNew=false )
/**
 * Validates the given token against the same stored in the session for a specific key.
 *
 * @token Token that to be validated against the token stored in the session.
 * @key The key against which the token be searched.
 *
 * @return Valid or Invalid Token
 */
boolean function csrfVerify( required string token='', string key='' )
/**
 * Generate a random token and build a hidden form element so you can submit it with your form
 *
 * @key A random token is generated for the key provided.
 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
 *
 * @return HTML of the hidden field (csrf)
 */
string function csrf( string key='', boolean forceNew=false )
/**
 * Generate a random token in a hidden form element and javascript that will refresh the page automatically when the token expires
 * @key A random token is generated for the key provided. CFID is the default
 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
 *
 * @return HTML of the hidden field (csrf)
 */
string function csrfField( string key='', boolean forceNew=false )
/**
 * Clears out all csrf token stored
 */
function csrfRotate()
```

## Mappings

The module also registers the following mapping in WireBox: `@cbcsrf` so you can call our service model directly.

## Automatic Token Expiration

By default, the module is configured to rotate all user csrf tokens **every 30 minutes**.  This means that every token that gets created has a maximum life-span of `{rotationTimeout}` minutes.  If you do NOT want the tokens to EVER expire during the user's logged in session, then use the value of `0` zero.

> It is recommended to rotate your keys often, in case your token get's compromised.

## Token Rotation

We have provided several methods to rotate or clear out all of a user's tokens.  If you are using `cbAuth` as your module of choice for authentication, then we will listen to logins and logouts and rotate the keys for you.

If you are NOT using `cbAuth` then we recommend you leverage the `csrfRotate()` mixin or the `cbsrf.rotate()` method on the `@cbsrf` model.

```js
function doLogin(){

	if( valid login ){
		// login user
		csrfRotate();
	}
}

function logout(){
	csrfRotate();
}
```

## Simple Example

Below is a simple example of manually verifying tokens:

```js
component {

    any function signUp( event, rc, prc ){
        // Store this in a hidden field in the form
        prc.token = csrfGenerate();
    }

    any function signUpProcess( event, rc, prc ){
        // Verify CSFR token from form
        if( csrfVerify( rc.token ) {
            // save form
        } else {
            // Something isn't right
            relocate( 'handler.signup' );
        }
    }
}
```

## Automatic Token Verifier

We have included an interceptor that if loaded will verify all incoming requests to make sure the token has been passed or it will throw an exception.

The settings for this feature are:

```js
	enableAutoVerifier : true,
	// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
	verifyExcludes : [
	]
```

You can also register an array of regular expressions that will be tested against the incoming event and if matched, it will allow the request through with no verification.

The verification process is as follows:

* If we are doing an integration test, then skip verification
* If the incoming HTTP Method is a `get,options or head` skip verification
* If the incoming event matches any of the `verifyExcludes` setting, then skip verification
* If the action is marked with a `skipCsrf` annotation, then skip verification
* If no `rc.csrf` exists and no `x-csrf-token` header exists, throw a 
`TokenNotFoundException` exception
* If the token is invalid then throw a `TokenMismatchException` exception

Please note that this verifier will check the following locations for the token:

1. The request collection (`rc`) via the `cbcsrf` key
2. The request HTTP header (`x-csrf-token`) key

### Warning

Please note that you can bypass the CSRF token verifier if you can call your events via the `GET` operation and passing the `rc` variables via the query string.  In order to avoid this, you will have to make sure your events are NOT allowed `GET` operations.  You can do this in two ways:

1. Add the protection via `this.allowedMethods` handler action security: https://coldbox.ortusbooks.com/the-basics/event-handlers/http-method-security
2. Register only the appropriate method on the ColdBox router: https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/routing-methods

### `skipCsrf` Annotation

You can also annotate your event handler actions with a `skipCsrf` annotation and the verifier will also skip the verification process for those actions.

```js
component{

	function doTestSave( event, rc, prc ) skipCsrf{


	}

}
```

## `/cbcsrf/generate` Endpoint

This module also allows you to turn on the generation HTTP endpoint via the `enableEndpoint` boolean setting.  When turned on the module will register the following route: `GET /cbcsrf/generate/:key?`.  You can use this endpoint to generate tokens for your users via AJAX or UI only applications.  Please note that you can pass an optional `/:key` URL parameter that will generate the token for that specific key.

This endpoint should be secured, so we have annotated it with a `secured` annotation so if you are using `cbSecurity` or `cbGuard` this endpoint will only be available to logged in users.  

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
