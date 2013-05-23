<cfoutput>
<!--- Snapshot Box --->
<div class="small_box">
	<div class="header">
		<i class="icon-camera"></i> Data Snapshots
	</div>
	<div class="body">
	    <!---Begin Accordion--->
		<div id="accordion" class="accordion">
		    <!---Begin Top Visited--->
		    <div class="accordion-group">
            	<div class="accordion-heading">
              		<a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##topvisited">
                		<i class="icon-bar-chart icon-large"></i> Top Visited Content
              		</a>
            	</div>
            	<div id="topvisited" class="accordion-body collapse in">
              		<div class="accordion-inner">
						<cfchart chartwidth="265" format="png" tipstyle="mouseOver" showlegend="false" >
							<cfchartseries type="pie" colorlist="##B22222,##FF69B4,##FF8C00, ##1E90FF,##ADFF2F" datalabelstyle="value"  >
								<cfloop array="#prc.topContent#" index="topContent">
									<cfchartdata item="#topContent.getTitle()#.."  value="#topContent.getHits()#">
								</cfloop>
							</cfchartseries>
						</cfchart>
						
						<table class="table table-condensed table-hover table-striped tablesorter" width="100%">
							<thead>
								<tr>
									<th>Title</th>
									<th width="40" class="center">Hits</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#prc.topContent#" index="topContent">
									<tr>
										<td>
											<a href="#prc.CBHelper.linkContent( topContent )#">#topContent.getTitle()#</a>
										</td>
										<td class="center">#topContent.getHits()#</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
              		</div>
            	</div>
          	</div>
            <!---End Top Visited--->
			
			<!---Begin Top Commented--->
		    <div class="accordion-group">
            	<div class="accordion-heading">
              		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##topcommented">
                		<i class="icon-bar-chart icon-large"></i> Top Commented Content
              		</a>
            	</div>
            	<div id="topcommented" class="accordion-body collapse">
              		<div class="accordion-inner">
						<cfchart chartwidth="265" format="png" tipstyle="none" >
							<cfchartseries type="bar" colorlist="##B22222,##FF69B4,##FF8C00, ##1E90FF,##ADFF2F" datalabelstyle="value">
								<cfloop array="#prc.topCommented#" index="topCommented">
									<cfchartdata item="#topCommented.getTitle()#"  value="#topCommented.getNumberOfComments()#">
								</cfloop>
							</cfchartseries>
						</cfchart>
						
						<table class="table table-condensed table-hover table-striped tablesorter" width="100%">
							<thead>
								<tr>
									<th>Title</th>
									<th width="40" class="center">Comments</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#prc.topCommented#" index="topCommented">
									<tr>
										<td>
											<a href="#prc.CBHelper.linkContent( topCommented )#">#topCommented.getTitle()#</a>
										</td>
										<td class="center">#topCommented.getNumberOfComments()#</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
              		</div>
            	</div>
          	</div>
            <!---End Top Commented--->
			
			<!---Begin Discussion--->
		    <div class="accordion-group">
            	<div class="accordion-heading">
              		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##discussion">
                		<i class="icon-comments icon-large"></i> Discussions
              		</a>
            	</div>
            	<div id="discussion" class="accordion-body collapse">
              		<div class="accordion-inner">
						<ul>
							<li><a title="View Comments" href="#event.buildLink(prc.xehComments)#">#prc.commentsCount# Comments</a> </li>
							<li><a title="View Approved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=true">#prc.commentsApprovedCount# Approved</a></li>
							<li><a title="View UnApproved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=false">#prc.commentsUnApprovedCount# Pending</a> </li>
						</ul>	
              		</div>
            	</div>
          	</div>
            <!---End Discussion--->
				
			<!---Begin Content--->
		    <div class="accordion-group">
            	<div class="accordion-heading">
              		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="##accordion" href="##content">
                		<i class="icon-pencil icon-large"></i> Content
              		</a>
            	</div>
            	<div id="content" class="accordion-body collapse">
              		<div class="accordion-inner">
						<ul>
							<li><a title="View Entries" href="#event.buildLink(prc.xehEntries)#">#prc.entriesCount# Entries</a> </li>
							<li><a title="View Entries" href="#event.buildLink(prc.xehPages)#">#prc.pagesCount# Page(s)</a> </li>
							<li><a title="View Categories" href="#event.buildLink(prc.xehCategories)#">#prc.categoriesCount# Categories</a> </li>
						</ul>
              		</div>
            	</div>
          	</div>
            <!---End Content--->	
        </div>	
		<!---End Accordion--->
	</div>
</div>
</cfoutput>