<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
	    <div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-tasks icon-large"></i>
				Custom HTML
			</div>
			<!--- Body --->
			<div class="body">	
			
			<!--- messageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- Info --->
			<p>
				Custom HTML can be used in any layout or content to easily add any type of HTML assets, snippets, custom css, js, 
				you name it!
			</p>
			
			<!--- entryForm --->
			#html.startForm(name="contentForm",action=prc.xehRemoveHTML)#
				#html.hiddenField(name="page",value=rc.page)#
				#html.hiddenField(name="contentID")#
			
				<!--- Content Bar --->
				<div class="well well-small" id="contentBar">
					<!--- Create Butons --->
					<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
					<div class="buttonBar">
						<!---Global --->
						<div class="btn-group">
					    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
								Global Actions <span class="caret"></span>
							</a>
					    	<ul class="dropdown-menu">
					    		<li class="dropdown-submenu">
									<a href="##"><i class="icon-download icon-large"></i> Export All</a>
									<ul class="dropdown-menu text-left">
										<li><a href="#event.buildLink(linkto=prc.xehExportAllHTML)#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
										<li><a href="#event.buildLink(linkto=prc.xehExportAllHTML)#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
									</ul>
								</li>
					    	</ul>
					    </div>
						<!---Create --->
						<button class="btn btn-danger" onclick="return to('#event.buildLink(prc.xehEditorHTML)#');">Create Content</button>
					</div>
					</cfif>
					
					<!--- Filter Bar --->
					<div class="filterBar">
						<div>
							#html.label(field="entryFilter",content="Quick Filter:",class="inline")#
							#html.textField(name="entryFilter",size="30",class="textfield")#
						</div>
					</div>
				</div>
				
				<!--- comments --->
				<table name="entries" id="entries" class="tablesorter table table-striped table-hover" width="98%">
					<thead>
						<tr>
							<th width="200">Title</th>
							<th>Slug</th>
							<th>Description</th>
							<th width="90" class="center {sorter:false}">Actions</th>
						</tr>
					</thead>
					
					<tbody>
						<cfloop array="#prc.entries#" index="entry">
						<tr>
							<td>
								<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
									<a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content">#entry.getTitle()#</a>
								<cfelse>
									#entry.getTitle()#
								</cfif>
							</td>
							<td>
								#entry.getSlug()#
							</td>
							<td>
								#entry.getDescription()#
							</td>
							<td class="center">
								
								<div class="btn-group">
							    	<a class="btn dropdown-toggle" data-toggle="dropdown" href="##" title="Page Actions">
										<i class="icon-cogs icon-large"></i>
									</a>
							    	<ul class="dropdown-menu text-left">
										<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN")>
										<!--- Edit Command --->
										<li><a href="#event.buildLink(prc.xehEditorHTML)#/contentID/#entry.getContentID()#" title="Edit Content"><i class="icon-edit icon-large"></i> Edit</a></li>
										<!--- Delete Command --->
										<li><a title="Delete Content Permanently" href="javascript:remove('#entry.getContentID()#')" class="confirmIt" data-title="Delete Content?"><i id="delete_#entry.getContentID()#" class="icon-trash icon-large"></i> Delete</a></li>
										<!--- Export --->
										<li class="dropdown-submenu">
											<a href="##"><i class="icon-download icon-large"></i> Export</a>
											<ul class="dropdown-menu text-left">
												<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.json" target="_blank"><i class="icon-code"></i> as JSON</a></li>
												<li><a href="#event.buildLink(linkto=prc.xehExportHTML)#/contentID/#entry.getContentID()#.xml" target="_blank"><i class="icon-sitemap"></i> as XML</a></li>
											</ul>
										</li>
										</cfif>
							    	</ul>
							    </div>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
				
				<!--- Paging --->
				#prc.pagingPlugin.renderit(foundRows=prc.entriesCount, link=prc.pagingLink, asList=true)#
			
			#html.endForm()#
			
			</div>
		</div>
	</div>    

	<!--- main sidebar --->    
	<div class="span3" id="main-sidebar">    
		<!--- Saerch Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-search"></i> Search
			</div>
			<div class="body<cfif len(rc.search)> selected</cfif>">
				<!--- Search Form --->
				#html.startForm(name="htmlSearchForm",action=prc.xehCustomHTML)#
					#html.textField(label="Search:",name="search",class="input-block-level",size="16",title="Search all content pieces",value=rc.search)#
					<button type="submit" class="btn btn-danger">Search</button>
					<button class="btn" onclick="return to('#event.buildLink(prc.xehCustomHTML)#')">Clear</button>				
				#html.endForm()#
			</div>
		</div>	
	</div>    
</div>
</cfoutput>