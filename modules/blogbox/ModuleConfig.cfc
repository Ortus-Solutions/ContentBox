component {
	
	// Module Properties
	this.title 				= "blogbox";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for blogbox: http://myapp/blogbox
	this.entryPoint			= "blog";
	
	function configure(){
	
		// module settings - stored in modules.name.settings
		settings = {};
		
		// Layout Settings
		layoutSettings = {
			defaultLayout = "blog.cfm"
		};
		
		// SES Routes
		routes = [
			// Generic module route
			{pattern="/", handler="entries", action="index" },
			// Admin routes
			{pattern="/admin/authors/:action?", handler="admin.authors" },
			{pattern="/admin/entries/:action?", handler="admin.entries" },
			{pattern="/admin/comments/:action?", handler="admin.comments" },
			{pattern="/admin/categories/:action?", handler="admin.categories" },
			{pattern="/admin/dashboard/:action?", handler="admin.dashboard" },
			// Default Route
			{pattern="/:handler/:action?"}
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};
		
		// Custom Declared Interceptors
		interceptors = [
		];
		
		// WireBox bindings
		binder.map("securityService@bb").to("#moduleMapping#.model.security.SecurityService");
		binder.map("authorService@bb").to("#moduleMapping#.model.entries.AuthorService");
		binder.map("entryService@bb").to("#moduleMapping#.model.entries.EntryService");
		binder.map("commentService@bb").to("#moduleMapping#.model.comments.CommentService");
		binder.map("categoryService@bb").to("#moduleMapping#.model.entries.CategoryService");
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		
	}
	
	/**
	* Fired on blogbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^blogbox:"{
		// store module root	
		event.setValue("bbroot", event.getModuleRoot());
		// store module entry point
		event.setValue("bbEntryPoint", this.entryPoint);
	}
	
}