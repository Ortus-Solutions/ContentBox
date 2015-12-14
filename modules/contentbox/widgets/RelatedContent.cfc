/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A nice widget that shows related content for the content
*/
component extends="contentbox.models.ui.BaseWidget" singleton{

    RelatedContent function init(){
        // Widget Properties
        setName( "Related Content" );
        setVersion( "1.0" );
        setDescription( "A nice widget to display your content's related content." );
        setAuthor( "Ortus Solutions" );
        setAuthorURL( "http://www.ortussolutions.com" );
        setIcon( "sitemap" );
        setCategory( "Content" );
        return this;
    }

    /**
    * Show the blog categories
    * @dropdown.hint Display as a dropdown or a list, default is list
    * @emptyMessage.hint Message to show when no related content is found
    * @title.hint The title to show before the dropdown or list, defaults to H2
    * @titleLevel.hint The H{level} to use, by default we use H2
    */
    any function renderIt(
        boolean dropdown=false,
        string emptyMessage = "Sorry, no related content was found.",
        string title="",
        string titleLevel="2"
    ) {
        var relatedContent = cb.getCurrentRelatedContent();
        var content = "";

        // handle related content
        saveContent variable="content"{
            // title
            if( len( arguments.title ) ){ 
                writeoutput( "<h#arguments.titleLevel#>#arguments.title#</h#arguments.titleLevel#>" ); 
            }
            if( arrayLen( relatedContent ) ) {
                // build type
                if( arguments.dropdown ){
                    writeoutput( buildDropDown( relatedContent ) );
                }
                else{
                    writeoutput( buildList( relatedContent ) );
                }
            }
            else {
                writeoutput( "<p>#arguments.emptyMessage#</p>" );
                if( cb.isPreview() ) {
                    writeoutput( "<small>NOTE: Related content may not appear in preview mode!</small>" );
                }
            }
        }
        return content;
    }

    private function buildDropDown( required array relatedContent ){
        var content = "";
        // generate related content
        saveContent variable="content"{
            writeoutput('<select name="relatedcontent" id="relatedcontent" onchange="window.location=this.value"><option value="##">Select Content</option>');
            // iterate and create
            for( var x=1; x lte arrayLen( arguments.relatedContent ); x++ ){
                // only show links for published content!
                if( relatedContent[ x ].isContentPublished() ){
                    writeoutput( 
                        '<option value="#cb.linkContent( arguments.relatedContent[ x ])#">#arguments.relatedContent[ x ].getTitle()#' 
                    );
                    writeoutput('</option>');
                }
            }
            // close ul
            writeOutput( "</select>" );
        }
        return content;
    }

    private function buildList( required array relatedContent ){
        var content = "";
        // generate related content
        saveContent variable="content"{
            writeoutput( '<ul id="relatedcontent">' );
            // iterate and create
            for( var x=1; x lte arrayLen( arguments.relatedContent ); x++ ){
                // only show links for published content!
                if( relatedContent[ x ].isContentPublished() ){
                    writeoutput(
                        '<li class="relatedcontent"><a href="#cb.linkContent( arguments.relatedContent[ x ] )#">#arguments.relatedContent[ x ].getTitle()#'
                    );
                    writeOutput( '</a></li>' );
                }
            }
            // close ul
            writeoutput( "</ul>" );
        }
        return content;
    }

}
