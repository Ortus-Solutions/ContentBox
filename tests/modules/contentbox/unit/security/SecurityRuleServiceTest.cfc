/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.security.SecurityRuleService"{

	function setup(){
		super.setup();
		model.init().setEventHandling( false );
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
	
	function testgetSecurityRules(){
		var rule = model.new(properties={whitelist="",securelist="firstRule",roles="",permissions="ADMIN",redirect="cbadmin/login",useSSL=false,order=0,match="event"});
		model.save( rule );
		var rule = model.new(properties={whitelist="",securelist="secondRule",roles="",permissions="ADMIN",redirect="cbadmin/login",useSSL=false,order=1,match="event"});
		model.save( rule );
		r = model.getSecurityRules();
		
		lastOrder = r.order[1];
		for(var x=2; x lte r.recordcount; x++){
			assertTrue( lastOrder lte r.order[x] );
			lastOrder = r.order[x];
		}
		
		model.delete( rule );
	}

} 