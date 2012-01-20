<cfoutput>
<script language="javascript">
$(document).ready(function() {
	// form validators
	$("##installerForm").validator({grouped:true, position:"top left"});
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
});
</script>
</cfoutput>