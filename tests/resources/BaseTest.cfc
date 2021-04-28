/**
 * This is the Base Integration Test CFC
 * Place any helpers or traits for all integration tests here.
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	// Load on first test
	this.loadColdBox   = true;
	// Do not unload per test bundle to improve performance.
	this.unloadColdBox = false;

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		ormClearSession();
		super.beforeAll();

		// Wire up the test object with dependencies
		if( this.loadColdBox && structKeyExists( application, "wirebox" ) ){
			getWireBox().autowire( this );
		}

	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	/**
	 * Helper to execeute after each spec
	 *
	 * @afterEach
	 */
	function clearAfterEachSpec(){
		ormClearSession();
	}

	/**
	 * Wrapper for rollbacks
	 *
	 * @target The target closure to run within the transaction
	 */
	function withRollback( target ){
		transaction {
			try {
				return arguments.target();
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
				ormClearSession();
			}
		}
	}

}
