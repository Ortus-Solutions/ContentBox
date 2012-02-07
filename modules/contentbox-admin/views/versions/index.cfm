<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Saerch Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/notice.png" alt="info" width="24" height="24" />#prc.content.getContentType()# Snapshot
		</div>
		<div class="body">
			<table class="tablelisting" width="100%">
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
				<button class="button2" onclick="to('#event.buildLink(prc.xehBackTrack)#');return false;">Back To Listing</button>
				<button class="button2" onclick="window.open('#prc.CBHelper.linkContent(prc.content)#');return false;">Open In Site</button>
			</div>
		</div>
	</div>	
	
	<!--- Help Box--->
	<div class="small_box" id="help_tips">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/help.png" alt="info" width="24" height="24" />Help Tips
		</div>
		<div class="body">
			<ul class="tipList">
				<li title="Click Me!" onclick="exposeIt('##versionsHistoryTable')">Right click on a row to activate quick look!</li>
				<li>Rollback will create a new version with the rollbacked content</li>
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
			<img src="#prc.cbroot#/includes/images/clock.png" alt="versions" width="30" height="30" />
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
</cfoutput>