<cfoutput>
	<section id="body-main" class="bg-light bg-darken-xs py-5">
		<div class="container text-center" >
			<div class="py-5">
				<h1>
					Oopss!
				</h1>
				<div class="text-muted">
					<svg xmlns="http://www.w3.org/2000/svg" width="100" fill="none" viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
					</svg>
				</div>
				<p>The page you requested: <code>#cb.getMissingPage()#</code> does not exist. </br>
					Please check your info and try again!
				</p>
				<div>
					<a class="btn btn-primary" href="#cb.linkHome()#" role="button">Go Home</a>
				</div>
			</div>
		</div>
	</section>
</cfoutput>