/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A helper to create standard email template sections
 */
component singleton {

	// DI
	property name="avatar" inject="Avatar@contentbox";

	/**
	 *  Constructor
	 */
	EmailTemplateHelper function init(){
		// Return instance
		return this;
	}

	public string function author( required string email, required string content ){
		var gravatar        = variables.avatar.renderAvatar( email = arguments.email, size = 40 );
		savecontent variable="authorContent" {
			writeOutput(
				text(
					"
                <table cellpadding=3 cellspacing=3>
                    <tr>
                        <td width=30>#gravatar#</td>
                        <td>#arguments.content#</td>
                    </tr>
                </table>
            "
				)
			);
		}
		return authorContent;
	}

	/**
	 * Create a divider
	 *
	 * @paddingTop.hint    Top padding
	 * @paddingRight.hint  Right padding
	 * @paddingBottom.hint Bottom padding
	 * @paddingLeft.hint   Left padding
	 * @borderColor.hint   Border color
	 * @borderStyle.hint   Border style
	 * @borderWidth.hint   Border width
	 */
	public string function divider(
		required numeric paddingTop    = 18,
		required numeric paddingRight  = 18,
		required numeric paddingBottom = 18,
		required numeric paddingLeft   = 18,
		required string borderColor    = "DDDDDD",
		required string borderStyle    = "solid",
		required numeric borderWidth   = 1
	){
		// cfformat-ignore-start
        savecontent variable="dividerContent" {
            writeoutput('
                <table border="0" cellpadding="0" cellspacing="0" width="100%" class="kmDividerBlock" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                    <tbody class="kmDividerBlockOuter">
                        <tr>
                            <td class="kmDividerBlockInner" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-top:#arguments.paddingTop#px;padding-bottom:#arguments.paddingBottom#px;padding-left:#arguments.paddingLeft#px;padding-right:#arguments.paddingRight#px;">
                                <table class="kmDividerContent" border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; border-top-width:#arguments.borderWidth#px;border-top-style:#arguments.borderStyle#;border-top-color:###arguments.borderColor#;">
                                    <tbody>
                                        <tr>
                                            <td style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                                <span></span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            ');
        }
		// cfformat-ignore-end
return dividerContent;
	}

	/**
	 * Create a heading
	 *
	 * @content.hint  Content for the heading
	 * @level.hint    The heading level
	 * @color.hint    Text color
	 * @fontSize.hint Heading font size
	 */
	public string function heading(
		required string content,
		required string level     = "h2",
		required string color     = "777",
		required numeric fontSize = 20
	){
		// cfformat-ignore-start
        savecontent variable="headingContent" {
            writeoutput('
                <#arguments.level# style="color: ###arguments.color#; display: block; font-family: Helvetica; font-size: #arguments.fontSize#px; font-style: normal; font-weight: bold; line-height: 110%; letter-spacing: normal; margin: 0; margin-bottom: 9px; text-align: left">
                    #arguments.content#
                </#arguments.level#>
            ');
        }
		// cfformat-ignore-end
return text(
			headingContent
		);
	}

	/**
	 * Create a text area
	 *
	 * @content.hint Content for the text area
	 * @callout.hint If true, will wrap content in a callout box
	 */
	public string function text( required string content, required boolean callout = false ){
		// cfformat-ignore-start
        savecontent variable="textContent" {
            writeoutput('
                <table border="0" cellpadding="0" cellspacing="0" class="kmTextBlock" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                    <tbody class="kmTextBlockOuter">
                        <tr>
                            <td class="kmTextBlockInner" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; ">
                                <table align="left" border="0" cellpadding="0" cellspacing="0" class="kmTextContentContainer" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                    <tbody>
                                        <tr>
                                            <td class="kmTextContent" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; color: ##505050; font-family: Helvetica; font-size: 14px; line-height: 150%; text-align: left; padding-top:9px;padding-bottom:9px;padding-left:18px;padding-right:18px;">
            ');
            if( arguments.callout ) {
                writeoutput( '
                    <div style="border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;border:solid 1px ##dadada;padding:10px;background-color:##efefef;">
                ');
            }
            writeoutput( '#arguments.content#' );
            if( arguments.callout ) {
                writeoutput( '</div>' );
            }
            writeoutput('
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            ');
        }
		// cfformat-ignore-end
return textContent;
	}

	/**
	 * Create a button bar
	 *
	 * @buttons.hint Array of buttons to add to the button bar
	 */
	public string function buttonBar( required Array buttons ){
		// cfformat-ignore-start
        savecontent variable="buttonBarContent" {
            writeoutput('
                #divider( 18, 18, 5, 18 )#
                <table border="0" cellpadding="0" cellspacing="0" class="kmButtonBarBlock" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                    <tbody class="kmButtonBarOuter">
                        <tr>
                            <td class="kmButtonBarInner" valign="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding:9px;">
                                <table align="left" border="0" cellpadding="0" cellspacing="0" class="kmButtonBarContentContainer" width="100%" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                                    <tbody>
                                        <tr>
                                            <td align="left" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-left:9px;padding-right:9px;">
                                                <table border="0" cellpadding="0" cellspacing="0" class="kmButtonBarContent" align="left" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; font-family: Helvetica">
                                                    <tbody>
                                                        <tr>
                                                            <td align="top" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
            ');
            // loop over buttons
            for( var button in arguments.buttons ) {
                writeoutput('
                    <table align="left" border="0" cellpadding="0" cellspacing="0" class="kmButtonVertical" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                        <tbody>
                            <tr>
                                <td align="center" valign="top" class="kmButtonIconContent" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-right:10px;padding-bottom:5px;">
                                    <a href="#button.href#" target="_blank" style="word-wrap: break-word; color: ##0000cd; font-weight: normal; text-decoration: underline"><img src="#button.image#" alt="#button.text#" class="kmButtonBlockIcon" width="16" style="border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; width:16px; max-width:16px; display:block;" /></a>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" class="kmButtonTextContent" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; padding-right:10px;padding-bottom:9px;">
                                    <a href="#button.href#" target="_blank" style="word-wrap: break-word; color: ##0000cd; font-weight: normal; text-decoration: underline; font-size:11px;text-align:center;text-decoration:none;">#button.text#</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <table align="left" border="0" cellpadding="0" cellspacing="0" class="kmButtonVertical" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0">
                        <tbody>
                            <tr>
                                <td width="10" style="border-collapse: collapse; mso-table-lspace: 0; mso-table-rspace: 0; width:10px;">&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                ');
            }
            // close off bar
            writeoutput('
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
                #divider( 0, 18, 18, 18 )#
            ');
        }
		// cfformat-ignore-end
return buttonBarContent;
	}

}
