/**
 * SyntaxHighlighter
 * http://alexgorbatchev.com/SyntaxHighlighter
 *
 * SyntaxHighlighter is donationware. If you are using it, please donate.
 * http://alexgorbatchev.com/SyntaxHighlighter/donate.html
 *
 * @version
 * 3.0.83 (July 02 2010)
 * 
 * @copyright
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 *
 * @license
 * Dual licensed under the MIT and GPL licenses.
 */
;(function()
{
  // CommonJS
  typeof(require) != 'undefined' ? SyntaxHighlighter = require('shCore').SyntaxHighlighter : null;

  function Brush()
  {
    // Contributed by Jen
    // http://www.jensbits.com/2009/05/14/coldfusion-brush-for-syntaxhighlighter-plus
    
    // Updated to ColdFusion 9.01 by John Whish
    // http://www.aliaspooryorik.com/

    var funcs  =  'ACos ASin Abs AddSOAPRequestHeader AddSOAPResponseHeader AjaxLink AjaxOnLoad ApplicationStop ArrayAppend ArrayAvg ArrayClear ArrayContains ArrayDelete ArrayDeleteAt ArrayFind ArrayFindNoCase ArrayInsertAt ArrayIsDefined ArrayIsEmpty ArrayLen ArrayMax ArrayMin ArrayNew ArrayPrepend ArrayResize ArraySet ArraySort ArraySum ArraySwap ArrayToList Asc Atn ' + 
            'BinaryDecode BinaryEncode BitAnd BitMaskClear BitMaskRead BitMaskSet BitNot BitOr BitSHLN BitSHRN BitXor ' + 
            'CJustify CacheGet CacheGetAllIds CacheGetMetadata CacheGetProperties CachePut CacheRemove CacheSetProperties Ceiling CharsetDecode CharsetEncode Chr Compare CompareNoCase Cos CreateDate CreateDateTime CreateODBCDate CreateODBCDateTime CreateODBCTime CreateObject CreateTime CreateTimeSpan CreateUUID ' + 
            'DE DateAdd DateCompare DateConvert DateDiff DateFormat DatePart Day DayOfWeek DayOfWeekAsString DayOfYear DaysInMonth DaysInYear DecimalFormat DecrementValue Decrypt DecryptBinary DeleteClientVariable DeserializeJSON DirectoryCreate DirectoryDelete DirectoryExists DirectoryList DirectoryRename DollarFormat DotNetToCFType Duplicate ' + 
            'Encrypt EncryptBinary EntityDelete EntityLoad EntityLoadByExample EntityLoadByPK EntityMerge EntityNew EntityReload EntitySave EntityToQuery Evaluate Exp ExpandPath ' + 
            'FileClose FileCopy FileDelete FileExists FileIsEOF FileMove FileOpen FileRead FileReadBinary FileReadLine FileSeek FileSetAccessMode FileSetAttribute FileSetLastModified FileSkipBytes FileWrite FileWriteLine Find FindNoCase FindOneOf FirstDayOfMonth Fix FormatBaseN ' + 
            'GenerateSecretKey GetAuthUser GetBaseTagData GetBaseTagList GetBaseTemplatePath GetClientVariablesList GetComponentMetaData GetContextRoot GetCurrentTemplatePath GetDirectoryFromPath GetEncoding GetException GetFileFromPath GetFileInfo GetFunctionList GetGatewayHelper GetHTTPRequestData GetHttpTimeString GetK2ServerDocCount GetK2ServerDocCountLimitStoreGetMetadata GetLocalHostIP GetLocale GetLocaleDisplayName GetMetaData GetMetricData GetPageContext GetPrinterInfo GetPrinterList GetProfileSections GetProfileString GetReadableImageFormats GetSOAPRequest GetSOAPRequestHeader GetSOAPResponse GetSOAPResponseHeader GetTempDirectory GetTempFile GetTemplatePath GetTickCount GetTimeZoneInfo GetToken GetUserRoles GetVFSMetaData GetWriteableImageFormats ' + 
            'HTMLCodeFormat HTMLEditFormat Hash Hour ' + 
            'IIf ImageAddBorder ImageBlur ImageClearRect ImageCopy ImageCrop ImageDrawArc ImageDrawBeveledRect ImageDrawCubicCurve ImageDrawLine ImageDrawLines ImageDrawOval ImageDrawPoint ImageDrawQuadraticCurve ImageDrawRect ImageDrawRoundRect ImageDrawText ImageFlip ImageGetBLOB ImageGetBufferedImage ImageGetEXIFTag ImageGetExifMetaData ImageGetHeight ImageGetIPTCTag ImageGetIptcMetaData ImageGetWidth ImageGrayscale ImageInfo ImageNegative ImageNew ImageOverlay ImagePaste ImageRead ImageReadBase64 ImageResize ImageRotate ImageRotateDrawingAxis ImageScaleToFit ImageSetAntiAliasing ImageSetBackgroundColor ImageSetDrawingColor ImageSetDrawingStroke ImageSetDrawingTransparency ImageSharpen ImageShear ImageShearDrawingAxis ImageTranslate ImageTranslateDrawingAxis ImageWrite ImageWriteBase64 ImageXORDrawingMode IncrementValue InputBaseN Insert Int IsArray IsBinary IsBoolean IsCustomFunction IsDDX IsDate IsDebugMode IsDefined IsIPV6 IsImage IsImageFile IsInstanceOf IsJSON IsK2ServerABroker IsK2ServerDocCountExceeded IsK2ServerOnline IsLeapYear IsLocalHost IsNull IsNumeric IsNumericDate IsObject IsPDFFile IsPDFObject IsQuery IsSOAPRequest IsSimpleValue IsSpreadSheetFile IsSpreadSheetObject IsStruct IsUserInAnyRole IsUserInRole IsUserLoggedIn IsValid IsWddx IsXml IsXmlAttribute IsXmlDoc IsXmlElem IsXmlNode IsXmlRoot ' + 
            'JSStringFormat JavaCast ' + 
            'LCase LJustify LSCurrencyFormat LSDateFormat LSEuroCurrencyFormat LSIsCurrency LSIsDate LSIsNumeric LSNumberFormat LSParseCurrency LSParseDateTime LSParseEuroCurrency LSParseNumber LSTimeFormat LTrim Left Len ListAppend ListChangeDelims ListContains ListContainsNoCase ListDeleteAt ListFind ListFindNoCase ListFirst ListGetAt ListInsertAt ListLast ListLen ListPrepend ListQualify ListRest ListSetAt ListSort ListToArray ListValueCount ListValueCountNoCase Location Log Log10 ' + 
            'Max Mid Min Minute Month MonthAsString ' + 
            'Now NumberFormat ' + 
            'ORMClearSession ORMCloseSession ORMEvictCollection ORMEvictEntity ORMEvictQueries ORMExecuteQuery ORMFlush ORMGetSession ORMGetSessionFactory ORMReload ObjectEquals ObjectLoad ObjectSave ' + 
            'ParagraphFormat ParameterExists ParseDateTime Pi PrecisionEvaluate PreserveSingleQuotes ' + 
            'Quarter QueryAddColumn QueryAddRow QueryConvertForGrid QueryNew QuerySetCell QuotedValueList ' + 
            'REFind REFindNoCase REMatch REMatchNoCase REReplace REReplaceNoCase RJustify RTrim Rand RandRange Randomize ReleaseComObject RemoveChars RepeatString Replace ReplaceList ReplaceNoCase Reverse Right Round ' + 
            'Second SendGatewayMessage SerializeJSON SetEncoding SetLocale SetProfileString SetVariable Sgn Sin Sleep SpanExcluding SpanIncluding SpreadSheetAddColumn SpreadSheetAddFreezePane SpreadSheetAddImage SpreadSheetAddInfo SpreadSheetAddRow SpreadSheetAddRows SpreadSheetAddSplitPane SpreadSheetCreateSheet SpreadSheetDeleteColumn SpreadSheetDeleteColumns SpreadSheetDeleteRow SpreadSheetDeleteRows SpreadSheetFormatCell SpreadSheetFormatColumn SpreadSheetFormatColumns SpreadSheetFormatRow SpreadSheetFormatRows SpreadSheetGetCellComment SpreadSheetGetCellFormula SpreadSheetGetCellValue SpreadSheetInfo SpreadSheetMergeCells SpreadSheetNew SpreadSheetRead SpreadSheetReadBinary SpreadSheetSetActiveSheet SpreadSheetSetActiveSheetNumber SpreadSheetSetCellComment SpreadSheetSetCellFormula SpreadSheetSetCellValue SpreadSheetSetColumnWidth SpreadSheetSetFooter SpreadSheetSetHeader SpreadSheetSetRowHeight SpreadSheetShiftColumns SpreadSheetShiftRows SpreadSheetWrite Sqr StoreAddACL StoreGetACL StoreSetACL StoreSetMetadata StripCr StructAppend StructClear StructCopy StructCount StructDelete StructFind StructFindKey StructFindValue StructGet StructInsert StructIsEmpty StructKeyArray StructKeyExists StructKeyList StructNew StructSort StructUpdate ' + 
            'Tan ThreadJoin ThreadTerminate Throw TimeFormat ToBase64 ToBinary ToScript ToString Trace TransactionCommit TransactionRollback TransactionSetSavepoint Trim ' + 
            'UCase URLDecode URLEncodedFormat URLSessionFormat ' + 
            'Val ValueList VerifyClient ' + 
            'Week Wrap WriteDump WriteLog WriteOutput ' + 
            'XMLFormat XMLValidate XmlChildPos XmlElemNew XmlGetNodeType XmlNew XmlParse XmlSearch XmlTransform ' + 
            'Year YesNoFormat '; 

    var keywords =  'cfabort cfajaximport cfajaxproxy cfapplet cfapplication cfargument cfassociate cfbreak cfcache cfcalendar ' + 
            'cfcase cfcatch cfchart cfchartdata cfchartseries cfcol cfcollection cfcomponent cfcontent cfcookie cfdbinfo ' + 
            'cfdefaultcase cfdirectory cfdiv cfdocument cfdocumentitem cfdocumentsection cfdump cfelse cfelseif cferror ' + 
            'cfexchangecalendar cfexchangeconnection cfexchangecontact cfexchangefilter cfexchangemail cfexchangetask ' + 
            'cfexecute cfexit cffeed cffile cfflush cfform cfformgroup cfformitem cfftp cffunction cfgrid cfgridcolumn ' + 
            'cfgridrow cfgridupdate cfheader cfhtmlhead cfhttp cfhttpparam cfif cfimage cfimport cfinclude cfindex ' + 
            'cfinput cfinsert cfinterface cfinvoke cfinvokeargument cflayout cflayoutarea cfldap cflocation cflock cflog ' + 
            'cflogin cfloginuser cflogout cfloop cfmail cfmailparam cfmailpart cfmenu cfmenuitem cfmodule cfNTauthenticate ' + 
            'cfobject cfobjectcache cfoutput cfparam cfpdf cfpdfform cfpdfformparam cfpdfparam cfpdfsubform cfpod cfpop ' + 
            'cfpresentation cfpresentationslide cfpresenter cfprint cfprocessingdirective cfprocparam cfprocresult ' + 
            'cfproperty cfquery cfqueryparam cfregistry cfreport cfreportparam cfrethrow cfreturn cfsavecontent cfschedule ' + 
            'cfscript cfsearch cfselect cfset cfsetting cfsilent cfslider cfsprydataset cfstoredproc cfswitch cftable ' + 
            'cftextarea cfthread cfthrow cftimer cftooltip cftrace cftransaction cftree cftreeitem cftry cfupdate cfwddx ' + 
            'cfwindow cfxml cfzip cfzipparam ' + 
            'cfcontinue cffileupload cffinally cfimap cfmap cfmapitem cfmediaplayer cfmenu cfmenuitem cfmessagebox cfpdf cfprocparam cfprogressbar cfsharepoint cfspreadsheet ' + 
            'property function component return ';
            
    var datatypes = 'numeric struct array any string void boolean ';

    var declarations =  'new this ';
    
    var accesstypes =  'public private remote package ';
    
    this.regexList = [
      { regex: new RegExp('--(.*)$', 'gm'),            css: 'comments' },  // one line and multiline comments
      { regex: SyntaxHighlighter.regexLib.singleLineCComments,  css: 'comments' },  // cfscript one line comments
      { regex: SyntaxHighlighter.regexLib.multiLineCComments,    css: 'comments' },  // cfscript multiline comments
      { regex: SyntaxHighlighter.regexLib.xmlComments,      css: 'comments' },  // single quoted strings
      { regex: SyntaxHighlighter.regexLib.doubleQuotedString,    css: 'string' },    // double quoted strings
      { regex: SyntaxHighlighter.regexLib.singleQuotedString,    css: 'string' },    // single quoted strings
      { regex: new RegExp(this.getKeywords(funcs), 'gmi'),    css: 'functions' }, // functions
      { regex: new RegExp(this.getKeywords(declarations), 'gmi'),  css: 'color1' },    // operators and such
      { regex: new RegExp(this.getKeywords(accesstypes), 'gmi'),  css: 'color2' },    // access types
      { regex: new RegExp(this.getKeywords(keywords), 'gmi'),    css: 'keyword' },  // keyword
      { regex: new RegExp(this.getKeywords(datatypes), 'gmi'),  css: 'value' }    // datatypes
    ];
  }

  Brush.prototype  = new SyntaxHighlighter.Highlighter();
  Brush.aliases  = ['coldfusion','cf','cfml'];
  
  SyntaxHighlighter.brushes.ColdFusion = Brush;

  // CommonJS
  typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();