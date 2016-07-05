<cfoutput>
    <div class="modal-dialog modal-lg" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4><span id="widget-title-bar"><i class="fa fa-image fa-lg fa-2x"></i> Image editor</span></h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-9">
                        <div id="croppedImage">
                            <img class="img-scaled" src="#rc.imageUrl#" id="cropbox">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <form action="crop.cfm" method="post">
                            <input type="hidden" size="4" id="x" name="x" />
                            <input type="hidden" size="4" id="y" name="y" />
                            <input type="hidden" size="4" id="x2" name="x2" />
                            <input type="hidden" size="4" id="y2" name="y2" />
                            <input type="hidden" size="4" id="w" name="w" />
                            <input type="hidden" size="4" id="h" name="h" />

                            <input type="hidden" name="imageFile"
                                    id="imageFile" value="" />
                            <button type="button" class="btn btn-primary" disabled="disabled"
                                    id="imageCrop_btn" value="Crop the image">Crop the image</button>
                            <button type="button" class="btn btn-primary" disabled="disabled"
                                    id="revert_btn" value="Revert to original">Revert to original</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
                        <button class="btn btn-info" id="widget-button-update">Update Widget</button>
                        <a id="widget-button-close" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Close</a>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
