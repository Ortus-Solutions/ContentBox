﻿<cfoutput>
<!--- post --->
<div class="post" id="post_#entry.getContentID()#">

	<!--- Date --->
	<div class="post-date" title="Posted on #entry.getDisplayPublishedDate()#">
		<span class="post-month">#dateFormat(entry.getPublishedDate(),"MMM")#</span>
		<span class="post-day">#dateFormat(entry.getPublishedDate(),"dd")#</span>
	</div>

	<!--- Title --->
	<div class="post-title">

		<!--- content Author --->
		<div class="post-content-author">
			#cb.quickAvatar(author=entry.getAuthorEmail(),size=30)# #entry.getAuthorName()#
		</div>

		<!--- Title --->
		<h2><a href="#cb.linkEntry(entry)#" rel="bookmark" title="#entry.getTitle()#">#entry.getTitle()#</a></h2>

		<!--- Category Bar --->
		<span class="post-cat">#cb.quickCategoryLinks(entry)#</span>

		<!--- content --->
		<div class="post-content">
			<!--- excerpt or content --->
			<cfif entry.hasExcerpt() and cb.isIndexView()>
				#entry.renderExcerpt()#
				<div class="post-more">
					<a href="#cb.linkEntry(entry)#" title="Read The Full Entry!"><button class="button2">Read More...</button></a>
				</div>
			<cfelse>
				#entry.renderContent()#
			</cfif>
		</div>

	</div>

	<!--- Comments Bar --->
	<div class="post-comments">
		<div class="infoBar">
			<cfif NOT cb.isCommentsEnabled(entry)>
			<img src="#cb.themeRoot()#/includes/images/important.png" alt="warning" />
			Comments are currently closed
			<cfelse>

				<cfif structKeyExists(args,"addComments") and args.addComments>
					<button class="button2" onclick="toggleCommentForm()"> Add Comment </button>
					<img src="#cb.themeRoot()#/includes/images/comments_32.png" alt="comments" /> #prc.entry.getNumberOfApprovedComments()#
				<cfelse>
					<a href="#cb.linkComments(entry)#" title="View Comments"><img src="#cb.themeRoot()#/includes/images/comments_32.png" alt="comments" border="0" /> #entry.getNumberOfApprovedComments()#</a>
				</cfif>

			</cfif>
		</div>
		<br/>
	</div>

	<div class="separator"></div>
</div>
</cfoutput>