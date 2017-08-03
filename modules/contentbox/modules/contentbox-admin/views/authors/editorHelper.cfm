<cfoutput>
<!--- Custom JS --->
<script>
$( document ).ready( function(){
	// pointers
	$authorForm 	= $( "##authorForm" );
	$twofactorForm 	= $( "##twofactorForm" );
	$authorUsername = $authorForm.find( "##username" );

	// initialize validator and add a custom form submission logic
	$authorForm.validate();
	$twofactorForm.validate();

	// Custom username unique validator
    $.validator.addMethod(
    	'username',
    	function( value, element ) {
			if( value.length && value == "#prc.author.getUsername()#" ){
				return true;
			}
			// verify username
			if( isUsernameFound( value ) ){
				return false;
			}
			return true;
    	},
    	"The username you entered already exists, try a new one!"
    );

    // Custom email unique validator
    $.validator.addMethod(
    	'email',
    	function( value, element ) {
			if( value.length && value == "#prc.author.getEmail()#" ){
				return true;
			}
			// verify email
			if( isEmailFound( value ) ){
				return false;
			}
			return true;
    	},
    	"The email you entered already exists, try a new one!"
    );

    // Custom Password Validator
    $.validator.addMethod(
    	"pwcheck",
    	passwordValidator,
		'Password should be at least #prc.cbSettings.cb_security_min_password_length# characters long and should contain at least 1 digit, 1 uppercase, 1 lowercase and 1 special chars' 
	);

	<cfif prc.author.isLoaded()>
    $( "##authorPasswordForm" ).validate();

    // Password match validator
    $.validator.addMethod(
    	'password',
    	function( value, element ){
        	return (value==$( "[name=password]" ).val()) ? true : false;
    	},
    	'Passwords need to match'
    );

	// Setup Permissions
	$permissions = $( "##permissions" );
	</cfif>

	// Password change rules
	$( "##password" ).keyup( passwordMeter );
} );
function isUsernameFound( username ){
	var usernameFound = false;
	$.ajax( {
		url    		: '#event.buildLink( prc.xehUsernameCheck )#',
		data   		: { username : username },
		async  		: false,
		success		: function( data ){
			usernameFound = data;
		},
		dataType    : "json"
	} );
	return usernameFound;
}
function isEmailFound( email ){
	var emailFound = false;
	$.ajax( {
		url    		: '#event.buildLink( prc.xehEmailCheck )#',
		data   		: { email : email },
		async  		: false,
		success		: function( data ){
			emailFound = data;
		},
		dataType    : "json"
	} );
	return emailFound;
}
<cfif prc.author.isLoaded()>
function loadPermissions(){
	$permissions.load( '#event.buildLink( prc.xehAuthorPermissions )#/authorID/' + #prc.author.getAuthorID()# );
}
</cfif>
</script>
</cfoutput>
