<cfoutput>
    <div class="modal-dialog modal-lg" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4><span id="widget-title-bar"><i class="fa fa-image fa-lg fa-2x"></i> Image editor</span></h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <cfdump var="#prc.imgInfo#">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Close</a>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
