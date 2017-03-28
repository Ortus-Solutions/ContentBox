<cfoutput>
<script>
	// This code is taken from: https://www.monkehworks.com/image-cropping-with-coldfusion-jquery/
	jQuery(document).ready(function(){			

		var jcrop_api;
		// obtain original image dimensions
		var originalImgHeight 	= jQuery('##cropbox').height();
		var originalImgWidth 	= jQuery('##cropbox').width();
		// set the padding for the crop-selection box
		var padding = 10;
		var firstClick = 1;
		// original image dimensions
		var imgW = $("##width").attr("data-width");
		var imgH = $("##height").attr("data-height");

		
		// set the x and y coords using the image dimensions
		// and the padding to leave a border
		var setX = originalImgHeight-padding;
		var setY = originalImgWidth-padding;
		
		// create variables for the form field elements
		var imgPath 	= jQuery('input[name=imagePath]');
		var imgName 	= jQuery('input[name=imageName]');
		var imgX 		= jQuery('input[name=x]');
		var imgY 		= jQuery('input[name=y]');
		var imgHeight 	= jQuery('input[name=h]');
		var imgWidth 	= jQuery('input[name=w]');
		var imgLoc 		= jQuery('input[name=imageFile]');
		var saveAs 		= jQuery('input[name=saveAs]');

		// get the current image source in the main view
		var currentImage = jQuery("##croppedImage img").attr('src');
		
		setImageFileValue(currentImage);

		buildJCrop();

		jQuery("##imagesave").click(function(){				
			// organise data into a readable string
			var data = 'height=' + $("##height").val() + '&width=' + $("##width").val() + 
					'&imgLoc=' + encodeURIComponent(imgLoc.val());

		    var $btn = $(this);
		    $btn.button('loading');					

			$.ajax({
			  type: "POST",
			  url: '#event.buildLink( 'cbFileBrowser.editor.imageSave' )#',
			  data: {
			  	imgLoc:$("##croppedImage").find('img')[0].src,
			  	imgPath : imgPath.val(),
			  	imgName : imgName.val(),
			  	saveAs  : saveAs.val(),
			  	overwrite : $("##over_write").is(':checked')
			  },
			  success: function(){
			  	closeRemoteModal();
			  	fbRefresh();
			  }
			});	

		});

		jQuery("##scale_btn").click(function(){	
			// check if cropping is saved
			if( !$("##croppedImage").find('img').hasClass("img-scaled") ){
				return confirm("There are unsaved changes. Do you want continue?");
			}			
			// organise data into a readable string
			var data = 'height=' + $("##height").val() + '&width=' + $("##width").val() +
					'&imgLoc=' + encodeURIComponent(imgLoc.val());
			// show loading message
		    var $btn = $(this);
		    $btn.button('loading');

			jQuery('##croppedImage').load('#event.buildLink( 'cbFileBrowser.editor.imageScale' )#', data, function(){
		        $btn.button('reset');
			} );
			
			// disable the image crop button and
			// enable the revert button
			jQuery('##imageCrop_btn').attr('disabled', 'disabled');
			jQuery('.revert_btn').removeAttr('disabled');
			// enable the save button
			jQuery('##imagesave').removeAttr('disabled');

			// do not submit the form using the default behaviour
			return false;
		});

		jQuery(".transform").click(function(){	
	
			// organise data into a readable string
			var data = 'imgLoc=' + encodeURIComponent(imgLoc.val()) + '&val=' + $(this).val();

			// show loading message
		    var $btn = $(this);
		    $btn.button('loading');

			jQuery('##croppedImage').load('#event.buildLink( 'cbFileBrowser.editor.imageTransform' )#', data, function(){
		        $btn.button('reset');
			} );
			
			// disable the image crop button and
			// enable the revert button
			jQuery('.revert_btn').removeAttr('disabled');

			// enable the save button
			jQuery('##imagesave').removeAttr('disabled');

			// do not submit the form using the default behaviour
			return false;
		});

		// selecting revert will create the img html tag complete with
		// image source attribute, read from the imageFile form field
		jQuery(".revert_btn").click(function() {					
			var htmlImg = '<img src="' + jQuery('input[name=imageFile]').val() 
					+ '" id="cropbox" class="img-scaled" />';
			jQuery('##croppedImage').html(htmlImg,{}, function(){

			});
			// instantiate the jcrop plugin
			setTimeout(buildJCrop, 500);
			$("##width").val(imgW);
			$("##height").val(imgH);
			// disable the save button
			jQuery('##imagesave').attr('disabled', 'disabled');
			jQuery(this).removeAttr('disabled');
        	jQuery("##scale_btn").attr( "disabled", 'disabled' );
			jQuery('##transformers').find('.transform').each(function(){
			   $(this).removeAttr('disabled')
			})

		});
		
		jQuery("##imageDeselect_btn").click(function() {					
		    destroyJcrop();
		    buildJCrop();
		    return false;							
		});
		
		jQuery("##imageCrop_btn").click(function(){
			if( !imgWidth.val() ){
				alert("Please select an area to crop!");
				return false;
			}					
			// organise data into a readable string
			var data = 'imgX=' + imgX.val() + '&imgY=' + imgY.val() + 
					'&height=' + imgHeight.val() + '&width=' + imgWidth.val() + 
					'&imgLoc=' + encodeURIComponent(imgLoc.val());

		    var $btn = $(this);
		    $btn.button('loading');					
			// 
			jQuery('##croppedImage').load('#event.buildLink( 'cbFileBrowser.editor.crop' )#',data, function(){
		        $btn.button('reset');
		        setTimeout(function(){
					jQuery('##imageCrop_btn').attr('disabled', 'disabled');
		        },100)
			});
			
			// disable the image crop button and
			// enable the revert button
			jQuery('##revert_btn').removeAttr('disabled');
			jQuery('##imageDeselect_btn').attr('disabled', 'disabled');
			// enable the save button
			jQuery('##imagesave').removeAttr('disabled');

			// do not submit the form using the default behaviour
			return false;
		});
		
		// add the jQuery invocation into a separate function,
		// which we will need to call more than once
		function buildJCrop() {
			jQuery('##cropbox').Jcrop({
				aspectRatio: 0,  //If you want to keep aspectRatio
				boxWidth: 800,   //Maximum width you want for your bigger images
				boxHeight: 600,  //Maximum Height for your bigger images
				bgColor: '##ccc',
				bgOpacity: '0.5',
				onRelease: function(){console.log(123)},
				onChange: showCoords,
				onSelect: showCoords
			},function(){
				jcrop_api = this;
			});
			// disable the revert button
			jQuery('##imageCrop_btn').attr('disabled', 'disabled');
			jQuery('##revert_btn').attr('disabled', 'disabled');
			jQuery('##imageDeselect_btn').attr('disabled', 'disabled');
		}

		function destroyJcrop(){
			jcrop_api.destroy();				
			jQuery('##x').val('0');
			jQuery('##y').val('0');
			jQuery('##x2').val('0');
			jQuery('##y2').val('0');
			jQuery('##w').val('0');
			jQuery('##h').val('0');			
		}

		// set the imageFile form field value to match
		// the new image source
		function setImageFileValue(imageSource) {
			imgLoc.val(imageSource);
		}
		
	});

	// Our simple event handler, called from onChange and onSelect
	// event handlers, as per the Jcrop invocation above
	function showCoords(c) {
		jQuery('##x').val(c.x);
		jQuery('##y').val(c.y);
		jQuery('##x2').val(c.x2);
		jQuery('##y2').val(c.y2);
		jQuery('##w').val(c.w);
		jQuery('##h').val(c.h);	
		// enable the image crop button and
		jQuery("##imageCrop_btn").prop( "disabled", false );
		jQuery("##imageDeselect_btn").prop( "disabled", false );
	};

	function calculateProportions( what ) {
		var w 		= jQuery('input[name=width]');
		var h 		= jQuery('input[name=height]');
		var newW 	= w.val();
		var newH 	= h.val();
		var prevW 	= w.attr("data-width");
		var prevH 	= h.attr("data-height");

		/*if(!isNaN(parseFloat(newH)) && isFinite(newH)){
			h.parent(".form-group").addClass("has-error has-danger");
			h.next().append("sdsdasdd dasda");
		}*/

		if(!isNaN(parseFloat(newW)) && isFinite(newW) || !isNaN(parseFloat(newH)) && isFinite(newH)){
			h.parent(".form-group").addClass("has-error has-danger");
			h.next().text("sdsdasdd dasda");
			w.parent(".form-group").addClass("has-error has-danger");
			w.next().text("sdsdasdd dasda");
			return;
		}

        if (what == 0) {
            calc = (prevH * newW) / prevW;
		    h.val(Math.round(calc));
        } else {
            calc = (prevW * newH) / prevH;
		    w.val(Math.round(calc));
        }
        if( prevW != newW || prevH != newH ){
        	jQuery("##scale_btn").prop( "disabled", false );
        }
	}

</script>
</cfoutput>