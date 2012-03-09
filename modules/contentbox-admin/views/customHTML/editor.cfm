<cfoutput>
#html.startForm(name="contentEditForm",action=prc.xehContentSave,novalidate="novalidate")#
<!--- contentid --->
#html.hiddenField(name="contentID",bind=prc.content)#
#html.hiddenField(name="sluggerURL",value=event.buildLink(prc.xehSlugify))#

<!--============================Sidebar============================-->
<div class="sidebar">
	<!--- Info Box --->
	<div class="small_box">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/tools_icon.png" alt="info" width="24" height="24" />
			Actions
		</div>
		<div class="body">

			<!--- Publish Info --->
			#html.startFieldset(legend='<img src="#prc.cbRoot#/includes/images/publish_black.png" alt="publish" width="16"/> Publishing')#

				<!--- Action Bar --->
				<div class="actionBar center">
					<button class="button2" onclick="return to('#event.buildLink(prc.xehCustomHTML)#')">Cancel</button>
					&nbsp;<input type="submit" class="buttonred" value="Save">
				</div>

			#html.endFieldSet()#

			<!--- Accordion --->
			<div id="accordion">
				<!--- Entry Cache Panel --->
				<h2>
					<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
					<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
					<img src="#prc.cbroot#/includes/images/database_black.png" alt="info" /> Cache Settings </h2>
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
			<img src="#prc.cbroot#/includes/images/html_32.png" alt="customHTML" width="30" height="30" />
			Custom HTML Editor
		</div>
		<!--- Body --->
		<div class="body">

			<!--- MessageBox --->
			#getPlugin("MessageBox").renderit()#

			<!--- fields --->
			#html.textField(name="title",label="Title:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="A human friendly name for the content piece")#
			#html.textField(name="slug",label="Slug:",bind=prc.content,required="required",maxlength="200",class="textfield width98",size="50",title="The slug used to retrieve this content piece")#
			#html.textarea(name="description",label="Short Description:",bind=prc.content,rows=3,class="width98",title="A short description for metadata purposes")#

			<!--- content --->
			#html.textarea(name="content",label="Content (HTML,JS,plain,or whatever):",bind=prc.content,required="required")#
		</div>
	</div>
</div>

#html.endForm()#
</cfoutput>