component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.security.SecurityRuleService"{

	function setup(){
		super.setup();
		model.init();
	}
	
	function testGetMaxORder(){
		t = model.getMaxOrder();
		assertTrue( isNumeric(t) );
	}
	
	function testGetNextMaxORder(){
		t = model.getMaxOrder();
		assertEquals( t+1, model.getNextMaxOrder() );
	}
	
	function testSaveRule(){
		
		// mocks
		t = getMockBox().prepareMock( entityNew("cbSecurityRule") );
		model.$("save").$("getNextMaxOrder",99);
		model.saveRule( t );
		assertEquals(99, t.getOrder() );
		
		t.$property("ruleID","variables",40);
		t.setOrder(40);
		model.saveRule( t );
		assertEquals(40, t.getOrder() );
		
	}

} 