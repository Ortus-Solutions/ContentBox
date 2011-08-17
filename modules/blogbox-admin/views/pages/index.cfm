<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/search.png" alt="info" width="24" height="24" />Search
		</div>
		<div class="body<cfif len(rc.searchPages)> selected</cfif>">
			<!--- Search Form --->
			#html.startForm(name="authorSearchForm",action=prc.xehPageSearch)#
				#html.textField(label="Search:",name="searchPages",class="textfield",size="16",title="Search all pages",value=event.getValue("searchPages",""))#
				<input type="submit" value="Search" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehPages)#')">Clear</button>				
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Filter Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/filter.png" alt="info" width="24" height="24" />Filters
		</div>
		<div class="body<cfif prc.isFiltering> selected</cfif>">
			#html.startForm(name="pageFilterForm",action=prc.xehPageSearch)#
			<!--- Authors --->
			<label for="fAuthors">Authors: </label>
			<select name="fAuthors" id="fAuthors" style="width:200px">
				<option value="all" <cfif rc.fAuthors eq "all">selected="selected"</cfif>>All Authors</option>
				<cfloop array="#prc.authors#" index="author">
				<option value="#author.getAuthorID()#" <cfif rc.fAuthors eq author.getAuthorID()>selected="selected"</cfif>>#author.getName()#</option>
				</cfloop>
			</select>
			<!--- Status --->
			<label for="fStatus">Page Status: </label>
			<select name="fStatus" id="fStatus" style="width:200px">
				<option value="any"   <cfif rc.fStatus eq "any">selected="selected"</cfif>>Any Status</option>
				<option value="true"  <cfif rc.fStatus eq "true">selected="selected"</cfif>>Published</option>
				<option value="false" <cfif rc.fStatus eq "false">selected="selected"</cfif>>Draft</option>				
			</select>
				
			<div class="actionBar">
				<input type="submit" value="Apply Filters" class="buttonred" />
				<button class="button" onclick="return to('#event.buildLink(prc.xehPages)#')">Reset</button>				
			</div>			
			#html.endForm()#
		</div>
	</div>	
	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.bbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li title="Click Me!" onclick="exposeIt('##pages')">Right click on a row to activate quick look!</li>
				<li title="Click Me!" onclick="exposeIt('##main_column')">Sorting is only done within your paging window</li>
				<li title="Click Me!" onclick="exposeIt('##contentBar')">Quick Filtering is only for viewed results</li>
				<li title="Click Me!" onclick="exposeIt('##th_order')">Order down means increase ordering index</li>
				<li title="Click Me!" onclick="exposeIt('##th_order')">Order up means decrease ordering index</li>
			</ul>
		</div>
	</div>		
