/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages ContentBox UI Module Requests
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="contentService" inject="contentService@contentbox";
	property name="CBHelper" inject="id:CBHelper@contentbox";

	/**
	 * Configure CB Request
	 */
	function configure(){
		// Make sure we attach ourselves to the singleton renderer in ColdBox 6
		var renderer = variables.controller.getRenderer();

		renderer.cb        = variables.CBHelper;
		renderer.$cbinject = variables.$cbinject;
		renderer.$cbinject();
	}

	/**
	 * Fired on contentbox requests
	 */
	function preProcess( event, data, buffer, rc, prc ) eventPattern="^contentbox\-ui"{
		// Verify ContentBox installer has been ran?
		if ( !settingService.isCBReady() ) {
			// Check if installer module exists, else throw exception
			if ( controller.getSetting( "modules" ).keyExists( "contentbox-installer" ) ) {
				// Relocate to it
				relocate( "cbInstaller" );
			} else {
				throw(
					message: "Oops! ContentBox is not installed and the Installer module cannot be found",
					detail : "To install the installer module use CommandBox via 'install contentbox-installer'",
					type   : "ContentBoxInstallerMissing"
				);
			}
		}

		// Prepare UI Request
		variables.CBHelper.prepareUIRequest();
	}

	/**
	 * Fired on post rendering
	 */
	function postRender( event, data, buffer, rc, prc ) eventPattern="^contentbox-ui\:(page|blog)"{
		// Rules to turn off the admin bar
		if (
			// Disabled SiteBar Setting
			!prc.oCurrentSite.getAdminBar()
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
			!prc.oCurrentAuthor.checkPermission(
				"CONTENTBOX_ADMIN,PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR"
			)
		) {
			return;
		}

		// Verify if we are in cache mode.
		if ( structKeyExists( prc, "contentCacheData" ) ) {
			// skip out if not in text/html mode
			if ( prc.contentCacheData.contentType neq "text/html" ) {
				return;
			}
			// Inflate content for admin bar
			local.oContent = variables.contentService.get( prc.contentCacheData.contentID );
		}

		// Determine content via context search
		if ( structKeyExists( prc, "entry" ) ) {
			local.oContent = prc.entry;
		}
		if ( structKeyExists( prc, "page" ) ) {
			local.oContent = prc.page;
		}

		// If not null, setup the link to edit
		var linkEdit = "";
		if ( !isNull( oContent ) ) {
			if ( oContent.getContentType() == "entry" ) {
				linkEdit = "#CBHelper.linkAdmin()#entries/editor/contentID/#oContent.getContentID()#";
			} else {
				linkEdit = "#CBHelper.linkAdmin()#pages/editor/contentID/#oContent.getContentID()#";
			}
		}

		// Render the admin bar out
		buffer.append(
			renderView(
				view   = "adminbar/index",
				module = "contentbox-ui",
				args   = {
					oContent       : oContent ?: javacast( "null", "" ),
					linkEdit       : linkEdit,
					linkLogout     : "#prc.cbAdminEntryPoint#/security/doLogout",
					oCurrentAuthor : prc.oCurrentAuthor
				}
			)
		);

		// Append adminbar styles to the html head
		cfhtmlhead( text = renderView( view = "adminbar/adminbarCSS", module = "contentbox-ui" ) );
	}

	/**
	 * Fired on contentbox requests
	 */
	function postProcess( event, data, buffer, rc, prc ) eventPattern="^contentbox-ui"{
		// announce event
		announce( "cbui_postRequest" );
	}

	/**
	 * private inject
	 */
	function $cbinject(){
		variables.cb = this.cb;
	}

}
