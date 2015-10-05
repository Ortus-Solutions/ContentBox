/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A convenient way to create a Bootstrap-themed file upload field
*/
component {

    // DI
    property name="html"		inject="HTMLHelper@coldbox";

    /**
    *  Constructor
    */
    BootstrapFileUpload function init(){
        //Return instance
        return this;        
    }
    
    /**
     * Main method for rendering bootstrap-themed file upload field
     * @name.hint The name of the file field to create
     * @required.hint Whether or not the field is required (validation)
     * @id.hint The id to apply to the file field
     * @label.hint If specified, will create a label element with the specified text for the file field
     * @columnWidth.hint The number of columns that the field should occupy (bootstrap grid system)
     * @useRemoveButton.hint Whether a "remove" button should be created
     * @selectButtonText.hint The text to use for the "select" button
     * @changeButtonText.hint The text to use for the "change" button
     * @removeButtonText.hint The text to use for the "remove" button
     */
    public string function renderIt( 
        required string name,
        boolean required=true,
        string id="",
        string label, 
        numeric columnWidth=3,
        useRemoveButton=true,
        selectButtonText="Select file",
        changeButtonText="Change",
        removeButtonText="Remove"
    ) {
        savecontent variable="renderedContent" {
            writeoutput(
                '<div class="form-group"><div class="controls">'
            );
            if( structKeyExists( arguments, "label" ) and len( arguments.label ) ) {
                writeoutput(
                    '#html.label( field="#arguments.name#", content="#arguments.label#", class="control-label" )#'
                );
            }
            writeoutput('
                <div class="fileinput fileinput-new input-group" data-provides="fileinput">
                    <div class="form-control" data-trigger="fileinput">
                        <i class="fa fa-file fileinput-exists"></i> <span class="fileinput-filename"></span>
                    </div>
                    <span class="input-group-addon btn btn-default btn-file">
                        <span class="fileinput-new">#arguments.selectButtonText#</span>
                        <span class="fileinput-exists">#arguments.changeButtonText#</span>
                        #html.fileField( name="#arguments.name#", required=arguments.required, id="#arguments.id#" )#
                    </span>
            ');
            if( arguments.useRemoveButton ) {
                writeoutput(
                    '<a href="##" class="input-group-addon btn btn-default fileinput-exists" data-dismiss="fileinput">#arguments.removeButtonText#</a>'
                );                
            }
            writeoutput(
                '</div></div></div>'
            );
        }
        return renderedContent;
    }
}
