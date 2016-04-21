/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Helps with CK Editor operations
*/
component singleton{
	
	CKHelper function init(){
		return this;
	}
	
	string function toCKDate( required inDate ){
		return dateFormat( arguments.inDate, "yyyy-mm-dd" );
	}
	
	string function ckHour( required inDate ){
		if( isNull( inDate ) ){ inDate = now(); }
		return timeFormat( arguments.inDate, "HH" );
	}
	
	string function ckMinute( required inDate ){
		if( isNull( inDate ) ){ inDate = now(); }
		return timeFormat( arguments.inDate, "mm" );
	}
	
}
