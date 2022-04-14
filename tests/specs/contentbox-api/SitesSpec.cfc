component extends="tests.resources.BaseApiTest" {

	property name="siteService" inject="siteService@contentbox";

	/*********************************** LIFE CYCLE Methods ***********************************/

	/**
	 * executes before all suites+specs in the run() method
	 */
	function beforeAll(){
		super.beforeAll();
		// Log in admin
		variables.loggedInData = loginUser();
	}

	/**
	 * executes after all suites+specs in the run() method
	 */
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Sites API Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to view a site by id or slug", function(){
				given( "an valid id", function(){
					then( "then I should get the requested site", function(){
						var testSite = getDefaultSite();
						var event    = this.get( "/cbapi/v1/sites/#testSite.getSiteID()#" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						expect( event.getResponse().getData().slug ).toBe( "default" );
					} );
				} );
				given( "an valid slug", function(){
					then( "then I should get the requested site", function(){
						var event = this.get( "/cbapi/v1/sites/default" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						expect( event.getResponse().getData().slug ).toBe( "default" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.get( "/cbapi/v1/sites/123" );
						expect( event.getResponse() ).toHaveStatus( 404, event.getResponse().getMessagesString() );
					} );
				} );
			} ); // end story view site by id or slug

			story( "I want to list all sites", function(){
				given( "no options", function(){
					then( "it can display all sites", function(){
						var event = this.get( "/cbapi/v1/sites" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
						event
							.getResponse()
							.getData()
							.each( function( thisItem ){
								expect( thisItem.isActive ).toBeTrue( thisItem.toString() );
							} );
					} );
				} );
				given( "inactive flag option", function(){
					then( "it can display inactive sites", function(){
						var event = this.get( "/cbapi/v1/sites?isActive=false" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						event
							.getResponse()
							.getData()
							.each( function( thisItem ){
								expect( thisItem.isActive ).toBeFalse();
							} );
					} );
				} );
				given( "a name or description search", function(){
					then( "it can find the site", function(){
						var event = this.get( "/cbapi/v1/sites?search=default" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						event
							.getResponse()
							.getData()
							.each( function( thisItem ){
								expect( thisItem.slug ).toBe( "default" );
							} );
					} );
				} );
			} ); // end story list all sites

			story( "I want to create a site", function(){
				given( "a valid id/slug", function(){
					then( "then I should see the confirmation", function(){
						withRollback( function(){
							var event = this.post(
								"cbapi/v1/sites",
								{
									name          : "bddtest",
									slug          : "bddtest",
									description   : "my bdd test site",
									domain        : "bddtest.com",
									domainRegex   : "bddtest\.com",
									domainAliases : "[]",
									activeTheme   : "default",
									homepage      : "cbBlog"
								}
							);
							expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
							expect( event.getResponse().getData().siteID ).notToBeEmpty();
							expect( event.getResponse().getData().slug ).toBe( "bddtest" );
						} );
					} );
				} );
				given( "duplicate site slug", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites",
							{
								name          : "default",
								slug          : "default",
								description   : "my bdd test site",
								domain        : "bddtest.com",
								domainRegex   : "bddtest\.com",
								domainAliases : "[]",
								activeTheme   : "default",
								homepage      : "cbBlog"
							}
						);
						expect( event.getResponse() ).toHaveStatus( 400, event.getResponse().getMessagesString() );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
					} );
				} );
				given( "invalid data", function(){
					then( "it should display an error message", function(){
						var event = this.post( "cbapi/v1/sites", { description : "A nice site" } );
						expect( event.getResponse() ).toHaveStatus( 400, event.getResponse().getMessagesString() );
						expect( event.getResponse() ).toHaveInvalidData( "name", "is required" );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
						expect( event.getResponse() ).toHaveInvalidData( "domain", "is required" );
					} );
				} );
			} ); // end create story

			story( "I want to edit a site", function(){
				given( "a valid id/slug and valid data", function(){
					then( "then it should update a site", function(){
						withRollback( function(){
							var event = this.put(
								"/cbapi/v1/sites/default",
								{ description : "bdd test baby!", isActive : false }
							);
							expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
							expect( event.getResponse().getData().description ).toInclude( "bdd test baby!" );
							expect( event.getResponse().getData().isActive ).toBeFalse();
						} );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.put( "/cbapi/v1/sites/123" );
						expect( event.getResponse() ).toHaveStatus( 404, event.getResponse().getMessagesString() );
					} );
				} );
			} ); // end edit story

			story( "I want to delete a site", function(){
				given( "a valid id/slug", function(){
					then( "then I should see the confirmation", function(){
						var siteId   = createUUID();
						var testSite = variables.siteService.save(
							variables.siteService.new( {
								name          : "bddtest-#siteId#",
								slug          : "bddtest-#siteId#",
								description   : "my bdd test site",
								domain        : "bddtest.com",
								domainRegex   : "bddtest\.com",
								domainAliases : "[]",
								activeTheme   : "default",
								homepage      : "cbBlog"
							} )
						);
						var event = this.delete( "/cbapi/v1/sites/#testSite.getSiteId()#" );
						expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
						expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.delete( "/cbapi/v1/sites/123" );
						expect( event.getResponse() ).toHaveStatus( 404, event.getResponse().getMessagesString() );
					} );
				} );
			} ); // end delete story
		} ); // end describe
	}
	// end run

}
