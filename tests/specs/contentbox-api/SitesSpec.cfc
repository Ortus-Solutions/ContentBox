component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

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
			"Sites API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to view a site by id or slug",
					() => {
						given(
							"an valid id",
							() => {
								then(
									"then I should get the requested site",
									() => {
										var testSite = getDefaultSite();
										var event = this.get( "/cbapi/v1/sites/#testSite.getSiteID()#" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "default" );
									}
								);
							}
						);
						given(
							"an valid slug",
							() => {
								then(
									"then I should get the requested site",
									() => {
										var event = this.get( "/cbapi/v1/sites/default" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().slug ).toBe( "default" );
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
										var event = this.get( "/cbapi/v1/sites/123" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end story view site by id or slug

				story(
					"I want to list all sites",
					() => {
						given(
							"no options",
							() => {
								then(
									"it can display all sites",
									() => {
										var event = this.get( "/cbapi/v1/sites" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.isActive ).toBeTrue( thisItem.toString() );
												}
											);
									}
								);
							}
						);
						given(
							"inactive flag option",
							() => {
								then(
									"it can display inactive sites",
									() => {
										var event = this.get( "/cbapi/v1/sites?isActive=false" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.isActive ).toBeFalse();
												}
											);
									}
								);
							}
						);
						given(
							"a name or description search",
							() => {
								then(
									"it can find the site",
									() => {
										var event = this.get( "/cbapi/v1/sites?search=default" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.slug ).toBe( "default" );
												}
											);
									}
								);
							}
						);
					}
				); // end story list all sites

				story(
					"I want to create a site",
					() => {
						given(
							"a valid id/slug",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										withRollback(
											() => {
												var event = this.post(
														"cbapi/v1/sites",
														{
															name         : "bddtest",
															slug         : "bddtest",
															description  : "my bdd test site",
															domain       : "bddtest.com",
															domainRegex  : "bddtest\.com",
															domainAliases: "[]",
															activeTheme  : "default",
															homepage     : "cbBlog"
														}
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												expect( event.getResponse().getData().siteID ).notToBeEmpty();
												expect( event.getResponse().getData().slug ).toBe( "bddtest" );
											}
										);
									}
								);
							}
						);
						given(
							"duplicate site slug",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post(
												"cbapi/v1/sites",
												{
													name         : "default",
													slug         : "default",
													description  : "my bdd test site",
													domain       : "bddtest.com",
													domainRegex  : "bddtest\.com",
													domainAliases: "[]",
													activeTheme  : "default",
													homepage     : "cbBlog"
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
							"invalid data",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post( "cbapi/v1/sites", { description: "A nice site" } );
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "name", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "domain", "is required" );
									}
								);
							}
						);
					}
				); // end create story

				story(
					"I want to edit a site",
					() => {
						given(
							"a valid id/slug and valid data",
							() => {
								then(
									"then it should update a site",
									() => {
										// Not wrapped in withRollback(): the "default" site is a shared
										// fixture nearly every other spec relies on, and withRollback()
										// isn't reliable for undoing an UPDATE across every engine. Edit
										// a disposable site instead so this test can't leak an inactive
										// "default" site into the rest of the suite.
										var siteId = createUUID();
										var testSite = variables.siteService.save(
												variables.siteService.new(
														{
															name         : "bddtest-#siteId#",
															slug         : "bddtest-#siteId#",
															description  : "my bdd test site",
															domain       : "bddtest.com",
															domainRegex  : "bddtest\.com",
															domainAliases: "[]",
															activeTheme  : "default",
															homepage     : "cbBlog"
														}
													)
											);
										try {
											var event = this.put(
													"/cbapi/v1/sites/#testSite.getSiteId()#",
													{ description: "bdd test baby!", isActive: false }
												);
											expect( event.getResponse() ).toHaveStatus( 200,
													event.getResponse().getMessagesString() );
											expect( event.getResponse().getData().description ).toInclude( "bdd test baby!" );
											expect( event.getResponse().getData().isActive ).toBeFalse();
										} finally {
											variables.siteService.delete( testSite );
										}
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
										var event = this.put( "/cbapi/v1/sites/123" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end edit story

				story( "I want to delete a site", () => {
					given( "a valid id/slug", () => {
							then(
								"then I should see the confirmation",
								() => {
									var siteId = createUUID();
									var testSite = variables.siteService.save(
											variables.siteService.new(
													{
														name         : "bddtest-#siteId#",
														slug         : "bddtest-#siteId#",
														description  : "my bdd test site",
														domain       : "bddtest.com",
														domainRegex  : "bddtest\.com",
														domainAliases: "[]",
														activeTheme  : "default",
														homepage     : "cbBlog"
													}
												)
										);
									// clear the session to make sure our delete is working with a new entity
									ormClearSession();
									var event = this.delete( "/cbapi/v1/sites/#testSite.getSiteId()#" );
									expect( event.getResponse() ).toHaveStatus( 200, event.getResponse().getMessagesString() );
									expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
								}
							);
					} );
					given(
						"an invalid id or slug",
						() => {
							then(
								"then I should see an error message",
								() => {
									var event = this.delete( "/cbapi/v1/sites/123" );
									expect( event.getResponse() ).toHaveStatus( 404,
											event.getResponse().getMessagesString() );
								}
							);
						}
					);
				} );
				// end delete story
			}
		); // end describe
	}


	// end run
}