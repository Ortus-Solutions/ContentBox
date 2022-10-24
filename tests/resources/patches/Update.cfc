component {

	property name="log" inject="logbox:logger:{this}";

	function init(){
		return this;
	}

	/**
	 * pre installation
	 */
	function preInstallation(){
		variables.log.info( "Executing pre installation" );
	}

	/**
	 * post installation
	 */
	function postInstallation(){
		variables.log.info( "Executing post installation" );
	}

}
