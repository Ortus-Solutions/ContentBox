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
                            <img class="img-scaled" src="#rc.imageSrc#" id="cropbox">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="widget-arguments" id="widget-arguments">
                        <form action="" method="post">
                            <legend>Crop image</legend>
                            <input type="hidden" size="4" id="x" name="x" />
                            <input type="hidden" size="4" id="y" name="y" />
                            <input type="hidden" size="4" id="x2" name="x2" />
                            <input type="hidden" size="4" id="y2" name="y2" />
                            <input type="hidden" size="4" id="w" name="w" />
                            <input type="hidden" size="4" id="h" name="h" />
                            <p>Click on image to activate cropping</p>
                            <input type="hidden" name="imageFile"
                                    id="imageFile" value="" />
                            <button type="button" class="btn btn-primary" disabled="disabled"
                                    id="imageCrop_btn" value="Crop the image">Crop the image</button>
                            <button type="button" class="btn btn-primary" disabled="disabled"
                                    id="revert_btn" value="Revert to original"><i class="fa fa-reply"></i>Revert to original</button>
                        </form>
                        </div>

                        <div class="widget-arguments" id="widget-arguments">
                        <form action="" method="post">
                            <legend>Resize image</legend>
                            <div class="form-group">
                                <label class="control-label" for="width">Width</label>
                                <p>Original dimension: #rc.width# x #rc.height#</p>
                                <div class="controls">
                                <small>The new width</small><br>
                                <input type="text" 
                                    value="#rc.width#" 
                                    data-width="#rc.width#" 
                                    name="width" 
                                    size="35" 
                                    class="form-control" 
                                    onkeyup="calculateProportions(0)" 
                                    title="The string to show if the page does not exist" id="width">
                                </div>
                                <label class="control-label" for="width">Height</label>
                                <div class="controls">
                                <small>The new height</small><br>
                                <input type="text" 
                                    value="#rc.height#" 
                                    data-height="#rc.height#" 
                                    name="height" 
                                    size="35" 
                                    class="form-control" 
                                    onkeyup="calculateProportions(1)" 
                                    title="The string to show if the page does not exist" 
                                    id="height">
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary"
                                    id="scale_btn" value="Scale">Scale</button>
                            <button type="button" class="btn btn-primary" disabled="disabled"
                                    id="revert_scale" value="Revert to original"><i class="fa fa-reply"></i>Revert to original</button>
                        </form>
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
                        <button class="btn btn-info" id="widget-button-update">Save image</button>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
