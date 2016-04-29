/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A Media-based Menu Item
*/
component 	persistent="true" 
			entityName="cbMediaMenuItem" 
			table="cb_menuItem" 
			extends="contentbox.models.menu.item.BaseMenuItem" 
			discriminatorValue="Media"{
	
	/* *********************************************************************
	**                          DI                                  
	********************************************************************* */
	property name="provider" persistent="false" inject="contentbox.models.menu.providers.MediaProvider";
	
	/* *********************************************************************
	**                          PROPERTIES                                  
	********************************************************************* */
	
	property    name="mediaPath" 
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

	this.constraints[ "mediaPath" ] 	= { required = false, size = "1..255" };
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
		result[ "mediaPath" ] 	= getMediaPath();
		result[ "urlClass" ] 	= getURLClass();
		result[ "target" ] 		= getTarget();

		return result;
	}
}