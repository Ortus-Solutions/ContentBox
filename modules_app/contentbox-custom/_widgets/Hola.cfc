/**
* A widget that shows you a 'hello world'
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	function init(){
		// Widget Properties
		setName( "Hola" );
		setVersion( "1.0.0" );
		setDescription( "A hello world widget" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "https://www.ortussolutions.com" );
        setIcon( "info" );
        
		return this;
	}

	/**
	 * Give you a nice welcome in Spanish
	 * @titleLevel The H{level} to use, by default we use H2
	 */
	any function renderIt( string titleLevel="2" ){
		var rString	= "";

		saveContent variable="rString"{
			writeOutput( "<h#arguments.titleLevel#>Hola mi amigo!</h#arguments.titleLevel#>" );
		}

		return rString;
	}

}