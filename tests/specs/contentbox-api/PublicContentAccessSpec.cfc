/**
 * Verifies anonymous (unauthenticated) access to the ContentBox API's read-only
 * content endpoints (entries, pages, contentStore): index/show are publicly
 * reachable for content that is already publicly live on the front-end site,
 * while draft/unpublished content and all write actions remain blocked.
 */
component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

	property name="authorService" inject="authorService@contentbox";

	property name="entryService" inject="entryService@contentbox";

	property name="pageService" inject="pageService@contentbox";

	property name="contentStoreService" inject="contentStoreService@contentbox";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();
		// Make absolutely sure no auth token carries over from a previously run spec bundle
		// within the same physical request: this suite must run fully anonymous.
		structDelete( request, "testUserData" );
	}

	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Public (Anonymous) Content API Access",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT.
						setup();
					}
				);

				story(
					"I want to anonymously read published entries",
					() => {
						given(
							"no authentication and a published entry",
							() => {
								then(
									"I can list them via index",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/entries" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);

								then(
									"I can view it via show using its slug",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/entries/disk-queues-77caf" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "disk-queues-77caf" );
									}
								);
							}
						);

						given(
							"no authentication and a draft (unpublished) entry",
							() => {
								then(
									"show returns a 404, never the draft content",
									() => {
										withRollback(
											() => {
												var authorCriteria = { username: variables.testAdminUsername };
												var oAuthor = variables.authorService.findWhere( authorCriteria );
												var oDraft = variables.entryService.save(
														variables.entryService.new(
																{
																	title      : "anon-draft-entry",
																	slug       : "anon-draft-entry",
																	isPublished: false,
																	changelog  : "draft fixture for anonymous API access test",
																	site       : variables.siteService.getDefaultSite(),
																	creator    : oAuthor
																}
															)
													);

												var event = this.get( "/cbapi/v1/sites/default/entries/#oDraft.getContentID()#" );
												expect( event.getResponse() ).toHaveStatus( 404,
														event.getResponse().getMessagesString() );
											}
										);
									}
								);
							}
						);

						given(
							"no authentication",
							() => {
								then(
									"creating an entry is still rejected",
									() => {
										var event = this.post(
												"/cbapi/v1/sites/default/entries",
												{ title: "nope", slug: "nope", content: "nope" }
											);
										expect( event.getResponse() ).toHaveStatus( 401,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				);

				story(
					"I want to anonymously read published pages",
					() => {
						given(
							"no authentication and a published page",
							() => {
								then(
									"I can list them via index",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);

								then(
									"I can view it via show using its slug",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/pages/products" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "products" );
									}
								);
							}
						);

						given(
							"no authentication and a draft (unpublished) page",
							() => {
								then(
									"show returns a 404, never the draft content",
									() => {
										withRollback(
											() => {
												var authorCriteria = { username: variables.testAdminUsername };
												var oAuthor = variables.authorService.findWhere( authorCriteria );
												var oDraft = variables.pageService.save(
														variables.pageService.new(
																{
																	title      : "anon-draft-page",
																	slug       : "anon-draft-page",
																	isPublished: false,
																	changelog  : "draft fixture for anonymous API access test",
																	site       : variables.siteService.getDefaultSite(),
																	creator    : oAuthor
																}
															)
													);

												var event = this.get( "/cbapi/v1/sites/default/pages/#oDraft.getContentID()#" );
												expect( event.getResponse() ).toHaveStatus( 404,
														event.getResponse().getMessagesString() );
											}
										);
									}
								);
							}
						);

						given(
							"no authentication",
							() => {
								then(
									"creating a page is still rejected",
									() => {
										var event = this.post(
												"/cbapi/v1/sites/default/pages",
												{ title: "nope", slug: "nope", content: "nope" }
											);
										expect( event.getResponse() ).toHaveStatus( 401,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				);

				story(
					"I want to anonymously read published content store items",
					() => {
						given(
							"no authentication and a published content store item",
							() => {
								then(
									"I can list them via index",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);

								then(
									"I can view it via show using its slug",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/contentstore/foot" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "foot" );
									}
								);
							}
						);

						given(
							"no authentication and a draft (unpublished) content store item",
							() => {
								then(
									"show returns a 404, never the draft content",
									() => {
										withRollback(
											() => {
												var authorCriteria = { username: variables.testAdminUsername };
												var oAuthor = variables.authorService.findWhere( authorCriteria );
												var oDraft = variables.contentStoreService.save(
														variables.contentStoreService.new(
																{
																	title      : "anon-draft-contentstore",
																	slug       : "anon-draft-contentstore",
																	isPublished: false,
																	changelog  : "draft fixture for anonymous API access test",
																	site       : variables.siteService.getDefaultSite(),
																	creator    : oAuthor
																}
															)
													);

												var event = this.get(
														"/cbapi/v1/sites/default/contentstore/#oDraft.getContentID()#"
													);
												expect( event.getResponse() ).toHaveStatus( 404,
														event.getResponse().getMessagesString() );
											}
										);
									}
								);
							}
						);

						given(
							"no authentication",
							() => {
								then(
									"creating a content store item is still rejected",
									() => {
										var event = this.post(
												"/cbapi/v1/sites/default/contentstore",
												{ title: "nope", slug: "nope", content: "nope" }
											);
										expect( event.getResponse() ).toHaveStatus( 401,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				);

				story(
					"I want administrative resources to remain fully locked down",
					() => {
						given(
							"no authentication",
							() => {
								then(
									"listing sites is still rejected",
									() => {
										var event = this.get( "/cbapi/v1/sites" );
										expect( event.getResponse() ).toHaveStatus( 401,
												event.getResponse().getMessagesString() );
									}
								);

								then(
									"listing menus is still rejected",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/menus" );
										expect( event.getResponse() ).toHaveStatus( 401,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				);
			}
		);
	}


	// end run
}