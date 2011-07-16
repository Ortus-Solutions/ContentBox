/**
* Service to handle auhtor operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton{
	
	// User hashing type
	property name="hashType";
	
	/**
	* Constructor
	*/
	AuthorService function init(){
		// init it
		super.init(entityName="bbAuthor");
	    setHashType( "SHA-256" );
	    
		return this;
	}
	
	/**
	* Save an author with extra pizazz!
	*/
	function saveAuthor(author,passwordChange=false){
		// hash password if new author
		if( !arguments.author.isLoaded() OR arguments.passwordChange ){
			arguments.author.setPassword( hash(arguments.author.getPassword(), getHashType()) );
		}
		// save the author
		save( author );
	}

}