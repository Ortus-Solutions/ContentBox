component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * CBSwagger Configuration
		 * --------------------------------------------------------------------------
		 * https://forgebox.io/view/cbswagger
		 */
		return {
			// The route prefix to search.  Routes beginning with this prefix will be determined to be api routes
			"routes"        : [ "cbapi" ],
			// Routes to exclude from the generated spec
			"excludeRoutes" : [ "cbapi/v1/:anything/" ],
			// The default output format, either json or yml
			"defaultFormat" : "json",
			// A convention route, relative to your app root, where request/response samples are stored ( e.g. resources/apidocs/responses/[module].[handler].[action].[HTTP Status Code].json )
			"samplesPath"   : "resources/apidocs",
			// Information about your API
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#infoObject
			"info"          : {
				// REQUIRED A title for your API
				"title"          : "ContentBox CMS API",
				// A short description of the application. CommonMark syntax MAY be used for rich text representation.
				"description"    : "The ContentBox Headless CMS API",
				// A URL to the Terms of Service for the API. MUST be in the format of a URL.
				"termsOfService" : "",
				// Contact information for the exposed API.
				"contact"        : {
					// The identifying name of the contact person/organization.
					"name"  : "Ortus Solutions",
					// The URL pointing to the contact information. MUST be in the format of a URL.
					"url"   : "https://www.ortussolutions.com",
					// The email address of the contact person/organization. MUST be in the format of an email address.
					"email" : "info@ortussolutions.com"
				},
				// License information for the exposed API.
				"license" : {
					// The license name used for the API.
					"name" : "Apache2",
					// A URL to the license used for the API. MUST be in the format of a URL.
					"url"  : "https://www.apache.org/licenses/LICENSE-2.0.html"
				},
				// REQUIRED. The version of the OpenAPI document (which is distinct from the OpenAPI Specification version or the API implementation version).
				"version" : "@version.number@"
			},
			// An array of Server Objects, which provide connectivity information to a target server. If the servers property is not provided, or is an empty array, the default value would be a Server Object with a url value of /.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverObject
			"servers" : [
				{
					"url"         : "http://127.0.0.1:8589",
					"description" : "Development Server"
				}
			],
			// An element to hold various schemas for the specification.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
			"components" : {
				// Define your security schemes here
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securitySchemeObject
				"securitySchemes" : {
					"ApiKeyAuth" : {
						"type"        : "apiKey",
						"description" : "User your JWT as an Api Key for security",
						"name"        : "x-auth-token",
						"in"          : "header"
					},
					"ApiKeyQueryAuth" : {
						"type"        : "apiKey",
						"description" : "User your JWT as an Api Key for security",
						"name"        : "x-auth-token",
						"in"          : "query"
					},
					"BearerAuth" : {
						"type"         : "http",
						"description"  : "User your JWT in the bearer Authorization header",
						"scheme"       : "bearer",
						"bearerFormat" : "JWT"
					}
				}
			},
			// A declaration of which security mechanisms can be used across the API.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securityRequirementObject
			"security" : [
				{ "ApiKeyAuth" : [] },
				{ "ApiKeyQueryAuth" : [] },
				{ "BearerAuth" : [] }
			],
			// A list of tags used by the specification with additional metadata.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#tagObject
			"tags" : [
				{ "name" : "Authors", "description" : "Author operations" },
				{
					"name"        : "Authentication",
					"description" : "Authentication operations"
				},
				{
					"name"        : "Categories",
					"description" : "Category operations"
				},
				{
					"name"        : "Comments",
					"description" : "Comment operations"
				},
				{
					"name"        : "ContentStore",
					"description" : "Content store operations"
				},
				{
					"name"        : "Entries",
					"description" : "Blog entry operations"
				},
				{ "name" : "Menus", "description" : "Menu operations" },
				{ "name" : "Pages", "description" : "Pages operations" },
				{ "name" : "Sites", "description" : "Site operations" },
				{
					"name"        : "Settings",
					"description" : "Global setting operations"
				},
				{
					"name"        : "Versions",
					"description" : "Content versions operations"
				}
			],
			// Additional external documentation.
			// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#externalDocumentationObject
			"externalDocs" : {
				"description" : "Find more info here",
				"url"         : "https://contentbox.ortusbooks.com"
			}
		};
	}

}
