<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##layoutUploadForm");
	$layoutForm = $("##layoutForm");
	$forgebox   = $("##forgeboxPane");
	// table sorting + filtering
	$("##layouts").tablesorter();
	$("##layoutFilter").keyup(function(){
		$.uiTableFilter( $("##layouts"), this.value );
	});
	// form validator
	$uploadForm.validator({position:'top left',onSuccess:function(e,els){ activateLoaders(); }});	
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(layoutName){
	$layoutForm.find("##layoutName").val( layoutName );
	$layoutForm.submit();
}
function loadForgeBox(){
	$forgebox.load('#event.buildLink(prc.xehForgeBox)#',{typeslug:'contentbox-layouts'});
}
</script>
</cfoutput>