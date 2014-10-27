<cfoutput>
<!--- Snapshot Box --->
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-camera"></i> Data Snapshots</h3>
    </div>
    <div class="panel-body panel-group accordion" id="accordion">
        <!---Begin Top Visited--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##topvisited">
                    <i class="fa fa-bar-chart-o icon-large"></i> Top Visited Content
                </a>
            </div>
            <div id="topvisited" class="panel-collapse collapse active in">
                <div class="panel-body">
                    <!--- Top Visited Content Chart --->
                    <div id="top-visited-chart"></div>
                    <!--- Table Report --->
                    <table class="table table-condensed table-hover table-striped tablesorter" width="100%">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th width="40" class="text-center">Hits</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#prc.topContent#" index="topContent">
                                <tr>
                                    <td>
                                        <a href="#prc.CBHelper.linkContent( topContent )#">#topContent.getTitle()#</a>
                                    </td>
                                    <td class="text-center">#topContent.getHits()#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!---End Top Visited--->

        <!---Begin Top Commented--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##topcommented">
                    <i class="fa fa-bar-chart-o icon-large"></i> Top Commented Content
                </a>
            </div>
            <div id="topcommented" class="panel-collapse collapse in">
                <div class="panel-body">
                    <!--- Top Visited Content Chart --->
                    <div id="top-commented-chart"></div>
                    <!--- Table Report --->
                    <table class="table table-condensed table-hover table-striped tablesorter" width="100%">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th width="40" class="text-center">Comments</th>
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
        <!---End Top Commented--->

        <!---Begin Discussions--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##discussion">
                    <i class="fa fa-comments icon-large"></i> Discussions
                </a>
            </div>
            <div id="discussion" class="panel-collapse collapse">
                <div class="panel-body">
                    <ul>
                        <li><a title="View Comments" href="#event.buildLink(prc.xehComments)#">#prc.commentsCount# Comments</a> </li>
                        <li><a title="View Approved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=true">#prc.commentsApprovedCount# Approved</a></li>
                        <li><a title="View UnApproved Comments" href="#event.buildLink(prc.xehComments)#?fStatus=false">#prc.commentsUnApprovedCount# Pending</a> </li>
                    </ul>   
                </div>
            </div>
        </div>
        <!---End Discussions--->

        <!---Begin Content--->
        <div class="panel panel-default">
            <div class="panel-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="##accordion" href="##content">
                    <i class="fa fa-pencil icon-large"></i> Content
                </a>
            </div>
            <div id="content" class="panel-collapse collapse">
                <div class="panel-body">
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
</div>
</cfoutput>