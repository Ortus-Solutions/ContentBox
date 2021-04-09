<cfoutput>
    <div class="mb10 #args.content.getIsPublished() ? '' : 'selected'#">

        <!--- is Published --->
        #html.hiddenField( name="isPublished", bind=args.content )#

        <!--- Publishing Bar --->
        <div id="publishingBar" style="display: none;" class="well well-sm">

			<h4>
				<i class="fa fa-calendar"></i> Publishing Details
			</h4>

            <!--- publish date --->
            <div>

                #html.label(
                    class       = "control-label",
                    field       = "publishedDate",
                    content     = "Publish Date (<a href='javascript:publishNow()'>Now</a>)"
                )#

                <div class="controls row">
                    <div class="col-md-6">
                        <div class="input-group">

                            #html.inputField(
                                size    = "9",
                                name    = "publishedDate",
                                value   = args.content.getPublishedDateForEditor(),
                                class   = "form-control datepicker"
                            )#

                            <span class="input-group-addon">
                                <span class="fa fa-calendar"></span>
                            </span>
                        </div>
                    </div>

                    <cfscript>
                        theTime     = "";
                        hour        = prc.ckHelper.ckHour( args.content.getPublishedDateForEditor( showTime=true ) );
                        minute      = prc.ckHelper.ckMinute( args.content.getPublishedDateForEditor( showTime=true ) );
                        if( len( hour ) && len( minute ) ) {
                            theTime = hour & ":" & minute;
                        }
                    </cfscript>

                    <div class="col-md-6">
                        <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                            <input type="text" class="form-control inline" value="#theTime#" name="publishedTime">
                            <span class="input-group-addon">
                                <span class="fas fa-history"></span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!--- expire date --->
            <div>

                #html.label(
					class   = "control-label",
					field   = "expireDate",
					content = "Expiration Date"
				)#

                <div class="controls row">
                    <div class="col-md-6">
                        <div class="input-group">

                            #html.inputField(
                                size    = "9",
                                name    = "expireDate",
                                value   = args.content.getExpireDateForEditor(),
                                class   = "form-control datepicker"
                            )#

                            <span class="input-group-addon">
                                <span class="fa fa-calendar"></span>
                            </span>
                        </div>
                    </div>

                    <cfscript>
                        theTime = "";
                        hour = prc.ckHelper.ckHour( args.content.getExpireDateForEditor(showTime=true) );
                        minute = prc.ckHelper.ckMinute( args.content.getExpireDateForEditor(showTime=true) );
                        if( len( hour ) && len( minute ) ) {
                            theTime = hour & ":" & minute;
                        }
                    </cfscript>

                    <div class="col-md-6">
                        <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                            <input type="text" class="form-control inline" value="#theTime#" name="expireTime">
                            <span class="input-group-addon">
                                <span class="fas fa-history"></span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!--- Changelog --->
            #html.textField(
                name              = "changelog",
                label             = "Commit Changelog",
                class             = "form-control",
                title             = "A quick description of what this commit is all about.",
                wrapper           = "div class=controls",
                labelClass        = "control-label",
                groupWrapper      = "div class=form-group"
			)#

			<!--- Site To Publish To --->
			<div class="form-group">
				<label class="control-label">
					Site
				</label>

				<select
					name="site"
					id="site"
					class="form-control rounded"
				>
					<cfloop array="#prc.allSites#" index="thisSite">
						<option
							value="#thisSite[ 'id' ]#"
							<cfif thisSite[ 'id' ] eq prc.oCurrentSite.getId()>selected="selected"</cfif>
						>
							#thisSite[ 'name' ]#
						</option>
					</cfloop>
				</select>
			</div>

            <div class="text-center">
                <button type="button"
                        class="btn btn-danger"
                        onclick="togglePublishingBar()"
                    >
                    Cancel
                </button>

                <button type="button"
                        id="publishButton"
                        class="btn btn-success"
                        onclick="quickPublish()"
                    >
                    Go!
                </button>
            </div>

        </div>

        <!--- Action Bar --->
        <div class="actionBar" id="actionBar">

            <div class="btn-group">
                <button type="button" class="btn btn-info" onclick="quickSave()" title="Save and continue editing">
                    Save
                </button>
                <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Save Options">
                    <span class="caret"></span>
                    <span class="sr-only">Toggle Dropdown</span>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a href="javascript:quickPublish( true )">Save and Close</a>
                    </li>
                </ul>
            </div>

			<button class="btn btn-success"
					onclick="togglePublishingBar()"
					type="button"
					title="Open Publishing Details"
			>
					Publish
			</button>
        </div>

        <!--- Loader --->
        <div class="loaders" id="uploadBarLoader">
            <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
            <div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
        </div>
    </div>
</cfoutput>