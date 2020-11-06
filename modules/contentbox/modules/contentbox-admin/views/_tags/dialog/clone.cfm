<!--- Component Args --->
<cfparam name="title"         default="Clone">
<cfparam name="infoMsg"       default="">
<cfparam name="action"        default="">
<cfparam name="titleLabel"    default="Title">
<cfparam name="siteLabel"     default="Site">
<cfparam name="publishLabel"  default="Publish">
<cfparam name="publishInfo"   default="By default all cloned items are published as drafts.">
<cfparam name="statusName"    default="contentStatus">
<!--- Template --->
<cfoutput>
<div
	id="cloneDialog"
	class="modal fade"
	tabindex="-1"
	role="dialog"
	aria-labelledby="cloneTitle"
	aria-hidden="true"
>

	<div class="modal-dialog" role="document" >
        <div class="modal-content">

			<!-- Modal Header -->
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="cloneTitle">
					<i class="far fa-clone"></i> #args.title#
				</h4>
			</div>

			<!--- Modal Body --->
            <div class="modal-body" id="remoteModelContent">
                <!--body-->
                #html.startForm(
					name   = "cloneForm",
					action = "#args.action#",
					class  = "form-vertical",
					role   = "form"
				)#
					#html.hiddenField( name="contentID" )#

					<div>
						<!--- Info Message --->
						<cfif len( args.infoMsg )>
							<div class="mb20">
								#args.infoMsg#
							</div>
						</cfif>

						<!--- Title --->
						#html.textfield(
                            name              = "title",
                            label             = "#args.titleLabel#",
                            class             = "form-control",
                            required          = "required",
                            size              = "50",
                            wrapper           = "div class=controls",
                            labelClass        = "control-label",
                            groupWrapper      = "div class=form-group"
						)#

						<!--- Site To Clone To --->
						<div class="form-group">
							<label class="control-label">
								#args.siteLabel#
							</label>

							<p>
								The site you want to clone your content to.
							</p>

							<select
								name="site"
								id="site"
								class="form-control"
							>
								<cfloop array="#prc.allSites#" index="thisSite">
									<option
										value="#thisSite[ 'siteId' ]#"
										<cfif thisSite[ 'siteId' ] eq prc.oCurrentSite.getSiteId()>selected="selected"</cfif>
									>
										#thisSite[ 'name' ]#
									</option>
								</cfloop>k
							</select>
						</div>

						<label for="contentStatus control-label">
							#args.publishLabel#
						</label>

						<p>
							#args.publishInfo#
						</p>

						#html.select(
                            options           = "true,false",
                            name              = "#args.statusName#",
                            selectedValue     = "false",
                            class             = "form-control input-sm valid",
                            wrapper           = "div class=controls",
                            labelClass        = "control-label",
                            groupWrapper      = "div class=form-group"
						)#
                    </div>
                #html.endForm()#
			</div>

            <!-- footer -->
			<div class="modal-footer">

                <!--- Button Bar --->
                <div id="cloneButtonBar">
                    <button
                    	class="btn btn-default"
                    	id="closeButton"
                    	data-dismiss="modal"
						type="button"
					>
                    	Cancel
                    </button>
                    <button
                    	class="btn btn-danger"
                    	id="cloneButton"
						type="button"
					>
                    	Clone
                    </button>
				</div>

                <!--- Loader --->
                <div class="center loaders" id="clonerBarLoader">
                    <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
                    <div class="m5">
						Please wait, doing some hardcore cloning action...
					</div>
                </div>
            </div>
        </div>
    </div>
</div>
</cfoutput>