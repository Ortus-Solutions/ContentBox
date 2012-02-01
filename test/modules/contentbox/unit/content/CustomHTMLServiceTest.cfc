/**
* All tests are performed with the sample data case
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.CustomHTMLService"{

	function setup(){
		super.setup();
		model.init(eventHandling=false);
	}
	
	
	function testsearch(){
		// test get all
		r = model.search();
		assertTrue( r.count gt 0 );
				
		r = model.search(search="contentbox");
		assertTrue( r.count gt 0 );
		r = model.search(search="contact");
		assertTrue( r.count gt 0 );
	} 
	
} 