editAreaLoader.load_syntax["coldfusion"] = {
	'DISPLAY_NAME' : 'ColdFusion'
	,'COMMENT_SINGLE' : {1 : '//', 2 : '@'}
	,'COMMENT_MULTI': { '/*' : '*/' }
	,'COMMENT_MULTI2' : {'<!---' : '--->'}
	,'QUOTEMARKS' : {1: "'", 2: '"'}
	,'KEYWORD_CASE_SENSITIVE' : false
	,'KEYWORDS' : {
		'constants': [
		    'null', 'false', 'true'
		]
		,'statements' : [
			'include', 'require', 'include_once', 'require_once', 'try', 'catch', 'finally',
			'for', 'foreach', 'as', 'if', 'elseif', 'else', 'while', 'do', 'endwhile',
            'endif', 'switch', 'case', 'endswitch', 'relocate', 'thread', 'transaction', 
			'return', 'break', 'continue', 'implements', 'extends', 'savecontent' , 'lock', 'abort', 'rethrow'
		]
		,'reserved' : [
			'AND', 'break', 'case', 'CONTAIN', 'CONTAINS', 'continue', 'default', 'do', 
			'DOES', 'else', 'EQ', 'EQUAL', 'EQUALTO', 'EQV', 'FALSE', 'for', 'GE', 
			'GREATER', 'GT', 'GTE', 'if', 'IMP', 'in', 'IS', 'LE', 'LESS', 'LT', 'LTE', 
			'MOD', 'NEQ', 'NOT', 'OR', 'return', 'switch', 'THAN', 'TO', 'TRUE', 'var', 
			'while', 'XOR'
		]
		,'types': [
			'any', 'array', 'binary', 'boolean', 'date', 'guid', 'numeric', 'query', 'string', 'struct', 'UUID', 'xml',
			'void', 'private', 'protected', 'package', 'public', 'function'
		]
		,'keywords': [
		    'new', 'return', 'import', 'component', 'function', 'property'
	    ]
		,'scopes': [
		    'this', 'super', 'cgi' , 'request', 'session', 'cluster', 'application', 'client', 'server', 'variables', 'local', 'arguments',
		    'event', 'controller', 'flash', 'wirebox', 'cachebox', 'logbox', 'cb'
		]
		,'functions' : [
		    'ImageWriteBase64', 'GetSOAPResponseHeader', 'GetTotalSpace', 'SpreadSheetRead', 'FileReadBinary', 'StructCopy', 'FileClose', 'ObjectEquals', 'ArrayEach', 'ImageCreateCaptcha', 'QuerySetCell', 'REEscape', 'GetMetadata', 'ImageInfo', 'XMLValidate', 'HTMLEditFormat', 'ImageRead', 'DE', 'ListGetAt', 'IsClosure', 'ThreadTerminate', 'HMac', 'IsDate', 'FileRead', 'ArrayFindAllNoCase', 'CacheRegionExists', 'SpreadSheetDeleteRows', 'DecrementValue', 'StoreAddACL', 'AjaxLink', 'Evaluate', 'ParagraphFormat', 'EncodeForCSS', 'IsUserLoggedIn', 'Duplicate', 'SessionGetMetadata', 'GetTemplatePath', 'ORMFlushAll', 'LSTimeFormat', 'ImageGetIPTCTag', 'Asc', 'ACos', 'CallStackGet', 'DaysInMonth', 'IsCustomFunction', 'SpreadSheetAddFreezePane', 'GetTempFile', 'ListValueCountNoCase', 'DayOfYear', 'Int', 'GetFreeSpace', 'ImageFlip', 'ListSort', 'RestDeleteApplication', 'SpreadSheetRemoveSheet', 'ORMEvictEntity', 'LSDateFormat', 'StructFindKey', 'ORMCloseAllSessions', 'ObjectLoad', 'TransactionSetSavepoint', 'CreateDateTime', 'Atn', 'LSIsDate', 'FileMove', 'ASin', 'ImageGetBLOB', 'FindNoCase', 'LSEuroCurrencyFormat', 'XmlSearch', 'ArraySum', 'ParameterExists', 'FileCopy', 'EntityLoadByExample', 'ImageSharpen', 'ArrayFilter', 'ImageGetBufferedImage', 'Sleep', 'DecodeFromURL', 'TransactionCommit', 'Find', 'BitMaskSet', 'ImagePaste', 'BitAnd', 'ListFind', 'RandRange', 'IsJSON', 'DeserializeJSON', 'SpreadSheetAddInfo', 'FileDelete', 'SpreadSheetFormatColumn', 'ImageDrawOval', 'Left', 'GetHTTPRequestData', 'ImageSetDrawingStroke', 'BitXor', 'WriteOutput', 'SpreadSheetInfo', 'IIf', 'IsIPV6', 'SpreadSheetCreateSheet', 'SpreadSheetSetHeader', 'GetBaseTagList', 'SpanIncluding', 'EntityReload', 'StructClear', 'XmlNew', 'ORMReload', 'GetProfileString', 'BinaryEncode', 'IsStruct', 'FileSkipBytes', 'GetPrinterInfo', 'Right', 'IsArray', 'QueryAddColumn', 'GetComponentMetadata', 'ImageCrop', 'StoreGetACL', 'ListLast', 'ImageRotate', 'ArrayDelete', 'FileSetLastModified', 'FileAppend', 'Encrypt', 'ToScript', 'ApplicationStop', 'StructFilter', 'ArrayIsEmpty', 'StructDelete', 'SpreadSheetSetRowHeight', 'GetToken', 'CacheGet', 'ImageDrawText', 'ListChangeDelims', 'DirectoryCreate', 'Week', 'Fix', 'ListContainsNoCase', 'LSCurrencyFormat', 'StoreGetMetadata', 'Trace', 'ImageMakeTranslucent', 'Day', 'ArraySlice', 'EntityToQuery', 'ImageBlur', 'StructKeyExists', 'DateDiff', 'StructKeyList', 'SpreadSheetAddSplitPane', 'Quarter', 'Tan', 'IsValid', 'IsSpreadSheetObject', 'IsUserInAnyRole', 'StructFindValue', 'Val', 'TimeFormat', 'CSRFVerifyToken', 'SpreadSheetAddRows', 'LSIsNumeric', 'ImageDrawArc', 'FileReadLine', 'SpreadSheetGetCellComment', 'IsLocalHost', 'LTrim', 'FileSetAttribute', 'Second', 'ImageOverlay', 'Log10', 'ArrayClear', 'SetVariable', 'ArrayDeleteAt', 'SpreadSheetGetCellValue', 'EntityDelete', 'GetTimeZoneInfo', 'YesNoFormat', 'ORMGetSessionFactory', 'ImageDrawLines', 'GetHttpTimeString', 'CreateODBCTime', 'ArrayContains', 'DeleteClientVariable', 'BitOr', 'ListContains', 'RestInitApplication', 'IsWddx', 'ImageShearDrawingAxis', 'ImageMakeColorTransparent', 'ImageDrawBeveledRect', 'SessionRotate', 'ImageCopy', 'ImageSetDrawingColor', 'Round', 'IsXmlAttribute', 'CreateDate', 'ORMEvictCollection', 'Pi', 'LSIsCurrency', 'SpreadSheetSetColumnWidth', 'IsBoolean', 'GetCpuUsage', 'ArrayAvg', 'IsObject', 'CompareNoCase', 'GetWriteableImageFormats', 'Year', 'EncodeForXML', 'Max', 'IsBinary', 'ORMEvictQueries', 'GetApplicationMetadata', 'DateFormat', 'ListFirst', 'DecimalFormat', 'SpreadSheetAddImage', 'ORMIndexPurge', 'FirstDayOfMonth', 'CreateODBCDateTime', 'ORMGetSession', 'SpreadSheetSetActiveSheetNumber', 'RemoveChars', 'FileWrite', 'ORMFlush', 'StructFind', 'DateTimeFormat', 'IsDDX', 'LSParseNumber', 'ImageTranslateDrawingAxis', 'CJustify', 'FileOpen', 'ArrayInsertAt', 'ListRemoveDuplicates', 'ORMIndex', 'IsNumeric', 'DirectoryRename', 'ImageSetAntiAliasing', 'ImageReadBase64', 'ImageDrawQuadraticCurve', 'SpreadSheetReadBinary', 'DirectoryCopy', 'GetUserRoles', 'RemoveCachedQuery', 'SetProfileString', 'GetGatewayHelper', 'CacheSetProperties', 'ORMSearch', 'ImageSetDrawingTransparency', 'XmlElemNew', 'ImageResize', 'SpreadSheetDeleteColumns', 'GetClientVariablesList', 'EntitySave', 'ImageTranslate', 'StructSort', 'GetSystemTotalMemory', 'ImageDrawLine', 'Len', 'SetLocale', 'FileIsEOF', 'CreateDynamicProxy', 'GetFileInfo', 'GetLocalHostIP', 'REMatchNoCase', 'Minute', 'RepeatString', 'DotNetToCFType', 'ListDeleteAt', 'JavaCast', 'ORMClearSession', 'BitNot', 'SpreadSheetSetFooter', 'BitSHLN', 'ArrayToList', 'ImageWrite', 'ArrayIsDefined', 'Now', 'ImageNew', 'LJustify', 'GetProfileSections', 'DateAdd', 'BinaryDecode', 'Month', 'ListQualify', 'StructCount', 'FileUploadAll', 'CachePut', 'Sin', 'REReplace', 'ImageDrawRect', 'QueryNew', 'ListPrepend', 'GetAuthUser', 'EncodeForHTMLAttribute', 'EntityLoadByPK', 'IsUserInRole', 'IncrementValue', 'DayOfWeek', 'CacheGetMetadata', 'IsDefined', 'PreserveSingleQuotes', 'DecryptBinary', 'LSParseCurrency', 'GetBaseTagData', 'CharsetDecode', 'ImageDrawPoint', 'StoreSetMetadata', 'SpreadSheetWrite', 'GetSOAPRequest', 'LSNumberFormat', 'FindOneOf', 'URLDecode', 'CacheRemoveAll', 'SpreadSheetFormatColumns', 'ImageXORDrawingMode', 'ArrayPrepend', 'ReplaceList', 'ArrayMin', 'REFindNoCase', 'EntityLoad', 'FileUpload', 'Abs', 'BitMaskClear', 'GetSOAPResponse', 'ArrayResize', 'SpreadSheetNew', 'ImageGetIptcMetadata', 'Trim', 'Location', 'ListRest', 'GetFunctionCalledName', 'StoreSetACL', 'GetException', 'Reverse', 'MonthAsString', 'FileGetMimeType', 'ImageDrawCubicCurve', 'SpreadSheetSetCellFormula', 'GetBaseTemplatePath', 'GetLocale', 'CacheRegionRemove', 'StripCr', 'ToBinary', 'ImageClearRect', 'SessionInvalidate', 'IsNull', 'IsQuery', 'GetFileFromPath', 'IsImage', 'ReleaseComObject', 'SetEncoding', 'DecodeForHTML', 'SpreadSheetFormatRow', 'IsPDFObject', 'DirectoryExists', 'ImageRotateDrawingAxis', 'SendGatewayMessage', 'Rand', 'Replace', 'GetContextRoot', 'REFind', 'IsXmlNode', 'RestSetResponse', 'ImageShear', 'ArrayFindAll', 'ToBase64', 'BitSHRN', 'ORMCloseSession', 'IsDebugMode', 'IsXmlElem', 'ParseDateTime', 'NumberFormat', 'ArrayLen', 'StructKeyArray', 'IsXmlDoc', 'CacheGetSession', 'IsSimpleValue', 'GetFunctionList', 'Mid', 'SpreadSheetGetCellFormula', 'SpreadSheetSetActiveSheet', 'Min', 'PrecisionEvaluate', 'Hour', 'Chr', 'XMLFormat', 'XmlGetNodeType', 'FileSeek', 'ArraySwap', 'VerifyClient', 'Sgn', 'GetPrinterList', 'HTMLCodeFormat', 'FormatBaseN', 'SpanExcluding', 'StructInsert', 'SpreadSheetAddColumn', 'ListFindNoCase', 'EntityNew', 'ORMSearchOffline', 'AddSOAPRequestHeader', 'CacheIdExists', 'ListLen', 'IsInstanceOf', 'ArrayAppend', 'DaysInYear', 'ArraySort', 'StructEach', 'ListValueCount', 'Log', 'StructUpdate', 'GetCurrentTemplatePath', 'ImageGetWidth', 'LCase', 'WriteDump', 'WSSendMessage', 'ImageDrawRoundRect', 'GetEncoding', 'CSRFGenerateToken', 'SpreadSheetSetCellValue', 'SpreadSheetFormatCell', 'BitMaskRead', 'ListToArray', 'StructIsEmpty', 'IsLeapYear', 'CallStackDump', 'Insert', 'Exp', 'Cos', 'ListFilter', 'DollarFormat', 'GetSOAPRequestHeader', 'WSGetAllChannels', 'SpreadSheetDeleteColumn', 'ListSetAt', 'REMatch', 'ArrayFindNoCase', 'IsImageFile', 'DirectoryDelete', 'Sqr', 'IsSOAPRequest', 'FileWriteLine', 'SpreadSheetSetCellComment', 'SpreadSheetFormatRows', 'XmlChildPos', 'ArrayFind', 'CreateTime', 'GetVFSMetadata', 'ExpandPath', 'SpreadSheetShiftColumns', 'CreateUUID', 'CacheRemove', 'ImageNegative', 'URLSessionFormat', 'EncodeForHTML', 'ImageSetBackgroundColor', 'ListInsertAt', 'FileExists', 'StructGet', 'JSStringFormat', 'URLEncodedFormat', 'AjaxOnLoad', 'EncryptBinary', 'UCase', 'EncodeForURL', 'XmlParse', 'XmlTransform', 'QueryAddRow', 'DatePart', 'ArraySet', 'ValueList', 'StructAppend', 'GetMetricData', 'CreateObject', 'TransactionRollback', 'IsXml', 'ImageAddBorder', 'GenerateSecretKey', 'ArrayMax', 'ReplaceNoCase', 'RTrim', 'Throw', 'QueryConvertForGrid', 'CharsetEncode', 'GetPageContext', 'GetTickCount', 'GetSystemFreeMemory', 'GetReadableImageFormats', 'Ceiling', 'CreateTimeSpan', 'SpreadSheetAddRow', 'ThreadJoin', 'EntityMerge', 'ORMExecuteQuery', 'GetTempDirectory', 'ImageGetExifMetadata', 'ToString', 'SpreadSheetMergeCells', 'IsSpreadSheetFile', 'LSParseEuroCurrency', 'GetLocaleDisplayName', 'Decrypt', 'GetDirectoryFromPath', 'ImageGrayscale', 'IsXmlRoot', 'Compare', 'StructNew', 'ImageGetEXIFTag', 'IsPDFFile', 'ListAppend', 'IsNumericDate', 'FileSetAccessMode', 'EncodeForJavaScript', 'SpreadSheetShiftRows', 'DateCompare', 'SpreadSheetDeleteRow', 'CacheGetAllIds', 'SerializeJSON', 'InputBaseN', 'DirectoryList', 'Hash', 'LSDateTimeFormat', 'DateConvert', 'ImageScaleToFit', 'WSPublish', 'CreateODBCDate', 'QuotedValueList', 'DayOfWeekAsString', 'WSGetSubscribers', 'WriteLog', 'REReplaceNoCase', 'ImageGetHeight', 'CacheGetProperties', 'AddSOAPResponseHeader', 'ArrayNew', 'CacheRegionNew', 'ObjectSave', 'RJustify', 'SpreadSheetFormatCellRange', 'LSParseDateTime', 'Wrap', 'Randomize'
		]
	}
	,'OPERATORS' :[
		'+', '-', '/', '*', '=', '<', '>', '%', '!', '?', ':', '&'
	]
	,'DELIMITERS' :[
		'(', ')', '[', ']', '{', '}'
	]
	,'REGEXPS' : {
		'doctype' : {
			'search' : '()(<!DOCTYPE[^>]*>)()'
			,'class' : 'doctype'
			,'modifiers' : ''
			,'execute' : 'before' // before or after
		}
		,'cftags' : {
			'search' : '(<)(/cf[a-z][^ \r\n\t>]*)([^>]*>)'
			,'class' : 'cftags'
			,'modifiers' : 'gi'
			,'execute' : 'before' // before or after
		}
		,'cftags2' : {
			'search' : '(<)(cf[a-z][^ \r\n\t>]*)([^>]*>)'
			,'class' : 'cftags2'
			,'modifiers' : 'gi'
			,'execute' : 'before' // before or after
		}
		,'tags' : {
			'search' : '(<)(/?[a-z][^ \r\n\t>]*)([^>]*>)'
			,'class' : 'tags'
			,'modifiers' : 'gi'
			,'execute' : 'before' // before or after
		}
		,'attributes' : {
			'search' : '( |\n|\r|\t)([^ \r\n\t=]+)(=)'
			,'class' : 'attributes'
			,'modifiers' : 'g'
			,'execute' : 'before' // before or after
		}
	}
	,'STYLES' : {
		'COMMENTS': 'color: #AAAAAA;'
		,'QUOTESMARKS': 'color: #6381F8;'
		,'KEYWORDS' : {
			'constants': 'color: #EE0000;'
			,'types': 'color: #0000EE;'
			,'reserved' : 'color: #48BDDF;'
			,'functions' : 'color: orange;'
			,'statements' : 'color: #60CA00;'
			,'keywords': 'color: #5496C9;'
			,'scopes' : 'color: #EE0000;'
		}
		,'OPERATORS' : 'color: #E775F0;'
		,'DELIMITERS': 'color: #0038E1;'
		,'REGEXPS' : {
			'attributes': 'color: #990033;'
			,'cftags': 'color: #990033;'
			,'cftags2': 'color: #990033;'
			,'tags': 'color: #000099;'
			,'doctype': 'color: #8DCFB5;'
			,'test': 'color: #00FF00;'
		}	
	}		
};

 	  	 
