/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.security.SecurityService"{

	function setup(){
		super.setup();
		mockSettingService = getMockBox().createSTub();
		mockCookieStorage = getMockBox().createSTub();
		mockLogger = getMockBox().createSTub().$("debug").$("info").$("error");
		model.init();
		
		model.$property("settingService", "variables", mockSettingService );
		model.$property("cookieStorage", "variables", mockCookieStorage );
		model.$property("log", "variables", mockLogger );
	}
	
	function testEncryptIt(){
		mockSalt = left( replace( createUUID(), "-", "" ,"all" ) , 32 );
		model.$("getEncryptionKey", mockSalt );
		makePublic( model, "encryptIt");
		r = model.encryptIt( "test" );
		debug( r );
		assertTrue( len( r ) and r neq "test" );
		
		r = model.encryptIt( "" );
		assertEquals( "", r );
	}
	
	function testDecryptIt(){
		// mocks
		mockSalt = left( replace( createUUID(), "-", "" ,"all" ) , 32 );
		model.$("getEncryptionKey", mockSalt );
		makePublic( model, "decryptIt");
		
		// no length
		r = model.decryptIt( "" );
		assertEquals( "", r );
		
		// Value
		mockEncrypt = encrypt( "hello unit test", mockSalt, "BLOWFISH", "HEX" );
		r = model.decryptIt( mockEncrypt );
		assertEquals( "hello unit test", r );
		
		// bad value
		mockEncrypt = "not encrypted";
		r = model.decryptIt( mockEncrypt );
		assertEquals( "", r );
		
	}
	
	function testGetRememberMe(){
		mockSalt = left( replace( createUUID(), "-", "" ,"all" ) , 32 );
		model.$("getEncryptionKey", mockSalt );
		
		// empty cookie
		mockCookieStorage.$("getVar", "");
		r = model.getRememberMe();
		assertEquals( "", r );
		
		// With bad value
		mockCookieStorage.$("getVar", "hello" );
		r = model.getRememberMe();
		assertEquals( "", r );
		
		// With good value
		mockEncrypt = encrypt( "helloUnitTest", mockSalt, "BLOWFISH", "HEX" );
		mockCookieStorage.$("getVar", mockEncrypt );
		r = model.getRememberMe();
		assertEquals( "helloUnitTest", r );
	}
	
	function testGetEncryptionKey(){
		// no key first
		mockSetting = entityNew( "cbSetting" );
		mockSettingService.$("findWhere")
			.$("new", mockSetting)
			.$("save");
		makepublic( model, "getEncryptionKey" );
		r = model.getEncryptionKey();
		assertEquals( 24, len( r ) );
		
		// with key
		mockSetting = entityNew("cbSetting");
		mockSettingService.$("findWhere", mockSetting);
		mockKey = generateSecretKey( "BLOWFISH" );
		mockSetting.setValue( mockKey );
		r = model.getEncryptionKey();
		assertEquals( mockKey, r );
	}
	
	function testSetRememberMe(){
		// mocks
		mockCookieStorage.$("setVar");
		mockSalt = left( replace( createUUID(), "-", "" ,"all" ) , 32 );
		model.$("getEncryptionKey", mockSalt );
		
		//no value
		model.setRememberMe( "" );
		debug( mockCookieStorage.$callLog().setVar[1].value );
		assertEquals( "", mockCookieStorage.$callLog().setVar[1].value );
		
		// with value
		model.setRememberMe( "lmajano" );
		debug( mockCookieStorage.$callLog().setVar[ 2 ].value );
		assertTrue( len( mockCookieStorage.$callLog().setVar[ 2 ].value ) );
	}

} 