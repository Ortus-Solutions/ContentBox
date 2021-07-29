<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	// pointers
	$authorForm 	= $( "##authorForm" );
	$authorUsername = $authorForm.find( "##username" );

	// initialize validator and add a custom form submission logic
	$authorForm.validate();

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
</script>
</cfoutput>
