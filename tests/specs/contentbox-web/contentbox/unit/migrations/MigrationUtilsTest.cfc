/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Tests for the migration helpers in modules/contentbox/migrations/util/MigrationUtils.cfm
 */
component extends="testbox.system.BaseSpec" {
	// Mix the helpers into this spec, the same way the migrations include them
	include "/contentbox/migrations/util/MigrationUtils.cfm";

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Migration Utils",
			() => {
				describe(
					"hasColumn()",
					() => {
						it(
							"finds an existing column",
							() => {
								expect( hasColumn( "cb_setting", "FK_siteID" ) ).toBeTrue();
							}
						);

						it(
							"ignores the case of table and column names",
							() => {
								expect( hasColumn( "cb_setting", "fk_siteid" ) ).toBeTrue();
								expect( hasColumn( "CB_SETTING", "FK_SITEID" ) ).toBeTrue();
								expect( hasColumn( "cb_site", "domainAliases" ) ).toBeTrue();
							}
						);

						it(
							"returns false for a missing column",
							() => {
								expect( hasColumn( "cb_setting", "notAColumn" ) ).toBeFalse();
							}
						);

						it(
							"returns false for a missing table",
							() => {
								expect( hasColumn( "cb_notATable", "FK_siteID" ) ).toBeFalse();
							}
						);
					}
				);
			}
		);
	}

}