<cfoutput>
<!--- Default to open or close the alert on render --->
<cfparam name="args.open" 		default="false">
<!--- Show close button --->
<cfparam name="args.withClose" 		default="true">
<!--- Type: info, success, default, warning, danger --->
<cfparam name="args.type" 		default="info">
<!--- Messages to show --->
<cfparam name="args.messages" 		default="">
<!--- Bind the messages + type to a Alpine model --->
<cfparam name="args.messageModel" 	default="">

<alert
	x-data="{
		alertOpen 		: #args.open#,
		alertType 		: '#args.type#',
		alertMessage 	: '#args.messages#',
		alertModel 		: '#args.messageModel#',
		alertCloseButton : #args.withClose#,
		alertClose() {
			this.alertOpen = false;
			<cfif len( args.messageModel )>
			this.#args.messageModel#.message = '';
			<cfelse>
			this.alertMessage = '';
			</cfif>
		}
	}"
	<cfif len( args.messageModel )>
		x-show="alertOpen || #args.messageModel#.message.length"
	<cfelse>
		x-show="alertOpen || alertMessage.length"
	</cfif>
	x-cloak
>
	<div
		class="alert"
		<cfif len( args.messageModel )>
			:class="`alert-${#args.messageModel#.type}`"
		<cfelse>
			:class="`alert-${alertType}`"
		</cfif>
	>
		<i
			@click="alertClose()"
			title="Close Alert"
			class="far fa-times-circle cursor-pointer float-right text-2xl"
			x-show="alertCloseButton"
		></i>
		<cfif len( args.messageModel )>
			<div x-html="#args.messageModel#.message"></div>
		<cfelse>
			<div x-html="alertMessage"></div>
		</cfif>
	</div>
</alert>
</cfoutput>