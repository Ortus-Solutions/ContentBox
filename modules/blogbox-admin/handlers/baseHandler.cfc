component{

	/**
	* Global admin prehandlers
	*/
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
		
		// Global Admin Exit Handlers
		rc.xehDashboard 	= "#rc.bbEntryPoint#.dashboard";
		
		// Entries Tab
		rc.xehEntries		= "#rc.bbEntryPoint#.entries";
		rc.xehBlogEditor 	= "#rc.bbEntryPoint#.entries.editor";
		rc.xehCategories	= "#rc.bbEntryPoint#.categories";
		rc.xehComments		= "#rc.bbEntryPoint#.comments";
		
		// Authors Tab
		rc.xehAuthors			= "#rc.bbEntryPoint#.authors";
		rc.xehAuthorEditor		= "#rc.bbEntryPoint#.authors.editor";
		rc.xehAuthorsProfile	= "#rc.bbEntryPoint#.authors.profile";
		
		// System
		rc.xehSettings		= "#rc.bbEntryPoint#.settings";
		rc.xehDoLogout 		= "#rc.bbEntryPoint#.security.doLogout";
	}

}