<cfoutput>
<script language="javascript">
$(document).ready(function() {
	// form validators
	$("##installerForm").validator( {grouped:true, position:"center right"} );
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
	$("##installerForm").bind("onFail", function(e, errors)  {
		// we are only doing stuff when the form is submitted
		if (e.originalEvent.type == 'submit') {
			if( errors.length ){
				$("##errorBar").fadeIn().addClass( "infoBarRed" )
					.html( '<strong>Cannot submit form! Please revise the form for validation errors.</strong>' )
					.delay( 3000 )
					.fadeOut();	
			}
		}
	});
});
function startInstaller(){
	$("ul.vertical_nav").data("tabs").next();
}
</script>
</cfoutput>