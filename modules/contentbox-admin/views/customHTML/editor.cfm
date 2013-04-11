<cfoutput>
#html.startForm(name="contentEditForm",action=prc.xehContentSave,novalidate="novalidate")#
<!--- contentid --->
#html.hiddenField(name="contentID",bind=prc.content)#
<div class="row-fluid">
	<!--- main content --->
	<div class="span9" id="main-content">
		
	</div>

	<!--- main sidebar --->
	<div class="span3" id="main-sidebar">
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
</div>
#html.endForm()#
</cfoutput>