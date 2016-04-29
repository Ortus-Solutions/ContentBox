/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A Content-based Menu Item
*/
component   persistent="true" 
			entityName="cbContentMenuItem" 
			table="cb_menuItem" 
			extends="contentbox.models.menu.item.BaseMenuItem" 
			discriminatorValue="Content"{

	/* *********************************************************************
	**                          DI                                  
	********************************************************************* */
	
	property name="provider"            persistent="false"  inject="contentbox.models.menu.providers.ContentProvider";
	property name="contentService"      persistent="false"  inject="id:contentService@cb";
	
	/* *********************************************************************
	**                          PROPERTIES                                  
	********************************************************************* */

	property    name="contentSlug" 
				notnull="false" 
				ormtype="string" 
				default="";

	property    name="target" 
				notnull="false" 
				ormtype="string" 
				default="";

	property    name="urlClass" 
				notnull="false" 
				ormtype="string" 
				default="";

	/* *********************************************************************
	**                          PK + CONSTRAINTS                                  
	********************************************************************* */

	this.constraints[ "contentSlug" ] 	= { required = false, size = "1..255" };
	this.constraints[ "target" ]	 	= { required = false, size = "1..255" };
	this.constraints[ "urlClass" ]		= { required = false, size = "1..255" };

	/* *********************************************************************
	**                          PUBLIC FUNCTIONS                                  
	********************************************************************* */

	/**
	 * Get a flat representation of this menu item
	 */
	public struct function getMemento(){
		var result = super.getMemento();
		
		// add our subclasses's properties
		result[ "contentSlug" ] = getContentSlug();
		result[ "urlClass" ] 	= getURLClass();
		result[ "target" ] 		= getTarget();

		return result;
	}

	/**
	 * Available precheck to determine display-ability of menu item
	 * @options.hint Additional arguments to be used in the method
	 */
	public boolean function canDisplay( required struct options={} ) {
		var display = super.canDisplay( argumentCollection=arguments );
		if( display ) {
			var content = contentService.findBySlug( getContentSlug() );
			var type = content.getContentType();
			return content.isLoaded() && ( type=="Page" || type=="Entry" ) ? true : false;
		}
		return display;        
	}
}