/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
		authorService = getInstance( "AuthorService@contentbox" );
		siteService   = getInstance( "siteService@contentbox" );
		currentSite   = siteService.getDefaultSite();
		currentAuthor = authorService.retrieveUserByUsername( "lmajano" );
		pageService   = getInstance( "pageService@contentbox" );
		entryService  = getInstance( "entryService@contentbox" );

		contentToLoad = 100;
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Seeding lots of pages", function(){
			beforeEach( function( currentSpec ){
			} );

			it( "can load all pages", function(){
				for ( x = 1; x lte contentToLoad; x++ ) {
					var testId = createUUID();
					// create a page
					var page   = pageService.new(
						properties = {
							title              : "This is a random #testId# page",
							slug               : "randompage-#testId#",
							publishedDate      : now(),
							isPublished        : true,
							allowComments      : false,
							passwordProtection : "",
							layout             : "pages"
						}
					);
					page.setCreator( currentAuthor );
					page.setSite( currentSite );
					page.addNewContentVersion(
						content   = "<p>#mockData( content = "lorem", $num = 1 )[ 1 ].content#</p>",
						changelog = "First creation",
						author    = currentAuthor
					);
					pageService.save( page );
					debug( "Added #page.getTitle()#" );
				}
			} );

			fit( "can load all entries", function(){
				for ( x = 1; x lte contentToLoad; x++ ) {
					var testId = createUUID();
					// create a page
					var entry  = entryService.new(
						properties = {
							title         : "This is a random #testId# entry",
							slug          : "randompage-#testId#",
							publishedDate : now(),
							isPublished   : true,
							allowComments : false
						}
					);
					entry.setCreator( currentAuthor );
					entry.setSite( currentSite );
					entry.addNewContentVersion(
						content   = "<p>#mockData( content = "lorem", $num = 1 )[ 1 ].content#</p>",
						changelog = "First creation",
						author    = currentAuthor
					);
					entryService.save( entry );
					debug( "Added #entry.getTitle()#" );
				}
			} );
		} );
	}

}
