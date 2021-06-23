<cfoutput>
    <h4>Here is a preview of what will be exported!</h4>
    <table class="table table-hover table-striped">
		<thead>
			<tr>
				<th>Content Area</th>
				<th class='text-center' width="100">Format</th>
				<th class='text-center' width="100">Total</th>
			</tr>
		<thead>
        <tbody>
			<cfloop array="#prc.aSortedContent#" index="key">
				<cfset content = prc.descriptor.content[ key ]>
				<tr>
					<td>#content.name#</td>
					<td class="text-center">
						<span
							class="#content.format eq "json" ? "label label-primary" : "label label-info"#"
							>
							#content.format#
						</span>
					</td>
					<td class="text-center">
						<span class="badge">#content.total#</div>
					</td>
				</tr>
			</cfloop>
		</tbody>
    </table>
</cfoutput>