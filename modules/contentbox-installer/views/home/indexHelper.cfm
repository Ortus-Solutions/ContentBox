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
		var wall = $("##errorBar").addClass("infoBarRed").fadeIn();
		// remove all existing messages
		wall.html("");
		// Init messages
		wall.append( "<h1>Cannot continue installation, please fix the following errors:</h1><ul>" );
		// add new errors
		$.each(errors, function(index, error) {
			wall.append(
				"<li><strong>" +error.input.attr("name")+ "</strong> " + error.messages[0] + "</li>"
			);
		});
		wall.append( "</ul>" );
	 
	// the effect does nothing when all inputs are valid
	}, function(inputs)  {
	 
	});
});
function nextStep(){
	$("ul.vertical_nav").data("tabs").next();
}
function prevStep(){
	$("ul.vertical_nav").data("tabs").prev();
}
</script>
</cfoutput>