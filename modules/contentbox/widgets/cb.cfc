/**
* A proxy to our ContentBox Helper Object
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

	cb function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setName( "CBHelper" );
		setVersion( "1.0" );
		setDescription( "A proxy to our CBHelper object" );
		setAuthor( "Ortus Solutions" );
		setAuthorURL( "http://www.ortussolutions.com" );
		setIcon( "wrench-add.png" );
		setCategory( "Utilities" );
		return this;
	}

	/**
	* Shows the CB Helper Motto
	*/
	any function renderIt(){
		return "CBHelper Rocks!";
	}

	/**
	* Proxy into the CB Helper
	*/
	any function onMissingMethod(missingMethodName,missingMethodArguments){
		return evaluate( "variables.cb.#missingMethodName#(argumentCollection=arguments.missingMethodArguments)" );
	}


}
