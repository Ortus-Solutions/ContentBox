/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Service to handle menu operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton {
    // DI
    property name="populator" inject="wirebox:populator";
    property name="renderer" inject="provider:ColdBoxRenderer";
    property name="menuItemService" inject="id:menuItemService@cb";
    
    /**
    * Constructor
    */
    MenuService function init(){
        // init it
        super.init( entityName="cbMenu" );
        return this;
    }
    
    /**
    * Save a menu and do necessary updates
    * @menu.hint The menu to save or update
    * @originalSlug.hint If an original slug is passed, then we need to update hierarchy slugs.
    */
    function saveMenu( required any menu, string originalSlug="" ) transactional{
        // Verify uniqueness of slug
        if( !isSlugUnique( slug=arguments.menu.getSlug(), menuID=arguments.menu.getMenuID() ) ){
            // make slug unique
            arguments.menu.setSlug( getUniqueSlugHash( arguments.menu.getSlug() ) );
        }
        // Save the target menu
        save( entity=arguments.menu, transactional=false );
        return this;
    }
    
    /**
    * Menu search by title or slug
    * @searchTerm.hint Search in firstname, lastname and email fields
    * @max.hint The max returned objects
    * @offset.hint The offset for pagination
    * @asQuery.hint Query or objects
    * @sortOrder.hint The sort order to apply
    */
    function search(
        string searchTerm="",
        numeric max=0, 
        numeric offset=0, 
        boolean asQuery=false, 
        string sortOrder="title"
    ){
        var results = {};
        var c = newCriteria();
        // Search
        if( len( arguments.searchTerm ) ){
            c.$or( 
                c.restrictions.like("title","%#arguments.searchTerm#%"),
                c.restrictions.like("slug", "%#arguments.searchTerm#%") 
            );
        }
        // run criteria query and projections count
        results.count = c.count( "menuID" );
        results.menus = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
            .list( offset=arguments.offset, max=arguments.max, sortOrder=arguments.sortOrder, asQuery=arguments.asQuery );
    
        return results;
    }

    /**
     * Find a menu object by slug, if not found it returns a new menu object
     * @slug.hint The slug to search
     */
    function findBySlug( required any slug ){
        var c = newCriteria();
        // By criteria now
        var menu = c.isEq( "slug",arguments.slug ).get();
        // return accordingly
        return ( isNull( menu ) ? new() : menu );
    }

    /**
    * Get all data prepared for export
    */
    array function getAllForExport(){
        var result = [];
        var data = getAll();
        for( var menu in data ){
            arrayAppend( result, menu.getMemento() );   
        }
        return result;
    }
    
    /**
    * Returns an array of slugs of all the content objects in the system.
    */
    array function getAllSlugs(){
        var c = newCriteria();
        return c.withProjections( property="slug" )
            .list( sortOrder="slug asc" );
    }

    /**
    * Import data from a ContentBox JSON file. Returns the import log
    */
    string function importFromFile( required importFile, boolean override=false ){
        var data        = fileRead( arguments.importFile );
        var importLog   = createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
        
        if( !isJSON( data ) ){
            throw( message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
        }
        // deserialize packet: Should be array of { settingID, name, value }
        return  importFromData( deserializeJSON( data ), arguments.override, importLog );
    }
    
    /**
    * Import data from an array of structures of authors or just one structure of author 
    */
    string function importFromData( required importData, boolean override=false, importLog ){
        var allMenus        = [];
        var badDateRegex    = " -\d{4}$";
        
        // if struct, inflate into an array
        if( isStruct( arguments.importData ) ){
            arguments.importData = [ arguments.importData ];
        }
        // iterate and import
        for( var menu in arguments.importData ){
            // Get new or persisted
            var oMenu = this.findBySlug( menu.slug );
            oMenu = ( isNull( oMenu ) ? new() : oMenu );
            
            // date conversion tests
            menu.createdDate    = reReplace( menu.createdDate, badDateRegex, "" );            
            // populate content from data
            populator.populateFromStruct( target=oMenu, memento=menu, composeRelationships=false, exclude="menuItems" );
            // Compose Menu Items
            if( arrayLen( menu.menuItems ) ){
                oMenu.populateMenuItems( menu.menuItems );
            }
            // if new or persisted with override then save.
            if( !oMenu.isLoaded() ){
                arguments.importLog.append( "New menu imported: #menu.slug#<br>" );
                arrayAppend( allMenus, oMenu );
            }
            else if( oMenu.isLoaded() and arguments.override ){
                arguments.importLog.append( "Persisted menu overriden: #menu.slug#<br>" );
                arrayAppend( allMenus, oMenu );
            }
            else{
                arguments.importLog.append( "Skipping persisted menu: #menu.slug#<br>" );
            }
        } // end import loop

        // Save them?
        if( arrayLen( allMenus ) ){
            saveAll( allMenus );
            arguments.importLog.append( "Saved all imported and overriden menus!" );
        }
        else{
            arguments.importLog.append( "No menus imported as none where found or able to be overriden from the import file." );
        }
        return arguments.importLog.toString(); 
    }

    /**
    * Builds editable menu for interface
    * @menu.hint the menu to parse
    * @menuString.hint build-up string for menu content
    * @inChild.hint flag for whether the content item is being evaluated as itself, or as a child of another item
    */
    public String function buildEditableMenu( required array menu, required string menuString="", boolean inChild=false ) {
        // loop over menu items
        for( var item in arguments.menu ) {
            var skipItem = false;
            // if item has a parent, and it's being evaluated on the same level as its parent, skip it
            if( item.hasParent() && !inChild ) {
                skipItem = true;
            }
            // build out the item
            if( !skipItem ) {
                menuString &= '<li id="key_#item.getMenuItemID()#" class="dd-item dd3-item" data-id="#item.getMenuItemID()#">';
                // render default menu item
                var args = { menuItem=item, provider=item.getProvider() };
                savecontent variable="providerContent" {
                    writeOutput( renderer.get().renderView( 
                        view="menus/provider", 
                        module="contentbox-admin",
                        args = args
                    ));
                };
                menuString &= providerContent;
                // if this item has children, recursively call this method to build them out too
                if( item.hasChild() ) {
                    menuString &='<ol class="dd-list">';
                    menuString &= buildEditableMenu( menu=item.getChildren(), inChild=true );
                    menuString &='</ol>';
                }
                menuString &='</li>';   
            }
        }
        return menuString;
    }

    /**
    * Verify an incoming slug is unique or not
    * @slug.hint The slug to search for uniqueness
    * @menuID.hint Limit the search to the passed menuID usually for updates
    */
    function isSlugUnique(required any slug, any menuID=""){
        var c = newCriteria()
            .isEq( "slug", arguments.slug );
        
        if( len( arguments.menuID ) ){
            c.ne( "menuID", javaCast( "int", arguments.menuID ) );
        }

        return ( c.count() gt 0 ? false : true );
    }

    /**
    * Get a unique slug hash
    * @slug.hint The slug to make unique
    */
    private function getUniqueSlugHash( required string slug ){
        return "#arguments.slug#-#lcase( left( hash( now() ), 5 ) )#";
    }
}