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
	* Index
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
	* Index
	*/
	any function imageScale( event, rc, prc ){
		// params
		event.paramValue( "width","" );
		event.paramValue( "height","" );
		event.paramValue( "imgLoc","" );

		if ( len(rc.imgLoc) ){

		    // read the image and create a ColdFusion image object --->
		    var sourceImage = ImageNew( imgLoc );

		    // crop the image using the supplied coords from the url request 
		    ImageResize(	sourceImage,
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
	* Index
	*/
	any function imageSave( event, rc, prc ){
		// params
		event.paramValue( "imgLoc","" );
		event.paramValue( "imgPath","" );
		event.paramValue( "imgName","" );

		if ( len(rc.imgLoc) ){

		    var sourceImage = ImageRead( rc.imgLoc );
			var path = rc.filebrowser.settings.directoryRoot & "/cc.jpg";

		    imageWrite( sourceImage, getDirectoryFromPath(rc.imgPath) & rc.imgName );

		}
		event.noRender();
	}
	
}