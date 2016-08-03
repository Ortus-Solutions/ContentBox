/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A JavaScript-based Menu Item
*/
component   persistent="true" 
			entityName="cbJSMenuItem" 
			table="cb_menuItem" 
			extends="contentbox.models.menu.item.BaseMenuItem" 
			discriminatorValue="JS"{

	/* *********************************************************************
	**                          DI                                  
	********************************************************************* */
	
	property name="provider" persistent="false" inject="contentbox.models.menu.providers.JSProvider";
	
	/* *********************************************************************
	**                          PROPERTIES                                  
	********************************************************************* */
	
	property    name="js" 
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

	this.constraints[ "js" ]		 	= { required = false, size = "1..255" };
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
		result[ "js" ] 			= getJS();
		result[ "urlClass" ] 	= getURLClass();
		
		return result;
	}
}