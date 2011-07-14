<cfoutput>
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	function remove(entryID){
		if( confirm("Really delete?") ){
			$("##entryID").val( entryID );
			$("##entryForm").submit();
		}
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">
<!--- Title --->
<h1>Blog Entries Management</h1>
<!--- MessageBox --->
#getPlugin("MessageBox").renderit()#

<ul>
	<li><a href="#event.buildLink(rc.xehEntryEditor)#">Create Entry</a></li>
</ul>

<!--- entryForm --->
<form name="entryForm" id="entryForm" method="post" action="#event.buildLink(rc.xehEntryRemove)#">
<input type="hidden" name="entryID" id="entryID" value="" />

<!--- entries --->
<table name="entries" id="entries" class="tablelisting" width="98%">
	<thead>
		<tr>
			<th>Name</th>			
			<th width="125" class="center">Actions</th>
		</tr>
	</thead>
	
	<tbody>
		<cfloop array="#rc.entries#" index="entry">
		<tr>
			<td><a href="#event.buildLink(rc.xehEntryEditor)#/entryID/#category.getentryID()#" title="Edit #entry.getTitle()#">#entry.getTitle()#</a></td>
			<td class="center">
				<input type="button" onclick="remove('#entry.getentryID()#')" value="Delete" title="Delete Entry"/>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>
</form>
</cfoutput>