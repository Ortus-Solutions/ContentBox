/**
* My Event Handler Hint
*/
component extends="coldbox.system.EventHandler"{

	property name="FileUtils" inject="coldbox.system.core.util.FileUtils";

	/**
	* Index
	*/
	any function index( event, rc, prc ){
		event.paramValue( "imagePath","" );
		event.paramValue( "imageSrc","" );
		event.paramValue( "imageName","" );

		var info=ImageInfo(rc.imagePath);
		rc.width = info.width;
		rc.height = info.height;
		rc.imageRelPath = rc.imageSrc;
		rc.imageSrc = #event.buildLink( '' )# & rc.imageSrc;

		if( event.isAjax() ) {
			event.renderData( data=renderView( view="editor/index", layout="ajax" ) );
		}
		else {
			event.setView( view="editor/index", layout="ajax" );
		}		
	}
	
	/**
	* Info
	*/
	any function info( event, rc, prc ){
		event.paramValue( "imagePath","" );
		event.paramValue( "imageSrc","" );
		event.paramValue( "imageName","" );

		var info=ImageInfo(rc.imagePath);
		rc.width = info.width;
		rc.height = info.height;
		rc.imageRelPath = rc.imageSrc;
		rc.imageSrc = #event.buildLink( '' )# & rc.imageSrc;
		
		prc.imgInfo = ImageInfo( rc.imageSrc );

		if( event.isAjax() ) {
			event.renderData( data=renderView( view="editor/info", layout="ajax" ) );
		}
		else {
			event.setView( view="editor/info", layout="ajax" );
		}		
	}
	
	/**
	* Crop image
	*/
	any function crop( event, rc, prc ){
		// params
		event.paramValue( "imgX","" );
		event.paramValue( "imgY","" );
		event.paramValue( "width","" );
		event.paramValue( "height","" );
		event.paramValue( "imgLoc","" );

		if ( len(rc.imgLoc) ){

		    // read the image and create a ColdFusion image object --->
		    var sourceImage = ImageNew( imgLoc );

		    <!--- crop the image using the supplied coords
		              from the url request --->
		    ImageCrop(	sourceImage,
	                        rc.imgX,
	                        rc.imgY,
	                        rc.width,
	                        rc.height);

		    cfimage (
		        action = "writeToBrowser",
		        source = sourceImage
		    );

		    abort;

		}

	}
	
	/**
	* Scale image
	*/
	any function imageScale( event, rc, prc ){
		// params
		event.paramValue( "width","" );
		event.paramValue( "height","" );
		event.paramValue( "imgLoc","" );

		if ( len(rc.imgLoc) ){

		    // read the image and create a ColdFusion image object --->
		    var sourceImage = ImageNew( rc.imgLoc );

		    // crop the image using the supplied coords from the url request 
		    ImageResize(	sourceImage,
	                        rc.width,
	                        rc.height);

		    cfimage (
		        action = "writeToBrowser",
		        source = sourceImage
		    );

		}

		event.noRender();

	}
	
	/**
	* Scale image
	*/
	any function imageTransform( event, rc, prc ){
		// params
		event.paramValue( "imgLoc","" );

		if ( len(rc.imgLoc) ){

		    // read the image and create a ColdFusion image object --->
		    var sourceImage = ImageNew( rc.imgLoc );

		    ImageSetAntialiasing( sourceImage, true );

		    // crop the image using the supplied coords from the url request 
		    ImageFlip( sourceImage, rc.val );

		    cfimage (
		        action = "writeToBrowser",
		        source = sourceImage
		    );

		}

		event.noRender();
	}
	
	/**
	* Save image
	*/
	any function imageSave( event, rc, prc ){
		// params
		event.paramValue( "imgLoc", "" );
		event.paramValue( "imgPath", "" );
		event.paramValue( "imgName", "" );
		event.paramValue( "saveAs", "" );
		event.paramValue( "overwrite", false );

		var ext = "." & ListLast( rc.imgPath, "." );

		if ( len(rc.imgLoc) ){

		    var sourceImage = ImageRead( rc.imgLoc );
			var path = rc.filebrowser.settings.directoryRoot & imgName;

			if( rc.overwrite AND !len(rc.saveAs) ){
				imageWrite( sourceImage, rc.imgPath, 1, rc.overwrite );
			}elseif( len(rc.saveAs) ){
				imageWrite( sourceImage, getDirectoryFromPath(rc.imgPath) & rc.saveAs & ext, 1, rc.overwrite );
			}else{
				imageWrite( sourceImage, getDirectoryFromPath(rc.imgPath) & "_edited_" & rc.imgName, 1 );				
			}

		}
		event.noRender();
	}
	
}