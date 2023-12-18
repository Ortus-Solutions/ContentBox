﻿<cfoutput>
<script>
window.authentication = #toJSON( prc.jwtTokens )#
window.assignedTemplate = #( !isNull( prc.oContent.getContentTemplate() ) ? toJSON( prc.oContent.getContentTemplate().getMemento() ) : booleanFormat( false ) )#

// Editor alerts model
function alertsModel(){
	return {
		alerts : [],

		init(){
			$nextTick( () => window.alerts = this.alerts )
		},

		removeAlert : index => this.alerts.splice( index, 1 ),

		addAlert( alert ){
			if( alert instanceof CustomEvent ){
				alert = alert.detail
			}
			this.alerts.push( alert );
		}
	}
}

/**
 * Enclosure for custom editor startup
 */
$cbEditorStartup = function(){
	#prc.oEditorDriver.startup()#
}

/**
 * Enclosure for custom editor startup
 */
$cbEditorShutdown = function(){
	#prc.oEditorDriver.shutdown()#
}

// Load Editor Provider Assets now
#prc.oEditorDriver.loadAssets()#

// On Dom Ready
document.addEventListener( "DOMContentLoaded", () => {

	// Dynamic global variables coming from ColdFusion
	$cbEditorConfig = {
		adminEntryPoint 	: "#prc.cbAdminEntryPoint#",
		adminEntryURL		: "#event.buildLink( prc.cbAdminEntryPoint )#",
		changelogMandatory	: #prc.cbSettings.cb_versions_commit_mandatory#,
		isBlogDisabled		: #prc.oCurrentSite.getIsBlogEnabled() ? 'false' : 'true'#,
		// Set by the content type handler
		slugifyURL			: "#event.buildLink( prc.xehSlugify )#",
		slugCheckURL		: "#event.buildLink( prc.xehSlugCheck )#"
	};

 	// Editor Form Pointer
	$contentForm = $( "##contentForm" );

	// Setup the Editors
	setupEditors(
		$contentForm,
		<cfif structKeyExists( prc.oContent, "getExcerpt" )>
			true,
		<cfelse>
			false,
		</cfif>
		'#event.buildLink( prc.xehContentSave )#'
	);

	// Apply content templates
	if( document.getElementById( 'contentTemplate' ) && document.getElementById( 'contentTemplate' ).value !== 'null' ){
		applyContentTemplate( document.getElementById( 'contentTemplate' ).value );
	}
} );
</script>
</cfoutput>