</div>
<!--End sidebar-->	
<!--============================Main Column============================-->
<div class="main_column" id="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<img src="#prc.bbroot#/includes/images/page_big.png" alt="sofa" width="30" height="30" />
			Pages (#prc.pagesCount#)
			<cfif len(rc.searchPages)> > Search: #rc.searchPages#</cfif>
			<cfif prc.isFiltering> > Filtered View</cfif>
		</div>
		<!--- Body --->
		<div class="body">
			
			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#
			
			<!--- pageForm --->
			#html.startForm(name="pageForm",action=prc.xehPageRemove)#
			<input type="hidden" name="pageID" id="pageID" value="" />
			
			<!--- Info Bar --->
			<cfif NOT prc.bbSettings.bb_comments_enabled>
				<div class="infoBar">
					<img src="#prc.bbRoot#/includes/images/info.png" alt="comments" />
					Comments are currently disabled site-wide!
				</div>
			</cfif>
			
			<!--- Content Bar --->
			<div class="contentBar" id="contentBar">
				
				<!--- Create Butons --->
				<div class="buttonBar">
					<button class="button2" onclick="return to('#event.buildLink(prc.xehPageEditor)#');" title="Create new page">Create Page</button>
				</div>
				
				<!--- Filter Bar --->
				<div class="filterBar">
					<div>
						#html.label(field="pageFilter",content="Quick Filter:",class="inline")#
						#html.textField(name="pageFilter",size="30",class="textfield")#
					</div>
				</div>
			</div>
			
			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#
			
			<!--- Location Bar --->
			<cfif len(rc.parent)>
			<div class="infoBar">
			  <a href="#event.buildLink(prc.xehPages)#">Root</a> #getMyPlugin(plugin="PageBreadcrumbVisitor",module="blogbox-admin").visit(prc.page, event.buildLink(prc.xehPages))#
			</div>
			</cfif>
			
			<!--- pages --->
			<table name="pages" id="pages" class="tablesorter" width="98%">
				<thead>
					<tr>
						<th width="15" class="center {sorter:false}"></th>
						<th>Name</th>
						<th width="55" class="center" id="th_order"><img src="#prc.bbRoot#/includes/images/sort.png" alt="order" title="Page Order"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/parent_color_small.png" alt="order" title="Child Pages"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/publish.png" alt="publish" title="Published"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/glasses.png" alt="hits" title="Hits"/></th>
						<th width="40" class="center"><img src="#prc.bbRoot#/includes/images/comments.png" alt="comments" title="Comments"/></th>
						<th width="95" class="center {sorter:false}">Actions</th>
					</tr>
				</thead>
				
				<tbody>
					<cfloop array="#prc.pages#" index="page">
					<tr data-pageID="#page.getPageID()#" <cfif NOT page.getIsPublished()>class="selected"</cfif>>
						<td class="middle">
							<!--- Children Dig Deeper --->
							<cfif page.getNumberOfChildren()>
								<a href="#event.buildLink(prc.xehPages)#/parent/#page.getPageID()#" title="View Child Pages (#page.getNumberOfChildren()#)"><img src="#prc.bbRoot#/includes/images/plus.png" alt="child" border="0"/></a>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/page.png" alt="child"/>
							</cfif>
						</td>
						<td>
							<!--- Title --->
							<a href="#event.buildLink(prc.xehPageEditor)#/pageID/#page.getPageID()#" title="Edit Page">#page.getTitle()#</a><br>
							<!--- password protect --->
							<cfif page.isPasswordProtected()>
								<img src="#prc.bbRoot#/includes/images/lock.png" alt="locked" title="Page is password protected"/>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/lock_off.png" alt="locked" title="Page is public"/>
							</cfif>
							&nbsp;
							<!--- comments icon --->
							<cfif page.getallowComments()>
								<img src="#prc.bbRoot#/includes/images/comments.png" alt="locked" title="Commenting is Open!"/>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/comments_off.png" alt="locked" title="Commenting is Closed!"/>
							</cfif>
						</td>
						<td class="center">
							#page.getOrder()#
							<!--- Order Up --->
							<cfif ( page.getOrder()-1 ) GTE 0 >
								<a href="javascript:changeOrder('#page.getPageID()#', #page.getOrder()-1#,'up')" title="Order Up"><img id="orderup_#page.getPageID()#" src="#prc.bbRoot#/includes/images/_up.gif" alt="order"/></a>
							</cfif>
							<!--- Increase Order Index--->
							<a href="javascript:changeOrder('#page.getPageID()#',#page.getOrder()+1#,'down')" title="Order Down"><img id="orderdown_#page.getPageID()#" src="#prc.bbRoot#/includes/images/_down.gif" alt="order"/></a>
						
						</td>
						<td class="center">
							#page.getNumberOfChildren()#
						</td>
						<td class="center">
							<cfif page.getIsPublished()>
								<img src="#prc.bbRoot#/includes/images/button_ok.png" alt="published" title="Page Published!" />
								<span class="hidden">published</span>
							<cfelse>
								<img src="#prc.bbRoot#/includes/images/button_cancel.png" alt="draft" title="Page Draft!" />
								<span class="hidden">draft</span>
							</cfif>
						</td>
						<td class="center">#page.getHits()#</td>
						<td class="center">#page.getNumberOfComments()#</td>
						<td class="center">
							<!--- Edit Command --->
							<a href="#event.buildLink(prc.xehPageEditor)#/pageID/#page.getPageID()#" title="Edit #page.getTitle()#"><img src="#prc.bbroot#/includes/images/edit.png" alt="edit" border="0"/></a>
							&nbsp;
							<!--- Create Child --->
							<a href="#event.buildLink(prc.xehPageEditor)#/parentID/#page.getPageID()#" title="Create Child Page"><img src="#prc.bbroot#/includes/images/parent.png" alt="edit" border="0"/></a>
							&nbsp;
							<!--- View in Site --->
							<a href="#prc.bbHelper.linkPage(page)#" title="View Page In Site" target="_blank"><img src="#prc.bbroot#/includes/images/eye.png" alt="edit" border="0"/></a>
							&nbsp;
							<!--- Delete Command --->
							<a title="Delete Page" href="javascript:remove('#page.getPageID()#')" class="confirmIt" data-title="Delete Page?"><img id="delete_#page.getPageID()#" src="#prc.bbroot#/includes/images/delete.png" border="0" alt="delete"/></a>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!--- Paging --->
			#prc.pagingPlugin.renderit(prc.pagesCount,prc.pagingLink)#
		
			#html.endForm()#

		</div>	
	</div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	$("##pages").tablesorter();
	$("##pageFilter").keyup(function(){
		$.uiTableFilter( $("##pages"), this.value );
	});
	// quick look
	$("##pages").find("tr").mousedown(function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-pageID') != null) {
				openRemoteModal('#event.buildLink(prc.xehPageQuickLook)#/pageID/' + $(this).attr('data-pageID'));
				e.preventDefault();
			}
	    }
	});

});
function remove(pageID){
	// img change
	$('##delete_'+pageID).attr('src','#prc.bbRoot#/includes/images/ajax-spinner.gif');
	$("##pageID").val( pageID );
	$("##pageForm").submit();
}
function changeOrder(pageID,order,direction){
	// img change
	$('##order'+direction+'_'+pageID).attr('src','#prc.bbRoot#/includes/images/ajax-spinner.gif');
	// change order
	$.post('#event.buildLink(prc.xehPageOrder)#',{pageid:pageID,order:order},function(){
		location.reload(true);
	});
}
</script>

</cfoutput>