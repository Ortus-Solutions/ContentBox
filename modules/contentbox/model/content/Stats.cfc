component persistent="true" entityname="cbStats" table="cb_stats" batchsize="25" cachename="cbStats" cacheuse="read-write" {

	// Properties
	property name="statsID" fieldtype="id" generator="native" setter="false";
	property name="hits"					notnull="false" ormtype="long" default="0";
	property name="contentID" notnull="true" cfc="contentbox.model.content.BaseContent" fieldtype="one-to-one" fkcolumn="FK_contentID" lazy="true" fetch="join";
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		super.init();
		return this;
	}

	/************************************** PUBLIC *********************************************/

}