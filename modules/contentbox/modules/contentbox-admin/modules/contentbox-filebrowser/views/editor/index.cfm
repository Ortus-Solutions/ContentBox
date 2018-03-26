<cfoutput>
    <div class="modal-dialog modal-lg" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4><span id="widget-title-bar"><i class="fa fa-image fa-lg fa-2x"></i> Image editor</span></h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-8">
                        <div id="croppedImage">
                            <img class="img-scaled" src="#prc.imageSrc#?nocahe=#Rand()#" id="cropbox">
                        </div>
                    </div>
                    <div class="col-md-4">

                        <div class="tab-wrapper margin0">

                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="height">URL</label>
                                        <input value="#prc.imageSrc#" 
                                                type="text"
                                                readonly="readonly" 
                                                class="form-control input-sm">
                                    </div> 
                                    <ul>
                                        <li>File name: #rc.imageName#</li>
                                        <li>File type: #prc.fileType#</li>
                                        <li>Dimensions: #prc.width# x #prc.height#</li>
                                    </ul>   
                                </div>
                            </div>

                            <ul class="nav nav-tabs" role="tablist">
                             
                                    <li role="presentation" class="active">
                                        <a href="##crop" aria-controls="crop" role="tab" data-toggle="tab">
                                            <i class="fa fa-crop"></i> Crop
                                        </a>
                                    </li>

                                    <li role="presentation">
                                        <a href="##resize" aria-controls="seo" role="tab" data-toggle="tab">
                                            <i class="fa fa-arrows"></i> Resize
                                        </a>
                                    </li>

                                    <li role="presentation">
                                        <a href="##transform" aria-controls="history" role="tab" data-toggle="tab">
                                            <i class="fa fa-edit"></i> Transform
                                        </a>
                                    </li>
                                
                            </ul>


                            <div class="tab-content">

                                <div class="widget-arguments tab-pane active" role="tabpanel" id="crop">
                                    <form class="form" action="" method="post">
                                        <legend>Crop image</legend>

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
                                            <input type="checkbox" class="hidden" name="imgEdited"
                                                    id="imgEdited" />
                                            <input type="hidden" name="imagePath"
                                                    id="imagePath" value="#rc.imagePath#" />
                                            <button type="button" class="btn btn-primary" disabled="disabled"
                                                    id="imageCrop_btn" value="Crop the image">Crop the image</button>
                                            <button type="button" class="btn btn-primary" disabled="disabled"
                                                    id="imageDeselect_btn" value="Crop the image">Deselect</button>

                                    </form>
                                </div>

                                <div class="widget-arguments tab-pane" role="tabpanel" id="resize">
                                    <form action="" method="post">
                                        <legend>Resize image </legend>

                                            <div class="form-group">

                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="width">Width</label>
                                                        <input value="#prc.width#" 
                                                                data-width="#prc.width#" 
                                                                type="text" 
                                                                class="form-control" 
                                                                id="width" 
                                                                name="width" 
                                                                onkeyup="calculateProportions(0)">
                                                        <div class="help-block with-errors"></div>
                                                    </div>    
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="height">Height</label>
                                                        <input value="#prc.height#" 
                                                                data-height="#prc.height#" 
                                                                type="text" 
                                                                class="form-control input-sm" 
                                                                id="height" 
                                                                name="height" 
                                                                onkeyup="calculateProportions(1)">
                                                        <div class="help-block with-errors"></div>
                                                    </div>    
                                                </div>

                                            </div>
                                            <button type="button" class="btn btn-primary" disabled="disabled"
                                                    id="scale_btn" value="Scale">Scale</button>

                                    </form>
                                </div>

                                <div class="widget-arguments tab-pane" role="tabpanel" id="transform">
                                    <div class="btn-group-vertical" id="transformers">

                                                <button type="button" class="btn btn-primary transform"
                                                        id="rotate_right" value="90"><i class="fa fa-repeat"></i> Rotate right</button>
                                            

                                                <button type="button" class="btn btn-primary transform"
                                                        id="rotate_left" value="270"><i class="fa fa-undo"></i> Rotate left</button>
                                            

                                                <button type="button" class="btn btn-primary transform"
                                                        id="flip_left" value="vertical"><i class="fa fa-arrows-v"></i> Flip vertical</button>
                                            

                                                <button type="button" class="btn btn-primary transform"
                                                        id="flip_right" value="horizontal"><i class="fa fa-arrows-h"></i> Flip horizontal</button>
                                            

                                                <button type="button" class="btn btn-primary transform"
                                                        id="flip_diagonal" value="diagonal"><i class="fa fa-arrows-alt"></i> Flip diagonal</button>
                                            

                                                <button type="button" class="btn btn-primary transform"
                                                        id="flip_antidiagonal" value="antidiagonal"><i class="fa fa-arrows-alt"></i> Flip antidiagonal</button>
                                            

                                    </div>
                                </div>

                            </div>

                        </div>

                        <div class="widget-arguments">

                            <div class="form-group">

                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="overwrite">
                                        <input type="checkbox" id="over_write" name="over_write"> Overwrite</label>
                                    </div>    
                                </div>

                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="newname">
                                        <input type="checkbox" id="newname" name="newname"> Save as</label>
                                    </div>    
                                </div>

                                <div id="saver" class="col-md-12 hidden">
                                    <div class="form-group">
                                        <label for="saveAs">New name</label>
                                        <input value="" 
                                                type="text" 
                                                class="form-control input-sm" 
                                                id="saveAs" 
                                                name="saveAs"">
                                    </div>    
                                </div>

                            </div>

                            
                        </div>

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-danger" onclick="closeRemoteModal()">Cancel</a>
                        <button type="button" class="btn btn-primary" disabled="disabled"
                                                    id="revert_btn" value="Undo"><i class="fa fa-reply"></i> Undo</button>
                        <button class="btn btn-info" disabled="disabled" id="imagesave">Save image</button>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
