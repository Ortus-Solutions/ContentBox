/*
* An avatar model object for ContentBox
*/
component singleton{

	// DI
	property name="requestService" inject="coldbox:requestService";

	/**
	*  Constructor
	*/
	function init(){
  		return this;		
	}
	
	/**
	* Render an avatar image
	* @email.hint THe email to render
	* @size.hint The pixel size, defautls to 80
	* @class.hint An optional class to add
	*/
	function renderAvatar( required email, numeric size=80, string class="gravatar" ){
		var avatar 		= "";
		var emailTarget = arguments.email;
		var prc 		= requestService.getContext().getCollection( private=true );

		// check settings
		if( NOT prc.cbSettings.cb_gravatar_display ){ return ""; }

		// render it out
		savecontent variable="avatar"{
			writeOutput('<img class="#arguments.class#" align="middle" width="#arguments.size#" height="#arguments.size#" src="//www.gravatar.com/avatar.php?gravatar_id=#lcase(Hash(emailTarget))#&s=#arguments.size#&r=#prc.cbSettings.cb_gravatar_rating#" />');
		}
		
		return avatar;
	}

}
