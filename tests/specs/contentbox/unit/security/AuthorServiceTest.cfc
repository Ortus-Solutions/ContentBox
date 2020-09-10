/**
* Author service tests
*/
component extends="tests.resources.BaseTest"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
		setup();
		authorService = getInstance( "authorService@cb" );
	}

/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Author Service", function(){

			it( "can search for authors with 2 factor auth status", function(){
				var results = authorService.search( twoFactorAuth = "true" );
				for( var item in results.authors ){
					expect(	item.getIs2FactorAuth() ).toBeTrue();
				}
			});

			it( "can search for authors without 2 factor auth status", function(){
				var results = authorService.search( twoFactorAuth = "false" );
				for( var item in results.authors ){
					expect(	item.getIs2FactorAuth() ).toBeFalse();
				}
			});

			it( "can be created", function(){
				expect(	isObject( authorService ) ).toBeTrue();
			});

			it( "can get status author reports", function(){
				var report = authorService.getStatusReport();
				expect(	report ).toHaveKey( "active" )
					.toHaveKey( "deactivated" )
					.toHaveKey( "2FactorAuthEnabled" )
					.toHaveKey( "2FactorAuthDisabled" );
			});

			it( "can check for non existent usernames", function(){
				var results = authorService.usernameFound( "bogus" );
				expect(	results ).toBeFalse();
			});

			it( "can check for existent usernames", function(){
				var results = authorService.usernameFound( "lmajano" );
				expect(	results ).toBeTrue();
			});

			it( "can check for non existent emails", function(){
				var results = authorService.emailFound( "bogus" );
				expect(	results ).toBeFalse();
			});

			it( "can check for existent emails", function(){
				var results = authorService.emailFound( "lmajano@gmail.com" );
				expect(	results ).toBeTrue();
			});
		});
	}

}