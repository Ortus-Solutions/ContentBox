<cfoutput>
<script>
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

// Load Editor Provider Assets now
#prc.oEditorDriver.loadAssets()#
// On Dom Ready
document.addEventListener( "DOMContentLoaded", () => {
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
} );
</script>
<!--- Load Editor Assets Now --->
<cfif getSetting( "environment" ) eq "development">
	<script src="#prc.cbroot#/includes/js/contentbox-editors.js"></script>
<cfelse>
	<script src="#prc.cbroot#/includes/js/contentbox-editors.min.js"></script>
</cfif>
</cfoutput>
