<cfoutput>
<script language="javascript">
$(document).ready(function() {
	// form validators
	$("##installerForm").validator( {grouped:true, effect:"wall", errorInputEvent: null} );
	
	// password validator
	$.tools.validator.fn("[name=password_confirm]", "Passwords need to match", function(el, value) {
		return (value==$("[name=password]").val()) ? true : false;
	});
	
	// adds an effect called "wall" to the validator
	$.tools.validator.addEffect("wall", function(errors, event) {
		// get the message wall
		var wall = $("##errorBar").addClass("alert alert-error").fadeIn();
		// remove all existing messages
		wall.html("");
		// Init messages
		wall.append( "<h3>Cannot continue installation, please fix the following errors:</h3><ul id='formErrors'>" );
		var formErrors = wall.find("##formErrors");
		// add new errors
		$.each(errors, function(index, error) {
			formErrors.append(
				"<li><strong>" +error.input.attr("name")+ "</strong> " + error.messages[0] + "</li>"
			);
		});
	 
	// the effect does nothing when all inputs are valid
	}, function(inputs)  {
	 
	});
});

function nextStep(){
    var $tabs = $('.tabbable li');
	$tabs.filter('.active').next('li').find('a[data-toggle="tab"]').tab('show');
}
function prevStep(){
    var $tabs = $('.tabbable li');
	$tabs.filter('.active').prev('li').find('a[data-toggle="tab"]').tab('show');
}
</script>
</cfoutput>