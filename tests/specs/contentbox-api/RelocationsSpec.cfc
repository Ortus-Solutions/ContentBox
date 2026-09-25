component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

	property name="RelocationService" inject="RelocationService@contentbox";

	/*********************************** LIFE CYCLE Methods ***********************************/

	/**
	 * executes before all suites+specs in the run() method
	 */
	function beforeAll() {
		super.beforeAll();
		// Log in admin
		variables.loggedInData = loginUser();
		variables.testSite = getDefaultSite();
		variables.testRelocation = variables.relocationService.new(
				properties = {
					"slug"  : createUUID(),
					"target": createUUID(),
					"site"  : testSite
				}
			);
		variables.RelocationService.save( testRelocation );
	}

	/**
	 * executes after all suites+specs in the run() method
	 */
	function afterAll() {
		if ( variables.keyExists( "testRelocation" ) ) {
			variables.relocationService.deleteWhere( slug = testRelocation.getSlug() );
		}
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		// all your suites go here.
		describe(
			"Relocations API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to view a Relocation by id or slug",
					() => {
						given(
							"a valid id",
							() => {
								then(
									"then I should get the requested Relocation",
									() => {
										var event = this.get(
												"/cbapi/v1/sites/default/relocations/#testRelocation.getRelocationID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200 );
										expect( event.getResponse().getData().slug ).toBe( testRelocation.getSlug() );
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
										var event = this.get( "/cbapi/v1/sites/default/relocations/XYZ" );
										expect( event.getResponse() ).toHaveStatus( 404 );
									}
								);
							}
						);
					}
				); // end story view site by id or slug

				story(
					"I want to list all site relocations",
					() => {
						given(
							"no options",
							() => {
								then(
									"it can display all site relocations",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/relocations" );
										expect( event.getResponse() ).toHaveStatus( 200 );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
					}
				); // end story list all sites

				story(
					"I want to create a site Relocation",
					() => {
						given(
							"valid incoming data",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										withRollback(
											() => {
												var event = this.post(
														"cbapi/v1/sites/default/relocations",
														{ target: "bddtest", slug: "bddtest" }
													);
												expect( event.getResponse() ).toHaveStatus( 200 );
												expect( event.getResponse().getData().relocationID ).notToBeEmpty();
												expect( event.getResponse().getData().slug ).toBe( "bddtest" );
											}
										);
									}
								);
							}
						);
						given(
							"duplicate Relocation slug",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post(
												"cbapi/v1/sites/default/relocations",
												{ "slug": testRelocation.getSlug(), target: "coldbox" }
											);
										expect( event.getResponse() ).toHaveStatus( 400 );
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
										var event = this.post(
												"cbapi/v1/sites/default/relocations",
												{ name: "A nice Relocation" }
											);
										expect( event.getResponse() ).toHaveStatus( 400 );
										expect( event.getResponse() ).toHaveInvalidData( "slug", "is required" );
									}
								);
							}
						);
					}
				); // end create story

				story(
					"I want to edit a Relocation",
					() => {
						given(
							"a valid id/slug and valid data",
							() => {
								then(
									"then it should update a Relocation",
									() => {
										withRollback(
											() => {
												var event = this.put(
														"/cbapi/v1/sites/default/relocations/#testRelocation.getRelocationID()#",
														{ target: "foo" }
													);
												expect( event.getResponse() ).toHaveStatus( 200 );
												expect( event.getResponse().getData().target ).toBe( "foo" );
											}
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
										var event = this.put( "/cbapi/v1/sites/default/relocations/123" );
										expect( event.getResponse() ).toHaveStatus( 404 );
									}
								);
							}
						);
					}
				); // end edit story
				story(
					"I want to delete a Relocation",
					() => {
						given(
							"a valid id/slug",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										var event = this.delete(
												"/cbapi/v1/sites/default/relocations/#variables.testRelocation.getRelocationID()#"
											);
										expect( event.getResponse() ).toHaveStatus( 200 );
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
										var event = this.delete( "/cbapi/v1/sites/default/relocations/1232222" );
										expect( event.getResponse() ).toHaveStatus( 404 );
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