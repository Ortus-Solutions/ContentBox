/**
* Image Editor
*/
component extends="coldbox.system.EventHandler"{

	/**
	* Index
	*/
	any function index( event, rc, prc ){
		event.paramValue( "imagePath", "" )
			.paramValue( "imageSrc", "" )
			.paramValue( "imageName", "" );

		var thisImage 	= imageRead( rc.imagepath );
		var info		= ImageInfo( thisImage );
		prc.width		= info.width;
		prc.height		= info.height;
		prc.imageRelPath= rc.imageSrc;
		prc.imageSrc	= reReplace( event.buildLink( '' ), "\/$" , "" ) & rc.imageSrc;
		prc.fileType	= listLast( rc.imageName, "." );

		if( event.isAjax() ) {
			event.renderData( 
				data = renderView( view="editor/index", layout = "ajax" )
			);
		} else {
			event.setView( 
				view 	= "editor/index", 
				layout 	= "ajax" 
			);
		}		
	}
	
	/**
	* Info
	*/
	any function info( event, rc, prc ){
		event.paramValue( "filePath","" )
			.paramValue( "fileSrc","" )
			.paramValue( "fileName","" );

		if( ! IsImageFile( rc.filePath ) ){
			prc.fileInfo 	= getFileInfo( rc.filePath );
		}else{

			prc.fileInfo 	= getFileInfo( rc.filePath );
			prc.imgInfo 	= ImageInfo( imageRead( rc.filePath ) );
			prc.fileRelPath = rc.fileSrc;
			prc.fileSrc 	= event.buildLink( '' ) & rc.fileSrc;

		}

		if( event.isAjax() ) {
			event.renderData( 
				data = renderView( view="editor/info", layout = "ajax" )
			);
		} else {
			event.setView( view="editor/info", layout="ajax" );
		}		
	}
	
	/**
	* Crop image
	*/
	any function crop( event, rc, prc ){
		// params
		event.paramValue( "imgX","" )
			.paramValue( "imgY","" )
			.paramValue( "width","" )
			.paramValue( "height","" )
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "imgEdited", false );

		if ( len( rc.imgLoc ) ){

			if( rc.imgEdited ){
				// read from in memory
		    	var sourceImage = ImageRead( rc.imgPath & "&type=" & rc.type );
			}else{
			    // read the image and create a ColdFusion image object --->
			    var sourceImage = ImageNew( sanitizeUrl( rc.imgName, rc.imgPath ) );
			}

		    //crop the image using the supplied coords from the url request
		    ImageCrop(	
		    	sourceImage,
				rc.imgX,
				rc.imgY,
				rc.width,
				rc.height
			);

		    cfimage (
		        action = "writeToBrowser",
		        source = sourceImage
		    );

		    event.noRender();

		}

	}
	
	/**
	* Scale image
	*/
	any function imageScale( event, rc, prc ){
		// params
		event.paramValue( "width","" )
			.paramValue( "height","" )
			.paramValue( "imgPath","" )
			.paramValue( "imgName","" )
			.paramValue( "imgEdited", false );

		if ( len( rc.imgPath ) ){

			if( rc.imgEdited ){
				// read from in memory
		    	var sourceImage = ImageRead( rc.imgPath & "&type=" & rc.type );
			}else{
			    // read the image and create a ColdFusion image object 
			    // read the image and create a ColdFusion image object --->
			    var sourceImage = ImageNew( sanitizeUrl( rc.imgName, rc.imgPath ) );
			}

		    // crop the image using the supplied coords from the url request 
		    ImageResize(	
		    	sourceImage,
				rc.width,
				rc.height
			);

		    cfimage (
		        action = "writeToBrowser",
		        source = sourceImage
		    );

		}

		event.noRender();
	}
	
	/**
	* Flip/rotate image
	*/
	any function imageTransform( event, rc, prc ){
		// params
		event.paramValue( "imgPath","" )
			.paramValue( "imgName","" )
			.paramValue( "imgEdited", false );

		if ( len( rc.imgPath ) ){
			if( rc.imgEdited ){
				// read from in memory
		    	var sourceImage = ImageRead( rc.imgPath & "&type=" & rc.type );
			}else{
			    // read the image and create a ColdFusion image object
			    var sourceImage = ImageNew( sanitizeUrl( rc.imgName, rc.imgPath ) );
			}
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
		event.paramValue( "imgLoc", "" )
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "saveAs", "" )
			.paramValue( "overwrite", false );

		var ext = "." & ListLast( rc.imgPath, "." );

		if ( len( rc.imgLoc ) ){

		    var sourceImage = ImageRead( rc.imgLoc );
			var path 		= rc.filebrowser.settings.directoryRoot & imgName;

			if( rc.overwrite AND !len( rc.saveAs ) ){
				imageWrite( sourceImage, rc.imgPath, 1, rc.overwrite );
			} else if( len( rc.saveAs ) ){
				imageWrite( sourceImage, getDirectoryFromPath( rc.imgPath ) & rc.saveAs & ext, 1, rc.overwrite );
			} else {
				imageWrite( sourceImage, getDirectoryFromPath( rc.imgPath ) & "_edited_" & rc.imgName, 1 );				
			}

		}
		event.noRender();
	}
	
	/**
	* Sanitize incoming paramed URL arguments
	*/
	private function sanitizeUrl( required string imgName, required string imgPath ){
		// strip out image name and re-add encoded
		return replace( arguments.imgPath, arguments.imgName, urlEncode( arguments.imgName ) );
	}

}