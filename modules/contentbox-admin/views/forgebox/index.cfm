<cfoutput>
#html.startForm(name="forgeBoxInstall",action=prc.xehForgeBoxInstall)#
#html.hiddenField(name="installDir",value=rc.installDir)#
#html.hiddenField(name="returnURL",value=rc.returnURL)#
#html.hiddenField(name="downloadURL")#

<cfif prc.errors>
#getPlugin("MessageBox").renderit()#
<cfelse>
	<div class="floatRight infoBar">
		<label class="inline">Sort By: </label>
		<a href="javascript:loadForgeBox('popular')">Popularity</a> |
		<a href="javascript:loadForgeBox('recent')">Recently Updated</a> |
		<a href="javascript:loadForgeBox('new')">New Stuff</a>
	</div>
	<!--- Title --->
	<h2>
		#prc.entriesTitle# - #prc.entries.recordcount# record(s)
	</h2>
	<!--- Instructions --->
	<p>
		Please note that not all contributed entries have a zip prepared for download. 
		So always verify your download URL first. You can also browse all of our online 
		<a href="http://www.coldbox.org/forgebox">ForgeBox Code Repository</a> to download
		items manually.
	</p>
	<!--- Filter Bar --->
	<div class="contentBar">
		<div class="filterBar">
			<div>
				#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
				#html.textField(name="entryFilter",size="30",class="textfield")#
			</div>
		</div>
	</div>
	<!--- Entries --->
	<cfloop query="prc.entries">
	<div class="forgeBox-entrybox" id="entry_#prc.entries.entryID#">
		<!--- Ratings --->
		<div class="forgebox-rating">
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 1>checked="checked"</cfif> value="1" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 2>checked="checked"</cfif> value="2" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 3>checked="checked"</cfif> value="3" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 4>checked="checked"</cfif> value="4" disabled="disabled"/>
			<input name="star_#prc.entries.entryID#" type="radio" class="star" <cfif prc.entries.entryRating gte 5>checked="checked"</cfif> value="5" disabled="disabled"/>
		</div>
		<!--- Info --->
		<h3>#prc.entries.title# v#prc.entries.version#</h3>
		<a href="#prc.entries.downloadURL#" title="Download URL" target="_blank"><img src="#prc.cbRoot#/includes/images/download_black.png" border="0"/> #prc.entries.downloadURL#</a>
		<p>#prc.entries.summary#</p>
		
		<!--- Description --->
		<cfif len(prc.entries.description)>
			<a href="javascript:openForgeboxModal('entry_description_#prc.entries.entryID#')">> Read Description</a>
			<div id="entry_description_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Description</h2>
				#prc.entries.description#
			</div><br />
		</cfif>
		<!--- Install Instructions --->
		<cfif len(prc.entries.installinstructions)>
			<a href="javascript:openForgeboxModal('entry_ii_#prc.entries.entryID#')">> Read Installation Instructions</a>
			<div id="entry_ii_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Installation Instructions</h2>
				#prc.entries.installinstructions#
			</div><br />
		</cfif>
		<!--- Changelog --->
		<cfif len(prc.entries.changelog)>
			<a href="javascript:openForgeboxModal('entry_cl_#prc.entries.entryID#')">> Read Changelog</a>
			<div id="entry_cl_#prc.entries.entryID#" class="forgebox-infobox" style="display:none">
				<h2>Changelog</h2>
				#prc.entries.changelog#
			</div><br />
		</cfif>
		<br/>
		<!--- Download & Install --->
		<div class="forgebox-download">
			<cfif findnocase("zip", prc.entries.downloadURL)>
			<a href="javascript:installEntry('entry_#prc.entries.entryID#','#prc.entries.downloadURL#')"
			   onclick="return confirm('Really install it?')"
			   title="Install Entry"><img src="#prc.cbRoot#/includes/images/entry-link.png" alt="Download" border="0" /></a>
			<cfelse>
			<div class="infoBar"><img src="#prc.cbroot#/includes/images/warning_icon.png"/> No zip detected, manual install only!</div>
			</cfif>	
		</div>
		<!--- Info --->
		<p>
			#getMyPlugin(plugin="Avatar",module="contentbox").renderAvatar(email=prc.entries.username,size="30")#
			<label class="inline">By: </label> <a title="Open Profile" href="http://www.coldbox.org/profiles/show/#prc.entries.username#" target="_blank">#prc.entries.username#</a> |
			<label class="inline">Updated: </label> #dateFormat(prc.entries.updatedate)# |
			<label class="inline">Downloads: </label> #prc.entries.downloads# |
			<label class="inline">Views: </label> #prc.entries.hits#<br />
		</p>
	</div>
	</cfloop>
	<cfif NOT prc.entries.recordcount>
		#getPlugin("MessageBox").renderMessage("warning","No Entries Found!")#
	</cfif>
	#html.endForm()#
</cfif>
</cfoutput>