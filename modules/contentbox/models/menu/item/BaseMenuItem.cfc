/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Base entity for all subclasses of Menu Items
*/
component   persistent="true" 
			entityName="cbMenuItem" 
			table="cb_menuItem" 
			extends="contentbox.models.BaseEntityMethods"
			cachename="cbMenuItem" 
			cacheuse="read-write" 
			discriminatorColumn="menuType"{
	
	/* *********************************************************************
	**                          DI                                  
	********************************************************************* */

	property name="menuItemService" inject="menuItemService@cb" persistent="false";

	/* *********************************************************************
	**							PROPERTIES due to CF9 Bug									
	********************************************************************* */

	property 	name="createdDate" 	
				type="date"
				ormtype="timestamp"
				notnull="true"
				update="false"
				index="idx_createDate";

	property 	name="modifiedDate"	
				type="date"
				ormtype="timestamp"
				notnull="true"
				index="idx_modifiedDate";

	property 	name="isDeleted"		
				ormtype="boolean"
				sqltype="bit" 	
				notnull="true" 
				default="false" 
				dbdefault="0" 
				index="idx_deleted";
	
	/* *********************************************************************
	**                          PROPERTIES                                  
	********************************************************************* */

	property    name="menuItemID"
				fieldtype="id"
				generator="native"
				setter="false"
				params="{ allocationSize = 1, sequence = 'menuItemID_seq' }";

	property    name="title"   
				notnull="true"  
				ormtype="string" 
				length="200" 
				default="" 
				index="idx_menuitemtitle";

	property    name="label"   
				notnull="false" 
				ormtype="string" 
				length="200" 
				default="";

	property    name="itemClass"     
				notnull="false" 
				ormtype="string" 
				length="200" 
				default="";
	
	property    name="data"    
				notnull="false" 
				ormtype="string" 
				default="";

	property    name="active"  
				ormtype="boolean" 
				default="true";

	property    name="menuType" 
				insert="false" 
				update="false";
	
	/* *********************************************************************
	**                          RELATIONSHIPS                                  
	********************************************************************* */

	// M20 - Owning menu
	property    name="menu" 
				cfc="contentbox.models.menu.Menu" 
				fieldtype="many-to-one" 
				fkcolumn="FK_menuID" 
				lazy="true" 
				fetch="join" 
				notnull="true";
		
	// M20 - Parent Menu item
	property    name="parent" 
				cfc="BaseMenuItem" 
				fieldtype="many-to-one" 
				fkcolumn="FK_parentID" 
				lazy="true";
	
	// O2M - Child Menu Item
	property    name="children" 
				singularName="child" 
				fieldtype="one-to-many" 
				type="array" 
				lazy="extra" 
				batchsize="25" 
				cfc="BaseMenuItem" 
				fkcolumn="FK_parentID" 
				inverse="true" 
				cascade="all-delete-orphan";
	
	/* *********************************************************************
	**                          PK + CONSTRAINTS                                  
	********************************************************************* */

	this.pk = "menuItemID";

	this.constraints = {
		"title" 				= { required = true, size = "1..200" },
		"label"	 				= { required = false, size = "1..200" },
		"itemClass"				= { required = false, size = "1..200" },
		"data"					= { required = false, size = "1..255" }
	};

	/* *********************************************************************
	**                          CONSTRUCTOR                                  
	********************************************************************* */

	/**
	* constructor
	*/
	BaseMenuItem function init(){
		variables.active 	= true;
		variables.children 	= [];

		super.init();
		
		return this;
	}

	/* *********************************************************************
	**                          PUBLIC FUNCTIONS                                  
	********************************************************************* */

	/**
	 * Get a flat representation of this menu item
	 * @excludes Exclude properties
	 */
	public struct function getMemento( excludes="" ){
		var pList = listToArray( arrayToList( menuItemService.getPropertyNames() ) );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		// add contentType
		result[ "menuType" ] = getMenuType();
		// set empty children
		result[ "children" ] = [];
		// remove parent...we'll rationalize the relationships via "children"
		structDelete( result, "parent" );
		// Children
		if( hasChild() ){
			result[ "children" ] = [];
			for( var thisChild in variables.children ){
				arrayAppend( result[ "children" ], thisChild.getMemento() );    
			}
		}
		return result;
	}

	/**
	 * Get a handy, formatted string of attributes that are applicable for the current menu item
	 */
	public string function getAttributesAsString() {
		var str = "";
		var title = !isNull( getTitle() ) ? getTitle() : "";
		var cls   = !isNull( getItemClass() ) ? getItemClass() : "";
		var data  = !isNull( getData() ) ? getData() : "";
		// handle title
		if( len( title ) ) {
			str &= ' title="#HTMLEditFormat( title )#"';
		}
		// handle cls
		if( len( cls ) ) {
			str &= ' class="#HTMLEditFormat( cls )#"';
		}
		// handle data
		if( len( data ) ) {
			// try json first
			if( isJSON( data ) ) {
				// deserialize so we can handle as object
				var pairs = deserializeJSON( data );
				// append all data attributes
				if( isStruct( pairs ) ) {
					for( dataKey in pairs ){
						if( isSimplevalue( pairs[ dataKey ] ) && len( pairs[ dataKey ] ) ){
							str &= ' data-#lcase( dataKey )#="#HTMLEditFormat( pairs[ datakey ] )#"';
						}
					}
				}
			}
			// try alternate format
			if( listLen( data, "," ) ) {
				for( var item in listToArray( data, "," ) ) {
					var splitVal = listToArray( item, "=" );
					if( arrayLen( splitVal ) > 1 ) {
						if( isSimplevalue( splitVal[ 2 ] ) ){
							str &= ' data-#lcase( splitVal[ 1 ] )#="#HTMLEditFormat( splitVal[ 2 ] )#"';
						}
					}
				}
			}
		}
		return str;
	}

	/**
	 * Available precheck to determine display-ability of menu item
	 * @options.hint Additional arguments to be used in the method
	 */
	public boolean function canDisplay( required struct options={} ) {
		return getActive();
	}
}