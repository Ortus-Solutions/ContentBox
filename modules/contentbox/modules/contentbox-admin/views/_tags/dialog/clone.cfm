<cfoutput>
<div id="cloneDialog" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="cloneTitle" aria-hidden="true">
    <div class="modal-dialog" role="document" >
        <div class="modal-content">
            <!--header-->
            <div class="modal-header">
                <!--if dismissable-->
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="cloneTitle"><i class="fa fa-copy"></i> #args.title#</h4>
            </div>
            <div class="modal-body" id="remoteModelContent">
                <!--body-->
                #html.startForm( name="cloneForm", action="#args.action#", class="form-vertical", role="form" )#
                    <div class="modal-body">
                        <p>#args.infoMsg#</p>
                        #html.hiddenField(name="contentID" )#
                        #html.textfield(
                            name="title", 
                            label="#args.titleLabel#", 
                            class="form-control", 
                            required="required", 
                            size="50",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <label for="contentStatus">#args.publishLabel#</label>
                        <small>#args.publishInfo#</small><br>
                        #html.select(
                            options="true,false", 
                            name="#args.statusName#", 
                            selectedValue="false", 
                            class="form-control input-sm valid",
                            wrapper="div class=controls",
                            labelClass="control-label",
                            groupWrapper="div class=form-group"
                        )#
                        <!---Notice --->
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle fa-lg"></i> Please note that cloning is an expensive process, so please be patient.
                        </div>
                    </div>
                #html.endForm()#
            </div>
            <!-- footer -->
            <div class="modal-footer">
                <!--- Button Bar --->
                <div id="cloneButtonBar">
                    <button class="btn btn-default" id="closeButton" data-dismiss="modal" type="button"> Cancel </button>
                    <button class="btn btn-danger" id="cloneButton" type="button"> Clone </button>
                </div>
                <!--- Loader --->
                <div class="center loaders" id="clonerBarLoader">
                    <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
                    <br>Please wait, doing some hardcore cloning action...
                </div>
            </div>
        </div>
    </div>
</div>
</cfoutput>