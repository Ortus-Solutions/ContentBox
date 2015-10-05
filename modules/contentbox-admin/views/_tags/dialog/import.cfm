<cfoutput>
<div id="importDialog" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="importTitle" aria-hidden="true">
    <!--header-->
    <div class="modal-header">
        <!--if dismissable-->
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="importTitle"><i class="fa fa-copy"></i> #args.title#</h4>
    </div>
    <!--body-->
    <div class="modal-body">
        #html.startForm(name="importForm", action="#args.action#", class="form-vertical", multipart=true, role="form" )#
            <p>#args.contentInfo#</p>
    
            #getModel( "BootstrapFileUpload@contentbox-admin" ).renderIt( 
                name        = "importFile",
                required    = true
            )#      
            
            <label for="overrideContent">Override content?</label>
            <small>By default all content that exist are NOT overwritten.</small><br>
            #html.select(
                options="true,false", 
                name="overrideContent", 
                selectedValue="false", 
                class="form-control input-sm valid", 
                wrapper="div class=controls", 
                labelClass="control-label", 
                groupWrapper="div class=form-group"
            )#
            <!---Notice --->
            <div class="alert alert-info">
                <i class="fa fa-info-circle fa-lg"></i> Please note that import is an expensive process, so please be patient when importing.
            </div>
        #html.endForm()#
    </div>
    <!-- footer -->
    <div class="modal-footer">
        <!--- Button Bar --->
        <div id="importButtonBar">
            <button class="btn btn-default" id="closeButton" data-dismiss="modal"> Cancel </button>
            <button class="btn btn-danger" id="importButton"> Import </button>
        </div>
        <!--- Loader --->
        <div class="center loaders" id="importBarLoader">
            <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
            <br>Please wait, doing some hardcore importing action...
        </div>
    </div>
</div>
</cfoutput>