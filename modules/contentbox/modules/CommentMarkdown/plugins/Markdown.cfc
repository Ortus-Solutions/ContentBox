<!-----------------------------------------------------------------------
********************************************************************************
Copyright since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author      :	Luis Majano
License		: 	Apache 2 License
Description :
	A plugin to do text conversions with markdown.

----------------------------------------------------------------------->
<cfcomponent name="Markdown" 
			 output="false" 
			 hint="A plugin to do text conversions with markdown."
			 singleton="true">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->
	
	<cffunction name="init" access="public" returntype="Markdown" output="false" hint="Constructor">
		<cfscript>			
			// MarkdownJ libPath
			var parserLibPath = getDirectoryFromPath(getMetadata(this).path) & "lib";
			var javaLoader	  = getPlugin("JavaLoader");
			
			// Plugin Properties
			setpluginName("Markdown");
			setpluginVersion("1.0");
			setpluginDescription("A plugin to do text conversions with markdown.");
			setpluginAuthor("Luis Majano");
			setpluginAuthorURL("http://www.coldbox.org");
			
			// Prepare Java Loader
			javaLoader.appendPaths( parserLibPath );
			
			// Setup markdown processor
			instance.processor = javaLoader.create("com.petebevin.markdown.MarkdownProcessor").init();
			
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->
	
	<cffunction name="toHTML" access="public" returntype="string" hint="Convert markdown text and return the HTML" output="false" >
		<cfargument name="txt"  type="string" required="true" hint="The markdown text to convert to HTML">
		<cfscript>
			return trim( instance.processor.markdown(arguments.txt) );
		</cfscript>
	</cffunction>
	

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>