<cfoutput>
<div class="modal-dialog modal-lg" role="document" >

	<div class="modal-content">

        <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
				&times;
			</button>
			<h3>
				<i class="fas fa-sitemap"></i> Select Related Content
			</h3>
		</div>

        <div class="modal-body">
        #html.startForm( name="relatedContentSelectorForm" )#

			<!--- Filter --->
			<div class="form-group">
				<div class="input-group input-group-sm">
					<input
						type="text"
						class="form-control rounded"
						placeholder="Quick Filter"
						aria-describedby="sizing-addon3"
						name="contentSearch"
						id="contentSearch"
						value ="#rc.search#"
					>
					<span
						class="input-group-addon cursor-pointer"
						id="sizing-addon3"
						title="Clear Search"
						onclick="clearSearch()"
					>
						<i class="far fa-times-circle fa-lg"></i>
					</span>
				</div>
			</div>

			<!--- Loader --->
            <div class="loaders float-right" id="relatedContentLoader">
                <i class="fa fa-circle-notch fa-spin fa-lg"></i>
            </div>

            <!--- Render tables out --->
            <div id="contentContainer" class="tab-wrapper tab-top tab-primary">

				<ul class="nav nav-tabs" id="contentTypes">
                    <!---loop over content types--->
                    <cfset types = listToArray( rc.contentType )>
                    <cfloop from="1" to="#arrayLen( types )#" index="i">
                        <cfset ct = types[ i ]>
                        <li <cfif i eq 1> class="active"</cfif>>
							<a href="###ct#" data-toggle="tab">
								<i class="#getContentTypeIconCls( ct )#" title="#ct#"></i> #ct#
							</a>
                        </li>
                    </cfloop>
				</ul>

                <div class="tab-content">
                    <cfloop from="1" to="#arrayLen( types )#" index="i">
                        <cfset ct = types[ i ]>
                        <div class="tab-pane fade<cfif i eq 1> active in</cfif>" id="#ct#"></div>
                    </cfloop>
                </div>
            </div>


        #html.endForm()#
		</div>

        <!--- Button Bar --->
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeRemoteModal()"> Close </button>
		</div>

    </div>
</div>
</cfoutput>