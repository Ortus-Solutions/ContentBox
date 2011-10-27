/*
* An avatar plugin for ContentBox
*/
component extends="coldbox.system.Plugin" singleton{

	function init(controller){
		super.init(controller);
		
		setpluginName("Avatar");
  		setpluginVersion("1.0");
  		setpluginDescription("An avatar display plugin");
  		setPluginAuthor("Luis Majano");
  		setPluginAuthorURL("http://www.ortussolutions.com");
  		
  		//Return instance
  		return this;		
	}
	
	/**
	* Render an avatar image
	*/
	function renderAvatar(required email,numeric size=80){
		var avatar 		= "";
		var emailTarget = arguments.email;
		var prc = getRequestCollection(private=true);
		
		// check settings
		if( NOT prc.cbSettings.cb_gravatar_display ){ return ""; }
		
		// render it out
		savecontent variable="avatar"{
			writeOutput('<img class="gravatar" align="middle" src="http://www.gravatar.com/avatar.php?gravatar_id=#lcase(Hash(emailTarget))#&s=#arguments.size#&r=#prc.cbSettings.cb_gravatar_rating#" alt="Cool Gravatar" />');
		}
		
		return avatar;
	}

}
