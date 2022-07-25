component extends="tests.resources.BaseApiTest"{

	property name="siteService" inject="siteService@contentbox";
	property name="categoryService" inject="categoryService@contentbox";

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
		describe( "Site Categories API Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to view a category by id or slug", function(){
				given( "a valid id", function(){
					then( "then I should get the requested category", function(){
						var testCategory = variables.categoryService.findWhere( { "slug" : "coldbox", "site" : getDefaultSite() } );
						var event        = this.get( "/cbapi/v1/sites/default/categories/#testCategory.getCategoryID()#" );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData().slug ).toBe( "coldbox" );
					} );
				} );
				given( "a valid slug", function(){
					then( "then I should get the requested category", function(){
						var event = this.get( "/cbapi/v1/sites/default/categories/coldbox" );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData().slug ).toBe( "coldbox" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.get( "/cbapi/v1/sites/default/categories/bogus" );
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} ); // end story view site by id or slug

			story( "I want to list all site categories", function(){
				given( "no options", function(){
					then( "it can display all site categories", function(){
						var event = this.get( "/cbapi/v1/sites/default/categories" );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
			} ); // end story list all sites

			story( "I want to create a site category", function(){
				given( "valid incoming data", function(){
					then( "then I should see the confirmation", function(){
						withRollback( function(){
							var event = this.post(
								"cbapi/v1/sites/default/categories",
								{ category : "bddtest", slug : "bddtest" }
							);
							expect( event.getResponse() ).toHaveStatus( 200 );
							expect( event.getResponse().getData().categoryID ).notToBeEmpty();
							expect( event.getResponse().getData().slug ).toBe( "bddtest" );
						} );
					} );
				} );
				given( "duplicate category slug", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/categories",
							{ category : "coldbox", slug : "coldbox" }
						);
						expect( event.getResponse() ).toHaveStatus( 400 );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
					} );
				} );
				given( "invalid data", function(){
					then( "it should display an error message", function(){
						var event = this.post( "cbapi/v1/sites/default/categories", { name : "A nice category" } );
						expect( event.getResponse() ).toHaveStatus( 400 );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
					} );
				} );
			} ); // end create story

			story( "I want to edit a category", function(){
				given( "a valid id/slug and valid data", function(){
					then( "then it should update a category", function(){
						withRollback( function(){
							var event = this.put(
								"/cbapi/v1/sites/default/categories/coldbox",
								{ category : "ColdBox Rocks" }
							);
							expect( event.getResponse() ).toHaveStatus( 200 );
							expect( event.getResponse().getData().category ).toInclude( "ColdBox Rocks" );
						} );
					} );
				} );
				given( "a non-unique slug", function(){
					then( "then I should see a validation message", function(){
						var event = this.put( "/cbapi/v1/sites/default/categories/coldbox", { slug : "coldfusion" } );
						expect( event.getResponse() ).toHaveStatus( 400 );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.put( "/cbapi/v1/sites/categories/123" );
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} ); // end edit story

			story( "I want to delete a category", function(){
				given( "a valid id/slug", function(){
					then( "then I should see the confirmation", function(){
						try {
							var testCategory = variables.categoryService.save(
								variables.categoryService.new( {
									category : "bddtest",
									slug     : "bddtest",
									site     : getDefaultSite()
								} )
							);
							var event = this.delete( "/cbapi/v1/sites/default/categories/bddtest" );
							expect( event.getResponse() ).toHaveStatus( 200 );
							expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
						} finally {
							queryExecute( "delete from cb_category where slug = 'bddtest'" );
						}
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.delete( "/cbapi/v1/sites/default/categories/1232222" );
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} ); // end delete story
		} ); // end describe
	}
	// end run

}
