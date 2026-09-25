component extends="tests.resources.BaseApiTest" {
	property name="siteService" inject="siteService@contentbox";

	property name="authorService" inject="authorService@contentbox";

	property name="roleService" inject="roleService@contentbox";

	property name="permissionService" inject="permissionService@contentbox";

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
			"Authors API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to list all authors",
					() => {
						given(
							"no options",
							() => {
								then(
									"it can display all active system authors",
									() => {
										var event = this.get( "/cbapi/v1/authors" );
										expect( event.getResponse() ).toHaveStatus( 200 );
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
							"isActive = false",
							() => {
								then(
									"it should display inactive users",
									() => {
										var event = this.get( "/cbapi/v1/authors?isActive=false" );
										expect( event.getResponse() ).toHaveStatus( 200 );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
										event
											.getResponse()
											.getData()
											.each(
												( thisItem ) => {
													expect( thisItem.isActive ).toBeFalse( thisItem.toString() );
												}
											);
									}
								);
							}
						);
						given(
							"a search criteria",
							() => {
								then(
									"it should display searched users",
									() => {
										var event = this.get( "/cbapi/v1/authors?search=tester" );
										expect( event.getResponse() ).toHaveStatus( 200 );
										expect( event.getResponse().getData() ).toBeArray().notToBeEmpty();
									}
								);
							}
						);
					}
				); // end list all authors

				story(
					"I want to view an author by id",
					() => {
						given(
							"a valid id",
							() => {
								then(
									"then I should get the requested author",
									() => {
										var testUser = variables.authorService.findWhere( { "username": "lmajano" } );
										var event = this.get( "/cbapi/v1/authors/#testUser.getAuthorID()#" );
										expect( event.getResponse() ).toHaveStatus( 200,
												event.getResponse().getMessagesString() );
										expect( event.getResponse().getData().username ).toBe( "lmajano" );
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
										var event = this.get( "/cbapi/v1/authors/123122" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end view author

				story(
					"I want to create a new author",
					() => {
						given(
							"valid incoming data",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										var testRole = variables.roleService.findWhere( { role: "Administrator" } );
										var testPermission = variables.permissionService.findWhere( {
													permission: "TOOLS_IMPORT"
												} );
										withRollback(
											() => {
												var event = this.post(
														"cbapi/v1/authors",
														{
															firstName  : "bdd",
															lastName   : "bdd",
															email      : "bdd@ortussolutions.com",
															username   : "bdd@ortussolutions.com",
															role       : testRole.getRoleID(),
															permissions: testPermission.getPermissionID()
														}
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												expect( event.getResponse().getData().authorID ).notToBeEmpty();
												expect( event.getResponse().getData().username ).toBe( "bdd@ortussolutions.com" );
											}
										);
									}
								);
							}
						);
						given(
							"duplicate username",
							() => {
								then(
									"it should display an error message",
									() => {
										var testRole = variables.roleService.findWhere( { role: "Administrator" } );
										var testPermission = variables.permissionService.findWhere( {
													permission: "TOOLS_IMPORT"
												} );
										var event = this.post(
												"cbapi/v1/authors",
												{
													firstName  : "bdd",
													lastName   : "bdd",
													email      : "bdd@ortussolutions.com",
													username   : variables.testAdminUsername,
													role       : testRole.getRoleID(),
													permissions: testPermission.getPermissionID()
												}
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "username", "is not unique" );
									}
								);
							}
						);
						given(
							"duplicate email",
							() => {
								then(
									"it should display an error message",
									() => {
										var testRole = variables.roleService.findWhere( { role: "Administrator" } );
										var testPermission = variables.permissionService.findWhere( {
													permission: "TOOLS_IMPORT"
												} );
										var event = this.post(
												"cbapi/v1/authors",
												{
													firstName  : "bdd",
													lastName   : "bdd",
													email      : variables.testAdminEmail,
													username   : "uniquebaby!",
													role       : testRole.getRoleID(),
													permissions: testPermission.getPermissionID()
												}
											);
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "email", "is not unique" );
									}
								);
							}
						);
						given(
							"basic invalid data",
							() => {
								then(
									"it should display an error message",
									() => {
										var event = this.post( "cbapi/v1/authors", {} );
										expect( event.getResponse() ).toHaveStatus( 400,
												event.getResponse().getMessagesString() );
										expect( event.getResponse() ).toHaveInvalidData( "firstName", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "lastName", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "email", "is required" );
										expect( event.getResponse() ).toHaveInvalidData( "username", "is required" );
									}
								);
							}
						);
					}
				); // end create story

				story(
					"I want to edit an author",
					() => {
						given(
							"a valid id and valid data",
							() => {
								then(
									"then it should update an author",
									() => {
										withRollback(
											() => {
												var testAuthor = variables.authorService.findWhere( {
															username: "lmajano"
														} );
												var event = this.put(
														"/cbapi/v1/authors/#testAuthor.getAuthorID()#",
														{ biography: "ColdBox Daddy!" }
													);
												expect( event.getResponse() ).toHaveStatus( 200,
														event.getResponse().getMessagesString() );
												expect( event.getResponse().getData().biography ).toInclude( "ColdBox Daddy!" );
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
										var event = this.put( "/cbapi/v1/authors/1232222" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end edit author

				story(
					"I want to delete an author",
					() => {
						given(
							"a valid id",
							() => {
								then(
									"then I should see the confirmation",
									() => {
										try {
											var testRole = variables.roleService.findWhere( { role: "Administrator" } );
											var testPermission = variables.permissionService.findWhere( {
														permission: "TOOLS_IMPORT"
													} );
											var testAuthor = variables.authorService.save(
													variables.authorService.new(
															{
																firstName  : "bdd",
																lastName   : "bdd",
																email      : "bdd@ortussolutions.com",
																username   : "bddtest",
																role       : testRole.getRoleID(),
																permissions: testPermission.getPermissionID()
															}
														)
												);
											var event = this.delete( "/cbapi/v1/authors/#testAuthor.getAuthorId()#" );
											expect( event.getResponse() ).toHaveStatus( 200,
													event.getResponse().getMessagesString() );
											expect( event.getResponse().getMessagesString() ).toInclude( "deleted" );
										} finally {
											queryExecute(
												"delete from cb_authorPermissions where FK_authorID = '#testAuthor.getAuthorID()#'"
											);
											queryExecute( "delete from cb_author where username = 'bddtest'" );
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
										var event = this.delete( "/cbapi/v1/sites/default/categories/1232222" );
										expect( event.getResponse() ).toHaveStatus( 404,
												event.getResponse().getMessagesString() );
									}
								);
							}
						);
					}
				); // end delete author
			}
		); // end describe
	}


	// end run
}