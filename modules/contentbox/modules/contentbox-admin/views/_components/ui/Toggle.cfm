<cfoutput>
<cfparam name="args.checked" 	default="false">
<cfparam name="args.label" 		default="Toggle Me">
<cfparam name="args.xmodel" 	default="">

<toggle x-data="{ toggle: #args.checked# }">
	<div>
		<label for="#args.name#" class="flex items-center cursor-pointer">
			<div class="pr5">#args.label#</div>
			<!-- toggle -->
			<div class="relative">
				<!--- Input --->
				<input
					id="#args.name#"
					name="#args.name#"
					class="hidden"
					type="checkbox"
					@click="toggle = !toggle"
					:checked="toggle"
					<cfif len( args.xmodel )>
						x-model="#args.xmodel#"
					</cfif>
				/>
				<!-- path -->
				<div
					class="toggle-path bg-gray-200 w-16 h-9 rounded-full shadow-inner"
				></div>
				<!-- circle -->
				<div
					class="toggle-circle absolute w-7 h-7 bg-white rounded-full shadow inset-y-0 left-0"
				></div>
		</div>
		</label>
	</div>
</toggle>
</cfoutput>