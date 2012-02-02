/**
* All tests are performed with the sample data case
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.ContentVersionService"{

	function setup(){
		super.setup();
		model.init(eventHandling=false);
	}
	
	function testfindRelatedVersions(){
		var page = entityLoad("cbPage")[1];
		r = model.findRelatedVersions(contentID=page.getContentID());
		debug( r );
		assertTrue( r.count gt 0 );
	} 
	
} 