<cfcomponent
	name="Zip"
	hint="A collections of functions that supports the Zip and GZip functionality by using the Java Zip file API."
	output="false"
	cache="false"
>
	<!--- ---------------------------------------- CONSTRUCTOR ---------------------------------------- --->       

	<cffunction name="init" access="public" returntype="ZipUtil" output="false">
		<cfscript>
			configure();
			return this;
		</cfscript>
	</cffunction>

	<!--- configure --->       
	<cffunction name="configure" output="false" access="public" returntype="ZipUtil" hint="Configure for operation">
		<cfscript>
			// This plugin's properties
			instance = structNew();
			instance.ioFile = createObject( "java", "java.io.File" );
			instance.ioInput = createObject( "java", "java.io.FileInputStream" );
			instance.ioOutput = createObject( "java", "java.io.FileOutputStream" );
			instance.ioBufOutput = createObject( "java", "java.io.BufferedOutputStream" );
			instance.zipFile = createObject( "java", "java.util.zip.ZipFile" );
			instance.zipEntry = createObject( "java", "java.util.zip.ZipEntry" );
			instance.zipInput = createObject( "java", "java.util.zip.ZipInputStream" );
			instance.zipOutput = createObject( "java", "java.util.zip.ZipOutputStream" );
			instance.gzInput = createObject( "java", "java.util.zip.GZIPInputStream" );
			instance.gzOutput = createObject( "java", "java.util.zip.GZIPOutputStream" );
			instance.objDate = createObject( "java", "java.util.Date" );

			/* Set Localized Variables */
			instance.os = Server.OS.Name;
			instance.slash = createObject( "java", "java.lang.System" ).getProperty( "file.separator" );

			// LM. To fix Overflow.
			instance.filename = "";

			return this;
		</cfscript>
	</cffunction>

	<!--- ---------------------------------------- PUBLIC ---------------------------------------- --->       

	<cffunction
		name="AddFiles"
		access="public"
		output="no"
		returntype="boolean"
		hint="Add files to a new or an existing Zip file archive."
	>
		<!--- ************************************************************* --->       
		<cfscript>
			/* Default variables */
			var i = 0;
			var l = 0;
			var buffer = repeatString( " ", 1024 ).getBytes();
			var entryPath = "";
			var entryFile = "";
			var localfiles = "";
			var path = "";
			var skip = "";

			try {
				/* Initialize Zip file */
				instance.ioOutput.init( pathFormat( arguments.zipFilePath ) );
				instance.filename = getFileFromPath( arguments.zipFilePath );
				instance.zipOutput.init( instance.ioOutput );
				instance.zipOutput.setLevel( arguments.compression );

				/* Get files list array */
				if ( structKeyExists( arguments, "files" ) && arguments.files NEQ "" ) {
					localfiles = listToArray( pathFormat( arguments.files ), "|" );
				} else if ( structKeyExists( arguments, "directory" ) && arguments.directory NEQ "" ) {
					localfiles = filesList(
						arguments.directory,
						arguments.filter,
						arguments.recurse
					);
					arguments.directory = pathFormat( arguments.directory );
				}

				/* Loop over files array */
				for ( i = 1; i LTE arrayLen( localfiles ); i = i + 1 ) {
					if ( fileExists( localfiles[ i ] ) ) {
						path = localfiles[ i ];

						// Get entry path and file
						entryPath = getDirectoryFromPath( path );
						entryFile = getFileFromPath( path );

						// Remove drive letter from path
						if (
							arguments.savePaths EQ "yes" && right( listFirst( entryPath, instance.slash ), 1 ) EQ ":"
						) {
							entryPath = listDeleteAt(
								entryPath,
								1,
								instance.slash
							);
						} else if ( arguments.savePaths EQ "no" ) {
							// Remove directory from path
							if ( structKeyExists( arguments, "directory" ) && arguments.directory NEQ "" ) {
								entryPath = replaceNoCase(
									entryPath,
									arguments.directory,
									"",
									"ALL"
								);
							} else if ( structKeyExists( arguments, "files" ) && arguments.files NEQ "" ) {
								entryPath = "";
							}
						}

						// Remove slash at first
						if ( len( entryPath ) GT 1 && left( entryPath, 1 ) EQ instance.slash ) {
							entryPath = right( entryPath, len( entryPath ) - 1 );
						} else if ( len( entryPath ) EQ 1 && left( entryPath, 1 ) EQ instance.slash ) {
							entryPath = "";
						}

						// Skip if entry with the same name already exsits
						try {
							instance.ioFile.init( path );
							instance.ioInput.init( instance.ioFile.getPath() );

							instance.zipEntry.init( entryPath & entryFile );
							instance.zipOutput.putNextEntry( instance.zipEntry );

							l = instance.ioInput.read( buffer );

							while ( l GT 0 ) {
								instance.zipOutput.write(
										buffer,
										0,
										l
									);
								l = instance.ioInput.read( buffer );
							}

							instance.zipOutput.closeEntry();
							instance.ioInput.close();
						} catch (java.util.zip.ZipException ex) {
							skip = "yes";
						}
					}
				}

				/* Close Zip file */
				instance.zipOutput.close();

				/* Return true */
				return true;
			} catch (Any expr) {
				/* Close Zip file */
				instance.zipOutput.close();

				/* Return false */
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction
		name="DeleteFiles"
		access="public"
		output="no"
		returntype="boolean"
		hint="Delete files from an existing Zip file archive."
	>
		<!--- ************************************************************* --->       
		<cfscript>
			/* NOTICE: There is no function in the Java API to delete entrys from a Zip file.
			 * So we have to create a workaround for this function. At first we create
			 * a new temporary Zip file and save there all entrys, excluded the delete
			 * files. Then we delete the orginal Zip file and rename the temporary Zip
			 file. */

			/* Default variables */
			var l = 0;
			var buffer = repeatString( " ", 1024 ).getBytes();
			var entries = "";
			var entry = "";
			var inStream = "";
			var zipTemp = "";
			var zipRename = "";
			/* Convert to the right path format */
			arguments.zipFilePath = pathFormat( arguments.zipFilePath );

			try {
				/* Open Zip file and get Zip file entries */
				instance.zipFile.init( arguments.zipFilePath );
				entries = instance.zipFile.entries();

				/* Create a new temporary Zip file */
				instance.ioOutput.init( pathFormat( arguments.zipFilePath & ".temp" ) );
				instance.zipOutput.init( instance.ioOutput );

				/* Loop over Zip file entries */
				while ( entries.hasMoreElements() ) {
					entry = entries.nextElement();

					if ( !entry.isDirectory() ) {
						/* Create a new entry in the temporary Zip file */
						if (
							!listFindNoCase(
								arguments.files,
								entry.getName(),
								"|"
							)
						) {
							// Set entry compression
							instance.zipOutput.setLevel( entry.getMethod() );

							// Create new entry in the temporary Zip file
							instance.zipEntry.init( entry.getName() );
							instance.zipOutput.putNextEntry( instance.zipEntry );

							inStream = instance.zipFile.getInputStream( entry );
							l = inStream.read( buffer );

							while ( l GT 0 ) {
								instance.zipOutput.write(
										buffer,
										0,
										l
									);
								l = inStream.read( buffer );
							}

							// Close entry
							instance.zipOutput.closeEntry();
						}
					}
				}

				/* Close the orginal Zip and the temporary Zip file */
				instance.zipFile.close();
				instance.zipOutput.close();

				/* Delete the orginal Zip file */
				instance
					.ioFile
					.init( arguments.zipFilePath )
					.delete();

				/* Rename the temporary Zip file */
				zipTemp = instance.ioFile.init( arguments.zipFilePath & ".temp" );
				zipRename = instance.ioFile.init( arguments.zipFilePath );
				zipTemp.renameTo( zipRename );

				/* Return true */
				return true;
			} catch (Any expr) {
				/* Close the orginal Zip and the temporary Zip file */
				instance.zipOutput.close();
				instance.zipFile.close();

				/* Delete the temporary Zip file, if exists */
				if ( fileExists( arguments.zipFilePath & ".temp" ) ) {
					instance
						.ioFile
						.init( arguments.zipFilePath & ".temp" )
						.delete();
				}

				/* Return false */
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction
		name="Extract"
		access="public"
		output="no"
		returntype="boolean"
		hint="Extracts a specified Zip file into a specified directory."
	>
		<!--- ************************************************************* --->       
		<cfscript>
			/* Default variables */
			var l = 0;
			var entries = "";
			var entry = "";
			var name = "";
			var path = "";
			var filePath = "";
			var buffer = repeatString( " ", 1024 ).getBytes();
			var lastChr = "";
			var lenPath = "";
			var inStream = "";
			var skip = "";

			/* Convert to the right path format */
			arguments.zipFilePath = pathFormat( arguments.zipFilePath );
			arguments.extractPath = pathFormat( arguments.extractPath );

			/* Check if the 'extractPath' string is closed */
			lastChr = right( arguments.extractPath, 1 );

			/* Set an slash at the end of string */
			if ( lastChr NEQ instance.slash ) {
				arguments.extractPath = arguments.extractPath & instance.slash;
			}

			try {
				/* Open Zip file */
				instance.zipFile.init( arguments.zipFilePath );

				/* Zip file entries */
				entries = instance.zipFile.entries();

				/* Loop over Zip file entries */
				while ( entries.hasMoreElements() ) {
					entry = entries.nextElement();

					if ( !entry.isDirectory() ) {
						name = entry.getName();

						/* Create directory only if 'useFolderNames' is 'yes' */
						if ( arguments.useFolderNames EQ "yes" ) {
							lenPath = len( name ) - len( getFileFromPath( name ) );

							if ( lenPath ) {
								path = extractPath & left( name, lenPath );
							} else {
								path = extractPath;
							}

							if ( !directoryExists( path ) ) {
								instance.ioFile.init( path );
								instance.ioFile.mkdirs();
							}
						}

						/* Set file path */
						if ( arguments.useFolderNames EQ "yes" ) {
							filePath = arguments.extractPath & name;
						} else {
							filePath = arguments.extractPath & getFileFromPath( name );
						}

						// Zip Slip Validation
						if ( !getCanonicalPath( filePath ).startsWith( getCanonicalPath( arguments.extractPath ) ) ) {
							throw(
								type    = "ArchiverException",
								message = "Entry is outside of the target destination: #filepath#"
							);
						}

						/* Extract files. Files would be extract when following conditions are fulfilled:
						 * If the 'extractFiles' list is not defined,
						 * or the 'extractFiles' list is defined and the entry filename is found in the list,
						 or the file already exists and 'overwriteFiles' is 'yes'. */
						if (
							(
									!structKeyExists( arguments, "extractFiles" ) ||
										(
											structKeyExists( arguments, "extractFiles" ) &&
												listFindNoCase(
													arguments.extractFiles,
													getFileFromPath( name ),
													"|"
												)
										)
								) &&
								(
									!fileExists( filePath ) ||
										( fileExists( filePath ) && arguments.overwriteFiles EQ "yes" )
								)
						) {
							// Skip if entry contains special characters
							try {
								instance.ioOutput.init( filePath );
								instance.ioBufOutput.init( instance.ioOutput );

								inStream = instance.zipFile.getInputStream( entry );
								l = inStream.read( buffer );

								while ( l GTE 0 ) {
									instance.ioBufOutput.write(
											buffer,
											0,
											l
										);
									l = inStream.read( buffer );
								}

								inStream.close();
								instance.ioBufOutput.close();
								instance.ioOutput.close();
							} catch (Any Expr) {
								skip = "yes";
							}
						}
					}
				}

				/* Close the Zip file */
				instance.zipFile.close();

				/* Return true */
				return true;
			} catch (Any expr) {
				/* Close the Zip file */
				instance.zipFile.close();

				/* Return false */
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction
		name="List"
		access="public"
		output="no"
		returntype="query"
		hint="List the content of a specified Zip file."
	>
		<!--- ************************************************************* --->       
		<cfscript>
			/* Default variables */
			var i = 0;
			var entries = "";
			var entry = "";
			var cols = "entry,date,size,packed,ratio,crc";
			var query = queryNew( cols );
			var qEntry = "";
			var qDate = "";
			var qSize = "";
			var qPacked = "";
			var qCrc = "";
			var qRatio = "";

			cols = listToArray( cols );

			/* Open Zip file */
			instance.zipFile.init( arguments.zipFilePath );

			/* Zip file entries */
			entries = instance.zipFile.entries();

			/* Fill query with data */
			while ( entries.hasMoreElements() ) {
				entry = entries.nextElement();

				if ( !entry.isDirectory() ) {
					queryAddRow( query, 1 );

					qEntry = pathFormat( entry.getName() );
					qDate = instance.objDate.init( entry.getTime() );
					qSize = entry.getSize();
					qPacked = entry.getCompressedSize();
					qCrc = entry.getCrc();

					if ( qSize GT 0 ) {
						qRatio = round( evaluate( 100 - ( ( qPacked * 100 ) / qSize ) ) ) & "%";
					} else {
						qRatio = "0%";
					}

					for ( i = 1; i LTE arrayLen( cols ); i = i + 1 ) {
						querySetCell(
							query,
							cols[ i ],
							trim( evaluate( "q#cols[ i ]#" ) )
						);
					}
				}
			}

			/* Close the Zip File */
			instance.zipFile.close();

			/* Return query */
			return query;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction name="gzipAddFile" access="public" output="no" returntype="boolean" hint="Create a new GZip file archive.">
		<!--- ************************************************************* --->       
		<cfscript>
			/* Default variables */
			var l = 0;
			var buffer = repeatString( " ", 1024 ).getBytes();
			var gzFileName = "";
			var outputFile = "";
			var lastChr = "";

			/* Convert to the right path format */
			arguments.gzipFilePath = pathFormat( arguments.gzipFilePath );
			arguments.filePath = pathFormat( arguments.filePath );

			/* Check if the 'extractPath' string is closed */
			lastChr = right( arguments.gzipFilePath, 1 );

			/* Set an slash at the end of string */
			if ( lastChr NEQ instance.slash ) {
				arguments.gzipFilePath = arguments.gzipFilePath & instance.slash;
			}

			try {
				/* Set output gzip file name */
				gzFileName = getFileFromPath( arguments.filePath ) & ".gz";
				outputFile = arguments.gzipFilePath & gzFileName;

				instance.ioInput.init( arguments.filePath );
				instance.ioOutput.init( outputFile );
				instance.gzOutput.init( instance.ioOutput );

				l = instance.ioInput.read( buffer );

				while ( l GT 0 ) {
					instance.gzOutput.write(
							buffer,
							0,
							l
						);
					l = instance.ioInput.read( buffer );
				}

				/* Close the GZip file */
				instance.gzOutput.close();
				instance.ioOutput.close();
				instance.ioInput.close();

				/* Return true */
				return true;
			} catch (Any expr) {
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction
		name="gzipExtract"
		access="public"
		output="no"
		returntype="boolean"
		hint="Extracts a specified GZip file into a specified directory."
	>
		<!--- ************************************************************* --->       
		<cfscript>
			/* Default variables */
			var l = 0;
			var buffer = repeatString( " ", 1024 ).getBytes();
			var gzFileName = "";
			var outputFile = "";
			var lastChr = "";

			/* Convert to the right path format */
			arguments.gzipFilePath = pathFormat( arguments.gzipFilePath );
			arguments.extractPath = pathFormat( arguments.extractPath );

			/* Check if the 'extractPath' string is closed */
			lastChr = right( arguments.extractPath, 1 );

			/* Set an slash at the end of string */
			if ( lastChr NEQ instance.slash ) {
				arguments.extractPath = arguments.extractPath & instance.slash;
			}

			try {
				/* Set output file name */
				gzFileName = getFileFromPath( arguments.gzipFilePath );
				outputFile = arguments.extractPath & left( gzFileName, len( gzFileName ) - 3 );

				/* Initialize gzip file */
				instance.ioOutput.init( outputFile );
				instance.ioInput.init( arguments.gzipFilePath );
				instance.gzInput.init( instance.ioInput );

				while ( l GTE 0 ) {
					instance.ioOutput.write(
							buffer,
							0,
							l
						);
					l = instance.gzInput.read( buffer );
				}

				/* Close the GZip file */
				instance.gzInput.close();
				instance.ioInput.close();
				instance.ioOutput.close();

				/* Return true */
				return true;
			} catch (Any expr) {
				return false;
			}
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<!--- ---------------------------------------- PRIVATE ---------------------------------------- --->       

	<!--- ************************************************************* --->       

	<cffunction
		name="FilesList"
		access="private"
		output="no"
		returntype="array"
		hint="Create an array with the file names of specified directory."
	>
		<!--- ************************************************************* --->       
		<cfset var i = 0>
		<cfset var n = 0>
		<cfset var dir = "">
		<cfset var array = arrayNew( 1 )>
		<cfset var path = "">
		<cfset var subdir = "">

		<cfdirectory action="list" name="dir" directory="#pathFormat( arguments.directory )#" filter="#arguments.filter#">

		<cfscript>
			/* Loop over directory query */
			for ( i = 1; i LTE dir.recordcount; i = i + 1 ) {
				path = pathFormat( arguments.directory & instance.slash & dir.name[ i ] );

				// Add file to array
				if ( dir.type[ i ] EQ "file" && dir.name[ i ] NEQ instance.filename ) {
					arrayAppend( array, path );
				} else if ( dir.type[ i ] EQ "dir" && arguments.recurse EQ "yes" ) {
					// Get files from sub directorys and add them to the array
					subdir = filesList(
						path,
						arguments.filter,
						arguments.recurse
					);

					for ( n = 1; n LTE arrayLen( subdir ); n = n + 1 ) {
						arrayAppend( array, subdir[ n ] );
					}
				}
			}

			/* Return array */
			return array;
		</cfscript>
	</cffunction>

	<!--- ************************************************************* --->       

	<cffunction
		name="pathFormat"
		access="private"
		output="no"
		returntype="string"
		hint="Convert path into Windows or Unix format."
	>
		<!--- ************************************************************* --->       
		<cfreturn replace(
			arguments.path,
			"\",
			"/",
			"all"
		)>
	</cffunction>
	<!--- ************************************************************* --->       
</cfcomponent>