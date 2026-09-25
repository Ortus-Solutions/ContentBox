component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

	property name="categoryService" inject="categoryService@contentbox";

	property name="pageService" inject="pageService@contentbox";

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
			"Pages API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to view a page item by id or slug",
					() => {
						given(
							"a valid id",
							() => {
								then(
									"then I should get the requested page",
									() => {
										var testContent = variables.pageService.findWhere( { slug: "products" } );
										var event = this.get(
												"/cbapi/v1/sites/default/pages/#testContent.getContentID()#"
											);
										// debug( event.getResponse().getData() )
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "products" );
										expect( event.getResponse().getData() ).toHaveKey(
												"activeContent,children,customFields,linkedContent,relatedContent,renderedContent"
											);
									}
								);
							}
						);
						given(
							"a valid slug",
							() => {
								then(
									"then I should get the requested page",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages/products" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "products" );
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
										var event = this.get( "/cbapi/v1/sites/default/pages/123kkdabugosu" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end story view site by id or slug

				story(
					"I want to list all pages",
					() => {
						given(
							"no options",
							() => {
								then(
									"it can display all items with default filters",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages" );
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
									"it can display pages from a parent",
									() => {
										var testContent = variables.pageService.findWhere( { slug: "products" } );
										var event = this.get(
												"/cbapi/v1/sites/default/pages?parent=#testContent.getContentID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.parent.slug ).toBe( "products" );
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
									"it can find the page",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages?search=products" );
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
									"it can find the pages",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages?slugPrefix=products" );
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
									"it can find the pages",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages?slugSearch=products" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
						given(
							"a show on menu search",
							() => {
								then(
									"it can find pages with showInMenu = false",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages?showInMenu=false" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().toBeEmpty();
									}
								);
							}
						);
					}
				); // end story list all sites

				story(
					"I want to create a page",
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
														"cbapi/v1/sites/default/pages",
														{
															title        : "bddtest",
															slug         : "bddtest",
															excerpt      : "bdd rules!",
															content      : "This is my awesome bdd test page",
															publishedDate: dateTimeFormat(
																now(),
																"yyyy-mm-dd'T'HH:mm:ssZ",
																"UTC"
															),
															layout      : "pages",
															showInMenu  : "false",
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
												expect( event.getResponse().getData().excerpt ).toInclude( "bdd" );
												expect( event.getResponse().getData().showInMenu ).toBeFalse();
												expect( event.getResponse().getData().layout ).toBe( "pages" );
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
												"cbapi/v1/sites/default/pages",
												{
													title  : "products",
													slug   : "products",
													content: "Products are here",
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
							"no content on a new content object",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post( "cbapi/v1/sites/default/pages",
												{ slug: "A nice site" } );
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
												"cbapi/v1/sites/default/pages",
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
					"I want to edit a page",
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
														"/cbapi/v1/sites/default/pages/products",
														{
															content  : "I am a new piece of content for the products!",
															changelog: "Update from a bdd test!"
														}
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												expect( event.getResponse().getData().renderedContent ).toInclude( "I am a new piece of content for the products!" );
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
												"cbapi/v1/sites/default/pages/products",
												{
													title  : "products",
													slug   : "support",
													content: "Products are here"
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
												"/cbapi/v1/sites/default/pages/bogusbaby",
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
					"I want to delete a page",
					() => {
						given(
							"a valid id/slug",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										var testContent = variables.pageService.save(
												variables.pageService.new(
														{
															title        : "bddtest",
															slug         : "bddtest",
															content      : "This is my awesome bdd test page",
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
												"/cbapi/v1/sites/default/pages/#testContent.getContentID()#"
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
										var event = this.delete( "/cbapi/v1/sites/default/pages/bogusbogus" );
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