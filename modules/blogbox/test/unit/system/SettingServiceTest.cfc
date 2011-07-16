component extends="coldbox.system.testing.BaseModelTest" model="blogbox.model.system.SettingService"{

	function setup(){
		super.setup();
		mockCache = getMockBox().createEmptyMock("coldbox.system.cache.providers.CacheBoxColdBoxProvider");
		
		// init service
		model.$property("cache","variables",mockCache);
		model.init();
	}
	
	function testFlushSettingsCache(){
		mockCache.$("clear");
		model.flushSettingsCache();
		assertTrue( mockCache.$once("clear") );
	}

	function testgetAllSettings(){
		// mocks
		mockCache.$("get",[1,2,3]);
		r = model.getAllSettings();
		assertEquals( r, [1,2,3] );
		
	}

} 