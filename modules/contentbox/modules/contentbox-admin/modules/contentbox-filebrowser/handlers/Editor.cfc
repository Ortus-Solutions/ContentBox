/**
 * Image Editor
 */
component extends="coldbox.system.EventHandler" {
	property name="cb" inject="CBHelper@contentbox";

	/**
	 * Pre handler
	 */
	function preHandler( event, currentAction, rc, prc ){
		prc.activeDisk = cbfs().get( variables.cb.site().getMediaDisk() ?: "contentbox" );
	}

	/**
	 * Index
	 */
	any function index( event, rc, prc ){
		event
			.paramValue( "imagePath", "" )
			.paramValue( "imageSrc", "" )
			.paramValue( "imageName", "" );

		var thisImage    = imageRead( prc.activeDisk.uri( rc.imagepath ) );
		var info         = imageInfo( thisImage );
		prc.width        = info.width;
		prc.height       = info.height;
		prc.imageRelPath = rc.imageSrc;
		prc.imageSrc     = reReplace( event.buildLink( "" ), "\/$", "" ) & rc.imageSrc;
		prc.fileType     = listLast( rc.imageName, "." );

		if ( event.isAjax() ) {
			event.renderData( data = view( view = "editor/index", layout = "ajax" ) );
		} else {
			event.setView( view = "editor/index", layout = "ajax" );
		}
	}

	/**
	 * Info
	 */
	any function info( event, rc, prc ){
		event
			.paramValue( "filePath", "" )
			.paramValue( "fileSrc", "" )
			.paramValue( "fileName", "" );

		if ( !isImageFile( prc.activeDisk.uri( rc.filePath ) ) ) {
			prc.fileInfo = prc.activeDisk.info( rc.filePath );
		} else {
			prc.fileInfo    = prc.activeDisk.info( rc.filePath );
			prc.imgInfo     = imageInfo( imageRead( prc.activeDisk.uri( rc.filePath ) ) );
			prc.fileRelPath = rc.fileSrc;
			prc.fileSrc     = event.buildLink( "" ) & rc.fileSrc;
		}

		if ( event.isAjax() ) {
			event.renderData( data = view( view = "editor/info", layout = "ajax" ) );
		} else {
			event.setView( view = "editor/info", layout = "ajax" );
		}
	}

	/**
	 * Crop image
	 */
	any function crop( event, rc, prc ){
		// params
		event
			.paramValue( "imgX", "" )
			.paramValue( "imgY", "" )
			.paramValue( "width", "" )
			.paramValue( "height", "" )
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "imgEdited", false )
			.paramValue( "type", "" )
		;

		if ( len( rc.imgLoc ) ) {
			if ( rc.imgEdited ) {
				// read from in memory
				if ( server.keyExists( "lucee" ) ) {
					var sourceImage = imageRead( rc.imgPath & "&type=" & rc.type );
				} else {
					var sourceImage = imageRead( rc.imgPath );
				}
			} else {
				// read the image and create a ColdFusion image object --->
				var sourceImage = imageNew( sanitizeUrl( rc.imgName, rc.imgPath ) );
			}

			// crop the image using the supplied coords from the url request
			imageCrop(
				sourceImage,
				rc.imgX,
				rc.imgY,
				rc.width,
				rc.height
			);

			cfimage( action = "writeToBrowser", source = sourceImage );

			event.noRender();
		}
	}

	/**
	 * Scale image
	 */
	any function imageScale( event, rc, prc ){
		// params
		event
			.paramValue( "width", "" )
			.paramValue( "height", "" )
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "imgEdited", false )
			.paramValue( "type", "" );

		if ( len( rc.imgPath ) ) {
			if ( rc.imgEdited ) {
				// read from in memory
				if ( server.keyExists( "lucee" ) ) {
					var sourceImage = imageRead( rc.imgPath & "&type=" & rc.type );
				} else {
					var sourceImage = imageRead( rc.imgPath );
				}
			} else {
				// read the image and create a ColdFusion image object
				// read the image and create a ColdFusion image object --->
				var path = findNoCase( "http", rc.imgPath ) ? rc.imgPath : prc.activeDisk.uri( rc.imgPath );
				var sourceImage = imageRead( path );
			}

			// crop the image using the supplied coords from the url request
			imageResize( sourceImage, rc.width, rc.height );

			cfimage( action = "writeToBrowser", source = sourceImage );
		}

		event.noRender();
	}

	/**
	 * Flip/rotate image
	 */
	any function imageTransform( event, rc, prc ){
		// params
		event
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "imgEdited", false )
			.paramValue( "type", "" );

		if ( len( rc.imgPath ) ) {
			if ( rc.imgEdited ) {
				// read from in memory
				if( !findNoCase( "http", rc.imgPath ) ){
					rc.imgPath = event.getHTMLBaseURL() & listToArray( rc.imgPath, "/" ).toList( "/" )
				}
				if ( server.keyExists( "lucee" ) ) {
					var sourceImage = imageRead( rc.imgPath & "&type=" & rc.type );
				} else {
					var sourceImage = imageRead( rc.imgPath );
				}
			} else {
				// read the image and create a ColdFusion image object
				var sourceImage = imageNew( sanitizeUrl( rc.imgName, rc.imgPath ) );
			}
			imageSetAntialiasing( sourceImage, true );

			// crop the image using the supplied coords from the url request
			imageFlip( sourceImage, rc.val );

			cfimage( action = "writeToBrowser", source = sourceImage );
		}

		event.noRender();
	}

	/**
	 * Save image
	 */
	any function imageSave( event, rc, prc ){
		// params
		event
			.paramValue( "imgLoc", "" )
			.paramValue( "imgPath", "" )
			.paramValue( "imgName", "" )
			.paramValue( "saveAs", "" )
			.paramValue( "overwrite", false );

		var ext = "." & listLast( rc.imgPath, "." );

		if ( len( rc.imgLoc ) ) {
			if( !findNoCase( "http", rc.imgLoc ) ){
				rc.imgLoc = event.getHTMLBaseURL() & listToArray( rc.imgLoc, "/" ).toList( "/" )
			}
			var sourceImage = fileReadBinary( rc.imgLoc );
			if ( rc.overwrite AND !len( rc.saveAs ) ) {
				prc.activeDisk.create(
					path = rc.imgPath,
					contents = sourceImage,
					overwrite = rc.overwrite
				);
			} else if ( len( rc.saveAs ) ) {
				prc.activeDisk.create(
					path = rc.saveAs,
					contents = sourceImage,
					overwrite = rc.overwrite
				);
			} else {
				prc.activeDisk.create(
					path = getDirectoryFromPath( rc.imgPath ) & "_edited_" & rc.imgName,
					contents = sourceImage,
					overwrite = rc.overwrite
				);
			}
		}
		event.noRender();
	}

	/**
	 * Sanitize incoming paramed URL arguments
	 *
	 * @imgName the image name
	 * @imgPath The image path location
	 *
	 * @return sanitized path
	 */
	private function sanitizeUrl( required string imgName, required string imgPath ){
		// strip out image name and re-add encoded
		return replace(
			arguments.imgPath,
			arguments.imgName,
			encodeForURL( arguments.imgName )
		);
	}
}
