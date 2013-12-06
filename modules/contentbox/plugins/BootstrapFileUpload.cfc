/*
* A convenient way to create a Bootstrap-themed file upload field
*/
component extends="coldbox.system.Plugin" {
    property name="html" inject="coldbox:plugin:HTMLHelper";

    /**
    *  Constructor
    */
    BootstrapFileUpload function init( required controller ){
        super.init( controller );
        
        setpluginName( "Bootstrap File Upload Field" );
        setpluginVersion( "1.0" );
        setpluginDescription( "A convenient way to create a Bootstrap-themed file upload field" );        
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
                '<div class="control-group"><div class="controls">'
            );
            if( structKeyExists( arguments, "label" ) and len( arguments.label ) ) {
                writeoutput(
                    '#html.label( field="#arguments.name#", content="#arguments.label#", class="control-label" )#'
                );
            }
            writeoutput('
                <div class="fileupload fileupload-new" data-provides="fileupload">
                    <div class="input-append textfield">
                        <div class="uneditable-input span#arguments.columnWidth#">
                            <i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span>
                        </div>
                        <span class="btn btn-file">
                            <span class="fileupload-new">#arguments.selectButtonText#</span>
                            <span class="fileupload-exists">#arguments.changeButtonText#</span>
                            #html.fileField( name="#arguments.name#", required=arguments.required, id="#arguments.id#" )#
                        </span>
            ');
            if( arguments.useRemoveButton ) {
                writeoutput(
                    '<a href="##" class="btn fileupload-exists" data-dismiss="fileupload">#arguments.removeButtonText#</a>'
                );                
            }
            writeoutput(
                '</div></div></div></div>'
            );
        }
        return renderedContent;
    }
}
