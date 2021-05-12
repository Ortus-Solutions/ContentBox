component extends="tests.resources.BaseApiTest" {

	property name="siteService" inject="siteService@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="contentStoreService" inject="contentStoreService@cb";

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
		describe( "Content Store API Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to view a content item by id or slug", function(){
				given( "an valid id", function(){
					then( "then I should get the requested content store item", function(){
						var testContent = variables.contentStoreService.findWhere( { slug : "foot" } );
						var event       = this.get(
							"/cbapi/v1/sites/default/contentstore/#testContent.getContentID()#"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData().slug ).toBe( "foot" );
						expect( event.getResponse().getData() ).toHaveKey(
							"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
						);
					} );
				} );
				given( "an valid slug", function(){
					then( "then I should get the requested content store item", function(){
						var event = this.get( "/cbapi/v1/sites/default/contentstore/foot" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData().slug ).toBe( "foot" );
						expect( event.getResponse().getData() ).toHaveKey(
							"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
						);
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.get( "/cbapi/v1/sites/default/contentstore/123kkdabugosu" );
						expect( event.getResponse() ).toHaveStatus(
							404,
							event.getResponse().getMessagesString()
						);
					} );
				} );
			} ); // end story view site by id or slug

			story( "I want to list all content store items", function(){
				given( "no options", function(){
					then( "it can display all items with default filters", function(){
						var event = this.get( "/cbapi/v1/sites/default/contentstore" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
				given( "a parent search", function(){
					then( "it can display content store items from a parent", function(){
						var testContent = variables.contentStoreService.findWhere( { slug : "foot" } );
						var event       = this.get(
							"/cbapi/v1/sites/default/contentstore?parent=#testContent.getContentID()#"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						event
							.getResponse()
							.getData()
							.each( function( thisItem ){
								expect( thisItem.parent.slug ).toBe( "foot" );
							} );
					} );
				} );
				given( "a content search", function(){
					then( "it can find the content store item", function(){
						var event = this.get( "/cbapi/v1/sites/default/contentstore?search=foot" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
				given( "a slug prefix search", function(){
					then( "it can find the content store items", function(){
						var event = this.get(
							"/cbapi/v1/sites/default/contentstore?slugPrefix=foot"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
				given( "a slug search", function(){
					then( "it can find the content store items", function(){
						var event = this.get(
							"/cbapi/v1/sites/default/contentstore?slugSearch=foot"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
			} ); // end story list all sites

			story( "I want to create a content store item", function(){
				xgiven( "a valid data", function(){
					then( "then I should see the confirmation", function(){
						withRollback( function(){
							var event = this.post(
								"cbapi/v1/sites",
								{
									title         : "bddtest",
									slug          : "bddtest",
									description   : "my bdd test site",
									content       : "This is my awesome bdd test content store item",
									publishedDate : now(),
									isPublished   : true,
									changelog     : "My first creation"
								}
							);
							expect( event.getResponse() ).toHaveStatus(
								200,
								event.getResponse().getMessagesString()
							);
							expect( event.getResponse().getData().contentID ).notToBeEmpty();
							expect( event.getResponse().getData().slug ).toBe( "bddtest" );
						} );
					} );
				} );
				given( "duplicate content slug", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/contentStore",
							{
								title   : "foot",
								slug    : "foot",
								content : "Footer is here",
								order   : 10
							}
						);
						expect( event.getResponse() ).toHaveStatus(
							400,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
					} );
				} );
				given( "invalid data", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/contentStore",
							{ description : "A nice site" }
						);
						expect( event.getResponse() ).toHaveStatus(
							400,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse() ).toHaveInvalidData( "title", "is required" );
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
					} );
				} );
			} ); // end create story

			xstory( "I want to edit a content store item", function(){
				given( "a valid id/slug and valid data", function(){
					then( "then it should update a site", function(){
						withRollback( function(){
							var event = this.put(
								"/cbapi/v1/sites/default",
								{ description : "bdd test baby!", isActive : false }
							);
							expect( event.getResponse() ).toHaveStatus( 200 );
							expect( event.getResponse().getData().description ).toInclude(
								"bdd test baby!"
							);
							expect( event.getResponse().getData().isActive ).toBeFalse();
						} );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.put( "/cbapi/v1/sites/123" );
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} ); // end edit story

			xstory( "I want to delete a content store item", function(){
				given( "a valid id/slug", function(){
					then( "then I should see the confirmation", function(){
						var testSite = variables.siteService.save(
							variables.siteService.new( {
								name        : "bddtest",
								slug        : "bddtest",
								description : "my bdd test site",
								domain      : "bddtest.com",
								domainRegex : "bddtest\.com",
								activeTheme : "default",
								homepage    : "cbBlog"
							} )
						);
						var event = this.delete( "/cbapi/v1/sites/#testSite.getSiteId()#" );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.delete( "/cbapi/v1/sites/123" );
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} ); // end delete story
		} ); // end describe
	}
	// end run

}
