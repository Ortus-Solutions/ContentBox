/**
* A widget that can render out ContentBox menus
*/
component extends="contentbox.model.ui.BaseWidget" singleton {

    Menu function init( controller ){
        // super init
        super.init( controller );

        // Widget Properties
        setPluginName( "Menu" );
        setPluginVersion( "1.0" );
        setPluginDescription( "A widget that can render out a ContentBox menu anywhere you like." );
        setPluginAuthor( "Ortus Solutions" );
        setPluginAuthorURL( "http://www.ortussolutions.com" );
        setIcon( "list.png" );
        setCategory( "Content" );
        return this;
    }

    /**
    * Renders a ContentBox menu by slug name
    * @slug.hint The menu slug to render
    * @slug.optionsUDF getSlugList
    * @defaultValue.hint The string to show if the menu does not exist
    */
    any function renderIt( required string slug, string defaultValue ){
        var menu = menuService.findWhere( { slug=arguments.slug } );

        if( !isNull( menu ) ){
            try {
                savecontent variable="menuContent" {
                    writeoutput( "#cb.menu( slug=arguments.slug, type="html" )#" );
                }
            }
            catch( any e ) {
                return arguments.defaultValue;
            }
            return menuContent;            
        }

        // default value
        if( structKeyExists( arguments, "defaultValue" ) ){
            return arguments.defaultValue;
        }

        throw( message="The menu slug '#arguments.slug#' does not exist", type="MenuWidget.InvalidMenuSlug" );
    }

    /**
    * Return an array of slug lists, the @ignore annotation means the ContentBox widget editors do not use it only used internally.
    * @cbignore
    */ 
    array function getSlugList(){
        return menuService.getAllSlugs();
    }
}