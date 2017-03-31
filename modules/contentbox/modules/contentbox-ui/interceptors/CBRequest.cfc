/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages ContentBox UI Module Requests
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="settingService"  inject="id:settingService@cb";
	property name="CBHelper"  		inject="id:CBHelper@cb";
	property name="html"  			inject="HTMLHelper@coldbox";

	/**
	* Configure CB Request
	*/
	function configure(){}

	/**
	* Fired on contentbox requests
	*/
	function preProcess( event, interceptData, buffer, rc, prc ) eventPattern="^contentbox-ui"{
		// Verify ContentBox installer has been ran?
		if( !settingService.isCBReady() ){
			setNextEvent( "cbInstaller" );
		}
		
		// Prepare UI Request
		CBHelper.prepareUIRequest();
	}

	/**
	* Fired on post rendering
	*/
	function postRender( event, interceptData, buffer, rc, prc ) eventPattern="^contentbox-ui"{
		// Verify if we are logged in and in an export format
		if( 
			!prc.oCurrentAuthor.isLoggedIn()
			||
			!prc.oCurrentAuthor.checkPermission( "CONTENTBOX_ADMIN,PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR" )
			||
			( structKeyExists( rc, "format" ) && rc.format != "html" )
		){
			return;
		}

		var linkEdit = "";
		if( structKeyExists( prc, "entry" ) ){
			var oContent = prc.entry;
			linkEdit = "#CBHelper.linkAdmin()#entries/editor/contentID/#oContent.getContentID()#";
		} else if ( structKeyExists( prc, "page" ) ){
			var oContent = prc.page;
			linkEdit = "#CBHelper.linkAdmin()#pages/editor/contentID/#oContent.getContentID()#";
		}

		var adminBar = renderView( 
			view 	= "adminbar/index", 
			module 	= "contentbox-ui",
			args 	= {
				oContent = oContent ?: javaCast( "null", "" ),
				linkEdit = linkEdit
			}
		);
		html.$htmlhead( adminBar );
	}

	/**
	* Fired on contentbox requests
	*/
	function postProcess( event, interceptData, buffer, rc, prc ) eventPattern="^contentbox-ui"{
		// announce event
		announceInterception( "cbui_postRequest" );
	}

	/*
	* Renderer helper injection
	*/
	function afterInstanceCreation( event, interceptData, buffer ){
		// check for renderer instance only
		if( isInstanceOf( arguments.interceptData.target, "coldbox.system.web.Renderer" ) ){
			var prc = event.getCollection( private=true );
			// decorate it
			arguments.interceptData.target.cb 			= CBHelper;
			arguments.interceptData.target.$cbInject 	= variables.$cbInject;
			arguments.interceptData.target.$cbInject();
			// re-broadcast event
			announceInterception( 
				"cbui_onRendererDecoration",
				{ renderer=arguments.interceptData.target, CBHelper=arguments.interceptData.target.cb } 
			);
		}
	}

	/**
	* private inject
	*/
	function $cbinject(){
		variables.cb = this.cb;
	}

}