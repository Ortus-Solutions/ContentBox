component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

	property name="categoryService" inject="categoryService@contentbox";

	property name="contentStoreService" inject="contentStoreService@contentbox";

	/*********************************** LIFE CYCLE Methods ***********************************/

	/**
	 * executes before all suites+specs in the run() method
	 */
	function beforeAll() {
		super.beforeAll();
		// Log in admin
		variables.loggedInData = loginUser();
	}

	/**
	 * executes after all suites+specs in the run() method
	 */
	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		// all your suites go here.
		describe(
			"Content Store API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to view a content item by id or slug",
					() => {
						given(
							"an valid id",
							() => {
								then(
									"then I should get the requested content store item",
									() => {
										var testContent = variables.contentStoreService.findWhere( { slug: "foot" } );
										var event = this.get(
												"/cbapi/v1/sites/default/contentstore/#testContent.getContentID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "foot" );
										expect( event.getResponse().getData() ).toHaveKey(
												"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
											);
									}
								);
							}
						);
						given(
							"an valid slug",
							() => {
								then(
									"then I should get the requested content store item",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore/foot" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "foot" );
										expect( event.getResponse().getData() ).toHaveKey(
												"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
											);
									}
								);
							}
						);
						given(
							"an invalid id or slug",
							() => {
								then(
									"then I should see an error message",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore/123kkdabugosu" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end story view site by id or slug

				story(
					"I want to list all content store items",
					() => {
						given(
							"no options",
							() => {
								then(
									"it can display all items with default filters",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
						given(
							"a parent search",
							() => {
								then(
									"it can display content store items from a parent",
									() => {
										var testContent = variables.contentStoreService.findWhere( { slug: "foot" } );
										var event = this.get(
												"/cbapi/v1/sites/default/contentstore?parent=#testContent.getContentID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.parent.slug ).toBe( "foot" );
												}
											);
									}
								);
							}
						);
						given(
							"a content search",
							() => {
								then(
									"it can find the content store item",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore?search=foot" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
						given(
							"a slug prefix search",
							() => {
								then(
									"it can find the content store items",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore?slugPrefix=foot" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
						given(
							"a slug search",
							() => {
								then(
									"it can find the content store items",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore?slugSearch=foot" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
					}
				); // end story list all sites

				story(
					"I want to create a content store item",
					() => {
						given(
							"valid data",
							() => {
								then(
									"then it should create a new content object",
									() => {
										withRollback(
											() => {
												var event = this.post(
														"cbapi/v1/sites/default/contentstore",
														{
															title        : "bddtest",
															slug         : "bddtest",
															description  : "my bdd test site",
															content      : "This is my awesome bdd test content store item",
															publishedDate: dateTimeFormat(
																now(),
																"yyyy-mm-dd'T'HH:mm:ssZ",
																"UTC"
															),
															changelog   : "My first creation from the bdd test",
															categories  : "coldbox,news",
															customFields: [
																{ key: "test", value: "true" },
																{ key: "data", value: "#now()#" }
															]
														}
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												// debug( event.getResponse().getData() );
												expect( event.getResponse().getData().contentID ).notToBeEmpty();
												expect( event.getResponse().getData().slug ).toBe( "bddtest" );
												expect( event.getResponse().getData().categories ).toBeArray().notToBeEmpty();
												expect( event.getResponse().getData().customFields ).toBeStruct().notToBeEmpty();
											}
										);
									}
								);
							}
						);
						given(
							"duplicate content slug",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post(
												"cbapi/v1/sites/default/contentStore",
												{
													title  : "foot",
													slug   : "foot",
													content: "Footer is here",
													order  : 10
												}
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
									}
								);
							}
						);
						given(
							"invalid content",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post(
												"cbapi/v1/sites/default/contentStore",
												{ slug: "A nice site" }
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										// debug( event.getResponse().getMemento() );

										expect( event.getResponse().getMessages() ).toInclude( "content is required" );
									}
								);
							}
						);
						given(
							"invalid data but good content",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post(
												"cbapi/v1/sites/default/contentStore",
												{ content: "Hello from bdd test land!" }
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "title", "is required" );
									}
								);
							}
						);
					}
				); // end create story

				story(
					"I want to edit a content store item",
					() => {
						given(
							"a valid id/slug and valid data",
							() => {
								then(
									"then it should update a content item",
									() => {
										getCache( "template" ).clearAll();
										withRollback(
											() => {
												var event = this.put(
														"/cbapi/v1/sites/default/contentstore/foot",
														{
															content  : "I am a new piece of content for the footer!",
															changelog: "Update from a bdd test!"
														}
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												expect( event.getResponse().getData().renderedContent ).toInclude( "I am a new piece of content for the footer!" );
												expect( event.getResponse().getData().activeContent.changelog ).toInclude( "bdd test" );
											}
										);
									}
								);
							}
						);
						given(
							"duplicate content slug",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.put(
												"cbapi/v1/sites/default/contentStore/foot",
												{
													title  : "foot",
													slug   : "my-awesome-news",
													content: "Footer is here"
												}
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "slug", "is not unique" );
									}
								);
							}
						);
						given(
							"an invalid id or slug",
							() => {
								then(
									"then I should see an error message",
									() => {
										var event = this.put(
												"/cbapi/v1/sites/default/contentstore/bogusbaby",
												{ content: "bogus" }
											);
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end edit story

				story(
					"I want to delete a content store item",
					() => {
						given(
							"a valid id/slug",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										var testContent = variables.contentstoreService.save(
												variables.contentstoreService.new(
														{
															title        : "bddtest",
															slug         : "bddtest",
															description  : "my bdd test site",
															content      : "This is my awesome bdd test content store item",
															publishedDate: dateTimeFormat(
																now(),
																"yyyy-mm-dd'T'HH:mm:ssZ",
																"UTC"
															),
															changelog: "My first creation from the bdd test",
															site     : variables.siteService.getDefaultSite(),
															creator  : variables.loggedInData.user
														}
													)
											);
										var event = this.delete(
												"/cbapi/v1/sites/default/contentstore/#testContent.getContentID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
									}
								);
							}
						);
						given(
							"an invalid id or slug",
							() => {
								then(
									"then I should see an error message",
									() => {
										var event = this.delete( "/cbapi/v1/sites/default/contentstore/bogusbogus" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end delete story
			}
		); // end describe
	}


	// end run
}