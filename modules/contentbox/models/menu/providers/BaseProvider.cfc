/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Base Provider
 */
component accessors="true" {

	/* *********************************************************************
	 **                      DI
	 ********************************************************************* */

	property name="renderer" inject="coldbox:renderer";

	/* *********************************************************************
	 **                      PROPERTIES
	 ********************************************************************* */

	property name="name" type="string";

	property name="entityName" type="string";

	property name="type" type="string";

	property name="iconClass" type="string";

	property name="description" type="string";

	/* *********************************************************************
	 **                      PUBLIC FUNCTIONS
	 ********************************************************************* */

	/**
	 * Gets the name of the menu item provider
	 */
	public string function getName(){
		return name;
	}

	/**
	 * Gets the entityName for the menu item provider
	 */
	public string function getEntityName(){
		return entityName;
	}

	/**
	 * Gets the name of the menu item provider
	 */
	public string function getType(){
		return type;
	}

	/**
	 * Gets the iconCls of the menu item provider
	 */
	public string function getIconClass(){
		return iconClass;
	}

	/**
	 * Gets the description of the menu item provider
	 */
	public string function getDescription(){
		return description;
	}

}
