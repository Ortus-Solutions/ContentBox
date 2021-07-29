<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$passwordResetForm 	= $( "##passwordResetForm" );

	// initialize validator and add a custom form submission logic
	$passwordResetForm.validate();

    // Custom Password Validator
    $.validator.addMethod(
    	'pwcheck',
    	passwordValidator,
		'#cb.r( "resetpassword.confirm@security" )#'
	);

    // Password match validator
    $.validator.addMethod(
    	'password',
    	function( value, element ){
        	return (value==$( "[name=password]" ).val()) ? true : false;
    	},
    	'#cb.r( "resetpassword.match@security" )#'
    );

    // Validation
    $( "##passwordResetForm" ).validate();

	// Password change rules
	$( "##password" ).keyup( passwordMeter );
} );
</script>
</cfoutput>