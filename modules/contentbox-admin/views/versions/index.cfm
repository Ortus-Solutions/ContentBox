<cfoutput>
<div class="row-fluid">    
	<!--- main content --->    
	<div class="span9" id="main-content">    
	    <div class="box">
			<!--- Body Header --->
			<div class="header">
				<i class="icon-time icon-large"></i>
				Content Version History
			</div>
			<!--- Body --->
			<div class="body">
	
				<!--- MessageBox --->
				#getPlugin("MessageBox").renderit()#
	
				<!--- Version History Panel --->
				#prc.versionsPager#
	
			</div>
		</div>
	</div>    

	<!--- main sidebar --->    
	<div class="span3" id="main-sidebar">    
		<!--- Saerch Box --->
		<div class="small_box">
			<div class="header">
				<i class="icon-camera"></i> #prc.content.getContentType()# Snapshot
			</div>
			<div class="body">
				<table class="table table-hover table-condensed table-striped" width="100%">
					<tr>
						<th width="85" class="textRight">Title:</th>
						<td>
							#prc.content.getTitle()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Published On:</th>
						<td>
							#prc.content.getDisplayPublishedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Created On:</th>
						<td>
							#prc.content.getDisplayCreatedDate()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Version:</th>
						<td>
							#prc.content.getActiveContent().getVersion()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Views:</th>
						<td>
							#prc.content.getHits()#
						</td>
					</tr>
					<tr>
						<th class="textRight">Comments:</th>
						<td>
							#prc.content.getNumberOfComments()#
						</td>
					</tr>
				</table>
				<div class="center">
					<button class="btn btn-primary" onclick="to('#event.buildLink(prc.xehBackTrack)#/parent/#prc.content.getParentID()#');return false;"><i class="icon-reply"></i> Back</button>
					<button class="btn btn-primary" onclick="window.open('#prc.CBHelper.linkContent(prc.content)#');return false;"><i class="icon-eye-open"></i> Open</button>
				</div>
			</div>
		</div>
	
		<!--- Help Box--->
		<div class="small_box" id="help_tips">
			<div class="header">
				<i class="icon-question-sign"></i> Help Tips
			</div>
			<div class="body">
				<ul class="tipList unstyled">
					<li><i class="icon-lightbulb"></i> Right click on a row to activate quick look!</li>
					<li><i class="icon-lightbulb"></i> Rollback will create a new version with the rollbacked content.</li>
				</ul>
			</div>
		</div>
	</div>    
</div>
</cfoutput>