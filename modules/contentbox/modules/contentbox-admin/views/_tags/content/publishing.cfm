<cfoutput>
    <div class="#args.content.getIsPublished()?'':'selected'#">
        <h4><i class="fa fa-calendar"></i> Publishing</h4>        
            <!--- Published? --->
        <cfif args.content.isLoaded()>
            <label class="inline">Status: </label>
            <cfif !args.content.getIsPublished()>
                <span class="textRed inline">Draft!</span>
            <cfelse>
                Published
            </cfif>
        </cfif>

        <!--- is Published --->
        #html.hiddenField(
            name="isPublished",value=true)#
        <!--- publish date --->
        <div class="form-group">
            #html.label(
                class="control-label",
                field="publishedDate",
                content="Publish Date (<a href='javascript:publishNow()'>Now</a>)"
            )#
            <div class="controls row">
                <div class="col-md-6">
                    <div class="input-group">
                        #html.inputField(
                            size="9", name="publishedDate",
                            value=args.content.getPublishedDateForEditor(), 
                            class="form-control datepicker"
                        )#
                        <span class="input-group-addon">
                            <span class="fa fa-calendar"></span>
                        </span>
                    </div>
                </div>
                <!---#html.inputField(
                    type="number",
                    name="publishedHour",
                    value=prc.ckHelper.ckHour( args.content.getPublishedDateForEditor(showTime=true) ),
                    size=2,
                    maxlength="2",
                    min="0",
                    max="24",
                    title="Hour in 24 format",
                    class="form-control editorTime"
                )#
                #html.inputField(
                    type="number",
                    name="publishedMinute",
                    value=prc.ckHelper.ckMinute( args.content.getPublishedDateForEditor(showTime=true) ),
                    size=2,
                    maxlength="2",
                    min="0",
                    max="60", 
                    title="Minute",
                    class="form-control editorTime"
                )#--->
                <cfscript>
                    theTime = "";
                    hour = prc.ckHelper.ckHour( args.content.getPublishedDateForEditor(showTime=true) );
                    minute = prc.ckHelper.ckMinute( args.content.getPublishedDateForEditor(showTime=true) );
                    if( len( hour ) && len( minute ) ) {
                        theTime = hour & ":" & minute;
                    }
                </cfscript>
                <div class="col-md-6">
                    <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                        <input type="text" class="form-control inline" value="#theTime#" name="publishedTime">
                        <span class="input-group-addon">
                            <span class="fa fa-clock-o"></span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <!--- expire date --->
        <div class="form-group">
            #html.label(class="control-label",field="expireDate",content="Expiration Date" )#
            <div class="controls row">
                <div class="col-md-6">
                    <div class="input-group">
                        #html.inputField(
                            size="9", 
                            name="expireDate",
                            value=args.content.getExpireDateForEditor(), 
                            class="form-control datepicker"
                        )#
                        <span class="input-group-addon">
                            <span class="fa fa-calendar"></span>
                        </span>
                    </div>
                </div>
                <!---
                #html.inputField(
                    type="number",
                    name="expireHour",
                    value=prc.ckHelper.ckHour( args.content.getExpireDateForEditor(showTime=true) ),
                    size=2,
                    maxlength="2",
                    min="0",
                    max="24",
                    title="Hour in 24 format",
                    class="form-control editorTime"
                )#
                #html.inputField(
                    type="number",
                    name="expireMinute",
                    value=prc.ckHelper.ckMinute( args.content.getExpireDateForEditor(showTime=true) ),
                    size=2,
                    maxlength="2",
                    min="0",
                    max="60", 
                    title="Minute",
                    class="form-control editorTime"
                )#
                --->
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
                            <span class="fa fa-clock-o"></span>
                        </span>
                    </div>
                </div>
            </div>
        </div>  
        <!--- Changelog --->
        #html.textField(
            name="changelog",
            label="Commit Changelog",
            class="form-control",
            title="A quick description of what this commit is all about.",
            wrapper="div class=controls",
            labelClass="control-label",
            groupWrapper="div class=form-group"
        )#

        <!--- Action Bar --->
        <div class="actionBar">
            <div class="btn-group">
            &nbsp;<input type="button" class="btn" value="Save" data-keybinding="ctrl+s" onclick="quickSave()">
            &nbsp;<input type="submit" class="btn" value="&nbsp; Draft &nbsp;" onclick="toggleDraft();setWasSubmitted()">
            &nbsp;<input type="submit" class="btn btn-danger" value="Publish" onclick="setWasSubmitted()">
            </div>
        </div>
         <!--- Loader --->
        <div class="loaders" id="uploadBarLoader">
            <i class="fa fa-spinner fa-spin fa-lg fa-2x"></i>
            <div id="uploadBarLoaderStatus" class="center textRed">Saving...</div>
        </div>
    </div>
</cfoutput>