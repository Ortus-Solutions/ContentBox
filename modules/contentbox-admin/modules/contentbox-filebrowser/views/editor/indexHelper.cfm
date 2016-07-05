<cfoutput>
	<script>
		// This code is taken from: https://www.monkehworks.com/image-cropping-with-coldfusion-jquery/
		jQuery(document).ready(function(){			

		// obtain original image dimensions
		var originalImgHeight 	= jQuery('##cropbox').height();
		var originalImgWidth 	= jQuery('##cropbox').width();
		// set the padding for the crop-selection box
		var padding = 10;
		var firstClick = 1;
		
		// set the x and y coords using the image dimensions
		// and the padding to leave a border
		var setX = originalImgHeight-padding;
		var setY = originalImgWidth-padding;
		
		// create variables for the form field elements
		var imgX 		= jQuery('input[name=x]');
		var imgY 		= jQuery('input[name=y]');
		var imgHeight 	= jQuery('input[name=h]');
		var imgWidth 	= jQuery('input[name=w]');
		var imgLoc 		= jQuery('input[name=imageFile]');
		
		// get the current image source in the main view
		var currentImage = jQuery("##croppedImage img").attr('src');
		
		setImageFileValue(currentImage);

			jQuery("##scale_btn").click(function(){				
				// organise data into a readable string
				var data = 'height=' + $("##height").val() + '&width=' + $("##width").val() + 
						'&imgLoc=' + encodeURIComponent(imgLoc.val());
				// 
				jQuery('##croppedImage').load('#event.buildLink( 'cbFileBrowser.editor.imageScale' )#',data);
				
				// disable the image crop button and
				// enable the revert button
				jQuery('##imageCrop_btn').attr('disabled', 'disabled');
				jQuery('##revert_scale').removeAttr('disabled');
				
				// do not submit the form using the default behaviour
				return false;
			});

		
			// instantiate the jcrop plugin
			jQuery("##croppedImage").click(function() {
				if(firstClick){
					firstClick = 0;
					return buildJCrop();
				}

			});

			// selecting revert will create the img html tag complete with
			// image source attribute, read from the imageFile form field
			jQuery("##revert_btn").click(function() {					
				var htmlImg = '<img src="' + jQuery('input[name=imageFile]').val() 
						+ '" id="cropbox" />';
				jQuery('##croppedImage').html(htmlImg);
				// instantiate the jcrop plugin
				buildJCrop();
				
			});
			
			jQuery("##revert_scale").click(function() {					
				var htmlImg = '<img src="' + jQuery('input[name=imageFile]').val() 
						+ '" id="cropbox" />';
				jQuery('##croppedImage').html(htmlImg);				
			});
			
			jQuery("##imageCrop_btn").click(function(){
				if( !imgWidth.val() ){
					alert("Please select an area to crop!");
				}					
				// organise data into a readable string
				var data = 'imgX=' + imgX.val() + '&imgY=' + imgY.val() + 
						'&height=' + imgHeight.val() + '&width=' + imgWidth.val() + 
						'&imgLoc=' + encodeURIComponent(imgLoc.val());
				// 
				jQuery('##croppedImage').load('#event.buildLink( 'cbFileBrowser.editor.crop' )#',data);
				
				// disable the image crop button and
				// enable the revert button
				jQuery('##imageCrop_btn').attr('disabled', 'disabled');
				jQuery('##revert_btn').removeAttr('disabled');
				
				// do not submit the form using the default behaviour
				return false;
			});
			
			// add the jQuery invocation into a separate function,
			// which we will need to call more than once
			function buildJCrop() {
				jQuery('##cropbox').Jcrop({
					aspectRatio: 0,
					bgColor: '##fff',
					bgOpacity: '0.5',
					onChange: showCoords,
					onSelect: showCoords,
					setSelect: [padding,padding,setY,setX]
				});
				// enable the image crop button and
				// disable the revert button
				jQuery('##imageCrop_btn').removeAttr('disabled');
				jQuery('##revert_btn').attr('disabled', 'disabled');
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
		};

		function calculateProportions( what ) {
			var newW = $("##width").val();
			var newH = $("##height").val();
			var prevW = $("##width").attr("data-width");
			var prevH = $("##height").attr("data-height");

	        if (what == 0) {
	            calc = (prevH * newW) / prevW;
			    $("##height").val(Math.round(calc));
	        } else {
	            calc = (prevW * newH) / prevH;
			    $("##width").val(Math.round(calc));
	        }
		}

	</script>
</cfoutput>