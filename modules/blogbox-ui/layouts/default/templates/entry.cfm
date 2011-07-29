<cfoutput>
<!--- post --->
<div class="post" id="post_#entry.getEntryID()#">
	
	<!--- Date --->
	<div class="post-date" title="Posted on #entry.getDisplayPublishedDate()#">
		<span class="post-month">#dateFormat(entry.getPublishedDate(),"MMM")#</span> 
		<span class="post-day">#dateFormat(entry.getPublishedDate(),"dd")#</span>
	</div>
	
	<!--- Title --->
	<div class="post-title">
		
		<!--- content Author --->
		<div class="post-content-author">
			#bb.quickAvatar(author=entry.getAuthor(),size=30)# #entry.getAuthorName()#
		</div>
		
		<!--- Title --->
		<h2><a href="#bb.linkEntry(entry)#" rel="bookmark" title="#entry.getTitle()#">#entry.getTitle()#</a></h2>
		
		<!--- Category Bar --->
		<span class="post-cat">#bb.quickCategoryLinks(entry)#</span> 
		
		<!--- content --->
		<div class="post-content">
			<!--- excerpt or content --->
			<cfif entry.hasExcerpt()>
				#entry.getExcerpt()#
				<div class="post-more">
					<a href="#bb.linkEntry(entry)#" title="Read The Full Entry!"><button class="button2">Read More...</button></a>
				</div>
			<cfelse>
				#entry.getContent()#
			</cfif>
		</div>
		
	</div>
	
	<!--- Comments --->
	<div class="post-comments">
		<cfif bb.isCommentsEnabled(entry)>
			<!--- Comment Count --->
			<a href="#bb.linkEntry(entry)###comments" title="Check out this entry's comments">
				<img src="#bb.layoutRoot()#/includes/images/comments.png" alt="comments"/> #entry.getNumberOfComments()# Comment(s)
			</a>		
		<cfelse>
			<strong><em>Comments Closed</em></strong>
		</cfif>									
	</div>
		
	<div class="separator"></div>
</div>
</cfoutput>