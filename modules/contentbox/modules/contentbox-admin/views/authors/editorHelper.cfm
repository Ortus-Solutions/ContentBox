<cfoutput>
<!--- Custom JS --->
<script>
$( document ).ready( function(){
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

    // Custom Password Validator
    $.validator.addMethod( 
    	"pwcheck", 
    	function( value ){

			var LOWER 	= /[a-z]/,
			    UPPER 	= /[A-Z]/,
			    DIGIT 	= /[0-9]/,
			    DIGITS 	= /[0-9].*[0-9]/,
			    SPECIAL = /[^a-zA-Z0-9]/;
			
			var lower 	= LOWER.test(value),
			    upper 	= UPPER.test(value),
			    digit 	= DIGIT.test(value),
			    digits 	= DIGITS.test(value),
			    special = SPECIAL.test(value);

			return lower // has a lowercase letter
			   && upper // has an uppercase letter
			   && digit // has at least one digit
			   && special // has special chars
		           && value.length > 7 // at least 8 chars
		}, 
		'Password should be at least 8 characters long and should contain at least 1 digit, 1 uppercase, 1 lowercase and 1 special chars' 
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
	$permissionsTab = $( "##permissionsTab" );
	</cfif>
	
} );
function isUsernameFound(username){
	var usernameFound = false;
	$.ajax( {
		url:'#event.buildLink(prc.xehUsernameCheck)#',
		data: {username: username},
		async:false,
		success: function(data){
			usernameFound = data;
		},
		dataType:"json"
	} );
	return usernameFound;
}
<cfif prc.author.isLoaded()>
function loadPermissions(){
	$permissionsTab.load('#event.buildLink(prc.xehAuthorPermissions)#/authorID/'+#prc.author.getAuthorID()#);
}
</cfif>
</script>
</cfoutput>