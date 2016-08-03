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
	isBlogDisabled		: #prc.cbSettings.cb_site_disable_blog#,
	// Set by the content type handler
	slugifyURL			: "#event.buildLink( prc.xehSlugify )#",
	slugCheckURL		: "#event.buildLink( prc.xehSlugCheck )#"
};

// Load Editor Provider Assets now
#prc.oEditorDriver.loadAssets()#
</script>

<!--- Load Editor Assets Now --->
<cfif getSetting( "environment" ) eq "development">
    <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-editors.js"></script>
<cfelse>
    <script type="application/javascript" src="#prc.cbroot#/includes/js/contentbox-editors.min.js"></script>
</cfif>
</cfoutput>