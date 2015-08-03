/**
* A widget that renders Custom HTML in ContentBox: DEPRECATED
* @deprecated
*/
component extends="ContentStore" singleton{

	CustomHTML function init(required controller){
		// super init
		super.init( arguments.controller );

		// Widget Properties
		setPluginName("CustomHTML");
		setPluginDescription("A widget that renders Custom HTML content anywhere you like. Deprecated, use the ContentStore widget instead");

		return this;
	}

}
