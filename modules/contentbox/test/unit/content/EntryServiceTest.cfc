component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.content.EntryService"{

	function setup(){
		super.setup();
		model.init();
		
		model.$property("HQLUtil","variables", new modules.contentbox.model.util.HQLHelper() );
	}
	
	function testgetArchivesReport(){
		
		r = model.getArchiveReport();
		assertTrue( arrayLen( r ) );
		
	}
	
	function testFindPublishedEntriesByDate(){
		// nothing
		r = model.findPublishedEntriesByDate(year=2000);
		assertFalse( arrayLen(r.entries) );
		assertEquals(0, r.count );
		
		// year
		r = model.findPublishedEntriesByDate(year=2010);
		assertTrue( arrayLen(r.entries) eq 1 );
		
		// year + Month
		r = model.findPublishedEntriesByDate(year=2010,month=7);
		assertTrue( arrayLen(r.entries) eq 1 );
		
		// year + Month
		r = model.findPublishedEntriesByDate(year=2010,month=1);
		assertTrue( arrayLen(r.entries) eq 0 );
		
		// year + Month + day
		r = model.findPublishedEntriesByDate(year=2010,month=7,day=19);
		assertTrue( arrayLen(r.entries) eq 1 );
	}
	

} 