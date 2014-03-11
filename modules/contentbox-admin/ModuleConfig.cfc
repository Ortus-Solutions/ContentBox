/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* ContentBox Admin module configuration
* Icon Themes: woothemesiconset, duesseldorf
*/
component {

	// Module Properties
	this.title 				= "ContentBox-Admin";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ContentBox Admin";
	this.version			= "2.0.0.@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbadmin";

	function configure(){

		// Layout Settings
		layoutSettings = { defaultLayout = "admin.cfm" };

		// Module Settings
		settings = {
			// ForgeBox Settings
			forgeBoxURL 	 = "http://www.coldbox.org/forgebox",
			forgeBoxEntryURL = "http://www.coldbox.org/forgebox/view"
		};

		// Parent Settings
		parentSettings = {
			messagebox_template = "#moduleMapping#/views/_tags/messagebox.cfm"
		};

		// SES Routes
		routes = [
			{pattern="/", handler="dashboard", action="index" },
			{pattern="/dashboard/reload/:targetModule", handler="dashboard", action="reload" },
			{pattern="/authors/page/:page",handler="authors"},
			{pattern="/entries/page/:page",handler="entries"},
			{pattern="/pages/parent/:parent?",handler="pages"},
			{pattern="/entries/pager/page/:page",handler="entries",action="pager"},
			{pattern="/comments/page/:page",handler="comments"},
			{pattern="/contentStore/page/:page",handler="contentStore"},
			{pattern="/menus/page/:page",handler="menus"},
			{pattern="/mediamanager/library/:library", handler="mediamanager", action="index"},
			{pattern="/module/:moduleEntryPoint/:moduleHandler/:moduleAction?", handler="modules", action="execute" },
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints = arrayToList([
				// Admin Layout HTML points
				"cbadmin_beforeHeadEnd","cbadmin_afterBodyStart","cbadmin_beforeBodyEnd","cbadmin_footer","cbadmin_beforeContent","cbadmin_afterContent","cbadmin_onTagLine", "cbadmin_onTopBar",
				// Entry Events
				"cbadmin_preEntrySave","cbadmin_postEntrySave","cbadmin_preEntryRemove","cbadmin_postEntryRemove", "cbadmin_onEntryStatusUpdate",
				"cbadmin_entryEditorSidebar", "cbadmin_entryEditorSidebarAccordion", "cbadmin_entryEditorSidebarFooter",
				"cbadmin_entryEditorFooter", "cbadmin_entryEditorInBody",
				// ContentStore Events
				"cbadmin_preContentStoreSave","cbadmin_postContentStoreSave","cbadmin_preContentStoreRemove","cbadmin_postContentStoreRemove", "cbadmin_onContentStoreStatusUpdate",
				"cbadmin_ContentStoreEditorSidebar", "cbadmin_ContentStoreEditorSidebarAccordion", "cbadmin_ContentStoreEditorSidebarFooter",
				"cbadmin_ContentStoreEditorFooter", "cbadmin_ContentStoreEditorInBody",
				// Page Events
				"cbadmin_prePageSave","cbadmin_postPageSave","cbadmin_prePageRemove","cbadmin_postPageRemove", "cbadmin_onPageStatusUpdate",
				"cbadmin_pageEditorSidebar", "cbadmin_pageEditorSidebarAccordion", "cbadmin_pageEditorSidebarFooter",
				"cbadmin_pageEditorFooter", "cbadmin_pageEditorInBody",
				// Author Events
				"cbadmin_preAuthorSave","cbadmin_postAuthorSave","cbadmin_onAuthorPasswordChange","cbadmin_preAuthorRemove","cbadmin_postAuthorRemove", 
				"cbadmin_preAuthorPreferencesSave" , "cbadmin_postAuthorPreferencesSave", "cbadmin_UserPreferencePanel",
				"cbadmin_onAuthorEditorNav", "cbadmin_onAuthorEditorContent", "cbadmin_onAuthorEditorSidebar", "cbadmin_onAuthorEditorActions",
				// Category Events
				"cbadmin_preCategorySave","cbadmin_postCategorySave","cbadmin_preCategoryRemove","cbadmin_postCategoryRemove",
				// Comment Events
				"cbadmin_onCommentStatusUpdate","cbadmin_preCommentSave","cbadmin_postCommentSave","cbadmin_preCommentRemove","cbadmin_postCommentRemove","cbadmin_preCommentRemoveAllModerated","cbadmin_postCommentRemoveAllModerated","cbadmin_preCommentSettingsSave","cbadmin_postCommentSettingsSave",
				"cbadmin_onCommentSettingsNav","cbadmin_onCommentSettingsContent",
				// Permission events
				"cbadmin_prePermissionSave", "cbadmin_postPermissionSave", "cbadmin_prePermissionRemove" , "cbadmin_postPermissionRemove" ,
				// Roles events
				"cbadmin_preRoleSave", "cbadmin_postRoleSave", "cbadmin_preRoleRemove" , "cbadmin_postRoleRemove" ,
				// Dashboard events
				"cbadmin_onDashboard", "cbadmin_preDashboardContent", "cbadmin_postDashboardContent", "cbadmin_preDashboardSideBar", "cbadmin_postDashboardSideBar", 
				"cbadmin_onDashboardTabNav", "cbadmin_preDashboardTabContent", "cbadmin_postDashboardTabContent",
				// Security events
				"cbadmin_preLogin","cbadmin_onLogin","cbadmin_onBadLogin","cbadmin_onLogout","cbadmin_onPasswordReminder","cbadmin_onInvalidPasswordReminder", "cbadmin_onPasswordReset", "cbadmin_onInvalidPasswordReset",
				// Settings events
				"cbadmin_preSettingsSave","cbadmin_postSettingsSave","cbadmin_preSettingRemove","cbadmin_postSettingRemove","cbadmin_onSettingsNav","cbadmin_onSettingsContent",
				// Global HTML Events
				"cbadmin_preGlobalHTMLSave","cbadmin_postGlobalHTMLSave",
				// Security Rules Events
				"cbadmin_preSecurityRulesSave", "cbadmin_postSecurityRulesSave", "cbadmin_preSecurityRulesRemove", "cbadmin_postSecurityRulesRemove", "cbadmin_onResetSecurityRules",
				// Layout Themes
				"cbadmin_onLayoutActivation", "cbadmin_onLayoutDeactivation",
				// Version Control
				"cbadmin_preContentVersionRemove","cbadmin_postContentVersionRemove","cbadmin_preContentVersionRollback", "cbadmin_postContentVersionRollback",
				// Menu events
				"cbadmin_preMenuSave","cbadmin_postMenuSave","cbadmin_preMenuRemove","cbadmin_postMenuRemove"
			])
		};

		// Custom Declared Interceptors
		interceptors = [
			// CB Admin Request Interceptor
			{ class="#moduleMapping#.interceptors.CBRequest", properties={ entryPoint=this.entryPoint }, name="CBRequest@cbAdmin" },
			{ class="#moduleMapping#.interceptors.CommentCleanup" },
			{ class="#moduleMapping#.interceptors.MenuCleanup" }
		];
		
	}
	
	/*
	* On Module Load
	*/
	function onLoad(){
		// Clean cached assets
		controller.getPlugin( plugin="JSMin", customPlugin="true", module="contentbox" )
			.cleanCache( "/#moduleMapping#/includes/cache" );
	}
}