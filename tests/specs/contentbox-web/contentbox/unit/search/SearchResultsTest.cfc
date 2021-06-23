/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component
	extends="coldbox.system.testing.BaseModelTest"
	model  ="contentbox.models.search.SearchResults"
{

	this.unLoadColdBox = false;

	function setup(){
		super.setup();
		model.init();
	}

	function testMemento(){
		r = model.getmemento();
		assertTrue( structCount( r ) );
	}

	function testPopulate(){
		r = {
			results       : [],
			searchTime    : getTickCount(),
			total         : 0,
			metadata      : { name : "luis", value : "awesome" },
			error         : false,
			errorMessages : [],
			searchTerm    : "luis"
		};

		model.populate( r );
		m = model.getMemento();
		assertEquals( r, m );
	}

}
