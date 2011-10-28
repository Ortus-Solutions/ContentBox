<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author      :	Luis Majano
Date        :	01/10/2008
License		: 	Apache 2 License
Description :
	A paging plugin.
	
To use this plugin you need to create some settings in your coldbox.xml and some
css entries.

COLDBOX SETTINGS
- PagingMaxRows : The maximum number of rows per page.
- PagingBandGap : The maximum number of pages in the page carrousel

CSS SETTINGS:
.pagingTabs - The div container
.pagingTabsTotals - The totals
.pagingTabsCarrousel - The carrousel

To use. You must use a "page" variable to move from page to page.
ex: index.cfm?event=users.list&page=2

In your handler you must calculate the boundaries to push into your paging query.
<cfset rc.boundaries = getMyPlugin("paging").getBoundaries()>
Gives you a struct:
[startrow] : the startrow to use
[maxrow] : the max row in this recordset to use.
Ex: [startrow=11][maxrow=20] if we are using a PagingMaxRows of 10

To RENDER:
#getMyPlugin("paging").renderit(FoundRows,link)#

FoundRows = The total rows found in the recordset
link = The link to use for paging, including a placeholder for the page @page@
	ex: index.cfm?event=users.list&page=@page@
----------------------------------------------------------------------->
<cfcomponent hint="A paging plugin" output="false">
  
<!------------------------------------------- CONSTRUCTOR ------------------------------------------->	
   
    <cffunction name="init" access="public" returntype="Paging" output="false">
		<cfscript>
  		setpluginName("Paging");
  		setpluginVersion("2.0");
  		setpluginDescription("Paging plugin");
  		
  		// Paging properties
  		var prc = controller.getRequestService().getContext().getCollection(private=true);
  		setPagingMaxRows( prc.cbSettings.cb_paging_maxrows );
  		setPagingBandGap( prc.cbSettings.cb_paging_bandgap );
  		
  		//Return instance
  		return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->	
	
	<!--- Get/Set paging max rows --->
	<cffunction name="getPagingMaxRows" access="public" returntype="numeric" hint="Get the paging max rows setting" output="false">
		<cfreturn instance.pagingMaxRows>
	</cffunction>
	<cffunction name="setPagingMaxRows" access="public" returntype="any" hint="Set the paging max rows setting" output="false">
		<cfargument name="pagingMaxRows" required="true" type="numeric">
		<cfset instance.pagingMaxRows = arguments.pagingMaxRows>
		<cfreturn this>
	</cffunction>
	
	<!--- Get/Set paging band gap --->
	<cffunction name="getPagingBandGap" access="public" returntype="numeric" hint="Get the paging carrousel band gap" output="false">
		<cfreturn instance.PagingBandGap>
	</cffunction>
	<cffunction name="setPagingBandGap" access="public" returntype="any" hint="Set the paging band gap" output="false">
		<cfargument name="PagingBandGap" required="true" type="numeric">
		<cfset instance.PagingBandGap = arguments.PagingBandGap>
		<cfreturn this>
	</cffunction>
	
	<!--- Get boundaries --->
	<cffunction name="getboundaries" access="public" returntype="struct" hint="Calculate the startrow and maxrow" output="false" >
		<cfargument name="pagingMaxRows" required="false" type="numeric" hint="You can override the paging max rows here.">
		<cfscript>
			var boundaries 	= structnew();
			var event 		= getController().getRequestService().getContext();
			var maxRows 	= getPagingMaxRows();
			
			// Check for Overrides
			if( structKeyExists(arguments,"PagingMaxRows") ){
				maxRows = arguments.pagingMaxRows;
			}
						
			boundaries.startrow = (event.getValue("page",1) * maxrows - maxRows)+1;
			boundaries.maxrow = boundaries.startrow + maxRows - 1;
		
			return boundaries;
		</cfscript>
	</cffunction>
	
	<!--- render paging --->
	<cffunction name="renderit" access="public" returntype="any" hint="render plugin tabs" output="false" >
		<!--- ***************************************************************** --->
		<cfargument name="foundRows"    required="true"  type="numeric" hint="The found rows to page">
		<cfargument name="link"   		required="true"  type="string"  hint="The link to use, you must place the @page@ place holder so the link ca be created correctly">
		<cfargument name="pagingMaxRows" required="false" type="numeric" hint="You can override the paging max rows here.">
		<!--- ***************************************************************** --->
		<cfset var event = getController().getRequestService().getContext()>
		<cfset var pagingTabs = "">
		<cfset var maxRows = getPagingMaxRows()>
		<cfset var bandGap = getPagingBandGap()>
		<cfset var totalPages = 0>
		<cfset var theLink = arguments.link>
		<!--- Paging vars --->
		<cfset var currentPage = event.getValue("page",1)>
		<cfset var pageFrom = 0>
		<cfset var pageTo = 0>
		<cfset var pageIndex = 0>
		
		<!--- Override --->
		<cfif structKeyExists(arguments, "pagingMaxRows")>
			<cfset maxRows = arguments.pagingMaxRows>
		</cfif>
		
		<!--- Only page if records found --->
		<cfif arguments.FoundRows neq 0>
			<!--- Calculate Total Pages --->
			<cfset totalPages = Ceiling( arguments.FoundRows / maxRows )>
			
			<!--- ***************************************************************** --->
			<!--- Paging Tabs 														--->
			<!--- ***************************************************************** --->
			<cfsavecontent variable="pagingtabs">
			<cfoutput>
			<div class="pagingTabs">
				
				<div class="pagingTabsTotals">
				<strong>Total Records: </strong> #arguments.FoundRows# &nbsp;
				<strong>Total Pages:</strong> #totalPages#
				</div>
				
				<div class="pagingTabsCarrousel">
					
					<!--- PREVIOUS PAGE --->
					<cfif currentPage-1 gt 0>
						<a href="#replace(theLink,"@page@",currentPage-1)#" title="Previous Page">&lt;&lt;</a>
					</cfif>
					
					<!--- Calcualte PageFrom Carrousel --->
					<cfset pageFrom=1>
					<cfif (currentPage-bandGap) gt 1>
						<cfset pageFrom=currentPage-bandgap>
						<a href="#replace(theLink,"@page@",1)#">1</a>
						...
					</cfif>
					
					<!--- Page TO of Carrousel --->
					<cfset pageTo=currentPage+bandgap>
					<cfif (currentPage+bandgap) gt totalPages>
						<cfset pageTo=totalPages>
					</cfif>
					<cfloop index="pageIndex" from="#pageFrom#" to="#pageTo#">
						<a href="#replace(theLink,"@page@",pageIndex)#"
						   <cfif currentPage eq pageIndex>class="selected"</cfif>>#pageIndex#</a>
					</cfloop>
					
					<!--- End Token --->
					<cfif (currentPage+bandgap) lt totalPages>
						...
						<a href="#replace(theLink,"@page@",totalPages)#">#totalPages#</a>
					</cfif>
					
					<!--- NEXT PAGE --->
					<cfif currentPage lt totalPages >
						<a href="#replace(theLink,"@page@",currentPage+1)#" title="Next Page">&gt;&gt;</a>
					</cfif>
					
				</div>
									
			</div>
			</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfreturn pagingTabs>
	</cffunction>
    
<!------------------------------------------- PRIVATE ------------------------------------------->	

	
</cfcomponent>