<cfoutput>
<cfif arrayLen( prc.content )>
    <!--- matches --->
    <table name="content" id="#rc.contentType#" class="table table-hover table-striped-removed " >
        <thead>
            <tr>
				<th>
					Title
				</th>
				<th width="40" class="text-center">
					Status
				</th>
				<th width="60" class="text-center">
					Select
				</th>
            </tr>
		</thead>

        <tbody>
            <cfloop array="#prc.content#" index="content">
			<tr
				id="contentID-#content.getContentID()#"
				<cfif NOT content.getIsPublished()>
					class="warning"
				</cfif>
				ondblclick="return chooseRelatedContent(
					'#content.getContentID()#',
					'#encodeForJavaScript( content.getTitle() )#',
					'#encodeForJavaScript( content.getContentType() )#',
					'#encodeForJavaScript( content.getSlug() )#'
				)"
				title="Double click to select"
			>
                <td>
                    <!--- Title --->
					<div class="size16">
						#content.getTitle()#
					</div>

					<div class="mt5">
						<div class="text-muted">
						<cfif content.getContentType() eq "contentStore">
							#content.getDescription()#
						<cfelse>
							<cfif content.hasExcerpt()>
								#prc.cbHelper.stripHTML( left( content.getExcerpt(), 100 ) )#
							<cfelse>
								#prc.cbHelper.stripHTML( left( content.getContent(), 100 ) )#
							</cfif>
							...
						</cfif>
						</div>
					</div>
				</td>

				<td class="text-center">
					#renderView(
						view : "_components/content/TableStatus",
						args : { content : content },
						prepostExempt : true
					)#
				</td>

                <td class="text-center">
                    <div class="btn-group">
                        <button
                        	class="btn btn-sm btn-more"
                        	onclick="return chooseRelatedContent(
								'#content.getContentID()#',
								'#encodeForJavaScript( content.getTitle() )#',
								'#encodeForJavaScript( content.getContentType() )#',
								'#encodeForJavaScript( content.getSlug() )#'
							)"
							title="Select"
						>
                            <i class="far fa-check-circle fa-lg"></i>
                        </button>
                    </div>
                </td>
            </tr>
            </cfloop>
        </tbody>
	</table>

<cfelse>
    <div class="alert alert-warning">
        <h4>Sorry!</h4>
		<p>
			No results were found matching your search
			<code>#encodeForHTML( rc.search )#</code>
		</p>
    </div>
</cfif>

<!--- Paging --->
#prc.oPaging.renderit(
	foundRows = prc.contentCount,
	link      = prc.pagingLink,
	asList    = true
)#
</cfoutput>