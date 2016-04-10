<cfoutput>
#html.addAsset( "#prc.cbRoot#/includes/css/diff.css" )#
<div id="diff">
	<div class="modal-dialog modal-lg" role="document" >
		<div class="modal-content">
            <!--header-->
            <div class="modal-header">
                <!--if dismissable-->
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="diffTitle">
                	<i class="fa fa-clock-o fa-lg"></i>
					Comparing Version <strong>#prc.currentVersion#</strong> and <strong>#prc.oldVersion#</strong>
				</h4>
            </div>
            <!--body-->
            <div class="modal-body">
                <h3>Version Info Comparison</h3>
				<!--- Info Table --->
				<table class="table table-hover table-condensed table-bordered">
					<tbody>
					<tr class="info">
						<th class="text-center" width="150">Info</th>
						<th class="text-center">Version #prc.oldVersion#</th>
						<th class="text-center">Version #prc.currentVersion#</th>
					</tr>
					<tr>
						<td><strong>Author</strong></td>
						<td><a href="mailto:#prc.oldContent.getAuthorEmail()#">#prc.oldContent.getAuthorName()#</a></td>
						<td><a href="mailto:#prc.currentContent.getAuthorEmail()#">#prc.currentContent.getAuthorName()#</a></td>
						
					</tr>
					<tr>
						<td><strong>Created Date</strong></td>
						<td>#prc.oldContent.getDisplayCreatedDate()#</td>
						<td>#prc.currentContent.getDisplayCreatedDate()#</td>
					</tr>
					<tr>
						<td><strong>Changelog</strong></td>
						<td>#prc.oldContent.getChangelog()#</td>
						<td>#prc.currentContent.getChangeLog()#</td>
					</tr>
					</tbody>
				</table>


				<!--- Legend --->
				<h3>Content Differences</h3>
				<div id="legend">
					<dl>
						<dt /><dd>Unmodified</dd>
						<dt class="ins"/><dd>Added</dd>
						<dt class="del"/><dd>Removed</dd>
						<dt class="upd"/><dd>Modified</dd>
					</dl>
				</div>

				<!--- Simple Comparisons --->
				<table class="diff table table-condensed">
					<thead>
						<tr>
							<th colspan="2" class="text-center">Version #prc.oldVersion#</th>
							<th colspan="2" class="text-center">Version #prc.currentVersion#</th>
						</tr>
					</thead>
					<tbody>
						<cfloop from="1" to="#prc.maxA#" index="x">
							<!--- Checks --->
							<cfset codeCSS = getCodeCSS(prc.rightA, prc.leftA, x)>
							<tr>
								<!--- Left --->
								<td class="linenum"><cfif arrayIsDefined( prc.leftA, x )>#x#<cfelse>&nbsp;</cfif></td>
								<td width="50%" class="code#codeCSS#">
									<div class="diffContent">
										<cfif arrayIsDefined( prc.leftA, x )>
										#Replace(HTMLEditFormat( prc.leftA[ x ] ),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL" )#
										</cfif>
									</div>
								</td>
								
								<!--- Right --->
								<td class="linenum"><cfif arrayIsDefined( prc.rightA, x )>#x#<cfelse>&nbsp;</cfif></td>
								<td width="50%" class="code#codeCSS#">
									<div class="diffContent">
										<cfif arrayIsDefined( prc.rightA, x )>
										#Replace(HTMLEditFormat( prc.rightA[ x ] ),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL" )#
										</cfif>
									</div>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
            </div>
            <!-- footer -->
            <div class="modal-footer">
                <button class="btn" onclick="closeRemoteModal()"> Close </button>
            </div>
        </div>
    </div>
</div>
</cfoutput>