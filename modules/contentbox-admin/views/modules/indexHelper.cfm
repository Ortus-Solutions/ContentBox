<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##moduleUploadForm");
	$moduleForm = $("##moduleForm");
	$forgebox   = $("##forgeboxPane");
	// table sorting + filtering
	$("##modules").tablesorter();
	$("##moduleFilter").keyup(function(){
		$.uiTableFilter( $("##modules"), this.value );
	});
	// form validator
	$uploadForm.validator({position:'top left',onSuccess:function(e,els){ activateLoaders(); }});
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(moduleName){
	$moduleForm.find("##moduleName").val( moduleName );
	$moduleForm.attr("action","#event.buildLink(prc.xehModuleRemove)#");
	$moduleForm.submit();
}
function activate(moduleName){
	$moduleForm.find("##moduleName").val( moduleName );
	$moduleForm.attr("action","#event.buildLink(prc.xehModuleActivate)#");
	$moduleForm.submit();
}
function deactivate(moduleName){
	$moduleForm.find("##moduleName").val( moduleName );
	$moduleForm.attr("action","#event.buildLink(prc.xehModuleDeactivate)#");
	$moduleForm.submit();
}
function loadForgeBox(orderBY){
	if( orderBY == null ){ orderBY = "popular"; }
	$forgebox.load('#event.buildLink(prc.xehForgeBox)#',
		{typeslug:'#prc.forgeBoxSlug#', installDir:'#prc.forgeBoxInstallDir#', returnURL:'#prc.forgeboxReturnURL#', orderBY:orderBY});
}
</script>
</cfoutput>