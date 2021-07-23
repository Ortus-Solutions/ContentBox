<cfset siteService = getInstance( "siteService@contentbox" )>
<cfset defaultSite = siteService.getDefaultSite()>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

	<base href="<cfoutput>#defaultSite.getSiteRoot()#</cfoutput>/modules/contentbox/email_templates/images/" />

	<title>ContentBox Email</title>
    <!--[if gte mso 6]>
      <style>
          table.kmButtonBarContent {width:100% !important;}
      </style>
    <![endif]-->

	<style type="text/css">
        @media only screen and (max-width: 480px) {
            body, table, td, p, a, li, blockquote {
                -webkit-text-size-adjust: none !important;
            }
            body{
                width: 100% !important;
                min-width: 100% !important;
            }
            td[id=bodyCell] {
                padding: 10px !important;
            }
            table[class=kmTextContentContainer] {
                width: 100% !important;
            }
            table[class=kmBoxedTextContentContainer] {
                width: 100% !important;
            }
            td[class=kmImageContent] {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }
            img[class=kmImage] {
                width:100% !important;
            }
            table[class=kmSplitContentLeftContentContainer],
            table[class=kmSplitContentRightContentContainer],
            table[class=kmColumnContainer] {
                width:100% !important;
            }
            table[class=kmSplitContentLeftContentContainer] td[class=kmTextContent],
            table[class=kmSplitContentRightContentContainer] td[class=kmTextContent],
            table[class="kmColumnContainer"] td[class=kmTextContent] {
                padding-top:9px !important;
            }
            td[class="rowContainer kmfloat-left"],
            td[class="rowContainer kmfloat-left firstColumn"],
            td[class="rowContainer kmfloat-left lastColumn"] {
                float:left;
                clear: both;
                width: 100% !important;
            }
            table[id=templateContainer],
            table[class=templateRow],
            table[id=templateHeader],
            table[id=templateBody],
            table[id=templateFooter] {
                max-width:600px !important;
                width:100% !important;
            }

            h1 {
                font-size:24px !important;
                line-height:100% !important;
            }


            h2 {
                font-size:20px !important;
                line-height:100% !important;
            }


            h3 {
                font-size:18px !important;
                line-height:100% !important;
            }


            h4 {
                font-size:16px !important;
                line-height:100% !important;
            }

            td[class=rowContainer] td[class=kmTextContent] {
                font-size:18px !important;
                line-height:100% !important;
                padding-right:18px !important;
                padding-left:18px !important;
            }


            td[class=headerContainer] td[class=kmTextContent] {
                font-size:18px !important;
                line-height:100% !important;
                padding-right:18px !important;
                padding-left:18px !important;
            }


            td[class=bodyContainer] td[class=kmTextContent] {
                font-size:18px !important;
                line-height:100% !important;
                padding-right:18px !important;
                padding-left:18px !important;
            }


            td[class=footerContent] {
                font-size:18px !important;
                line-height:100% !important;
            }

            td[class=footerContent] a {
                display:block !important;
            }
        }
    </style>
</head>

<body style="margin: 0; padding: 0; background-color: #EAEAEA">
<center>
    <table align="center" border="0" cellpadding="0" cellspacing="0" id="bodyTable" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding: 0; background-color: #EAEAEA; height: 100%; margin: 0; width: 100%">
        <tbody>
            <tr>
                <td align="center" id="bodyCell" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-top: 20px; padding-left: 20px; padding-bottom: 20px; padding-right: 20px; border-top: 0; height: 100%; margin: 0; width: 100%">
                    <table border="0" cellpadding="0" cellspacing="0" id="templateContainer" width="600" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; border: 1px solid #CCC; background-color: #F4F4F4; border-radius: 0">
                        <tbody>
                            <tr>
                                <td align="center" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                    <table border="0" cellpadding="0" cellspacing="0" class="templateRow" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                        <tbody>
                                            <tr>
                                                <td class="rowContainer kmfloat-left" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                    <table border="0" cellpadding="0" cellspacing="0" class="templateRow" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                        <tbody>
                                            <tr>
                                                <td
                                                	class="rowContainer kmfloat-left"
                                                	valign="top"
                                                	style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0;padding-top:10px;">

                                                    <cfoutput>
													#externalView(
														view : getExplicitView().view,
														args : args
													)#
													</cfoutput>

                                                    <!-- Footer -->
                                                   <div
                                                    	style="text-align: center; border-top: 1px dotted gray; margin: 20px; padding-top: 20px">
                                                        <img
                                                        	alt="contentbox"
                                                        	class="kmImage"
                                                        	src="contentbox-horizontal.png"
                                                        	style="border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; max-width: 100%; padding-bottom: 0; display: inline; vertical-align: bottom" />

                                                        <br><br>

                                                        <cfoutput>
                                                        <small style="color: gray">
                                                            You're receiving this email because of your account on
                                                            <a href="#defaultSite.getSiteRoot()#">
                                                                <em>#defaultSite.getName()#</em>
                                                            </a>
                                                            <br>
                                                            If you'd like to receive fewer emails, you can adjust your notification settings.
                                                        </small>
                                                        </cfoutput>
                                                    </div>

                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
</center>
</body>
</html>
