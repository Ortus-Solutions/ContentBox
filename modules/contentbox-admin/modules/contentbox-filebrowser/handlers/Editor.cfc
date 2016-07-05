/**
* My Event Handler Hint
*/
component extends="coldbox.system.EventHandler"{

	property name="FileUtils" inject="coldbox.system.core.util.FileUtils";

	/**
	* Index
	*/
	any function index( event, rc, prc ){
		event.paramValue( "imageUrl","" );
		if( event.isAjax() ) {
			event.renderData( data=renderView( view="editor/index", layout="ajax" ) );
		}
		else {
			event.setView( view="editor/index", layout="ajax" );
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
	
}