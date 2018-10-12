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
	property name="contentService"  inject="id:contentService@cb";
	property name="CBHelper"  		inject="id:CBHelper@cb";

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
			relocate( "cbInstaller" );
		}

		// Prepare UI Request
		CBHelper.prepareUIRequest();
	}

	/**
	* Fired on post rendering
	*/
	function postRender( event, interceptData, buffer, rc, prc ) eventPattern="^contentbox-ui\:(page|blog)"{
		// Rules to turn off the admin bar
		if(
			// Disabled SiteBar Setting
			!prc.cbSettings.cb_site_adminbar
			||
			// Disabled SiteBar per request
			structKeyExists( prc, "cbAdminBar" ) and !prc.cbAdminBar
			||
			// Ajax Request
			event.isAjax()
			||
			// Output Format not HTML
			( structKeyExists( rc, "format" ) && rc.format != "html" )
			||
			// Preview actions disabled
			event.getCurrentAction() == "preview"
			||
			// Logged In
			!prc.oCurrentAuthor.isLoggedIn()
			||
			// Permissions
			!prc.oCurrentAuthor.checkPermission( "CONTENTBOX_ADMIN,PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR" )
		){
			return;
		}

		// Verify if we are in cache mode.
		if( structKeyExists( prc, "contentCacheData" ) ){
			// skip out if not in text/html mode
			if( prc.contentCacheData.contentType neq "text/html" ){
				return;
			}
			// Inflate content for admin bar
			local.oContent = contentService.get( prc.contentCacheData.contentID );
		}

		// Determine content via context search
		if( structKeyExists( prc, "entry" ) ){
			local.oContent = prc.entry;
		}
		if( structKeyExists( prc, "page" ) ){
			local.oContent = prc.page;
		}

		// If not null, setup the link to edit
		var linkEdit = "";
		if( !isNull( oContent ) ){
			if( oContent.getContentType() == "entry" ){
				linkEdit = "#CBHelper.linkAdmin()#entries/editor/contentID/#oContent.getContentID()#";
			} else {
				linkEdit = "#CBHelper.linkAdmin()#pages/editor/contentID/#oContent.getContentID()#";
			}
		}

		// Render the admin bar out
		var adminBar = renderView(
			view 	= "adminbar/index",
			module 	= "contentbox-ui",
			args 	= {
				oContent 		= oContent ?: javaCast( "null", "" ),
				linkEdit 		= linkEdit,
				oCurrentAuthor 	= prc.oCurrentAuthor
			}
		);
		cfhtmlhead( text="#adminBar#" );
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