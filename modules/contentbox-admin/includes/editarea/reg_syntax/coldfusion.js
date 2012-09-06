editAreaLoader.load_syntax["coldfusion"] = {
	'DISPLAY_NAME' : 'ColdFusion'
	,'COMMENT_SINGLE' : {1 : '//', 2 : '#'}
	,'COMMENT_MULTI' : {'<!--' : '-->'}
	,'COMMENT_MULTI2' : {'<!---' : '--->'}
	,'COMMENT_MULTI3': { '/**': '*/' }
	,'QUOTEMARKS' : {1: "'", 2: '"'}
	,'KEYWORD_CASE_SENSITIVE' : false
	,'KEYWORDS' : {
		'statements' : [
			'include', 'require', 'include_once', 'require_once',
			'for', 'foreach', 'as', 'if', 'elseif', 'else', 'while', 'do', 'endwhile',
            'endif', 'switch', 'case', 'endswitch', 'relocate',
			'return', 'break', 'continue', 'implements', 'extends', 'savecontent' , 'lock'
		]
		,'reserved' : [
			'AND', 'break', 'case', 'CONTAIN', 'CONTAINS', 'continue', 'default', 'do', 
			'DOES', 'else', 'EQ', 'EQUAL', 'EQUALTO', 'EQV', 'FALSE', 'for', 'GE', 
			'GREATER', 'GT', 'GTE', 'if', 'IMP', 'in', 'IS', 'LE', 'LESS', 'LT', 'LTE', 
			'MOD', 'NEQ', 'NOT', 'OR', 'return', 'switch', 'THAN', 'TO', 'TRUE', 'var', 
			'while', 'XOR'
		]
		,'keywords': [
		    'new', 'return', 'import', 'super', 'abort', 'rethrow'
	    ]
		,'functions' : [
		    'Abs', 'ACos', 'AddSOAPRequestHeader', 'AddSOAPResponseHeader', 'AjaxLink', 'AjaxOnLoad', 'ApplicationStop', 'ArrayAppend', 'ArrayAvg', 'ArrayClear', 'ArrayContains', 'ArrayDelete', 'ArrayDeleteAt', 'ArrayFind', 'ArrayFindNoCase', 'ArrayInsertAt', 'ArrayIsDefined', 'ArrayIsEmpty', 'ArrayLen', 'ArrayMax', 'ArrayMin', 'ArrayNew', 'ArrayPrepend', 'ArrayResize', 'ArraySet', 'ArraySort', 'ArraySum', 'ArraySwap', 'ArrayToList', 'Asc', 'ASin', 'Atn', 'BinaryDecode', 'BinaryEncode', 'BitAnd', 'BitMaskClear', 'BitMaskRead', 'BitMaskSet', 'BitNot', 'BitOr', 'BitSHLN', 'BitSHRN', 'BitXor', 'CacheGet', 'CacheGetAllIds', 'CacheGetMetadata', 'CacheGetProperties', 'CacheGetSession', 'CachePut', 'CacheRemove', 'CacheSetProperties', 'Ceiling', 'CharsetDecode', 'CharsetEncode', 'Chr', 'CJustify', 'Compare', 'CompareNoCase', 'Cos', 'CreateDate', 'CreateDateTime', 'CreateObject', 'CreateODBCDate', 'CreateODBCDateTime', 'CreateODBCTime', 'CreateTime', 'CreateTimeSpan', 'CreateUUID', 'DateAdd', 'DateCompare', 'DateConvert', 'DateDiff', 'DateFormat', 'DatePart', 'Day', 'DayOfWeek', 'DayOfWeekAsString', 'DayOfYear', 'DaysInMonth', 'DaysInYear', 'DE', 'DecimalFormat', 'DecrementValue', 'Decrypt', 'DecryptBinary', 'DeleteClientVariable', 'DeserializeJSON', 'DirectoryCreate', 'DirectoryDelete', 'DirectoryExists', 'DirectoryList', 'DirectoryRename', 'DollarFormat', 'DotNetToCFType', 'Duplicate', 'Encrypt', 'EncryptBinary', 'EntityDelete', 'EntityLoad', 'EntityLoadByExample', 'EntityLoadByPK', 'EntityMerge', 'EntityNew', 'EntityReload', 'EntitySave', 'EntityToQuery', 'Evaluate', 'Exp', 'ExpandPath', 'FileClose', 'FileCopy', 'FileDelete', 'FileExists', 'FileIsEOF', 'FileMove', 'FileOpen', 'FileRead', 'FileReadBinary', 'FileReadLine', 'FileSeek', 'FileSetAccessMode', 'FileSetAttribute', 'FileSetLastModified', 'FileSkipBytes', 'FileUpload', 'FileUploadAll', 'FileWrite', 'FileWriteLine', 'Find', 'FindNoCase', 'FindOneOf', 'FirstDayOfMonth', 'Fix', 'FormatBaseN', 'GenerateSecretKey', 'GetAuthUser', 'GetBaseTagData', 'GetBaseTagList', 'GetBaseTemplatePath', 'GetClientVariablesList', 'GetComponentMetaData', 'GetContextRoot', 'GetCurrentTemplatePath', 'GetDirectoryFromPath', 'GetEncoding', 'GetException', 'GetFileFromPath', 'GetFileInfo', 'GetFunctionCalledName', 'GetFunctionList', 'GetGatewayHelper', 'GetHTTPRequestData', 'GetHttpTimeString', 'GetK2ServerDocCountLimit', 'GetLocale', 'GetLocaleDisplayName', 'GetLocalHostIP', 'GetMetaData', 'GetMetricData', 'GetPageContext', 'GetPrinterInfo', 'GetPrinterList', 'GetProfileSections', 'GetProfileString', 'GetReadableImageFormats', 'GetSOAPRequest', 'GetSOAPRequestHeader', 'GetSOAPResponse', 'GetSOAPResponseHeader', 'GetTempDirectory', 'GetTempFile', 'GetTemplatePath', 'GetTickCount', 'GetTimeZoneInfo', 'GetToken', 'GetUserRoles', 'GetVFSMetaData', 'GetWriteableImageFormats', 'Hash', 'Hour', 'HTMLCodeFormat', 'HTMLEditFormat', 'IIf', 'ImageAddBorder', 'ImageBlur', 'ImageClearRect', 'ImageCopy', 'ImageCrop', 'ImageDrawArc', 'ImageDrawBeveledRect', 'ImageDrawCubicCurve', 'ImageDrawLine', 'ImageDrawLines', 'ImageDrawOval', 'ImageDrawPoint', 'ImageDrawQuadraticCurve', 'ImageDrawRect', 'ImageDrawRoundRect', 'ImageDrawText', 'ImageFlip', 'ImageGetBLOB', 'ImageGetBufferedImage', 'ImageGetExifMetaData', 'ImageGetEXIFTag', 'ImageGetHeight', 'ImageGetIptcMetaData', 'ImageGetIPTCTag', 'ImageGetWidth', 'ImageGrayscale', 'ImageInfo', 'ImageNegative', 'ImageNew', 'ImageOverlay', 'ImagePaste', 'ImageRead', 'ImageReadBase64', 'ImageResize', 'ImageRotate', 'ImageRotateDrawingAxis', 'ImageScaleToFit', 'ImageSetAntiAliasing', 'ImageSetBackgroundColor', 'ImageSetDrawingColor', 'ImageSetDrawingStroke', 'ImageSetDrawingTransparency', 'ImageSharpen', 'ImageShear', 'ImageShearDrawingAxis', 'ImageTranslate', 'ImageTranslateDrawingAxis', 'ImageWrite', 'ImageWriteBase64', 'ImageXORDrawingMode', 'IncrementValue', 'InputBaseN', 'Insert', 'Int', 'IsArray', 'IsBinary', 'IsBoolean', 'IsCustomFunction', 'IsDate', 'IsDDX', 'IsDebugMode', 'IsDefined', 'IsImage', 'IsImageFile', 'IsInstanceOf', 'IsIPV6', 'IsJSON', 'IsK2ServerABroker', 'IsLeapYear', 'IsLocalHost', 'IsNull', 'IsNumeric', 'IsNumericDate', 'IsObject', 'IsPDFFile', 'IsPDFObject', 'IsQuery', 'IsSimpleValue', 'IsSOAPRequest', 'IsSpreadSheetFile', 'IsSpreadSheetObject', 'IsStruct', 'IsUserInAnyRole', 'IsUserInRole', 'IsUserLoggedIn', 'IsValid', 'IsWddx', 'IsXml', 'IsXmlAttribute', 'IsXmlDoc', 'IsXmlElem', 'IsXmlNode', 'IsXmlRoot', 'JavaCast', 'JSStringFormat', 'LCase', 'Left', 'Len', 'ListAppend', 'ListChangeDelims', 'ListContains', 'ListContainsNoCase', 'ListDeleteAt', 'ListFind', 'ListFindNoCase', 'ListFirst', 'ListGetAt', 'ListInsertAt', 'ListLast', 'ListLen', 'ListPrepend', 'ListQualify', 'ListRest', 'ListSetAt', 'ListSort', 'ListToArray', 'ListValueCount', 'ListValueCountNoCase', 'LJustify', 'Location', 'Log', 'Log10', 'LSCurrencyFormat', 'LSDateFormat', 'LSEuroCurrencyFormat', 'LSIsCurrency', 'LSIsDate', 'LSIsNumeric', 'LSNumberFormat', 'LSParseCurrency', 'LSParseDateTime', 'LSParseEuroCurrency', 'LSParseNumber', 'LSTimeFormat', 'LTrim', 'Max', 'Mid', 'Min', 'Minute', 'Month', 'MonthAsString', 'Now', 'NumberFormat', 'ObjectEquals', 'ObjectLoad', 'ObjectSave', 'ORMClearSession', 'ORMCloseAllSessions', 'ORMCloseSession', 'ORMEvictCollection', 'ORMEvictEntity', 'ORMEvictQueries', 'ORMExecuteQuery', 'ORMFlush', 'ORMFlushAll', 'ORMGetSession', 'ORMGetSessionFactory', 'ORMReload', 'ParagraphFormat', 'ParameterExists', 'ParseDateTime', 'Pi', 'PrecisionEvaluate', 'PreserveSingleQuotes', 'Quarter', 'QueryAddColumn', 'QueryAddRow', 'QueryConvertForGrid', 'QueryNew', 'QuerySetCell', 'QuotedValueList', 'Rand', 'Randomize', 'RandRange', 'REFind', 'REFindNoCase', 'ReleaseComObject', 'REMatch', 'REMatchNoCase', 'RemoveChars', 'RepeatString', 'Replace', 'ReplaceList', 'ReplaceNoCase', 'REReplace', 'REReplaceNoCase', 'Reverse', 'Right', 'RJustify', 'Round', 'RTrim', 'Second', 'SendGatewayMessage', 'SerializeJSON', 'SetEncoding', 'SetLocale', 'SetProfileString', 'SetVariable', 'Sgn', 'Sin', 'Sleep', 'SpanExcluding', 'SpanIncluding', 'SpreadSheetAddColumn', 'SpreadSheetAddFreezePane', 'SpreadSheetAddImage', 'SpreadSheetAddInfo', 'SpreadSheetAddRow', 'SpreadSheetAddRows', 'SpreadSheetAddSplitPane', 'SpreadSheetCreateSheet', 'SpreadSheetDeleteColumn', 'SpreadSheetDeleteColumns', 'SpreadSheetDeleteRow', 'SpreadSheetDeleteRows', 'SpreadSheetFormatCell', 'SpreadSheetFormatCellRange', 'SpreadSheetFormatColumn', 'SpreadSheetFormatColumns', 'SpreadSheetFormatRow', 'SpreadSheetFormatRows', 'SpreadSheetGetCellComment', 'SpreadSheetGetCellFormula', 'SpreadSheetGetCellValue', 'SpreadSheetInfo', 'SpreadSheetMergeCells', 'SpreadSheetNew', 'SpreadSheetRead', 'SpreadSheetReadBinary', 'SpreadSheetRemoveSheet', 'SpreadSheetSetActiveSheet', 'SpreadSheetSetActiveSheetNumber', 'SpreadSheetSetCellComment', 'SpreadSheetSetCellFormula', 'SpreadSheetSetCellValue', 'SpreadSheetSetColumnWidth', 'SpreadSheetSetFooter', 'SpreadSheetSetHeader', 'SpreadSheetSetRowHeight', 'SpreadSheetShiftColumns', 'SpreadSheetShiftRows', 'SpreadSheetWrite', 'Sqr', 'StoreAddACL', 'StoreGetACL', 'StoreGetMetadata', 'StoreSetACL', 'StoreSetMetadata', 'StripCr', 'StructAppend', 'StructClear', 'StructCopy', 'StructCount', 'StructDelete', 'StructFind', 'StructFindKey', 'StructFindValue', 'StructGet', 'StructInsert', 'StructIsEmpty', 'StructKeyArray', 'StructKeyExists', 'StructKeyList', 'StructNew', 'StructSort', 'StructUpdate', 'Tan', 'ThreadJoin', 'ThreadTerminate', 'Throw', 'TimeFormat', 'ToBase64', 'ToBinary', 'ToScript', 'ToString', 'Trace', 'TransactionCommit', 'TransactionRollback', 'TransactionSetSavepoint', 'Trim', 'UCase', 'URLDecode', 'URLEncodedFormat', 'URLSessionFormat', 'Val', 'ValueList', 'VerifyClient', 'Week', 'Wrap', 'WriteDump', 'WriteLog', 'WriteOutput', 'XmlChildPos', 'XmlElemNew', 'XMLFormat', 'XmlGetNodeType', 'XmlNew', 'XmlParse', 'XmlSearch', 'XmlTransform', 'XMLValidate', 'Year', 'YesNoFormat'
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
			'reserved' : 'color: #48BDDF;'
			,'functions' : 'color: #0000FF;'
			,'statements' : 'color: #60CA00;'
			}
		,'OPERATORS' : 'color: #E775F0;'
		,'DELIMITERS' : ''
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

 	  	 
