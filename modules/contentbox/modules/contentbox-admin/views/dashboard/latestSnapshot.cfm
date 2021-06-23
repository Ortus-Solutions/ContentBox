<cfoutput>
<!--- Snapshot Box --->
<div class="panel panel-primary">
    <div class="panel-heading">
		<h3 class="panel-title">
			<i class="fas fa-flag-checkered fa-lg"></i> #$r( "dashboard.latestSnapshot.title@admin" )#
		</h3>
	</div>

    <div class="panel-body panel-group accordion" id="accordion">
        <!---Begin Top Visited--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle block" data-toggle="collapse" data-parent="##accordion" href="##topcontent">
                    <i class="fas fa-chart-pie fa-lg"></i> #$r( "dashboard.latestSnapshot.topHitsAndComments.head@admin" )#
                </a>
            </div>
            <div id="topcontent" class="panel-collapse collapse active in">
                <div class="panel-body">
                    <!--- Top Visited Content Chart --->
                    <div id="top-visited-chart"></div>
                    <!--- Table Report --->
                    <table class="table  table-hover table-striped" width="100%">
                        <thead>
                            <tr>
                                <th>#$r( "dashboard.latestSnapshot.topHitsAndComments.table.head1@admin" )#</th>
                                <th width="40" class="text-center">#$r( "dashboard.latestSnapshot.topHitsAndComments.table.head2@admin" )#</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#prc.topContent#" index="topContent">
                                <tr>
                                    <td>
                                        <a href="#prc.CBHelper.linkContent( topContent )#">#topContent.getTitle()#</a>
                                    </td>
                                    <td class="text-center">#topContent.getNumberOfHits()#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                    <!--- Top Visited Content Chart --->
                    <div id="top-commented-chart"></div>
                    <!--- Table Report --->
                    <table class="table  table-hover table-striped" width="100%">
                        <thead>
                            <tr>
                                <th>#$r( "dashboard.latestSnapshot.topHitsAndComments.table2.head1@admin" )#</th>
                                <th width="40" class="text-center">#$r( "dashboard.latestSnapshot.topHitsAndComments.table2.head2@admin" )#</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#prc.topCommented#" index="topCommented">
                                <tr>
                                    <td>
                                        <a href="#prc.CBHelper.linkContent( topCommented )#">#topCommented.getTitle()#</a>
                                    </td>
                                    <td class="text-center">#topCommented.getNumberOfComments()#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!---End Top Visited--->

        <!---Begin Discussions--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle block" data-toggle="collapse" data-parent="##accordion" href="##discussion">
                    <i class="far fa-comments fa-lg"></i> #$r( "dashboard.latestSnapshot.discussionCounts@admin" )#
                </a>
            </div>
            <div id="discussion" class="panel-collapse collapse">
                <div class="panel-body">
                    <ul>
						<li>
							<a
								title="View Comments"
								href="#event.buildLink( prc.xehComments )#">
								#prc.commentsCount# Comments
							</a>
						</li>
						<li>
							<a
								title="View Approved Comments"
								href="#event.buildLink( prc.xehComments )#?fStatus=true">
								#prc.commentsApprovedCount# Approved
							</a>
						</li>
						<li>
							<a
								title="View UnApproved Comments"
								href="#event.buildLink( prc.xehComments )#?fStatus=false">
								#prc.commentsUnApprovedCount# Pending
							</a>
						</li>
                    </ul>
                </div>
            </div>
        </div>
        <!---End Discussions--->

        <!---Begin Content--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle block" data-toggle="collapse" data-parent="##accordion" href="##content">
                    <i class="fas fa-box fa-lg"></i> #$r( "dashboard.latestSnapshot.contentCounts@admin" )#
                </a>
            </div>
            <div id="content" class="panel-collapse collapse">
                <div class="panel-body">
                    <ul>
						<li>
							<a
								title="View Entries"
								href="#event.buildLink( prc.xehEntries )#"
							>
								#prc.entriesCount# Entries
							</a>
						</li>
						<li>
							<a
								title="View Entries"
								href="#event.buildLink( prc.xehPages )#"
							>
								#prc.pagesCount# Page(s)
							</a>
						</li>
						<li>
							<a
								title="View Categories"
								href="#event.buildLink( prc.xehCategories )#"
							>
								#prc.categoriesCount# Categories
							</a>
						</li>
                    </ul>
                </div>
            </div>
        </div>
        <!---End Content--->
    </div>
</div>
</cfoutput>