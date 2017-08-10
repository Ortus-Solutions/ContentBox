<!--- In Tags due to we still need to support CF10, remove this in major bump. --->
<cfcomponent output="false">

	<!--- sendFile --->
	<cffunction name="sendFile" output="false" access="public" returntype="void" hint="Send a file to the browser">
		<!--- ************************************************************* --->
		<cfargument name="file"	 		type="any"  	required="false" 	default="" hint="The absolute path to the file or a binary file">
		<cfargument name="name" 		type="string"  	required="false" 	default="" hint="The name to send the file to the browser. If not sent in, it will use the name of the file or a UUID for a binary file"/>
		<cfargument name="mimeType" 	type="string"  	required="false" 	default="" hint="A valid mime type to use. If not sent in, we will try to use a default one according to file extension"/>
		<cfargument name="disposition"  type="string" 	required="false" 	default="attachment" hint="The browser content disposition (attachment/inline)"/>
		<cfargument name="abortAtEnd" 	type="boolean" 	required="false" 	default="false" hint="Do an abort after content sending"/>
		<cfargument name="extension" 	type="string" 	required="false" 	default="" hint="Only used if file is binary. e.g. jpg or gif"/>
		<cfargument name="deleteFile"   type="string"   required="false"    default="false" hint="Delete the file after sending. Only used if file is not binary"/>
		<!--- ************************************************************* --->
		
		<cfset var fileSize = 0 />
		
		<!--- Binary File? --->
		<cfif isBinary( arguments.file )>

			<!--- Create unique ID? --->
			<cfif len( trim( arguments.name ) ) eq 0>
				<cfset arguments.name = CreateUUID()>
			</cfif>

			<!--- No Extension in arguments? --->
			<cfif TRIM( arguments.extension ) eq ''>
				<cfthrow message="Extension for binary file missing" detail="Please provide the extension argument when using a binary file" type="Utilities.ArgumentMissingException">
			</cfif>
			
			<!--- Set size --->
			<cfset fileSize = len( arguments.file )>

		<cfelseif fileExists( arguments.file )>
		<!--- File with absolute path --->

			<!--- File name? --->
			<cfif len( trim( arguments.name ) ) eq 0>
				<cfset arguments.name = reReplace( getFileFromPath( arguments.file ), "\.[^.]*$", "")>
			</cfif>

			<!--- Set extension --->
			<cfset arguments.extension = listLast( arguments.file, "." )>
			
			<!--- Set size --->
			<cfset fileSize = getFileInfo( arguments.file ).size>
			
		<cfelse>
			<!--- No binary file and no file found using absolute path --->
			<cfthrow message="File not found" detail="The file '#arguments.file#' cannot be located. Argument FILE requires an absolute file path or a binary file." type="Utilities.FileNotFoundException">
		</cfif>

		<!--- Lookup mime type for Extension? --->
		<cfif len( trim( arguments.mimetype ) ) eq 0>
			<cfset arguments.mimetype = getFileMimeType( extension )>
		</cfif>

		<!--- Set content header --->
		<cfheader name="content-disposition" value='#arguments.disposition#; filename="#arguments.name#.#extension#"'>
	
		<!--- Set content length --->
		<cfheader name="content-length" value="#fileSize#" />
		
		<!--- Send file --->
		<cfif isBinary(arguments.file)>
			<cfcontent type="#arguments.mimetype#" variable="#arguments.file#"/>
		<cfelse>
			<cfcontent type="#arguments.mimetype#" file="#arguments.file#" deletefile="#arguments.deleteFile#">
		</cfif>

		<!--- Abort further processing? --->
		<cfif arguments.abortAtEnd><cfabort></cfif>
	</cffunction>

	<!--- getFileMimeType --->
	<cffunction name="getFileMimeType" output="false" access="public" returntype="string" hint="Get's the file mime type for a given file extension">
		<cfargument name="extension" type="string" required="true" hint="e.g. jpg or gif" />

		<cfset var fileMimeType = ''>

		<cfswitch expression="#LCASE(arguments.extension)#">
			<cfcase value="txt,js,css,cfm,cfc,html,htm,jsp">
				<cfset fileMimeType = 'text/plain'>
			</cfcase>
			<cfcase value="gif">
				<cfset fileMimeType = 'image/gif'>
			</cfcase>
			<cfcase value="jpg,jpeg">
				<cfset fileMimeType = 'image/jpg'>
			</cfcase>
			<cfcase value="png">
				<cfset fileMimeType = 'image/png'>
			</cfcase>
			<cfcase value="wav">
				<cfset fileMimeType = 'audio/wav'>
			</cfcase>
			<cfcase value="mp3">
				<cfset fileMimeType = 'audio/mpeg3'>
			</cfcase>
			<cfcase value="pdf">
				<cfset fileMimeType = 'application/pdf'>
			</cfcase>
			<cfcase value="zip,tar,gz">
				<cfset fileMimeType = 'application/zip'>
			</cfcase>
			<cfcase value="ppt,pptx">
				<cfset fileMimeType = 'application/vnd.ms-powerpoint'>
			</cfcase>
			<cfcase value="doc,docx">
				<cfset fileMimeType = 'application/msword'>
			</cfcase>
			<cfcase value="xls,xlsx">
				<cfset fileMimeType = 'application/vnd.ms-excel'>
			</cfcase>
			<cfdefaultcase>
				<cfset fileMimeType = 'application/octet-stream'>
			</cfdefaultcase>
		</cfswitch>
		 <!--- More mimeTypes: http://www.iana.org/assignments/media-types/application/ --->

		 <cfreturn fileMimeType>
	</cffunction>

</cfcomponent>