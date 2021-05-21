component extends="tests.resources.BaseApiTest" {

	property name="siteService" inject="siteService@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="entryService" inject="entryService@cb";

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
		describe( "Entries API Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				getCache( "template" ).clearAll();
			} );

			story( "I want to view an entry item by id or slug", function(){
				given( "an valid id", function(){
					then( "then I should get the requested entry", function(){
						var testContent = variables.entryService.findWhere( { slug : "disk-queues-77caf" } );
						var event       = this.get(
							"/cbapi/v1/sites/default/entries/#testContent.getContentID()#"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData().slug ).toBe( "disk-queues-77caf" );
						expect( event.getResponse().getData() ).toHaveKey(
							"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
						);
					} );
				} );
				given( "a valid slug", function(){
					then( "then I should get the requested entry", function(){
						var event = this.get( "/cbapi/v1/sites/default/entries/disk-queues-77caf" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData().slug ).toBe( "disk-queues-77caf" );
						expect( event.getResponse().getData() ).toHaveKey(
							"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
						);
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.get( "/cbapi/v1/sites/default/entries/123kkdabugosu" );
						expect( event.getResponse() ).toHaveStatus(
							404,
							event.getResponse().getMessagesString()
						);
					} );
				} );
			} ); // end story view site by id or slug

			story( "I want to list all entries", function(){
				given( "no options", function(){
					then( "it can display all items with default filters", function(){
						var event = this.get( "/cbapi/v1/sites/default/entries" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
				given( "a content search", function(){
					then( "it can find the entries", function(){
						var event = this.get( "/cbapi/v1/sites/default/entries?search=disk-queues" );
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
				given( "a slug search", function(){
					then( "it can find the entries", function(){
						var event = this.get(
							"/cbapi/v1/sites/default/entries?slugSearch=disk-queues-77caf"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
					} );
				} );
			} ); // end story list all sites

			story( "I want to create an entry", function(){
				given( "valid data", function(){
					then( "then it should create a new content object", function(){
						withRollback( function(){
							var event = this.post(
								"cbapi/v1/sites/default/entries",
								{
									title         : "bddtest",
									slug          : "bddtest",
									excerpt       : "bdd rules!",
									content       : "This is my awesome bdd test entry",
									publishedDate : dateTimeFormat(
										now(),
										"yyyy-mm-dd'T'HH:mm:ssZ",
										"UTC"
									),
									changelog    : "My first creation from the bdd test",
									categories   : "coldbox,news",
									customFields : [
										{ key : "test", value : "true" },
										{ key : "data", value : "#now()#" }
									]
								}
							);
							expect( event.getResponse() ).toHaveStatus(
								200,
								event.getResponse().getMessagesString()
							);
							debug( event.getResponse().getData() );
							expect( event.getResponse().getData().contentID ).notToBeEmpty();
							expect( event.getResponse().getData().slug ).toBe( "bddtest" );
							expect( event.getResponse().getData().excerpt ).toInclude( "bdd" );
							expect( event.getResponse().getData().categories )
								.toBeArray()
								.notToBeEmpty();
							expect( event.getResponse().getData().customFields )
								.toBeStruct()
								.notToBeEmpty();
						} );
					} );
				} );
				given( "duplicate content slug", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/entries",
							{
								title   : "disk-queues-77caf",
								slug    : "disk-queues-77caf",
								content : "disk-queues-77caf are here",
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
				given( "no content on a new content object", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/entries",
							{ slug : "A nice site" }
						);
						expect( event.getResponse() ).toHaveStatus(
							400,
							event.getResponse().getMessagesString()
						);
						debug( event.getResponse().getMemento() );

						expect( event.getResponse().getMessages() ).toInclude(
							"content is required"
						);
					} );
				} );
				given( "invalid data but good content", function(){
					then( "it should display an error message", function(){
						var event = this.post(
							"cbapi/v1/sites/default/entries",
							{ content : "Hello from bdd test land!" }
						);
						expect( event.getResponse() ).toHaveStatus(
							400,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
						expect( event.getResponse() ).toHaveInvalidData( "title", "is required" );
					} );
				} );
			} ); // end create story

			story( "I want to edit an entry", function(){
				given( "a valid id/slug and valid data", function(){
					then( "then it should update a content item", function(){
						withRollback( function(){
							var event = this.put(
								"/cbapi/v1/sites/default/entries/disk-queues-77caf",
								{
									content   : "I am a new piece of content for the disk-queues-77caf!",
									changelog : "Update from a bdd test!"
								}
							);
							expect( event.getResponse() ).toHaveStatus(
								200,
								event.getResponse().getMessagesString()
							);
							expect( event.getResponse().getData().renderedContent ).toInclude(
								"I am a new piece of content for the disk-queues-77caf!"
							);
							expect( event.getResponse().getData().activeContent.changelog ).toInclude(
								"bdd test"
							);
						} );
					} );
				} );
				given( "duplicate content slug", function(){
					then( "it should display an error message", function(){
						var event = this.put(
							"cbapi/v1/sites/default/entries/disk-queues-77caf",
							{
								title   : "this-is-just-awesome",
								slug    : "this-is-just-awesome",
								content : "disk-queues-77caf are here"
							}
						);
						expect( event.getResponse() ).toHaveStatus(
							400,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.put(
							"/cbapi/v1/sites/default/entries/bogusbaby",
							{ content : "bogus" }
						);
						expect( event.getResponse() ).toHaveStatus(
							404,
							event.getResponse().getMessagesString()
						);
					} );
				} );
			} ); // end edit story

			story( "I want to delete a entry", function(){
				given( "a valid id/slug", function(){
					then( "then I should see the confirmation", function(){
						var testContent = variables.entryService.save(
							variables.entryService.new( {
								title         : "bddtest",
								slug          : "bddtest",
								content       : "This is my awesome bdd test entry",
								publishedDate : dateTimeFormat(
									now(),
									"yyyy-mm-dd'T'HH:mm:ssZ",
									"UTC"
								),
								changelog : "My first creation from the bdd test",
								site      : variables.siteService.getDefaultSite(),
								creator   : variables.loggedInData.user
							} )
						);
						var event = this.delete(
							"/cbapi/v1/sites/default/entries/#testContent.getContentID()#"
						);
						expect( event.getResponse() ).toHaveStatus(
							200,
							event.getResponse().getMessagesString()
						);
						expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
					} );
				} );
				given( "an invalid id or slug", function(){
					then( "then I should see an error message", function(){
						var event = this.delete( "/cbapi/v1/sites/default/entries/bogusbogus" );
						expect( event.getResponse() ).toHaveStatus(
							404,
							event.getResponse().getMessagesString()
						);
					} );
				} );
			} ); // end delete story
		} ); // end describe
	}
	// end run

}
