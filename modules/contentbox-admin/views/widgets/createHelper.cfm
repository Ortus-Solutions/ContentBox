<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$widgetCreateForm = $("##widgetCreateForm");
	// form validator	
    $widgetCreateForm.validate();
});
function toggleIconSelector(){
	$widgetCreateForm.find("##widget-icon-selector").slideToggle();
}
function chooseIcon(iconPath){
	$widgetCreateForm.find("##icon").val( iconPath );
	toggleIconSelector();
}
</script>
</cfoutput>