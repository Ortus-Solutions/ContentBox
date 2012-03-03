<!---
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
*/
--->
<cfoutput>
<!--- post --->
<div class="post" id="post_#entry.getContentID()#">

	<!--- Title --->
	<div class="post-title">

		<!--- content Author --->
		<div class="post-content-author">
			#cb.quickAvatar(author=entry.getAuthorEmail(),size=30)# #entry.getAuthorName()#
		</div>

		<!--- Title --->
		<h2><a href="#cb.linkEntry(entry)#" rel="bookmark" title="#entry.getTitle()#">#entry.getTitle()#</a></h2>

		<!--- Category Bar: I could loop but why, let the quick category do it--->
		<cfif entry.hasCategories()>
		<span class="post-cat">#cb.quickCategoryLinks(entry)#</span><br/><Br/>
		</cfif>
		<span class="post-date">#entry.getDisplayPublishedDate()#</span>

		<!--- content --->
		<div class="post-content">
			<!--- excerpt or content --->
			<cfif entry.hasExcerpt() and cb.isIndexView()>
				#entry.getExcerpt()#
				<div class="post-more">
					<a href="#cb.linkEntry(entry)#" title="Read The Full Entry!"><button class="button2">Read More...</button></a>
				</div>
			<cfelse>
				<!--- Don't get the content, render the content --->
				#entry.renderContent()#
			</cfif>
		</div>

	</div>

	<div class="separator"></div>
</div>
</cfoutput>