﻿/*
* An avatar plugin for ContentBox
*/
component extends="coldbox.system.Plugin" singleton{

	/**
	*  Constructor
	*/
	function init( required controller ){
		super.init( controller );
		
		setpluginName( "Avatar" );
  		setpluginVersion( "1.0" );
  		setpluginDescription( "An avatar display plugin" );
  		setPluginAuthor( "Luis Majano" );
  		setPluginAuthorURL( "http://www.ortussolutions.com" );
  		
  		//Return instance
  		return this;		
	}
	
	/**
	* Render an avatar image
	* @email.hint THe email to render
	* @size.hint The pixel size, defautls to 80
	*/
	function renderAvatar( required email, numeric size=80 ){
		var avatar 		= "";
		var emailTarget = arguments.email;
		var prc 		= getRequestCollection( private=true );
		
		// check settings
		if( NOT prc.cbSettings.cb_gravatar_display ){ return ""; }
		
		// render it out
		savecontent variable="avatar"{
			writeOutput('<img class="gravatar" align="middle" width="#arguments.size#" height="#arguments.size#" src="//www.gravatar.com/avatar.php?gravatar_id=#lcase(Hash(emailTarget))#&s=#arguments.size#&r=#prc.cbSettings.cb_gravatar_rating#" />');
		}
		
		return avatar;
	}

}
