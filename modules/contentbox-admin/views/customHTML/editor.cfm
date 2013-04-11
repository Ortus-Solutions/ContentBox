<cfoutput>
#html.startForm(name="contentEditForm",action=prc.xehContentSave,novalidate="novalidate")#
<!--- contentid --->
#html.hiddenField(name="contentID",bind=prc.content)#

<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<i class="icon-cogs"></i>
			Actions
		</div>
		<div class="body">

			<!--- Publish Info --->
			#html.startFieldset(legend='<i class="icon-globe icon-large"></i> Publishing')#

				<!--- Action Bar --->
				<div class="actionBar center">
					<button class="btn btn-primary" onclick="return to('#event.buildLink(prc.xehCustomHTML)#')">Cancel</button>
					&nbsp;<input type="submit" class="btn btn-danger" value="Save">
				</div>

			#html.endFieldSet()#

			<!--- Accordion --->
			<div id="accordion">
				<!--- Entry Cache Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<i class="icon-hdd icon-large"></i> Cache Settings </h2>
				<div class="pane">

					<!--- Cache Settings --->
					#html.label(field="cache",content="Cache Content:",class="inline")#
					#html.select(name="cache",options="Yes,No",selectedValue=yesNoFormat(prc.content.getCache()))#<br/>
					#html.inputField(type="numeric",name="cacheTimeout",label="Cache Timeout (0=Use Global):",bind=prc.content,title="Enter the number of minutes to cache your content, 0 means use global default",class="textfield",size="10",maxlength="100")#
					#html.inputField(type="numeric",name="cacheLastAccessTimeout",label="Idle Timeout: (0=Use Global)",bind=prc.content,title="Enter the number of minutes for an idle timeout for your content, 0 means use global default",class="textfield",size="10",maxlength="100")#

				</div>
			</div>
			<!--- End Accordion --->

		</div>
	</div>
</div>
<!--End sidebar-->
<!--============================Main Column============================-->

<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			<i class="icon-tasks icon-large"></i>
			Custom HTML Editor
		</div>
		<!--- Body --->
		<div class="body">

			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#

			<!--- fields --->
			#html.hiddenField(name="contentType",value="CustomHTML")#
			#html.textField(name="title",label="Title:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="A human friendly name for the content piece")#
			<div id='slugCheckErrors'></div>
			#html.textField(name="slug",label="Slug:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="The slug used to retrieve this content piece")#
			#html.textarea(name="description",label="Short Description:",bind=prc.content,rows=3,class="width98",title="A short description for metadata purposes")#
			
			<!---ContentToolBar --->
			<div id="contentToolBar">
				
				<!--- editor selector --->
				<label for="contentEditorChanger" class="inline">Editor: </label>
				<cfif prc.oAuthor.checkPermission( "EDITORS_EDITOR_SELECTOR" )>
				#html.select(name="contentEditorChanger", 
							 options=prc.editors,
							 column="name",
							 nameColumn="displayName",
							 selectedValue=prc.defaultEditor,
							 onchange="switchEditor(this.value)")#
				</cfif>
				<!--- markup --->
				<label for="markup" class="inline">Markup: </label>
				#html.select(name="markup", 
							 options=prc.markups,
							 selectedValue=( prc.content.isLoaded() ? prc.content.getMarkup() : prc.defaultMarkup ))#
				
				<!---Right References Panel --->
				<div class="floatRight">
					<a href="javascript:previewContent()" class="btn" title="Quick Preview">
						<i class="icon-eye-open icon-large"></i>
					</a>
				</div>
			</div>
			
			<!--- content --->
			#html.textarea(name="content", bind=prc.content, required="required", rows="25", class="width98")#
		</div>
	</div>
</div>

#html.endForm()#
</cfoutput>