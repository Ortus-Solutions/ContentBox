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
                            <img class="img-scaled" src="#rc.imageSrc#?nocahe=#Rand()#" id="cropbox">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="widget-arguments" id="widget-arguments">
                        <form class="form" action="" method="post">
                            <legend>Crop image</legend>
                            <div class="" id="collapseCrop">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="x">X</label>
                                        <input disabled="disabled" type="text" class="form-control" id="x" name="x">
                                    </div>                                    
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstname">Y</label>
                                        <input disabled="disabled" type="text" class="form-control" id="y" name="y">
                                    </div>    
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstname">Width</label>
                                        <input disabled="disabled" type="text" class="form-control" id="w" name="w">
                                    </div>                                    
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstname">Height</label>
                                        <input disabled="disabled" type="text" class="form-control" id="h" name="h">
                                    </div>    
                                </div>
                                <input type="hidden" size="4" id="x2" name="x2" />
                                <input type="hidden" size="4" id="y2" name="y2" />
                                <input type="hidden" name="imageName"
                                        id="imageName" value="#rc.imageName#" />
                                <input type="hidden" name="imageFile"
                                        id="imageFile" value="" />
                                <input type="hidden" name="imagePath"
                                        id="imagePath" value="#rc.imagePath#" />
                                <button type="button" class="btn btn-primary" disabled="disabled"
                                        id="imageCrop_btn" value="Crop the image">Crop the image</button>
                                <button type="button" class="btn btn-primary" disabled="disabled"
                                        id="imageDeselect_btn" value="Crop the image">Deselect</button>
                                <button type="button" class="btn btn-primary" disabled="disabled"
                                        id="revert_btn" value="Revert to original"><i class="fa fa-reply"></i>Revert to original</button>
                            </div>
                        </form>
                        </div>

                        <div class="widget-arguments" id="widget-arguments">
                        <form action="" method="post">
                            <legend>Resize image </legend>
                            <div class="" id="">
                                <div class="form-group">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="width">Width</label>
                                            <input value="#rc.width#" 
                                                    data-width="#rc.width#" 
                                                    type="text" 
                                                    class="form-control" 
                                                    id="width" 
                                                    name="width" 
                                                    onkeyup="calculateProportions(0)">
                                        </div>    
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="height">Height</label>
                                            <input value="#rc.height#" 
                                                    data-height="#rc.height#" 
                                                    type="text" 
                                                    class="form-control input-sm" 
                                                    id="height" 
                                                    name="height" 
                                                    onkeyup="calculateProportions(1)">
                                        </div>    
                                    </div>

                                </div>
                                <button type="button" class="btn btn-primary" disabled="disabled"
                                        id="scale_btn" value="Scale">Scale</button>
                                <button type="button" class="btn btn-primary" disabled="disabled"
                                        id="revert_scale" value="Revert to original"><i class="fa fa-reply"></i>Revert to original</button>
                            </div>
                        </form>
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
                        <button class="btn btn-info" id="imagesave">Save image</button>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
