<cfoutput>
#html.startForm(name="forgeBoxInstall",action=prc.xehForgeBoxInstall)#
#html.hiddenField(name="installDir",value=rc.installDir)#
#html.hiddenField(name="returnURL",value=rc.returnURL)#
#html.hiddenField(name="downloadURL")#

<cfif prc.errors>
#getPlugin("MessageBox").renderit()#
<cfelse>
	<!--- Title --->
	<h2>
		#prc.entriesTitle# - #prc.entries.recordcount# record(s)
	</h2>
	<!--- Instructions --->
	<p>
		Please note that not all contributed entries can be automatically installed for you. 
		A button much like this <button class="btn btn-primary btn-small" onclick="return false;">Download & Install</button>
		will appear if an item can be automatically installed for you.  If not, you will 
		have to download the entry manually and upload it to install it.
		 You can also browse all of our online 
		<a href="http://www.coldbox.org/forgebox">ForgeBox Code Repository</a> to download
		items manually.
	</p>
	<!--- Filter Bar --->
	<div class="well well-small">
		<div class="filterBar">
			<div class="btn-group pull-right">
			    <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="##">
			    <i class="icon-sort"></i> Sort By
			    <span class="caret"></span>
			    </a>
			    <ul class="dropdown-menu">
			    	<li><a href="javascript:loadForgeBox('popular')"><i class="icon-thumbs-up"></i> Popularity</a></li>
					<li><a href="javascript:loadForgeBox('recent')"><i class="icon-calendar"></i> Recently Updated</a></li>
					<li><a href="javascript:loadForgeBox('new')"><i class="icon-gift"></i> New Stuff</a>
			    </ul>
		    </div>
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
		<a href="#prc.entries.downloadURL#" title="Download URL" target="_blank"><i class="icon-download icon-large"></i> #prc.entries.downloadURL#</a>
		<p>#prc.entries.summary#</p>
		
		<!--- Description --->
		<cfif len(prc.entries.description)>
			<a href="##entry_description_#prc.entries.entryID#" role="button" data-toggle="modal"><i class="icon-plus"></i> Read Description</a>
			<div id="entry_description_#prc.entries.entryID#" class="modal forgebox-modal hide fade">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3>Description</h3>
				</div>
				<div class="modal-body">
				#prc.entries.description#
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				</div>
			</div><br/>
		</cfif>
		<!--- Install Instructions --->
		<cfif len(prc.entries.installinstructions)>
			<a href="##entry_ii_#prc.entries.entryID#" role="button" data-toggle="modal"><i class="icon-plus"></i> Read Installation Instructions</a>
			<div id="entry_ii_#prc.entries.entryID#" class="modal forgebox-modal hide fade">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3>Installation Instructions</h3>
				</div>
				<div class="modal-body">
				#prc.entries.installinstructions#
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				</div>
			</div><br/>
		</cfif>
		<!--- Changelog --->
		<cfif len(prc.entries.changelog)>
			<a href="##entry_cl_#prc.entries.entryID#" role="button" data-toggle="modal"><i class="icon-plus"></i> Read Changelog</a>
			<div id="entry_cl_#prc.entries.entryID#" class="modal forgebox-modal hide fade">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3>Changelog</h3>
				</div>
				<div class="modal-body">
				#prc.entries.changelog#
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
				</div>
			</div><br/>
		</cfif>
		<br/>
		<!--- Download & Install --->
		<div class="forgebox-download">
			<cfif findnocase(".zip", prc.entries.downloadURL)>
			<a href="javascript:installEntry('entry_#prc.entries.entryID#','#prc.entries.downloadURL#')" class="btn btn-primary">
			   	<span>Download & Install</span>
			</a>
			<cfelse>
			<div class="alert"><i class="icon-exclamation-sign icon-large"></i> No zip detected, manual install only!</div>
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