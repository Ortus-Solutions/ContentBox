/*!
 * Datepicker for Bootstrap v1.6.4 (https://github.com/eternicode/bootstrap-datepicker)
 *
 * Copyright 2012 Stefan Petre
 * Improvements by Andrew Rowls
 * Licensed under the Apache License v2.0 (http://www.apache.org/licenses/LICENSE-2.0)
 */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):a("object"==typeof exports?require("jquery"):jQuery)}(function(a,b){function c(){return new Date(Date.UTC.apply(Date,arguments))}function d(){var a=new Date;return c(a.getFullYear(),a.getMonth(),a.getDate())}function e(a,b){return a.getUTCFullYear()===b.getUTCFullYear()&&a.getUTCMonth()===b.getUTCMonth()&&a.getUTCDate()===b.getUTCDate()}function f(a){return function(){return this[a].apply(this,arguments)}}function g(a){return a&&!isNaN(a.getTime())}function h(b,c){function d(a,b){return b.toLowerCase()}var e,f=a(b).data(),g={},h=new RegExp("^"+c.toLowerCase()+"([A-Z])");c=new RegExp("^"+c.toLowerCase());for(var i in f)c.test(i)&&(e=i.replace(h,d),g[e]=f[i]);return g}function i(b){var c={};if(q[b]||(b=b.split("-")[0],q[b])){var d=q[b];return a.each(p,function(a,b){b in d&&(c[b]=d[b])}),c}}var j=function(){var b={get:function(a){return this.slice(a)[0]},contains:function(a){for(var b=a&&a.valueOf(),c=0,d=this.length;d>c;c++)if(this[c].valueOf()===b)return c;return-1},remove:function(a){this.splice(a,1)},replace:function(b){b&&(a.isArray(b)||(b=[b]),this.clear(),this.push.apply(this,b))},clear:function(){this.length=0},copy:function(){var a=new j;return a.replace(this),a}};return function(){var c=[];return c.push.apply(c,arguments),a.extend(c,b),c}}(),k=function(b,c){a(b).data("datepicker",this),this._process_options(c),this.dates=new j,this.viewDate=this.o.defaultViewDate,this.focusDate=null,this.element=a(b),this.isInput=this.element.is("input"),this.inputField=this.isInput?this.element:this.element.find("input"),this.component=this.element.hasClass("date")?this.element.find(".add-on, .input-group-addon, .btn"):!1,this.hasInput=this.component&&this.inputField.length,this.component&&0===this.component.length&&(this.component=!1),this.isInline=!this.component&&this.element.is("div"),this.picker=a(r.template),this._check_template(this.o.templates.leftArrow)&&this.picker.find(".prev").html(this.o.templates.leftArrow),this._check_template(this.o.templates.rightArrow)&&this.picker.find(".next").html(this.o.templates.rightArrow),this._buildEvents(),this._attachEvents(),this.isInline?this.picker.addClass("datepicker-inline").appendTo(this.element):this.picker.addClass("datepicker-dropdown dropdown-menu"),this.o.rtl&&this.picker.addClass("datepicker-rtl"),this.viewMode=this.o.startView,this.o.calendarWeeks&&this.picker.find("thead .datepicker-title, tfoot .today, tfoot .clear").attr("colspan",function(a,b){return parseInt(b)+1}),this._allow_update=!1,this.setStartDate(this._o.startDate),this.setEndDate(this._o.endDate),this.setDaysOfWeekDisabled(this.o.daysOfWeekDisabled),this.setDaysOfWeekHighlighted(this.o.daysOfWeekHighlighted),this.setDatesDisabled(this.o.datesDisabled),this.fillDow(),this.fillMonths(),this._allow_update=!0,this.update(),this.showMode(),this.isInline&&this.show()};k.prototype={constructor:k,_resolveViewName:function(a,c){return 0===a||"days"===a||"month"===a?0:1===a||"months"===a||"year"===a?1:2===a||"years"===a||"decade"===a?2:3===a||"decades"===a||"century"===a?3:4===a||"centuries"===a||"millennium"===a?4:c===b?!1:c},_check_template:function(c){try{if(c===b||""===c)return!1;if((c.match(/[<>]/g)||[]).length<=0)return!0;var d=a(c);return d.length>0}catch(e){return!1}},_process_options:function(b){this._o=a.extend({},this._o,b);var e=this.o=a.extend({},this._o),f=e.language;q[f]||(f=f.split("-")[0],q[f]||(f=o.language)),e.language=f,e.startView=this._resolveViewName(e.startView,0),e.minViewMode=this._resolveViewName(e.minViewMode,0),e.maxViewMode=this._resolveViewName(e.maxViewMode,4),e.startView=Math.min(e.startView,e.maxViewMode),e.startView=Math.max(e.startView,e.minViewMode),e.multidate!==!0&&(e.multidate=Number(e.multidate)||!1,e.multidate!==!1&&(e.multidate=Math.max(0,e.multidate))),e.multidateSeparator=String(e.multidateSeparator),e.weekStart%=7,e.weekEnd=(e.weekStart+6)%7;var g=r.parseFormat(e.format);e.startDate!==-(1/0)&&(e.startDate?e.startDate instanceof Date?e.startDate=this._local_to_utc(this._zero_time(e.startDate)):e.startDate=r.parseDate(e.startDate,g,e.language,e.assumeNearbyYear):e.startDate=-(1/0)),e.endDate!==1/0&&(e.endDate?e.endDate instanceof Date?e.endDate=this._local_to_utc(this._zero_time(e.endDate)):e.endDate=r.parseDate(e.endDate,g,e.language,e.assumeNearbyYear):e.endDate=1/0),e.daysOfWeekDisabled=e.daysOfWeekDisabled||[],a.isArray(e.daysOfWeekDisabled)||(e.daysOfWeekDisabled=e.daysOfWeekDisabled.split(/[,\s]*/)),e.daysOfWeekDisabled=a.map(e.daysOfWeekDisabled,function(a){return parseInt(a,10)}),e.daysOfWeekHighlighted=e.daysOfWeekHighlighted||[],a.isArray(e.daysOfWeekHighlighted)||(e.daysOfWeekHighlighted=e.daysOfWeekHighlighted.split(/[,\s]*/)),e.daysOfWeekHighlighted=a.map(e.daysOfWeekHighlighted,function(a){return parseInt(a,10)}),e.datesDisabled=e.datesDisabled||[],a.isArray(e.datesDisabled)||(e.datesDisabled=[e.datesDisabled]),e.datesDisabled=a.map(e.datesDisabled,function(a){return r.parseDate(a,g,e.language,e.assumeNearbyYear)});var h=String(e.orientation).toLowerCase().split(/\s+/g),i=e.orientation.toLowerCase();if(h=a.grep(h,function(a){return/^auto|left|right|top|bottom$/.test(a)}),e.orientation={x:"auto",y:"auto"},i&&"auto"!==i)if(1===h.length)switch(h[0]){case"top":case"bottom":e.orientation.y=h[0];break;case"left":case"right":e.orientation.x=h[0]}else i=a.grep(h,function(a){return/^left|right$/.test(a)}),e.orientation.x=i[0]||"auto",i=a.grep(h,function(a){return/^top|bottom$/.test(a)}),e.orientation.y=i[0]||"auto";else;if(e.defaultViewDate){var j=e.defaultViewDate.year||(new Date).getFullYear(),k=e.defaultViewDate.month||0,l=e.defaultViewDate.day||1;e.defaultViewDate=c(j,k,l)}else e.defaultViewDate=d()},_events:[],_secondaryEvents:[],_applyEvents:function(a){for(var c,d,e,f=0;f<a.length;f++)c=a[f][0],2===a[f].length?(d=b,e=a[f][1]):3===a[f].length&&(d=a[f][1],e=a[f][2]),c.on(e,d)},_unapplyEvents:function(a){for(var c,d,e,f=0;f<a.length;f++)c=a[f][0],2===a[f].length?(e=b,d=a[f][1]):3===a[f].length&&(e=a[f][1],d=a[f][2]),c.off(d,e)},_buildEvents:function(){var b={keyup:a.proxy(function(b){-1===a.inArray(b.keyCode,[27,37,39,38,40,32,13,9])&&this.update()},this),keydown:a.proxy(this.keydown,this),paste:a.proxy(this.paste,this)};this.o.showOnFocus===!0&&(b.focus=a.proxy(this.show,this)),this.isInput?this._events=[[this.element,b]]:this.component&&this.hasInput?this._events=[[this.inputField,b],[this.component,{click:a.proxy(this.show,this)}]]:this._events=[[this.element,{click:a.proxy(this.show,this),keydown:a.proxy(this.keydown,this)}]],this._events.push([this.element,"*",{blur:a.proxy(function(a){this._focused_from=a.target},this)}],[this.element,{blur:a.proxy(function(a){this._focused_from=a.target},this)}]),this.o.immediateUpdates&&this._events.push([this.element,{"changeYear changeMonth":a.proxy(function(a){this.update(a.date)},this)}]),this._secondaryEvents=[[this.picker,{click:a.proxy(this.click,this)}],[a(window),{resize:a.proxy(this.place,this)}],[a(document),{mousedown:a.proxy(function(a){this.element.is(a.target)||this.element.find(a.target).length||this.picker.is(a.target)||this.picker.find(a.target).length||this.isInline||this.hide()},this)}]]},_attachEvents:function(){this._detachEvents(),this._applyEvents(this._events)},_detachEvents:function(){this._unapplyEvents(this._events)},_attachSecondaryEvents:function(){this._detachSecondaryEvents(),this._applyEvents(this._secondaryEvents)},_detachSecondaryEvents:function(){this._unapplyEvents(this._secondaryEvents)},_trigger:function(b,c){var d=c||this.dates.get(-1),e=this._utc_to_local(d);this.element.trigger({type:b,date:e,dates:a.map(this.dates,this._utc_to_local),format:a.proxy(function(a,b){0===arguments.length?(a=this.dates.length-1,b=this.o.format):"string"==typeof a&&(b=a,a=this.dates.length-1),b=b||this.o.format;var c=this.dates.get(a);return r.formatDate(c,b,this.o.language)},this)})},show:function(){return this.inputField.prop("disabled")||this.inputField.prop("readonly")&&this.o.enableOnReadonly===!1?void 0:(this.isInline||this.picker.appendTo(this.o.container),this.place(),this.picker.show(),this._attachSecondaryEvents(),this._trigger("show"),(window.navigator.msMaxTouchPoints||"ontouchstart"in document)&&this.o.disableTouchKeyboard&&a(this.element).blur(),this)},hide:function(){return this.isInline||!this.picker.is(":visible")?this:(this.focusDate=null,this.picker.hide().detach(),this._detachSecondaryEvents(),this.viewMode=this.o.startView,this.showMode(),this.o.forceParse&&this.inputField.val()&&this.setValue(),this._trigger("hide"),this)},destroy:function(){return this.hide(),this._detachEvents(),this._detachSecondaryEvents(),this.picker.remove(),delete this.element.data().datepicker,this.isInput||delete this.element.data().date,this},paste:function(b){var c;if(b.originalEvent.clipboardData&&b.originalEvent.clipboardData.types&&-1!==a.inArray("text/plain",b.originalEvent.clipboardData.types))c=b.originalEvent.clipboardData.getData("text/plain");else{if(!window.clipboardData)return;c=window.clipboardData.getData("Text")}this.setDate(c),this.update(),b.preventDefault()},_utc_to_local:function(a){return a&&new Date(a.getTime()+6e4*a.getTimezoneOffset())},_local_to_utc:function(a){return a&&new Date(a.getTime()-6e4*a.getTimezoneOffset())},_zero_time:function(a){return a&&new Date(a.getFullYear(),a.getMonth(),a.getDate())},_zero_utc_time:function(a){return a&&new Date(Date.UTC(a.getUTCFullYear(),a.getUTCMonth(),a.getUTCDate()))},getDates:function(){return a.map(this.dates,this._utc_to_local)},getUTCDates:function(){return a.map(this.dates,function(a){return new Date(a)})},getDate:function(){return this._utc_to_local(this.getUTCDate())},getUTCDate:function(){var a=this.dates.get(-1);return"undefined"!=typeof a?new Date(a):null},clearDates:function(){this.inputField&&this.inputField.val(""),this.update(),this._trigger("changeDate"),this.o.autoclose&&this.hide()},setDates:function(){var b=a.isArray(arguments[0])?arguments[0]:arguments;return this.update.apply(this,b),this._trigger("changeDate"),this.setValue(),this},setUTCDates:function(){var b=a.isArray(arguments[0])?arguments[0]:arguments;return this.update.apply(this,a.map(b,this._utc_to_local)),this._trigger("changeDate"),this.setValue(),this},setDate:f("setDates"),setUTCDate:f("setUTCDates"),remove:f("destroy"),setValue:function(){var a=this.getFormattedDate();return this.inputField.val(a),this},getFormattedDate:function(c){c===b&&(c=this.o.format);var d=this.o.language;return a.map(this.dates,function(a){return r.formatDate(a,c,d)}).join(this.o.multidateSeparator)},getStartDate:function(){return this.o.startDate},setStartDate:function(a){return this._process_options({startDate:a}),this.update(),this.updateNavArrows(),this},getEndDate:function(){return this.o.endDate},setEndDate:function(a){return this._process_options({endDate:a}),this.update(),this.updateNavArrows(),this},setDaysOfWeekDisabled:function(a){return this._process_options({daysOfWeekDisabled:a}),this.update(),this.updateNavArrows(),this},setDaysOfWeekHighlighted:function(a){return this._process_options({daysOfWeekHighlighted:a}),this.update(),this},setDatesDisabled:function(a){this._process_options({datesDisabled:a}),this.update(),this.updateNavArrows()},place:function(){if(this.isInline)return this;var b=this.picker.outerWidth(),c=this.picker.outerHeight(),d=10,e=a(this.o.container),f=e.width(),g="body"===this.o.container?a(document).scrollTop():e.scrollTop(),h=e.offset(),i=[];this.element.parents().each(function(){var b=a(this).css("z-index");"auto"!==b&&0!==b&&i.push(parseInt(b))});var j=Math.max.apply(Math,i)+this.o.zIndexOffset,k=this.component?this.component.parent().offset():this.element.offset(),l=this.component?this.component.outerHeight(!0):this.element.outerHeight(!1),m=this.component?this.component.outerWidth(!0):this.element.outerWidth(!1),n=k.left-h.left,o=k.top-h.top;"body"!==this.o.container&&(o+=g),this.picker.removeClass("datepicker-orient-top datepicker-orient-bottom datepicker-orient-right datepicker-orient-left"),"auto"!==this.o.orientation.x?(this.picker.addClass("datepicker-orient-"+this.o.orientation.x),"right"===this.o.orientation.x&&(n-=b-m)):k.left<0?(this.picker.addClass("datepicker-orient-left"),n-=k.left-d):n+b>f?(this.picker.addClass("datepicker-orient-right"),n+=m-b):this.picker.addClass("datepicker-orient-left");var p,q=this.o.orientation.y;if("auto"===q&&(p=-g+o-c,q=0>p?"bottom":"top"),this.picker.addClass("datepicker-orient-"+q),"top"===q?o-=c+parseInt(this.picker.css("padding-top")):o+=l,this.o.rtl){var r=f-(n+m);this.picker.css({top:o,right:r,zIndex:j})}else this.picker.css({top:o,left:n,zIndex:j});return this},_allow_update:!0,update:function(){if(!this._allow_update)return this;var b=this.dates.copy(),c=[],d=!1;return arguments.length?(a.each(arguments,a.proxy(function(a,b){b instanceof Date&&(b=this._local_to_utc(b)),c.push(b)},this)),d=!0):(c=this.isInput?this.element.val():this.element.data("date")||this.inputField.val(),c=c&&this.o.multidate?c.split(this.o.multidateSeparator):[c],delete this.element.data().date),c=a.map(c,a.proxy(function(a){return r.parseDate(a,this.o.format,this.o.language,this.o.assumeNearbyYear)},this)),c=a.grep(c,a.proxy(function(a){return!this.dateWithinRange(a)||!a},this),!0),this.dates.replace(c),this.dates.length?this.viewDate=new Date(this.dates.get(-1)):this.viewDate<this.o.startDate?this.viewDate=new Date(this.o.startDate):this.viewDate>this.o.endDate?this.viewDate=new Date(this.o.endDate):this.viewDate=this.o.defaultViewDate,d?this.setValue():c.length&&String(b)!==String(this.dates)&&this._trigger("changeDate"),!this.dates.length&&b.length&&this._trigger("clearDate"),this.fill(),this.element.change(),this},fillDow:function(){var b=this.o.weekStart,c="<tr>";for(this.o.calendarWeeks&&(this.picker.find(".datepicker-days .datepicker-switch").attr("colspan",function(a,b){return parseInt(b)+1}),c+='<th class="cw">&#160;</th>');b<this.o.weekStart+7;)c+='<th class="dow',a.inArray(b,this.o.daysOfWeekDisabled)>-1&&(c+=" disabled"),c+='">'+q[this.o.language].daysMin[b++%7]+"</th>";c+="</tr>",this.picker.find(".datepicker-days thead").append(c)},fillMonths:function(){for(var a=this._utc_to_local(this.viewDate),b="",c=0;12>c;){var d=a&&a.getMonth()===c?" focused":"";b+='<span class="month'+d+'">'+q[this.o.language].monthsShort[c++]+"</span>"}this.picker.find(".datepicker-months td").html(b)},setRange:function(b){b&&b.length?this.range=a.map(b,function(a){return a.valueOf()}):delete this.range,this.fill()},getClassNames:function(b){var c=[],d=this.viewDate.getUTCFullYear(),e=this.viewDate.getUTCMonth(),f=new Date;return b.getUTCFullYear()<d||b.getUTCFullYear()===d&&b.getUTCMonth()<e?c.push("old"):(b.getUTCFullYear()>d||b.getUTCFullYear()===d&&b.getUTCMonth()>e)&&c.push("new"),this.focusDate&&b.valueOf()===this.focusDate.valueOf()&&c.push("focused"),this.o.todayHighlight&&b.getUTCFullYear()===f.getFullYear()&&b.getUTCMonth()===f.getMonth()&&b.getUTCDate()===f.getDate()&&c.push("today"),-1!==this.dates.contains(b)&&c.push("active"),this.dateWithinRange(b)||c.push("disabled"),this.dateIsDisabled(b)&&c.push("disabled","disabled-date"),-1!==a.inArray(b.getUTCDay(),this.o.daysOfWeekHighlighted)&&c.push("highlighted"),this.range&&(b>this.range[0]&&b<this.range[this.range.length-1]&&c.push("range"),-1!==a.inArray(b.valueOf(),this.range)&&c.push("selected"),b.valueOf()===this.range[0]&&c.push("range-start"),b.valueOf()===this.range[this.range.length-1]&&c.push("range-end")),c},_fill_yearsView:function(c,d,e,f,g,h,i,j){var k,l,m,n,o,p,q,r,s,t,u;for(k="",l=this.picker.find(c),m=parseInt(g/e,10)*e,o=parseInt(h/f,10)*f,p=parseInt(i/f,10)*f,n=a.map(this.dates,function(a){return parseInt(a.getUTCFullYear()/f,10)*f}),l.find(".datepicker-switch").text(m+"-"+(m+9*f)),q=m-f,r=-1;11>r;r+=1)s=[d],t=null,-1===r?s.push("old"):10===r&&s.push("new"),-1!==a.inArray(q,n)&&s.push("active"),(o>q||q>p)&&s.push("disabled"),q===this.viewDate.getFullYear()&&s.push("focused"),j!==a.noop&&(u=j(new Date(q,0,1)),u===b?u={}:"boolean"==typeof u?u={enabled:u}:"string"==typeof u&&(u={classes:u}),u.enabled===!1&&s.push("disabled"),u.classes&&(s=s.concat(u.classes.split(/\s+/))),u.tooltip&&(t=u.tooltip)),k+='<span class="'+s.join(" ")+'"'+(t?' title="'+t+'"':"")+">"+q+"</span>",q+=f;l.find("td").html(k)},fill:function(){var d,e,f=new Date(this.viewDate),g=f.getUTCFullYear(),h=f.getUTCMonth(),i=this.o.startDate!==-(1/0)?this.o.startDate.getUTCFullYear():-(1/0),j=this.o.startDate!==-(1/0)?this.o.startDate.getUTCMonth():-(1/0),k=this.o.endDate!==1/0?this.o.endDate.getUTCFullYear():1/0,l=this.o.endDate!==1/0?this.o.endDate.getUTCMonth():1/0,m=q[this.o.language].today||q.en.today||"",n=q[this.o.language].clear||q.en.clear||"",o=q[this.o.language].titleFormat||q.en.titleFormat;if(!isNaN(g)&&!isNaN(h)){this.picker.find(".datepicker-days .datepicker-switch").text(r.formatDate(f,o,this.o.language)),this.picker.find("tfoot .today").text(m).toggle(this.o.todayBtn!==!1),this.picker.find("tfoot .clear").text(n).toggle(this.o.clearBtn!==!1),this.picker.find("thead .datepicker-title").text(this.o.title).toggle(""!==this.o.title),this.updateNavArrows(),this.fillMonths();var p=c(g,h-1,28),s=r.getDaysInMonth(p.getUTCFullYear(),p.getUTCMonth());p.setUTCDate(s),p.setUTCDate(s-(p.getUTCDay()-this.o.weekStart+7)%7);var t=new Date(p);p.getUTCFullYear()<100&&t.setUTCFullYear(p.getUTCFullYear()),t.setUTCDate(t.getUTCDate()+42),t=t.valueOf();for(var u,v=[];p.valueOf()<t;){if(p.getUTCDay()===this.o.weekStart&&(v.push("<tr>"),this.o.calendarWeeks)){var w=new Date(+p+(this.o.weekStart-p.getUTCDay()-7)%7*864e5),x=new Date(Number(w)+(11-w.getUTCDay())%7*864e5),y=new Date(Number(y=c(x.getUTCFullYear(),0,1))+(11-y.getUTCDay())%7*864e5),z=(x-y)/864e5/7+1;v.push('<td class="cw">'+z+"</td>")}u=this.getClassNames(p),u.push("day"),this.o.beforeShowDay!==a.noop&&(e=this.o.beforeShowDay(this._utc_to_local(p)),e===b?e={}:"boolean"==typeof e?e={enabled:e}:"string"==typeof e&&(e={classes:e}),e.enabled===!1&&u.push("disabled"),e.classes&&(u=u.concat(e.classes.split(/\s+/))),e.tooltip&&(d=e.tooltip)),u=a.isFunction(a.uniqueSort)?a.uniqueSort(u):a.unique(u),v.push('<td class="'+u.join(" ")+'"'+(d?' title="'+d+'"':"")+">"+p.getUTCDate()+"</td>"),d=null,p.getUTCDay()===this.o.weekEnd&&v.push("</tr>"),p.setUTCDate(p.getUTCDate()+1)}this.picker.find(".datepicker-days tbody").empty().append(v.join(""));var A=q[this.o.language].monthsTitle||q.en.monthsTitle||"Months",B=this.picker.find(".datepicker-months").find(".datepicker-switch").text(this.o.maxViewMode<2?A:g).end().find("span").removeClass("active");if(a.each(this.dates,function(a,b){b.getUTCFullYear()===g&&B.eq(b.getUTCMonth()).addClass("active")}),(i>g||g>k)&&B.addClass("disabled"),g===i&&B.slice(0,j).addClass("disabled"),g===k&&B.slice(l+1).addClass("disabled"),this.o.beforeShowMonth!==a.noop){var C=this;a.each(B,function(c,d){var e=new Date(g,c,1),f=C.o.beforeShowMonth(e);f===b?f={}:"boolean"==typeof f?f={enabled:f}:"string"==typeof f&&(f={classes:f}),f.enabled!==!1||a(d).hasClass("disabled")||a(d).addClass("disabled"),f.classes&&a(d).addClass(f.classes),f.tooltip&&a(d).prop("title",f.tooltip)})}this._fill_yearsView(".datepicker-years","year",10,1,g,i,k,this.o.beforeShowYear),this._fill_yearsView(".datepicker-decades","decade",100,10,g,i,k,this.o.beforeShowDecade),this._fill_yearsView(".datepicker-centuries","century",1e3,100,g,i,k,this.o.beforeShowCentury)}},updateNavArrows:function(){if(this._allow_update){var a=new Date(this.viewDate),b=a.getUTCFullYear(),c=a.getUTCMonth();switch(this.viewMode){case 0:this.o.startDate!==-(1/0)&&b<=this.o.startDate.getUTCFullYear()&&c<=this.o.startDate.getUTCMonth()?this.picker.find(".prev").css({visibility:"hidden"}):this.picker.find(".prev").css({visibility:"visible"}),this.o.endDate!==1/0&&b>=this.o.endDate.getUTCFullYear()&&c>=this.o.endDate.getUTCMonth()?this.picker.find(".next").css({visibility:"hidden"}):this.picker.find(".next").css({visibility:"visible"});break;case 1:case 2:case 3:case 4:this.o.startDate!==-(1/0)&&b<=this.o.startDate.getUTCFullYear()||this.o.maxViewMode<2?this.picker.find(".prev").css({visibility:"hidden"}):this.picker.find(".prev").css({visibility:"visible"}),this.o.endDate!==1/0&&b>=this.o.endDate.getUTCFullYear()||this.o.maxViewMode<2?this.picker.find(".next").css({visibility:"hidden"}):this.picker.find(".next").css({visibility:"visible"})}}},click:function(b){b.preventDefault(),b.stopPropagation();var e,f,g,h,i,j,k;e=a(b.target),e.hasClass("datepicker-switch")&&this.showMode(1);var l=e.closest(".prev, .next");l.length>0&&(f=r.modes[this.viewMode].navStep*(l.hasClass("prev")?-1:1),0===this.viewMode?(this.viewDate=this.moveMonth(this.viewDate,f),this._trigger("changeMonth",this.viewDate)):(this.viewDate=this.moveYear(this.viewDate,f),1===this.viewMode&&this._trigger("changeYear",this.viewDate)),this.fill()),e.hasClass("today")&&!e.hasClass("day")&&(this.showMode(-2),this._setDate(d(),"linked"===this.o.todayBtn?null:"view")),e.hasClass("clear")&&this.clearDates(),e.hasClass("disabled")||(e.hasClass("day")&&(g=parseInt(e.text(),10)||1,h=this.viewDate.getUTCFullYear(),i=this.viewDate.getUTCMonth(),e.hasClass("old")&&(0===i?(i=11,h-=1,j=!0,k=!0):(i-=1,j=!0)),e.hasClass("new")&&(11===i?(i=0,h+=1,j=!0,k=!0):(i+=1,j=!0)),this._setDate(c(h,i,g)),k&&this._trigger("changeYear",this.viewDate),j&&this._trigger("changeMonth",this.viewDate)),e.hasClass("month")&&(this.viewDate.setUTCDate(1),g=1,i=e.parent().find("span").index(e),h=this.viewDate.getUTCFullYear(),this.viewDate.setUTCMonth(i),this._trigger("changeMonth",this.viewDate),1===this.o.minViewMode?(this._setDate(c(h,i,g)),this.showMode()):this.showMode(-1),this.fill()),(e.hasClass("year")||e.hasClass("decade")||e.hasClass("century"))&&(this.viewDate.setUTCDate(1),g=1,i=0,h=parseInt(e.text(),10)||0,this.viewDate.setUTCFullYear(h),e.hasClass("year")&&(this._trigger("changeYear",this.viewDate),2===this.o.minViewMode&&this._setDate(c(h,i,g))),e.hasClass("decade")&&(this._trigger("changeDecade",this.viewDate),3===this.o.minViewMode&&this._setDate(c(h,i,g))),e.hasClass("century")&&(this._trigger("changeCentury",this.viewDate),4===this.o.minViewMode&&this._setDate(c(h,i,g))),this.showMode(-1),this.fill())),this.picker.is(":visible")&&this._focused_from&&a(this._focused_from).focus(),delete this._focused_from},_toggle_multidate:function(a){var b=this.dates.contains(a);if(a||this.dates.clear(),-1!==b?(this.o.multidate===!0||this.o.multidate>1||this.o.toggleActive)&&this.dates.remove(b):this.o.multidate===!1?(this.dates.clear(),this.dates.push(a)):this.dates.push(a),"number"==typeof this.o.multidate)for(;this.dates.length>this.o.multidate;)this.dates.remove(0)},_setDate:function(a,b){b&&"date"!==b||this._toggle_multidate(a&&new Date(a)),b&&"view"!==b||(this.viewDate=a&&new Date(a)),this.fill(),this.setValue(),b&&"view"===b||this._trigger("changeDate"),this.inputField&&this.inputField.change(),!this.o.autoclose||b&&"date"!==b||this.hide()},moveDay:function(a,b){var c=new Date(a);return c.setUTCDate(a.getUTCDate()+b),c},moveWeek:function(a,b){return this.moveDay(a,7*b)},moveMonth:function(a,b){if(!g(a))return this.o.defaultViewDate;if(!b)return a;var c,d,e=new Date(a.valueOf()),f=e.getUTCDate(),h=e.getUTCMonth(),i=Math.abs(b);if(b=b>0?1:-1,1===i)d=-1===b?function(){return e.getUTCMonth()===h}:function(){return e.getUTCMonth()!==c},c=h+b,e.setUTCMonth(c),(0>c||c>11)&&(c=(c+12)%12);else{for(var j=0;i>j;j++)e=this.moveMonth(e,b);c=e.getUTCMonth(),e.setUTCDate(f),d=function(){return c!==e.getUTCMonth()}}for(;d();)e.setUTCDate(--f),e.setUTCMonth(c);return e},moveYear:function(a,b){return this.moveMonth(a,12*b)},moveAvailableDate:function(a,b,c){do{if(a=this[c](a,b),!this.dateWithinRange(a))return!1;c="moveDay"}while(this.dateIsDisabled(a));return a},weekOfDateIsDisabled:function(b){return-1!==a.inArray(b.getUTCDay(),this.o.daysOfWeekDisabled)},dateIsDisabled:function(b){return this.weekOfDateIsDisabled(b)||a.grep(this.o.datesDisabled,function(a){return e(b,a)}).length>0},dateWithinRange:function(a){return a>=this.o.startDate&&a<=this.o.endDate},keydown:function(a){if(!this.picker.is(":visible"))return void((40===a.keyCode||27===a.keyCode)&&(this.show(),a.stopPropagation()));var b,c,d=!1,e=this.focusDate||this.viewDate;switch(a.keyCode){case 27:this.focusDate?(this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.fill()):this.hide(),a.preventDefault(),a.stopPropagation();break;case 37:case 38:case 39:case 40:if(!this.o.keyboardNavigation||7===this.o.daysOfWeekDisabled.length)break;b=37===a.keyCode||38===a.keyCode?-1:1,0===this.viewMode?a.ctrlKey?(c=this.moveAvailableDate(e,b,"moveYear"),c&&this._trigger("changeYear",this.viewDate)):a.shiftKey?(c=this.moveAvailableDate(e,b,"moveMonth"),c&&this._trigger("changeMonth",this.viewDate)):37===a.keyCode||39===a.keyCode?c=this.moveAvailableDate(e,b,"moveDay"):this.weekOfDateIsDisabled(e)||(c=this.moveAvailableDate(e,b,"moveWeek")):1===this.viewMode?((38===a.keyCode||40===a.keyCode)&&(b=4*b),c=this.moveAvailableDate(e,b,"moveMonth")):2===this.viewMode&&((38===a.keyCode||40===a.keyCode)&&(b=4*b),c=this.moveAvailableDate(e,b,"moveYear")),c&&(this.focusDate=this.viewDate=c,this.setValue(),this.fill(),a.preventDefault());break;case 13:if(!this.o.forceParse)break;e=this.focusDate||this.dates.get(-1)||this.viewDate,this.o.keyboardNavigation&&(this._toggle_multidate(e),d=!0),this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.setValue(),this.fill(),this.picker.is(":visible")&&(a.preventDefault(),a.stopPropagation(),this.o.autoclose&&this.hide());break;case 9:this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.fill(),this.hide()}d&&(this.dates.length?this._trigger("changeDate"):this._trigger("clearDate"),this.inputField&&this.inputField.change())},showMode:function(a){a&&(this.viewMode=Math.max(this.o.minViewMode,Math.min(this.o.maxViewMode,this.viewMode+a))),this.picker.children("div").hide().filter(".datepicker-"+r.modes[this.viewMode].clsName).show(),this.updateNavArrows()}};var l=function(b,c){a(b).data("datepicker",this),this.element=a(b),this.inputs=a.map(c.inputs,function(a){return a.jquery?a[0]:a}),delete c.inputs,n.call(a(this.inputs),c).on("changeDate",a.proxy(this.dateUpdated,this)),this.pickers=a.map(this.inputs,function(b){return a(b).data("datepicker")}),this.updateDates()};l.prototype={updateDates:function(){this.dates=a.map(this.pickers,function(a){return a.getUTCDate()}),this.updateRanges()},updateRanges:function(){var b=a.map(this.dates,function(a){return a.valueOf()});a.each(this.pickers,function(a,c){c.setRange(b)})},dateUpdated:function(b){if(!this.updating){this.updating=!0;var c=a(b.target).data("datepicker");if("undefined"!=typeof c){var d=c.getUTCDate(),e=a.inArray(b.target,this.inputs),f=e-1,g=e+1,h=this.inputs.length;if(-1!==e){if(a.each(this.pickers,function(a,b){b.getUTCDate()||b.setUTCDate(d)}),d<this.dates[f])for(;f>=0&&d<this.dates[f];)this.pickers[f--].setUTCDate(d);else if(d>this.dates[g])for(;h>g&&d>this.dates[g];)this.pickers[g++].setUTCDate(d);this.updateDates(),delete this.updating}}}},remove:function(){a.map(this.pickers,function(a){a.remove()}),delete this.element.data().datepicker}};var m=a.fn.datepicker,n=function(c){var d=Array.apply(null,arguments);d.shift();var e;if(this.each(function(){var b=a(this),f=b.data("datepicker"),g="object"==typeof c&&c;if(!f){var j=h(this,"date"),m=a.extend({},o,j,g),n=i(m.language),p=a.extend({},o,n,j,g);b.hasClass("input-daterange")||p.inputs?(a.extend(p,{inputs:p.inputs||b.find("input").toArray()}),f=new l(this,p)):f=new k(this,p),b.data("datepicker",f)}"string"==typeof c&&"function"==typeof f[c]&&(e=f[c].apply(f,d))}),e===b||e instanceof k||e instanceof l)return this;if(this.length>1)throw new Error("Using only allowed for the collection of a single element ("+c+" function)");return e};a.fn.datepicker=n;var o=a.fn.datepicker.defaults={assumeNearbyYear:!1,autoclose:!1,beforeShowDay:a.noop,beforeShowMonth:a.noop,beforeShowYear:a.noop,beforeShowDecade:a.noop,beforeShowCentury:a.noop,calendarWeeks:!1,clearBtn:!1,toggleActive:!1,daysOfWeekDisabled:[],daysOfWeekHighlighted:[],datesDisabled:[],endDate:1/0,forceParse:!0,format:"mm/dd/yyyy",keyboardNavigation:!0,language:"en",minViewMode:0,maxViewMode:4,multidate:!1,multidateSeparator:",",orientation:"auto",rtl:!1,startDate:-(1/0),startView:0,todayBtn:!1,todayHighlight:!1,weekStart:0,disableTouchKeyboard:!1,enableOnReadonly:!0,showOnFocus:!0,zIndexOffset:10,container:"body",immediateUpdates:!1,title:"",templates:{leftArrow:"&laquo;",rightArrow:"&raquo;"}},p=a.fn.datepicker.locale_opts=["format","rtl","weekStart"];a.fn.datepicker.Constructor=k;var q=a.fn.datepicker.dates={en:{days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],daysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],daysMin:["Su","Mo","Tu","We","Th","Fr","Sa"],months:["January","February","March","April","May","June","July","August","September","October","November","December"],monthsShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],today:"Today",clear:"Clear",titleFormat:"MM yyyy"}},r={modes:[{clsName:"days",navFnc:"Month",navStep:1},{clsName:"months",navFnc:"FullYear",navStep:1},{clsName:"years",navFnc:"FullYear",navStep:10},{clsName:"decades",navFnc:"FullDecade",navStep:100},{clsName:"centuries",navFnc:"FullCentury",navStep:1e3}],isLeapYear:function(a){return a%4===0&&a%100!==0||a%400===0},getDaysInMonth:function(a,b){return[31,r.isLeapYear(a)?29:28,31,30,31,30,31,31,30,31,30,31][b]},validParts:/dd?|DD?|mm?|MM?|yy(?:yy)?/g,nonpunctuation:/[^ -\/:-@\u5e74\u6708\u65e5\[-`{-~\t\n\r]+/g,parseFormat:function(a){if("function"==typeof a.toValue&&"function"==typeof a.toDisplay)return a;var b=a.replace(this.validParts,"\x00").split("\x00"),c=a.match(this.validParts);if(!b||!b.length||!c||0===c.length)throw new Error("Invalid date format.");return{separators:b,parts:c}},parseDate:function(e,f,g,h){function i(a,b){return b===!0&&(b=10),100>a&&(a+=2e3,a>(new Date).getFullYear()+b&&(a-=100)),a}function j(){var a=this.slice(0,s[n].length),b=s[n].slice(0,a.length);return a.toLowerCase()===b.toLowerCase()}if(!e)return b;if(e instanceof Date)return e;if("string"==typeof f&&(f=r.parseFormat(f)),f.toValue)return f.toValue(e,f,g);var l,m,n,o,p=/([\-+]\d+)([dmwy])/,s=e.match(/([\-+]\d+)([dmwy])/g),t={d:"moveDay",m:"moveMonth",w:"moveWeek",y:"moveYear"},u={yesterday:"-1d",today:"+0d",tomorrow:"+1d"};if(/^[\-+]\d+[dmwy]([\s,]+[\-+]\d+[dmwy])*$/.test(e)){for(e=new Date,n=0;n<s.length;n++)l=p.exec(s[n]),m=parseInt(l[1]),o=t[l[2]],e=k.prototype[o](e,m);return c(e.getUTCFullYear(),e.getUTCMonth(),e.getUTCDate())}if("undefined"!=typeof u[e]&&(e=u[e],s=e.match(/([\-+]\d+)([dmwy])/g),/^[\-+]\d+[dmwy]([\s,]+[\-+]\d+[dmwy])*$/.test(e))){for(e=new Date,n=0;n<s.length;n++)l=p.exec(s[n]),m=parseInt(l[1]),o=t[l[2]],e=k.prototype[o](e,m);return c(e.getUTCFullYear(),e.getUTCMonth(),e.getUTCDate())}s=e&&e.match(this.nonpunctuation)||[],e=new Date;var v,w,x={},y=["yyyy","yy","M","MM","m","mm","d","dd"],z={yyyy:function(a,b){return a.setUTCFullYear(h?i(b,h):b)},yy:function(a,b){return a.setUTCFullYear(h?i(b,h):b)},m:function(a,b){if(isNaN(a))return a;for(b-=1;0>b;)b+=12;for(b%=12,a.setUTCMonth(b);a.getUTCMonth()!==b;)a.setUTCDate(a.getUTCDate()-1);return a},d:function(a,b){return a.setUTCDate(b)}};z.M=z.MM=z.mm=z.m,z.dd=z.d,e=d();var A=f.parts.slice();if(s.length!==A.length&&(A=a(A).filter(function(b,c){return-1!==a.inArray(c,y)}).toArray()),s.length===A.length){var B;for(n=0,B=A.length;B>n;n++){if(v=parseInt(s[n],10),l=A[n],isNaN(v))switch(l){case"MM":w=a(q[g].months).filter(j),v=a.inArray(w[0],q[g].months)+1;break;case"M":w=a(q[g].monthsShort).filter(j),v=a.inArray(w[0],q[g].monthsShort)+1}x[l]=v}var C,D;for(n=0;n<y.length;n++)D=y[n],D in x&&!isNaN(x[D])&&(C=new Date(e),z[D](C,x[D]),isNaN(C)||(e=C))}return e},formatDate:function(b,c,d){if(!b)return"";if("string"==typeof c&&(c=r.parseFormat(c)),
c.toDisplay)return c.toDisplay(b,c,d);var e={d:b.getUTCDate(),D:q[d].daysShort[b.getUTCDay()],DD:q[d].days[b.getUTCDay()],m:b.getUTCMonth()+1,M:q[d].monthsShort[b.getUTCMonth()],MM:q[d].months[b.getUTCMonth()],yy:b.getUTCFullYear().toString().substring(2),yyyy:b.getUTCFullYear()};e.dd=(e.d<10?"0":"")+e.d,e.mm=(e.m<10?"0":"")+e.m,b=[];for(var f=a.extend([],c.separators),g=0,h=c.parts.length;h>=g;g++)f.length&&b.push(f.shift()),b.push(e[c.parts[g]]);return b.join("")},headTemplate:'<thead><tr><th colspan="7" class="datepicker-title"></th></tr><tr><th class="prev">&laquo;</th><th colspan="5" class="datepicker-switch"></th><th class="next">&raquo;</th></tr></thead>',contTemplate:'<tbody><tr><td colspan="7"></td></tr></tbody>',footTemplate:'<tfoot><tr><th colspan="7" class="today"></th></tr><tr><th colspan="7" class="clear"></th></tr></tfoot>'};r.template='<div class="datepicker"><div class="datepicker-days"><table class="table-condensed">'+r.headTemplate+"<tbody></tbody>"+r.footTemplate+'</table></div><div class="datepicker-months"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-years"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-decades"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-centuries"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+"</table></div></div>",a.fn.datepicker.DPGlobal=r,a.fn.datepicker.noConflict=function(){return a.fn.datepicker=m,this},a.fn.datepicker.version="1.6.4",a(document).on("focus.datepicker.data-api click.datepicker.data-api",'[data-provide="datepicker"]',function(b){var c=a(this);c.data("datepicker")||(b.preventDefault(),n.call(c,"show"))}),a(function(){n.call(a('[data-provide="datepicker-inline"]'))})});
/*
 * jQuery Navgoco Menus Plugin v0.2.1 (2014-04-11)
 * https://github.com/tefra/navgoco
 *
 * Copyright (c) 2014 Chris T (@tefra)
 * BSD - https://github.com/tefra/navgoco/blob/master/LICENSE-BSD
 */
!function(a){"use strict";var b=function(b,c,d){return this.el=b,this.$el=a(b),this.options=c,this.uuid=this.$el.attr("id")?this.$el.attr("id"):d,this.state={},this.init(),this};b.prototype={init:function(){var b=this;b._load(),b.$el.find("ul").each(function(c){var d=a(this);d.attr("data-index",c),b.options.save&&b.state.hasOwnProperty(c)?(d.parent().addClass(b.options.openClass),d.show()):d.parent().hasClass(b.options.openClass)?(d.show(),b.state[c]=1):d.hide()});var c=a("<span></span>").prepend(b.options.caretHtml),d=b.$el.find("li > a");b._trigger(c,!1),b._trigger(d,!0),b.$el.find("li:has(ul) > a").prepend(c)},_trigger:function(b,c){var d=this;b.on("click",function(b){b.stopPropagation();var e=c?a(this).next():a(this).parent().next(),f=!1;if(c){var g=a(this).attr("href");f=void 0===g||""===g||"#"===g}if(e=e.length>0?e:!1,d.options.onClickBefore.call(this,b,e),!c||e&&f)b.preventDefault(),d._toggle(e,e.is(":hidden")),d._save();else if(d.options.accordion){var h=d.state=d._parents(a(this));d.$el.find("ul").filter(":visible").each(function(){var b=a(this),c=b.attr("data-index");h.hasOwnProperty(c)||d._toggle(b,!1)}),d._save()}d.options.onClickAfter.call(this,b,e)})},_toggle:function(b,c){var d=this,e=b.attr("data-index"),f=b.parent();if(d.options.onToggleBefore.call(this,b,c),c){if(f.addClass(d.options.openClass),b.slideDown(d.options.slide),d.state[e]=1,d.options.accordion){var g=d.state=d._parents(b);g[e]=d.state[e]=1,d.$el.find("ul").filter(":visible").each(function(){var b=a(this),c=b.attr("data-index");g.hasOwnProperty(c)||d._toggle(b,!1)})}}else f.removeClass(d.options.openClass),b.slideUp(d.options.slide),d.state[e]=0;d.options.onToggleAfter.call(this,b,c)},_parents:function(b,c){var d={},e=b.parent(),f=e.parents("ul");return f.each(function(){var b=a(this),e=b.attr("data-index");return e?void(d[e]=c?b:1):!1}),d},_save:function(){if(this.options.save){var b={};for(var d in this.state)1===this.state[d]&&(b[d]=1);c[this.uuid]=this.state=b,a.cookie(this.options.cookie.name,JSON.stringify(c),this.options.cookie)}},_load:function(){if(this.options.save){if(null===c){var b=a.cookie(this.options.cookie.name);c=b?JSON.parse(b):{}}this.state=c.hasOwnProperty(this.uuid)?c[this.uuid]:{}}},toggle:function(b){var c=this,d=arguments.length;if(1>=d)c.$el.find("ul").each(function(){var d=a(this);c._toggle(d,b)});else{var e,f={},g=Array.prototype.slice.call(arguments,1);d--;for(var h=0;d>h;h++){e=g[h];var i=c.$el.find('ul[data-index="'+e+'"]').first();if(i&&(f[e]=i,b)){var j=c._parents(i,!0);for(var k in j)f.hasOwnProperty(k)||(f[k]=j[k])}}for(e in f)c._toggle(f[e],b)}c._save()},destroy:function(){a.removeData(this.$el),this.$el.find("li:has(ul) > a").unbind("click"),this.$el.find("li:has(ul) > a > span").unbind("click")}},a.fn.navgoco=function(c){if("string"==typeof c&&"_"!==c.charAt(0)&&"init"!==c)var d=!0,e=Array.prototype.slice.call(arguments,1);else c=a.extend({},a.fn.navgoco.defaults,c||{}),a.cookie||(c.save=!1);return this.each(function(f){var g=a(this),h=g.data("navgoco");h||(h=new b(this,d?a.fn.navgoco.defaults:c,f),g.data("navgoco",h)),d&&h[c].apply(h,e)})};var c=null;a.fn.navgoco.defaults={caretHtml:"",accordion:!1,openClass:"open",save:!0,cookie:{name:"navgoco",expires:!1,path:"/"},slide:{duration:400,easing:"swing"},onClickBefore:a.noop,onClickAfter:a.noop,onToggleBefore:a.noop,onToggleAfter:a.noop}}(jQuery);
(function(){function require(name){var module=require.modules[name];if(!module)throw new Error('failed to require "'+name+'"');if(!("exports"in module)&&typeof module.definition==="function"){module.client=module.component=true;module.definition.call(this,module.exports={},module);delete module.definition}return module.exports}require.loader="component";require.helper={};require.helper.semVerSort=function(a,b){var aArray=a.version.split(".");var bArray=b.version.split(".");for(var i=0;i<aArray.length;++i){var aInt=parseInt(aArray[i],10);var bInt=parseInt(bArray[i],10);if(aInt===bInt){var aLex=aArray[i].substr((""+aInt).length);var bLex=bArray[i].substr((""+bInt).length);if(aLex===""&&bLex!=="")return 1;if(aLex!==""&&bLex==="")return-1;if(aLex!==""&&bLex!=="")return aLex>bLex?1:-1;continue}else if(aInt>bInt){return 1}else{return-1}}return 0};require.latest=function(name,returnPath){function showError(name){throw new Error('failed to find latest module of "'+name+'"')}var versionRegexp=/(.*)~(.*)@v?(\d+\.\d+\.\d+[^\/]*)$/;var remoteRegexp=/(.*)~(.*)/;if(!remoteRegexp.test(name))showError(name);var moduleNames=Object.keys(require.modules);var semVerCandidates=[];var otherCandidates=[];for(var i=0;i<moduleNames.length;i++){var moduleName=moduleNames[i];if(new RegExp(name+"@").test(moduleName)){var version=moduleName.substr(name.length+1);var semVerMatch=versionRegexp.exec(moduleName);if(semVerMatch!=null){semVerCandidates.push({version:version,name:moduleName})}else{otherCandidates.push({version:version,name:moduleName})}}}if(semVerCandidates.concat(otherCandidates).length===0){showError(name)}if(semVerCandidates.length>0){var module=semVerCandidates.sort(require.helper.semVerSort).pop().name;if(returnPath===true){return module}return require(module)}var module=otherCandidates.sort(function(a,b){return a.name>b.name})[0].name;if(returnPath===true){return module}return require(module)};require.modules={};require.register=function(name,definition){require.modules[name]={definition:definition}};require.define=function(name,exports){require.modules[name]={exports:exports}};require.register("abpetkov~transitionize@0.0.3",function(exports,module){module.exports=Transitionize;function Transitionize(element,props){if(!(this instanceof Transitionize))return new Transitionize(element,props);this.element=element;this.props=props||{};this.init()}Transitionize.prototype.isSafari=function(){return/Safari/.test(navigator.userAgent)&&/Apple Computer/.test(navigator.vendor)};Transitionize.prototype.init=function(){var transitions=[];for(var key in this.props){transitions.push(key+" "+this.props[key])}this.element.style.transition=transitions.join(", ");if(this.isSafari())this.element.style.webkitTransition=transitions.join(", ")}});require.register("ftlabs~fastclick@v0.6.11",function(exports,module){function FastClick(layer){"use strict";var oldOnClick,self=this;this.trackingClick=false;this.trackingClickStart=0;this.targetElement=null;this.touchStartX=0;this.touchStartY=0;this.lastTouchIdentifier=0;this.touchBoundary=10;this.layer=layer;if(!layer||!layer.nodeType){throw new TypeError("Layer must be a document node")}this.onClick=function(){return FastClick.prototype.onClick.apply(self,arguments)};this.onMouse=function(){return FastClick.prototype.onMouse.apply(self,arguments)};this.onTouchStart=function(){return FastClick.prototype.onTouchStart.apply(self,arguments)};this.onTouchMove=function(){return FastClick.prototype.onTouchMove.apply(self,arguments)};this.onTouchEnd=function(){return FastClick.prototype.onTouchEnd.apply(self,arguments)};this.onTouchCancel=function(){return FastClick.prototype.onTouchCancel.apply(self,arguments)};if(FastClick.notNeeded(layer)){return}if(this.deviceIsAndroid){layer.addEventListener("mouseover",this.onMouse,true);layer.addEventListener("mousedown",this.onMouse,true);layer.addEventListener("mouseup",this.onMouse,true)}layer.addEventListener("click",this.onClick,true);layer.addEventListener("touchstart",this.onTouchStart,false);layer.addEventListener("touchmove",this.onTouchMove,false);layer.addEventListener("touchend",this.onTouchEnd,false);layer.addEventListener("touchcancel",this.onTouchCancel,false);if(!Event.prototype.stopImmediatePropagation){layer.removeEventListener=function(type,callback,capture){var rmv=Node.prototype.removeEventListener;if(type==="click"){rmv.call(layer,type,callback.hijacked||callback,capture)}else{rmv.call(layer,type,callback,capture)}};layer.addEventListener=function(type,callback,capture){var adv=Node.prototype.addEventListener;if(type==="click"){adv.call(layer,type,callback.hijacked||(callback.hijacked=function(event){if(!event.propagationStopped){callback(event)}}),capture)}else{adv.call(layer,type,callback,capture)}}}if(typeof layer.onclick==="function"){oldOnClick=layer.onclick;layer.addEventListener("click",function(event){oldOnClick(event)},false);layer.onclick=null}}FastClick.prototype.deviceIsAndroid=navigator.userAgent.indexOf("Android")>0;FastClick.prototype.deviceIsIOS=/iP(ad|hone|od)/.test(navigator.userAgent);FastClick.prototype.deviceIsIOS4=FastClick.prototype.deviceIsIOS&&/OS 4_\d(_\d)?/.test(navigator.userAgent);FastClick.prototype.deviceIsIOSWithBadTarget=FastClick.prototype.deviceIsIOS&&/OS ([6-9]|\d{2})_\d/.test(navigator.userAgent);FastClick.prototype.needsClick=function(target){"use strict";switch(target.nodeName.toLowerCase()){case"button":case"select":case"textarea":if(target.disabled){return true}break;case"input":if(this.deviceIsIOS&&target.type==="file"||target.disabled){return true}break;case"label":case"video":return true}return/\bneedsclick\b/.test(target.className)};FastClick.prototype.needsFocus=function(target){"use strict";switch(target.nodeName.toLowerCase()){case"textarea":return true;case"select":return!this.deviceIsAndroid;case"input":switch(target.type){case"button":case"checkbox":case"file":case"image":case"radio":case"submit":return false}return!target.disabled&&!target.readOnly;default:return/\bneedsfocus\b/.test(target.className)}};FastClick.prototype.sendClick=function(targetElement,event){"use strict";var clickEvent,touch;if(document.activeElement&&document.activeElement!==targetElement){document.activeElement.blur()}touch=event.changedTouches[0];clickEvent=document.createEvent("MouseEvents");clickEvent.initMouseEvent(this.determineEventType(targetElement),true,true,window,1,touch.screenX,touch.screenY,touch.clientX,touch.clientY,false,false,false,false,0,null);clickEvent.forwardedTouchEvent=true;targetElement.dispatchEvent(clickEvent)};FastClick.prototype.determineEventType=function(targetElement){"use strict";if(this.deviceIsAndroid&&targetElement.tagName.toLowerCase()==="select"){return"mousedown"}return"click"};FastClick.prototype.focus=function(targetElement){"use strict";var length;if(this.deviceIsIOS&&targetElement.setSelectionRange&&targetElement.type.indexOf("date")!==0&&targetElement.type!=="time"){length=targetElement.value.length;targetElement.setSelectionRange(length,length)}else{targetElement.focus()}};FastClick.prototype.updateScrollParent=function(targetElement){"use strict";var scrollParent,parentElement;scrollParent=targetElement.fastClickScrollParent;if(!scrollParent||!scrollParent.contains(targetElement)){parentElement=targetElement;do{if(parentElement.scrollHeight>parentElement.offsetHeight){scrollParent=parentElement;targetElement.fastClickScrollParent=parentElement;break}parentElement=parentElement.parentElement}while(parentElement)}if(scrollParent){scrollParent.fastClickLastScrollTop=scrollParent.scrollTop}};FastClick.prototype.getTargetElementFromEventTarget=function(eventTarget){"use strict";if(eventTarget.nodeType===Node.TEXT_NODE){return eventTarget.parentNode}return eventTarget};FastClick.prototype.onTouchStart=function(event){"use strict";var targetElement,touch,selection;if(event.targetTouches.length>1){return true}targetElement=this.getTargetElementFromEventTarget(event.target);touch=event.targetTouches[0];if(this.deviceIsIOS){selection=window.getSelection();if(selection.rangeCount&&!selection.isCollapsed){return true}if(!this.deviceIsIOS4){if(touch.identifier===this.lastTouchIdentifier){event.preventDefault();return false}this.lastTouchIdentifier=touch.identifier;this.updateScrollParent(targetElement)}}this.trackingClick=true;this.trackingClickStart=event.timeStamp;this.targetElement=targetElement;this.touchStartX=touch.pageX;this.touchStartY=touch.pageY;if(event.timeStamp-this.lastClickTime<200){event.preventDefault()}return true};FastClick.prototype.touchHasMoved=function(event){"use strict";var touch=event.changedTouches[0],boundary=this.touchBoundary;if(Math.abs(touch.pageX-this.touchStartX)>boundary||Math.abs(touch.pageY-this.touchStartY)>boundary){return true}return false};FastClick.prototype.onTouchMove=function(event){"use strict";if(!this.trackingClick){return true}if(this.targetElement!==this.getTargetElementFromEventTarget(event.target)||this.touchHasMoved(event)){this.trackingClick=false;this.targetElement=null}return true};FastClick.prototype.findControl=function(labelElement){"use strict";if(labelElement.control!==undefined){return labelElement.control}if(labelElement.htmlFor){return document.getElementById(labelElement.htmlFor)}return labelElement.querySelector("button, input:not([type=hidden]), keygen, meter, output, progress, select, textarea")};FastClick.prototype.onTouchEnd=function(event){"use strict";var forElement,trackingClickStart,targetTagName,scrollParent,touch,targetElement=this.targetElement;if(!this.trackingClick){return true}if(event.timeStamp-this.lastClickTime<200){this.cancelNextClick=true;return true}this.cancelNextClick=false;this.lastClickTime=event.timeStamp;trackingClickStart=this.trackingClickStart;this.trackingClick=false;this.trackingClickStart=0;if(this.deviceIsIOSWithBadTarget){touch=event.changedTouches[0];targetElement=document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset)||targetElement;targetElement.fastClickScrollParent=this.targetElement.fastClickScrollParent}targetTagName=targetElement.tagName.toLowerCase();if(targetTagName==="label"){forElement=this.findControl(targetElement);if(forElement){this.focus(targetElement);if(this.deviceIsAndroid){return false}targetElement=forElement}}else if(this.needsFocus(targetElement)){if(event.timeStamp-trackingClickStart>100||this.deviceIsIOS&&window.top!==window&&targetTagName==="input"){this.targetElement=null;return false}this.focus(targetElement);if(!this.deviceIsIOS4||targetTagName!=="select"){this.targetElement=null;event.preventDefault()}return false}if(this.deviceIsIOS&&!this.deviceIsIOS4){scrollParent=targetElement.fastClickScrollParent;if(scrollParent&&scrollParent.fastClickLastScrollTop!==scrollParent.scrollTop){return true}}if(!this.needsClick(targetElement)){event.preventDefault();this.sendClick(targetElement,event)}return false};FastClick.prototype.onTouchCancel=function(){"use strict";this.trackingClick=false;this.targetElement=null};FastClick.prototype.onMouse=function(event){"use strict";if(!this.targetElement){return true}if(event.forwardedTouchEvent){return true}if(!event.cancelable){return true}if(!this.needsClick(this.targetElement)||this.cancelNextClick){if(event.stopImmediatePropagation){event.stopImmediatePropagation()}else{event.propagationStopped=true}event.stopPropagation();event.preventDefault();return false}return true};FastClick.prototype.onClick=function(event){"use strict";var permitted;if(this.trackingClick){this.targetElement=null;this.trackingClick=false;return true}if(event.target.type==="submit"&&event.detail===0){return true}permitted=this.onMouse(event);if(!permitted){this.targetElement=null}return permitted};FastClick.prototype.destroy=function(){"use strict";var layer=this.layer;if(this.deviceIsAndroid){layer.removeEventListener("mouseover",this.onMouse,true);layer.removeEventListener("mousedown",this.onMouse,true);layer.removeEventListener("mouseup",this.onMouse,true)}layer.removeEventListener("click",this.onClick,true);layer.removeEventListener("touchstart",this.onTouchStart,false);layer.removeEventListener("touchmove",this.onTouchMove,false);layer.removeEventListener("touchend",this.onTouchEnd,false);layer.removeEventListener("touchcancel",this.onTouchCancel,false)};FastClick.notNeeded=function(layer){"use strict";var metaViewport;var chromeVersion;if(typeof window.ontouchstart==="undefined"){return true}chromeVersion=+(/Chrome\/([0-9]+)/.exec(navigator.userAgent)||[,0])[1];if(chromeVersion){if(FastClick.prototype.deviceIsAndroid){metaViewport=document.querySelector("meta[name=viewport]");if(metaViewport){if(metaViewport.content.indexOf("user-scalable=no")!==-1){return true}if(chromeVersion>31&&window.innerWidth<=window.screen.width){return true}}}else{return true}}if(layer.style.msTouchAction==="none"){return true}return false};FastClick.attach=function(layer){"use strict";return new FastClick(layer)};if(typeof define!=="undefined"&&define.amd){define(function(){"use strict";return FastClick})}else if(typeof module!=="undefined"&&module.exports){module.exports=FastClick.attach;module.exports.FastClick=FastClick}else{window.FastClick=FastClick}});require.register("component~indexof@0.0.3",function(exports,module){module.exports=function(arr,obj){if(arr.indexOf)return arr.indexOf(obj);for(var i=0;i<arr.length;++i){if(arr[i]===obj)return i}return-1}});require.register("component~classes@1.2.1",function(exports,module){var index=require("component~indexof@0.0.3");var re=/\s+/;var toString=Object.prototype.toString;module.exports=function(el){return new ClassList(el)};function ClassList(el){if(!el)throw new Error("A DOM element reference is required");this.el=el;this.list=el.classList}ClassList.prototype.add=function(name){if(this.list){this.list.add(name);return this}var arr=this.array();var i=index(arr,name);if(!~i)arr.push(name);this.el.className=arr.join(" ");return this};ClassList.prototype.remove=function(name){if("[object RegExp]"==toString.call(name)){return this.removeMatching(name)}if(this.list){this.list.remove(name);return this}var arr=this.array();var i=index(arr,name);if(~i)arr.splice(i,1);this.el.className=arr.join(" ");return this};ClassList.prototype.removeMatching=function(re){var arr=this.array();for(var i=0;i<arr.length;i++){if(re.test(arr[i])){this.remove(arr[i])}}return this};ClassList.prototype.toggle=function(name,force){if(this.list){if("undefined"!==typeof force){if(force!==this.list.toggle(name,force)){this.list.toggle(name)}}else{this.list.toggle(name)}return this}if("undefined"!==typeof force){if(!force){this.remove(name)}else{this.add(name)}}else{if(this.has(name)){this.remove(name)}else{this.add(name)}}return this};ClassList.prototype.array=function(){var str=this.el.className.replace(/^\s+|\s+$/g,"");var arr=str.split(re);if(""===arr[0])arr.shift();return arr};ClassList.prototype.has=ClassList.prototype.contains=function(name){return this.list?this.list.contains(name):!!~index(this.array(),name)}});require.register("component~event@0.1.4",function(exports,module){var bind=window.addEventListener?"addEventListener":"attachEvent",unbind=window.removeEventListener?"removeEventListener":"detachEvent",prefix=bind!=="addEventListener"?"on":"";exports.bind=function(el,type,fn,capture){el[bind](prefix+type,fn,capture||false);return fn};exports.unbind=function(el,type,fn,capture){el[unbind](prefix+type,fn,capture||false);return fn}});require.register("component~query@0.0.3",function(exports,module){function one(selector,el){return el.querySelector(selector)}exports=module.exports=function(selector,el){el=el||document;return one(selector,el)};exports.all=function(selector,el){el=el||document;return el.querySelectorAll(selector)};exports.engine=function(obj){if(!obj.one)throw new Error(".one callback required");if(!obj.all)throw new Error(".all callback required");one=obj.one;exports.all=obj.all;return exports}});require.register("component~matches-selector@0.1.5",function(exports,module){var query=require("component~query@0.0.3");var proto=Element.prototype;var vendor=proto.matches||proto.webkitMatchesSelector||proto.mozMatchesSelector||proto.msMatchesSelector||proto.oMatchesSelector;module.exports=match;function match(el,selector){if(!el||el.nodeType!==1)return false;if(vendor)return vendor.call(el,selector);var nodes=query.all(selector,el.parentNode);for(var i=0;i<nodes.length;++i){if(nodes[i]==el)return true}return false}});require.register("component~closest@0.1.4",function(exports,module){var matches=require("component~matches-selector@0.1.5");module.exports=function(element,selector,checkYoSelf,root){element=checkYoSelf?{parentNode:element}:element;root=root||document;while((element=element.parentNode)&&element!==document){if(matches(element,selector))return element;if(element===root)return}}});require.register("component~delegate@0.2.3",function(exports,module){var closest=require("component~closest@0.1.4"),event=require("component~event@0.1.4");exports.bind=function(el,selector,type,fn,capture){return event.bind(el,type,function(e){var target=e.target||e.srcElement;e.delegateTarget=closest(target,selector,true,el);if(e.delegateTarget)fn.call(el,e)},capture)};exports.unbind=function(el,type,fn,capture){event.unbind(el,type,fn,capture)}});require.register("component~events@1.0.9",function(exports,module){var events=require("component~event@0.1.4");var delegate=require("component~delegate@0.2.3");module.exports=Events;function Events(el,obj){if(!(this instanceof Events))return new Events(el,obj);if(!el)throw new Error("element required");if(!obj)throw new Error("object required");this.el=el;this.obj=obj;this._events={}}Events.prototype.sub=function(event,method,cb){this._events[event]=this._events[event]||{};this._events[event][method]=cb};Events.prototype.bind=function(event,method){var e=parse(event);var el=this.el;var obj=this.obj;var name=e.name;var method=method||"on"+name;var args=[].slice.call(arguments,2);function cb(){var a=[].slice.call(arguments).concat(args);obj[method].apply(obj,a)}if(e.selector){cb=delegate.bind(el,e.selector,name,cb)}else{events.bind(el,name,cb)}this.sub(name,method,cb);return cb};Events.prototype.unbind=function(event,method){if(0==arguments.length)return this.unbindAll();if(1==arguments.length)return this.unbindAllOf(event);var bindings=this._events[event];if(!bindings)return;var cb=bindings[method];if(!cb)return;events.unbind(this.el,event,cb)};Events.prototype.unbindAll=function(){for(var event in this._events){this.unbindAllOf(event)}};Events.prototype.unbindAllOf=function(event){var bindings=this._events[event];if(!bindings)return;for(var method in bindings){this.unbind(event,method)}};function parse(event){var parts=event.split(/ +/);return{name:parts.shift(),selector:parts.join(" ")}}});require.register("switchery",function(exports,module){var transitionize=require("abpetkov~transitionize@0.0.3"),fastclick=require("ftlabs~fastclick@v0.6.11"),classes=require("component~classes@1.2.1"),events=require("component~events@1.0.9");module.exports=Switchery;var defaults={color:"#64bd63",secondaryColor:"#dfdfdf",jackColor:"#fff",jackSecondaryColor:null,className:"switchery",disabled:false,disabledOpacity:.5,speed:"0.4s",size:"default"};function Switchery(element,options){if(!(this instanceof Switchery))return new Switchery(element,options);this.element=element;this.options=options||{};for(var i in defaults){if(this.options[i]==null){this.options[i]=defaults[i]}}if(this.element!=null&&this.element.type=="checkbox")this.init();if(this.isDisabled()===true)this.disable()}Switchery.prototype.hide=function(){this.element.style.display="none"};Switchery.prototype.show=function(){var switcher=this.create();this.insertAfter(this.element,switcher)};Switchery.prototype.create=function(){this.switcher=document.createElement("span");this.jack=document.createElement("small");this.switcher.appendChild(this.jack);this.switcher.className=this.options.className;this.events=events(this.switcher,this);return this.switcher};Switchery.prototype.insertAfter=function(reference,target){reference.parentNode.insertBefore(target,reference.nextSibling)};Switchery.prototype.setPosition=function(clicked){var checked=this.isChecked(),switcher=this.switcher,jack=this.jack;if(clicked&&checked)checked=false;else if(clicked&&!checked)checked=true;if(checked===true){this.element.checked=true;if(window.getComputedStyle)jack.style.left=parseInt(window.getComputedStyle(switcher).width)-parseInt(window.getComputedStyle(jack).width)+"px";else jack.style.left=parseInt(switcher.currentStyle["width"])-parseInt(jack.currentStyle["width"])+"px";if(this.options.color)this.colorize();this.setSpeed()}else{jack.style.left=0;this.element.checked=false;this.switcher.style.boxShadow="inset 0 0 0 0 "+this.options.secondaryColor;this.switcher.style.borderColor=this.options.secondaryColor;this.switcher.style.backgroundColor=this.options.secondaryColor!==defaults.secondaryColor?this.options.secondaryColor:"#fff";this.jack.style.backgroundColor=this.options.jackSecondaryColor!==this.options.jackColor?this.options.jackSecondaryColor:this.options.jackColor;this.setSpeed()}};Switchery.prototype.setSpeed=function(){var switcherProp={},jackProp={"background-color":this.options.speed,left:this.options.speed.replace(/[a-z]/,"")/2+"s"};if(this.isChecked()){switcherProp={border:this.options.speed,"box-shadow":this.options.speed,"background-color":this.options.speed.replace(/[a-z]/,"")*3+"s"}}else{switcherProp={border:this.options.speed,"box-shadow":this.options.speed}}transitionize(this.switcher,switcherProp);transitionize(this.jack,jackProp)};Switchery.prototype.setSize=function(){var small="switchery-small",normal="switchery-default",large="switchery-large";switch(this.options.size){case"small":classes(this.switcher).add(small);break;case"large":classes(this.switcher).add(large);break;default:classes(this.switcher).add(normal);break}};Switchery.prototype.colorize=function(){var switcherHeight=this.switcher.offsetHeight/2;this.switcher.style.backgroundColor=this.options.color;this.switcher.style.borderColor=this.options.color;this.switcher.style.boxShadow="inset 0 0 0 "+switcherHeight+"px "+this.options.color;this.jack.style.backgroundColor=this.options.jackColor};Switchery.prototype.handleOnchange=function(state){if(document.dispatchEvent){var event=document.createEvent("HTMLEvents");event.initEvent("change",true,true);this.element.dispatchEvent(event)}else{this.element.fireEvent("onchange")}};Switchery.prototype.handleChange=function(){var self=this,el=this.element;if(el.addEventListener){el.addEventListener("change",function(){self.setPosition()})}else{el.attachEvent("onchange",function(){self.setPosition()})}};Switchery.prototype.handleClick=function(){var switcher=this.switcher;fastclick(switcher);this.events.bind("click","bindClick")};Switchery.prototype.bindClick=function(){var parent=this.element.parentNode.tagName.toLowerCase(),labelParent=parent==="label"?false:true;this.setPosition(labelParent);this.handleOnchange(this.element.checked)};Switchery.prototype.markAsSwitched=function(){this.element.setAttribute("data-switchery",true)};Switchery.prototype.markedAsSwitched=function(){return this.element.getAttribute("data-switchery")};Switchery.prototype.init=function(){this.hide();this.show();this.setSize();this.setPosition();this.markAsSwitched();this.handleChange();this.handleClick()};Switchery.prototype.isChecked=function(){return this.element.checked};Switchery.prototype.isDisabled=function(){return this.options.disabled||this.element.disabled||this.element.readOnly};Switchery.prototype.destroy=function(){this.events.unbind()};Switchery.prototype.enable=function(){if(!this.options.disabled)return;if(this.options.disabled)this.options.disabled=false;if(this.element.disabled)this.element.disabled=false;if(this.element.readOnly)this.element.readOnly=false;this.switcher.style.opacity=1;this.events.bind("click","bindClick")};Switchery.prototype.disable=function(){if(this.options.disabled)return;if(!this.options.disabled)this.options.disabled=true;if(!this.element.disabled)this.element.disabled=true;if(!this.element.readOnly)this.element.readOnly=true;this.switcher.style.opacity=this.options.disabledOpacity;this.destroy()}});if(typeof exports=="object"){module.exports=require("switchery")}else if(typeof define=="function"&&define.amd){define("Switchery",[],function(){return require("switchery")})}else{(this||window)["Switchery"]=require("switchery")}})();
// ┌───────────────────────────────────────────────────────────────────────────────────────────────────────┐ \\
// │ Raphaël 2.2.0 - JavaScript Vector Library                                                             │ \\
// ├───────────────────────────────────────────────────────────────────────────────────────────────────────┤ \\
// │ Copyright © 2008-2016 Dmitry Baranovskiy (http://raphaeljs.com)                                       │ \\
// │ Copyright © 2008-2016 Sencha Labs (http://sencha.com)                                                 │ \\
// ├───────────────────────────────────────────────────────────────────────────────────────────────────────┤ \\
// │ Licensed under the MIT (https://github.com/DmitryBaranovskiy/raphael/blob/master/license.txt) license.│ \\
// └───────────────────────────────────────────────────────────────────────────────────────────────────────┘ \\

(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["Raphael"] = factory();
	else
		root["Raphael"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;!(__WEBPACK_AMD_DEFINE_ARRAY__ = [__webpack_require__(1), __webpack_require__(3), __webpack_require__(4)], __WEBPACK_AMD_DEFINE_RESULT__ = function(R) {

	    return R;

	}.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;!(__WEBPACK_AMD_DEFINE_ARRAY__ = [__webpack_require__(2)], __WEBPACK_AMD_DEFINE_RESULT__ = function(eve) {

	    /*\
	     * Raphael
	     [ method ]
	     **
	     * Creates a canvas object on which to draw.
	     * You must do this first, as all future calls to drawing methods
	     * from this instance will be bound to this canvas.
	     > Parameters
	     **
	     - container (HTMLElement|string) DOM element or its ID which is going to be a parent for drawing surface
	     - width (number)
	     - height (number)
	     - callback (function) #optional callback function which is going to be executed in the context of newly created paper
	     * or
	     - x (number)
	     - y (number)
	     - width (number)
	     - height (number)
	     - callback (function) #optional callback function which is going to be executed in the context of newly created paper
	     * or
	     - all (array) (first 3 or 4 elements in the array are equal to [containerID, width, height] or [x, y, width, height]. The rest are element descriptions in format {type: type, <attributes>}). See @Paper.add.
	     - callback (function) #optional callback function which is going to be executed in the context of newly created paper
	     * or
	     - onReadyCallback (function) function that is going to be called on DOM ready event. You can also subscribe to this event via Eve’s “DOMLoad” event. In this case method returns `undefined`.
	     = (object) @Paper
	     > Usage
	     | // Each of the following examples create a canvas
	     | // that is 320px wide by 200px high.
	     | // Canvas is created at the viewport’s 10,50 coordinate.
	     | var paper = Raphael(10, 50, 320, 200);
	     | // Canvas is created at the top left corner of the #notepad element
	     | // (or its top right corner in dir="rtl" elements)
	     | var paper = Raphael(document.getElementById("notepad"), 320, 200);
	     | // Same as above
	     | var paper = Raphael("notepad", 320, 200);
	     | // Image dump
	     | var set = Raphael(["notepad", 320, 200, {
	     |     type: "rect",
	     |     x: 10,
	     |     y: 10,
	     |     width: 25,
	     |     height: 25,
	     |     stroke: "#f00"
	     | }, {
	     |     type: "text",
	     |     x: 30,
	     |     y: 40,
	     |     text: "Dump"
	     | }]);
	    \*/
	    function R(first) {
	        if (R.is(first, "function")) {
	            return loaded ? first() : eve.on("raphael.DOMload", first);
	        } else if (R.is(first, array)) {
	            return R._engine.create[apply](R, first.splice(0, 3 + R.is(first[0], nu))).add(first);
	        } else {
	            var args = Array.prototype.slice.call(arguments, 0);
	            if (R.is(args[args.length - 1], "function")) {
	                var f = args.pop();
	                return loaded ? f.call(R._engine.create[apply](R, args)) : eve.on("raphael.DOMload", function () {
	                    f.call(R._engine.create[apply](R, args));
	                });
	            } else {
	                return R._engine.create[apply](R, arguments);
	            }
	        }
	    }
	    R.version = "2.2.0";
	    R.eve = eve;
	    var loaded,
	        separator = /[, ]+/,
	        elements = {circle: 1, rect: 1, path: 1, ellipse: 1, text: 1, image: 1},
	        formatrg = /\{(\d+)\}/g,
	        proto = "prototype",
	        has = "hasOwnProperty",
	        g = {
	            doc: document,
	            win: window
	        },
	        oldRaphael = {
	            was: Object.prototype[has].call(g.win, "Raphael"),
	            is: g.win.Raphael
	        },
	        Paper = function () {
	            /*\
	             * Paper.ca
	             [ property (object) ]
	             **
	             * Shortcut for @Paper.customAttributes
	            \*/
	            /*\
	             * Paper.customAttributes
	             [ property (object) ]
	             **
	             * If you have a set of attributes that you would like to represent
	             * as a function of some number you can do it easily with custom attributes:
	             > Usage
	             | paper.customAttributes.hue = function (num) {
	             |     num = num % 1;
	             |     return {fill: "hsb(" + num + ", 0.75, 1)"};
	             | };
	             | // Custom attribute “hue” will change fill
	             | // to be given hue with fixed saturation and brightness.
	             | // Now you can use it like this:
	             | var c = paper.circle(10, 10, 10).attr({hue: .45});
	             | // or even like this:
	             | c.animate({hue: 1}, 1e3);
	             |
	             | // You could also create custom attribute
	             | // with multiple parameters:
	             | paper.customAttributes.hsb = function (h, s, b) {
	             |     return {fill: "hsb(" + [h, s, b].join(",") + ")"};
	             | };
	             | c.attr({hsb: "0.5 .8 1"});
	             | c.animate({hsb: [1, 0, 0.5]}, 1e3);
	            \*/
	            this.ca = this.customAttributes = {};
	        },
	        paperproto,
	        appendChild = "appendChild",
	        apply = "apply",
	        concat = "concat",
	        supportsTouch = ('ontouchstart' in g.win) || g.win.DocumentTouch && g.doc instanceof DocumentTouch, //taken from Modernizr touch test
	        E = "",
	        S = " ",
	        Str = String,
	        split = "split",
	        events = "click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel"[split](S),
	        touchMap = {
	            mousedown: "touchstart",
	            mousemove: "touchmove",
	            mouseup: "touchend"
	        },
	        lowerCase = Str.prototype.toLowerCase,
	        math = Math,
	        mmax = math.max,
	        mmin = math.min,
	        abs = math.abs,
	        pow = math.pow,
	        PI = math.PI,
	        nu = "number",
	        string = "string",
	        array = "array",
	        toString = "toString",
	        fillString = "fill",
	        objectToString = Object.prototype.toString,
	        paper = {},
	        push = "push",
	        ISURL = R._ISURL = /^url\(['"]?(.+?)['"]?\)$/i,
	        colourRegExp = /^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\))\s*$/i,
	        isnan = {"NaN": 1, "Infinity": 1, "-Infinity": 1},
	        bezierrg = /^(?:cubic-)?bezier\(([^,]+),([^,]+),([^,]+),([^\)]+)\)/,
	        round = math.round,
	        setAttribute = "setAttribute",
	        toFloat = parseFloat,
	        toInt = parseInt,
	        upperCase = Str.prototype.toUpperCase,
	        availableAttrs = R._availableAttrs = {
	            "arrow-end": "none",
	            "arrow-start": "none",
	            blur: 0,
	            "clip-rect": "0 0 1e9 1e9",
	            cursor: "default",
	            cx: 0,
	            cy: 0,
	            fill: "#fff",
	            "fill-opacity": 1,
	            font: '10px "Arial"',
	            "font-family": '"Arial"',
	            "font-size": "10",
	            "font-style": "normal",
	            "font-weight": 400,
	            gradient: 0,
	            height: 0,
	            href: "http://raphaeljs.com/",
	            "letter-spacing": 0,
	            opacity: 1,
	            path: "M0,0",
	            r: 0,
	            rx: 0,
	            ry: 0,
	            src: "",
	            stroke: "#000",
	            "stroke-dasharray": "",
	            "stroke-linecap": "butt",
	            "stroke-linejoin": "butt",
	            "stroke-miterlimit": 0,
	            "stroke-opacity": 1,
	            "stroke-width": 1,
	            target: "_blank",
	            "text-anchor": "middle",
	            title: "Raphael",
	            transform: "",
	            width: 0,
	            x: 0,
	            y: 0,
	            "class": ""
	        },
	        availableAnimAttrs = R._availableAnimAttrs = {
	            blur: nu,
	            "clip-rect": "csv",
	            cx: nu,
	            cy: nu,
	            fill: "colour",
	            "fill-opacity": nu,
	            "font-size": nu,
	            height: nu,
	            opacity: nu,
	            path: "path",
	            r: nu,
	            rx: nu,
	            ry: nu,
	            stroke: "colour",
	            "stroke-opacity": nu,
	            "stroke-width": nu,
	            transform: "transform",
	            width: nu,
	            x: nu,
	            y: nu
	        },
	        whitespace = /[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]/g,
	        commaSpaces = /[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/,
	        hsrg = {hs: 1, rg: 1},
	        p2s = /,?([achlmqrstvxz]),?/gi,
	        pathCommand = /([achlmrqstvz])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/ig,
	        tCommand = /([rstm])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/ig,
	        pathValues = /(-?\d*\.?\d*(?:e[\-+]?\d+)?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/ig,
	        radial_gradient = R._radial_gradient = /^r(?:\(([^,]+?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*([^\)]+?)\))?/,
	        eldata = {},
	        sortByKey = function (a, b) {
	            return a.key - b.key;
	        },
	        sortByNumber = function (a, b) {
	            return toFloat(a) - toFloat(b);
	        },
	        fun = function () {},
	        pipe = function (x) {
	            return x;
	        },
	        rectPath = R._rectPath = function (x, y, w, h, r) {
	            if (r) {
	                return [["M", x + r, y], ["l", w - r * 2, 0], ["a", r, r, 0, 0, 1, r, r], ["l", 0, h - r * 2], ["a", r, r, 0, 0, 1, -r, r], ["l", r * 2 - w, 0], ["a", r, r, 0, 0, 1, -r, -r], ["l", 0, r * 2 - h], ["a", r, r, 0, 0, 1, r, -r], ["z"]];
	            }
	            return [["M", x, y], ["l", w, 0], ["l", 0, h], ["l", -w, 0], ["z"]];
	        },
	        ellipsePath = function (x, y, rx, ry) {
	            if (ry == null) {
	                ry = rx;
	            }
	            return [["M", x, y], ["m", 0, -ry], ["a", rx, ry, 0, 1, 1, 0, 2 * ry], ["a", rx, ry, 0, 1, 1, 0, -2 * ry], ["z"]];
	        },
	        getPath = R._getPath = {
	            path: function (el) {
	                return el.attr("path");
	            },
	            circle: function (el) {
	                var a = el.attrs;
	                return ellipsePath(a.cx, a.cy, a.r);
	            },
	            ellipse: function (el) {
	                var a = el.attrs;
	                return ellipsePath(a.cx, a.cy, a.rx, a.ry);
	            },
	            rect: function (el) {
	                var a = el.attrs;
	                return rectPath(a.x, a.y, a.width, a.height, a.r);
	            },
	            image: function (el) {
	                var a = el.attrs;
	                return rectPath(a.x, a.y, a.width, a.height);
	            },
	            text: function (el) {
	                var bbox = el._getBBox();
	                return rectPath(bbox.x, bbox.y, bbox.width, bbox.height);
	            },
	            set : function(el) {
	                var bbox = el._getBBox();
	                return rectPath(bbox.x, bbox.y, bbox.width, bbox.height);
	            }
	        },
	        /*\
	         * Raphael.mapPath
	         [ method ]
	         **
	         * Transform the path string with given matrix.
	         > Parameters
	         - path (string) path string
	         - matrix (object) see @Matrix
	         = (string) transformed path string
	        \*/
	        mapPath = R.mapPath = function (path, matrix) {
	            if (!matrix) {
	                return path;
	            }
	            var x, y, i, j, ii, jj, pathi;
	            path = path2curve(path);
	            for (i = 0, ii = path.length; i < ii; i++) {
	                pathi = path[i];
	                for (j = 1, jj = pathi.length; j < jj; j += 2) {
	                    x = matrix.x(pathi[j], pathi[j + 1]);
	                    y = matrix.y(pathi[j], pathi[j + 1]);
	                    pathi[j] = x;
	                    pathi[j + 1] = y;
	                }
	            }
	            return path;
	        };

	    R._g = g;
	    /*\
	     * Raphael.type
	     [ property (string) ]
	     **
	     * Can be “SVG”, “VML” or empty, depending on browser support.
	    \*/
	    R.type = (g.win.SVGAngle || g.doc.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1") ? "SVG" : "VML");
	    if (R.type == "VML") {
	        var d = g.doc.createElement("div"),
	            b;
	        d.innerHTML = '<v:shape adj="1"/>';
	        b = d.firstChild;
	        b.style.behavior = "url(#default#VML)";
	        if (!(b && typeof b.adj == "object")) {
	            return (R.type = E);
	        }
	        d = null;
	    }
	    /*\
	     * Raphael.svg
	     [ property (boolean) ]
	     **
	     * `true` if browser supports SVG.
	    \*/
	    /*\
	     * Raphael.vml
	     [ property (boolean) ]
	     **
	     * `true` if browser supports VML.
	    \*/
	    R.svg = !(R.vml = R.type == "VML");
	    R._Paper = Paper;
	    /*\
	     * Raphael.fn
	     [ property (object) ]
	     **
	     * You can add your own method to the canvas. For example if you want to draw a pie chart,
	     * you can create your own pie chart function and ship it as a Raphaël plugin. To do this
	     * you need to extend the `Raphael.fn` object. You should modify the `fn` object before a
	     * Raphaël instance is created, otherwise it will take no effect. Please note that the
	     * ability for namespaced plugins was removed in Raphael 2.0. It is up to the plugin to
	     * ensure any namespacing ensures proper context.
	     > Usage
	     | Raphael.fn.arrow = function (x1, y1, x2, y2, size) {
	     |     return this.path( ... );
	     | };
	     | // or create namespace
	     | Raphael.fn.mystuff = {
	     |     arrow: function () {…},
	     |     star: function () {…},
	     |     // etc…
	     | };
	     | var paper = Raphael(10, 10, 630, 480);
	     | // then use it
	     | paper.arrow(10, 10, 30, 30, 5).attr({fill: "#f00"});
	     | paper.mystuff.arrow();
	     | paper.mystuff.star();
	    \*/
	    R.fn = paperproto = Paper.prototype = R.prototype;
	    R._id = 0;
	    /*\
	     * Raphael.is
	     [ method ]
	     **
	     * Handful of replacements for `typeof` operator.
	     > Parameters
	     - o (…) any object or primitive
	     - type (string) name of the type, i.e. “string”, “function”, “number”, etc.
	     = (boolean) is given value is of given type
	    \*/
	    R.is = function (o, type) {
	        type = lowerCase.call(type);
	        if (type == "finite") {
	            return !isnan[has](+o);
	        }
	        if (type == "array") {
	            return o instanceof Array;
	        }
	        return  (type == "null" && o === null) ||
	                (type == typeof o && o !== null) ||
	                (type == "object" && o === Object(o)) ||
	                (type == "array" && Array.isArray && Array.isArray(o)) ||
	                objectToString.call(o).slice(8, -1).toLowerCase() == type;
	    };

	    function clone(obj) {
	        if (typeof obj == "function" || Object(obj) !== obj) {
	            return obj;
	        }
	        var res = new obj.constructor;
	        for (var key in obj) if (obj[has](key)) {
	            res[key] = clone(obj[key]);
	        }
	        return res;
	    }

	    /*\
	     * Raphael.angle
	     [ method ]
	     **
	     * Returns angle between two or three points
	     > Parameters
	     - x1 (number) x coord of first point
	     - y1 (number) y coord of first point
	     - x2 (number) x coord of second point
	     - y2 (number) y coord of second point
	     - x3 (number) #optional x coord of third point
	     - y3 (number) #optional y coord of third point
	     = (number) angle in degrees.
	    \*/
	    R.angle = function (x1, y1, x2, y2, x3, y3) {
	        if (x3 == null) {
	            var x = x1 - x2,
	                y = y1 - y2;
	            if (!x && !y) {
	                return 0;
	            }
	            return (180 + math.atan2(-y, -x) * 180 / PI + 360) % 360;
	        } else {
	            return R.angle(x1, y1, x3, y3) - R.angle(x2, y2, x3, y3);
	        }
	    };
	    /*\
	     * Raphael.rad
	     [ method ]
	     **
	     * Transform angle to radians
	     > Parameters
	     - deg (number) angle in degrees
	     = (number) angle in radians.
	    \*/
	    R.rad = function (deg) {
	        return deg % 360 * PI / 180;
	    };
	    /*\
	     * Raphael.deg
	     [ method ]
	     **
	     * Transform angle to degrees
	     > Parameters
	     - rad (number) angle in radians
	     = (number) angle in degrees.
	    \*/
	    R.deg = function (rad) {
	        return Math.round ((rad * 180 / PI% 360)* 1000) / 1000;
	    };
	    /*\
	     * Raphael.snapTo
	     [ method ]
	     **
	     * Snaps given value to given grid.
	     > Parameters
	     - values (array|number) given array of values or step of the grid
	     - value (number) value to adjust
	     - tolerance (number) #optional tolerance for snapping. Default is `10`.
	     = (number) adjusted value.
	    \*/
	    R.snapTo = function (values, value, tolerance) {
	        tolerance = R.is(tolerance, "finite") ? tolerance : 10;
	        if (R.is(values, array)) {
	            var i = values.length;
	            while (i--) if (abs(values[i] - value) <= tolerance) {
	                return values[i];
	            }
	        } else {
	            values = +values;
	            var rem = value % values;
	            if (rem < tolerance) {
	                return value - rem;
	            }
	            if (rem > values - tolerance) {
	                return value - rem + values;
	            }
	        }
	        return value;
	    };

	    /*\
	     * Raphael.createUUID
	     [ method ]
	     **
	     * Returns RFC4122, version 4 ID
	    \*/
	    var createUUID = R.createUUID = (function (uuidRegEx, uuidReplacer) {
	        return function () {
	            return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(uuidRegEx, uuidReplacer).toUpperCase();
	        };
	    })(/[xy]/g, function (c) {
	        var r = math.random() * 16 | 0,
	            v = c == "x" ? r : (r & 3 | 8);
	        return v.toString(16);
	    });

	    /*\
	     * Raphael.setWindow
	     [ method ]
	     **
	     * Used when you need to draw in `&lt;iframe>`. Switched window to the iframe one.
	     > Parameters
	     - newwin (window) new window object
	    \*/
	    R.setWindow = function (newwin) {
	        eve("raphael.setWindow", R, g.win, newwin);
	        g.win = newwin;
	        g.doc = g.win.document;
	        if (R._engine.initWin) {
	            R._engine.initWin(g.win);
	        }
	    };
	    var toHex = function (color) {
	        if (R.vml) {
	            // http://dean.edwards.name/weblog/2009/10/convert-any-colour-value-to-hex-in-msie/
	            var trim = /^\s+|\s+$/g;
	            var bod;
	            try {
	                var docum = new ActiveXObject("htmlfile");
	                docum.write("<body>");
	                docum.close();
	                bod = docum.body;
	            } catch(e) {
	                bod = createPopup().document.body;
	            }
	            var range = bod.createTextRange();
	            toHex = cacher(function (color) {
	                try {
	                    bod.style.color = Str(color).replace(trim, E);
	                    var value = range.queryCommandValue("ForeColor");
	                    value = ((value & 255) << 16) | (value & 65280) | ((value & 16711680) >>> 16);
	                    return "#" + ("000000" + value.toString(16)).slice(-6);
	                } catch(e) {
	                    return "none";
	                }
	            });
	        } else {
	            var i = g.doc.createElement("i");
	            i.title = "Rapha\xebl Colour Picker";
	            i.style.display = "none";
	            g.doc.body.appendChild(i);
	            toHex = cacher(function (color) {
	                i.style.color = color;
	                return g.doc.defaultView.getComputedStyle(i, E).getPropertyValue("color");
	            });
	        }
	        return toHex(color);
	    },
	    hsbtoString = function () {
	        return "hsb(" + [this.h, this.s, this.b] + ")";
	    },
	    hsltoString = function () {
	        return "hsl(" + [this.h, this.s, this.l] + ")";
	    },
	    rgbtoString = function () {
	        return this.hex;
	    },
	    prepareRGB = function (r, g, b) {
	        if (g == null && R.is(r, "object") && "r" in r && "g" in r && "b" in r) {
	            b = r.b;
	            g = r.g;
	            r = r.r;
	        }
	        if (g == null && R.is(r, string)) {
	            var clr = R.getRGB(r);
	            r = clr.r;
	            g = clr.g;
	            b = clr.b;
	        }
	        if (r > 1 || g > 1 || b > 1) {
	            r /= 255;
	            g /= 255;
	            b /= 255;
	        }

	        return [r, g, b];
	    },
	    packageRGB = function (r, g, b, o) {
	        r *= 255;
	        g *= 255;
	        b *= 255;
	        var rgb = {
	            r: r,
	            g: g,
	            b: b,
	            hex: R.rgb(r, g, b),
	            toString: rgbtoString
	        };
	        R.is(o, "finite") && (rgb.opacity = o);
	        return rgb;
	    };

	    /*\
	     * Raphael.color
	     [ method ]
	     **
	     * Parses the color string and returns object with all values for the given color.
	     > Parameters
	     - clr (string) color string in one of the supported formats (see @Raphael.getRGB)
	     = (object) Combined RGB & HSB object in format:
	     o {
	     o     r (number) red,
	     o     g (number) green,
	     o     b (number) blue,
	     o     hex (string) color in HTML/CSS format: #••••••,
	     o     error (boolean) `true` if string can’t be parsed,
	     o     h (number) hue,
	     o     s (number) saturation,
	     o     v (number) value (brightness),
	     o     l (number) lightness
	     o }
	    \*/
	    R.color = function (clr) {
	        var rgb;
	        if (R.is(clr, "object") && "h" in clr && "s" in clr && "b" in clr) {
	            rgb = R.hsb2rgb(clr);
	            clr.r = rgb.r;
	            clr.g = rgb.g;
	            clr.b = rgb.b;
	            clr.hex = rgb.hex;
	        } else if (R.is(clr, "object") && "h" in clr && "s" in clr && "l" in clr) {
	            rgb = R.hsl2rgb(clr);
	            clr.r = rgb.r;
	            clr.g = rgb.g;
	            clr.b = rgb.b;
	            clr.hex = rgb.hex;
	        } else {
	            if (R.is(clr, "string")) {
	                clr = R.getRGB(clr);
	            }
	            if (R.is(clr, "object") && "r" in clr && "g" in clr && "b" in clr) {
	                rgb = R.rgb2hsl(clr);
	                clr.h = rgb.h;
	                clr.s = rgb.s;
	                clr.l = rgb.l;
	                rgb = R.rgb2hsb(clr);
	                clr.v = rgb.b;
	            } else {
	                clr = {hex: "none"};
	                clr.r = clr.g = clr.b = clr.h = clr.s = clr.v = clr.l = -1;
	            }
	        }
	        clr.toString = rgbtoString;
	        return clr;
	    };
	    /*\
	     * Raphael.hsb2rgb
	     [ method ]
	     **
	     * Converts HSB values to RGB object.
	     > Parameters
	     - h (number) hue
	     - s (number) saturation
	     - v (number) value or brightness
	     = (object) RGB object in format:
	     o {
	     o     r (number) red,
	     o     g (number) green,
	     o     b (number) blue,
	     o     hex (string) color in HTML/CSS format: #••••••
	     o }
	    \*/
	    R.hsb2rgb = function (h, s, v, o) {
	        if (this.is(h, "object") && "h" in h && "s" in h && "b" in h) {
	            v = h.b;
	            s = h.s;
	            o = h.o;
	            h = h.h;
	        }
	        h *= 360;
	        var R, G, B, X, C;
	        h = (h % 360) / 60;
	        C = v * s;
	        X = C * (1 - abs(h % 2 - 1));
	        R = G = B = v - C;

	        h = ~~h;
	        R += [C, X, 0, 0, X, C][h];
	        G += [X, C, C, X, 0, 0][h];
	        B += [0, 0, X, C, C, X][h];
	        return packageRGB(R, G, B, o);
	    };
	    /*\
	     * Raphael.hsl2rgb
	     [ method ]
	     **
	     * Converts HSL values to RGB object.
	     > Parameters
	     - h (number) hue
	     - s (number) saturation
	     - l (number) luminosity
	     = (object) RGB object in format:
	     o {
	     o     r (number) red,
	     o     g (number) green,
	     o     b (number) blue,
	     o     hex (string) color in HTML/CSS format: #••••••
	     o }
	    \*/
	    R.hsl2rgb = function (h, s, l, o) {
	        if (this.is(h, "object") && "h" in h && "s" in h && "l" in h) {
	            l = h.l;
	            s = h.s;
	            h = h.h;
	        }
	        if (h > 1 || s > 1 || l > 1) {
	            h /= 360;
	            s /= 100;
	            l /= 100;
	        }
	        h *= 360;
	        var R, G, B, X, C;
	        h = (h % 360) / 60;
	        C = 2 * s * (l < .5 ? l : 1 - l);
	        X = C * (1 - abs(h % 2 - 1));
	        R = G = B = l - C / 2;

	        h = ~~h;
	        R += [C, X, 0, 0, X, C][h];
	        G += [X, C, C, X, 0, 0][h];
	        B += [0, 0, X, C, C, X][h];
	        return packageRGB(R, G, B, o);
	    };
	    /*\
	     * Raphael.rgb2hsb
	     [ method ]
	     **
	     * Converts RGB values to HSB object.
	     > Parameters
	     - r (number) red
	     - g (number) green
	     - b (number) blue
	     = (object) HSB object in format:
	     o {
	     o     h (number) hue
	     o     s (number) saturation
	     o     b (number) brightness
	     o }
	    \*/
	    R.rgb2hsb = function (r, g, b) {
	        b = prepareRGB(r, g, b);
	        r = b[0];
	        g = b[1];
	        b = b[2];

	        var H, S, V, C;
	        V = mmax(r, g, b);
	        C = V - mmin(r, g, b);
	        H = (C == 0 ? null :
	             V == r ? (g - b) / C :
	             V == g ? (b - r) / C + 2 :
	                      (r - g) / C + 4
	            );
	        H = ((H + 360) % 6) * 60 / 360;
	        S = C == 0 ? 0 : C / V;
	        return {h: H, s: S, b: V, toString: hsbtoString};
	    };
	    /*\
	     * Raphael.rgb2hsl
	     [ method ]
	     **
	     * Converts RGB values to HSL object.
	     > Parameters
	     - r (number) red
	     - g (number) green
	     - b (number) blue
	     = (object) HSL object in format:
	     o {
	     o     h (number) hue
	     o     s (number) saturation
	     o     l (number) luminosity
	     o }
	    \*/
	    R.rgb2hsl = function (r, g, b) {
	        b = prepareRGB(r, g, b);
	        r = b[0];
	        g = b[1];
	        b = b[2];

	        var H, S, L, M, m, C;
	        M = mmax(r, g, b);
	        m = mmin(r, g, b);
	        C = M - m;
	        H = (C == 0 ? null :
	             M == r ? (g - b) / C :
	             M == g ? (b - r) / C + 2 :
	                      (r - g) / C + 4);
	        H = ((H + 360) % 6) * 60 / 360;
	        L = (M + m) / 2;
	        S = (C == 0 ? 0 :
	             L < .5 ? C / (2 * L) :
	                      C / (2 - 2 * L));
	        return {h: H, s: S, l: L, toString: hsltoString};
	    };
	    R._path2string = function () {
	        return this.join(",").replace(p2s, "$1");
	    };
	    function repush(array, item) {
	        for (var i = 0, ii = array.length; i < ii; i++) if (array[i] === item) {
	            return array.push(array.splice(i, 1)[0]);
	        }
	    }
	    function cacher(f, scope, postprocessor) {
	        function newf() {
	            var arg = Array.prototype.slice.call(arguments, 0),
	                args = arg.join("\u2400"),
	                cache = newf.cache = newf.cache || {},
	                count = newf.count = newf.count || [];
	            if (cache[has](args)) {
	                repush(count, args);
	                return postprocessor ? postprocessor(cache[args]) : cache[args];
	            }
	            count.length >= 1e3 && delete cache[count.shift()];
	            count.push(args);
	            cache[args] = f[apply](scope, arg);
	            return postprocessor ? postprocessor(cache[args]) : cache[args];
	        }
	        return newf;
	    }

	    var preload = R._preload = function (src, f) {
	        var img = g.doc.createElement("img");
	        img.style.cssText = "position:absolute;left:-9999em;top:-9999em";
	        img.onload = function () {
	            f.call(this);
	            this.onload = null;
	            g.doc.body.removeChild(this);
	        };
	        img.onerror = function () {
	            g.doc.body.removeChild(this);
	        };
	        g.doc.body.appendChild(img);
	        img.src = src;
	    };

	    function clrToString() {
	        return this.hex;
	    }

	    /*\
	     * Raphael.getRGB
	     [ method ]
	     **
	     * Parses colour string as RGB object
	     > Parameters
	     - colour (string) colour string in one of formats:
	     # <ul>
	     #     <li>Colour name (“<code>red</code>”, “<code>green</code>”, “<code>cornflowerblue</code>”, etc)</li>
	     #     <li>#••• — shortened HTML colour: (“<code>#000</code>”, “<code>#fc0</code>”, etc)</li>
	     #     <li>#•••••• — full length HTML colour: (“<code>#000000</code>”, “<code>#bd2300</code>”)</li>
	     #     <li>rgb(•••, •••, •••) — red, green and blue channels’ values: (“<code>rgb(200,&nbsp;100,&nbsp;0)</code>”)</li>
	     #     <li>rgb(•••%, •••%, •••%) — same as above, but in %: (“<code>rgb(100%,&nbsp;175%,&nbsp;0%)</code>”)</li>
	     #     <li>hsb(•••, •••, •••) — hue, saturation and brightness values: (“<code>hsb(0.5,&nbsp;0.25,&nbsp;1)</code>”)</li>
	     #     <li>hsb(•••%, •••%, •••%) — same as above, but in %</li>
	     #     <li>hsl(•••, •••, •••) — same as hsb</li>
	     #     <li>hsl(•••%, •••%, •••%) — same as hsb</li>
	     # </ul>
	     = (object) RGB object in format:
	     o {
	     o     r (number) red,
	     o     g (number) green,
	     o     b (number) blue
	     o     hex (string) color in HTML/CSS format: #••••••,
	     o     error (boolean) true if string can’t be parsed
	     o }
	    \*/
	    R.getRGB = cacher(function (colour) {
	        if (!colour || !!((colour = Str(colour)).indexOf("-") + 1)) {
	            return {r: -1, g: -1, b: -1, hex: "none", error: 1, toString: clrToString};
	        }
	        if (colour == "none") {
	            return {r: -1, g: -1, b: -1, hex: "none", toString: clrToString};
	        }
	        !(hsrg[has](colour.toLowerCase().substring(0, 2)) || colour.charAt() == "#") && (colour = toHex(colour));
	        var res,
	            red,
	            green,
	            blue,
	            opacity,
	            t,
	            values,
	            rgb = colour.match(colourRegExp);
	        if (rgb) {
	            if (rgb[2]) {
	                blue = toInt(rgb[2].substring(5), 16);
	                green = toInt(rgb[2].substring(3, 5), 16);
	                red = toInt(rgb[2].substring(1, 3), 16);
	            }
	            if (rgb[3]) {
	                blue = toInt((t = rgb[3].charAt(3)) + t, 16);
	                green = toInt((t = rgb[3].charAt(2)) + t, 16);
	                red = toInt((t = rgb[3].charAt(1)) + t, 16);
	            }
	            if (rgb[4]) {
	                values = rgb[4][split](commaSpaces);
	                red = toFloat(values[0]);
	                values[0].slice(-1) == "%" && (red *= 2.55);
	                green = toFloat(values[1]);
	                values[1].slice(-1) == "%" && (green *= 2.55);
	                blue = toFloat(values[2]);
	                values[2].slice(-1) == "%" && (blue *= 2.55);
	                rgb[1].toLowerCase().slice(0, 4) == "rgba" && (opacity = toFloat(values[3]));
	                values[3] && values[3].slice(-1) == "%" && (opacity /= 100);
	            }
	            if (rgb[5]) {
	                values = rgb[5][split](commaSpaces);
	                red = toFloat(values[0]);
	                values[0].slice(-1) == "%" && (red *= 2.55);
	                green = toFloat(values[1]);
	                values[1].slice(-1) == "%" && (green *= 2.55);
	                blue = toFloat(values[2]);
	                values[2].slice(-1) == "%" && (blue *= 2.55);
	                (values[0].slice(-3) == "deg" || values[0].slice(-1) == "\xb0") && (red /= 360);
	                rgb[1].toLowerCase().slice(0, 4) == "hsba" && (opacity = toFloat(values[3]));
	                values[3] && values[3].slice(-1) == "%" && (opacity /= 100);
	                return R.hsb2rgb(red, green, blue, opacity);
	            }
	            if (rgb[6]) {
	                values = rgb[6][split](commaSpaces);
	                red = toFloat(values[0]);
	                values[0].slice(-1) == "%" && (red *= 2.55);
	                green = toFloat(values[1]);
	                values[1].slice(-1) == "%" && (green *= 2.55);
	                blue = toFloat(values[2]);
	                values[2].slice(-1) == "%" && (blue *= 2.55);
	                (values[0].slice(-3) == "deg" || values[0].slice(-1) == "\xb0") && (red /= 360);
	                rgb[1].toLowerCase().slice(0, 4) == "hsla" && (opacity = toFloat(values[3]));
	                values[3] && values[3].slice(-1) == "%" && (opacity /= 100);
	                return R.hsl2rgb(red, green, blue, opacity);
	            }
	            rgb = {r: red, g: green, b: blue, toString: clrToString};
	            rgb.hex = "#" + (16777216 | blue | (green << 8) | (red << 16)).toString(16).slice(1);
	            R.is(opacity, "finite") && (rgb.opacity = opacity);
	            return rgb;
	        }
	        return {r: -1, g: -1, b: -1, hex: "none", error: 1, toString: clrToString};
	    }, R);
	    /*\
	     * Raphael.hsb
	     [ method ]
	     **
	     * Converts HSB values to hex representation of the colour.
	     > Parameters
	     - h (number) hue
	     - s (number) saturation
	     - b (number) value or brightness
	     = (string) hex representation of the colour.
	    \*/
	    R.hsb = cacher(function (h, s, b) {
	        return R.hsb2rgb(h, s, b).hex;
	    });
	    /*\
	     * Raphael.hsl
	     [ method ]
	     **
	     * Converts HSL values to hex representation of the colour.
	     > Parameters
	     - h (number) hue
	     - s (number) saturation
	     - l (number) luminosity
	     = (string) hex representation of the colour.
	    \*/
	    R.hsl = cacher(function (h, s, l) {
	        return R.hsl2rgb(h, s, l).hex;
	    });
	    /*\
	     * Raphael.rgb
	     [ method ]
	     **
	     * Converts RGB values to hex representation of the colour.
	     > Parameters
	     - r (number) red
	     - g (number) green
	     - b (number) blue
	     = (string) hex representation of the colour.
	    \*/
	    R.rgb = cacher(function (r, g, b) {
	        function round(x) { return (x + 0.5) | 0; }
	        return "#" + (16777216 | round(b) | (round(g) << 8) | (round(r) << 16)).toString(16).slice(1);
	    });
	    /*\
	     * Raphael.getColor
	     [ method ]
	     **
	     * On each call returns next colour in the spectrum. To reset it back to red call @Raphael.getColor.reset
	     > Parameters
	     - value (number) #optional brightness, default is `0.75`
	     = (string) hex representation of the colour.
	    \*/
	    R.getColor = function (value) {
	        var start = this.getColor.start = this.getColor.start || {h: 0, s: 1, b: value || .75},
	            rgb = this.hsb2rgb(start.h, start.s, start.b);
	        start.h += .075;
	        if (start.h > 1) {
	            start.h = 0;
	            start.s -= .2;
	            start.s <= 0 && (this.getColor.start = {h: 0, s: 1, b: start.b});
	        }
	        return rgb.hex;
	    };
	    /*\
	     * Raphael.getColor.reset
	     [ method ]
	     **
	     * Resets spectrum position for @Raphael.getColor back to red.
	    \*/
	    R.getColor.reset = function () {
	        delete this.start;
	    };

	    // http://schepers.cc/getting-to-the-point
	    function catmullRom2bezier(crp, z) {
	        var d = [];
	        for (var i = 0, iLen = crp.length; iLen - 2 * !z > i; i += 2) {
	            var p = [
	                        {x: +crp[i - 2], y: +crp[i - 1]},
	                        {x: +crp[i],     y: +crp[i + 1]},
	                        {x: +crp[i + 2], y: +crp[i + 3]},
	                        {x: +crp[i + 4], y: +crp[i + 5]}
	                    ];
	            if (z) {
	                if (!i) {
	                    p[0] = {x: +crp[iLen - 2], y: +crp[iLen - 1]};
	                } else if (iLen - 4 == i) {
	                    p[3] = {x: +crp[0], y: +crp[1]};
	                } else if (iLen - 2 == i) {
	                    p[2] = {x: +crp[0], y: +crp[1]};
	                    p[3] = {x: +crp[2], y: +crp[3]};
	                }
	            } else {
	                if (iLen - 4 == i) {
	                    p[3] = p[2];
	                } else if (!i) {
	                    p[0] = {x: +crp[i], y: +crp[i + 1]};
	                }
	            }
	            d.push(["C",
	                  (-p[0].x + 6 * p[1].x + p[2].x) / 6,
	                  (-p[0].y + 6 * p[1].y + p[2].y) / 6,
	                  (p[1].x + 6 * p[2].x - p[3].x) / 6,
	                  (p[1].y + 6*p[2].y - p[3].y) / 6,
	                  p[2].x,
	                  p[2].y
	            ]);
	        }

	        return d;
	    }
	    /*\
	     * Raphael.parsePathString
	     [ method ]
	     **
	     * Utility method
	     **
	     * Parses given path string into an array of arrays of path segments.
	     > Parameters
	     - pathString (string|array) path string or array of segments (in the last case it will be returned straight away)
	     = (array) array of segments.
	    \*/
	    R.parsePathString = function (pathString) {
	        if (!pathString) {
	            return null;
	        }
	        var pth = paths(pathString);
	        if (pth.arr) {
	            return pathClone(pth.arr);
	        }

	        var paramCounts = {a: 7, c: 6, h: 1, l: 2, m: 2, r: 4, q: 4, s: 4, t: 2, v: 1, z: 0},
	            data = [];
	        if (R.is(pathString, array) && R.is(pathString[0], array)) { // rough assumption
	            data = pathClone(pathString);
	        }
	        if (!data.length) {
	            Str(pathString).replace(pathCommand, function (a, b, c) {
	                var params = [],
	                    name = b.toLowerCase();
	                c.replace(pathValues, function (a, b) {
	                    b && params.push(+b);
	                });
	                if (name == "m" && params.length > 2) {
	                    data.push([b][concat](params.splice(0, 2)));
	                    name = "l";
	                    b = b == "m" ? "l" : "L";
	                }
	                if (name == "r") {
	                    data.push([b][concat](params));
	                } else while (params.length >= paramCounts[name]) {
	                    data.push([b][concat](params.splice(0, paramCounts[name])));
	                    if (!paramCounts[name]) {
	                        break;
	                    }
	                }
	            });
	        }
	        data.toString = R._path2string;
	        pth.arr = pathClone(data);
	        return data;
	    };
	    /*\
	     * Raphael.parseTransformString
	     [ method ]
	     **
	     * Utility method
	     **
	     * Parses given path string into an array of transformations.
	     > Parameters
	     - TString (string|array) transform string or array of transformations (in the last case it will be returned straight away)
	     = (array) array of transformations.
	    \*/
	    R.parseTransformString = cacher(function (TString) {
	        if (!TString) {
	            return null;
	        }
	        var paramCounts = {r: 3, s: 4, t: 2, m: 6},
	            data = [];
	        if (R.is(TString, array) && R.is(TString[0], array)) { // rough assumption
	            data = pathClone(TString);
	        }
	        if (!data.length) {
	            Str(TString).replace(tCommand, function (a, b, c) {
	                var params = [],
	                    name = lowerCase.call(b);
	                c.replace(pathValues, function (a, b) {
	                    b && params.push(+b);
	                });
	                data.push([b][concat](params));
	            });
	        }
	        data.toString = R._path2string;
	        return data;
	    });
	    // PATHS
	    var paths = function (ps) {
	        var p = paths.ps = paths.ps || {};
	        if (p[ps]) {
	            p[ps].sleep = 100;
	        } else {
	            p[ps] = {
	                sleep: 100
	            };
	        }
	        setTimeout(function () {
	            for (var key in p) if (p[has](key) && key != ps) {
	                p[key].sleep--;
	                !p[key].sleep && delete p[key];
	            }
	        });
	        return p[ps];
	    };
	    /*\
	     * Raphael.findDotsAtSegment
	     [ method ]
	     **
	     * Utility method
	     **
	     * Find dot coordinates on the given cubic bezier curve at the given t.
	     > Parameters
	     - p1x (number) x of the first point of the curve
	     - p1y (number) y of the first point of the curve
	     - c1x (number) x of the first anchor of the curve
	     - c1y (number) y of the first anchor of the curve
	     - c2x (number) x of the second anchor of the curve
	     - c2y (number) y of the second anchor of the curve
	     - p2x (number) x of the second point of the curve
	     - p2y (number) y of the second point of the curve
	     - t (number) position on the curve (0..1)
	     = (object) point information in format:
	     o {
	     o     x: (number) x coordinate of the point
	     o     y: (number) y coordinate of the point
	     o     m: {
	     o         x: (number) x coordinate of the left anchor
	     o         y: (number) y coordinate of the left anchor
	     o     }
	     o     n: {
	     o         x: (number) x coordinate of the right anchor
	     o         y: (number) y coordinate of the right anchor
	     o     }
	     o     start: {
	     o         x: (number) x coordinate of the start of the curve
	     o         y: (number) y coordinate of the start of the curve
	     o     }
	     o     end: {
	     o         x: (number) x coordinate of the end of the curve
	     o         y: (number) y coordinate of the end of the curve
	     o     }
	     o     alpha: (number) angle of the curve derivative at the point
	     o }
	    \*/
	    R.findDotsAtSegment = function (p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t) {
	        var t1 = 1 - t,
	            t13 = pow(t1, 3),
	            t12 = pow(t1, 2),
	            t2 = t * t,
	            t3 = t2 * t,
	            x = t13 * p1x + t12 * 3 * t * c1x + t1 * 3 * t * t * c2x + t3 * p2x,
	            y = t13 * p1y + t12 * 3 * t * c1y + t1 * 3 * t * t * c2y + t3 * p2y,
	            mx = p1x + 2 * t * (c1x - p1x) + t2 * (c2x - 2 * c1x + p1x),
	            my = p1y + 2 * t * (c1y - p1y) + t2 * (c2y - 2 * c1y + p1y),
	            nx = c1x + 2 * t * (c2x - c1x) + t2 * (p2x - 2 * c2x + c1x),
	            ny = c1y + 2 * t * (c2y - c1y) + t2 * (p2y - 2 * c2y + c1y),
	            ax = t1 * p1x + t * c1x,
	            ay = t1 * p1y + t * c1y,
	            cx = t1 * c2x + t * p2x,
	            cy = t1 * c2y + t * p2y,
	            alpha = (90 - math.atan2(mx - nx, my - ny) * 180 / PI);
	        (mx > nx || my < ny) && (alpha += 180);
	        return {
	            x: x,
	            y: y,
	            m: {x: mx, y: my},
	            n: {x: nx, y: ny},
	            start: {x: ax, y: ay},
	            end: {x: cx, y: cy},
	            alpha: alpha
	        };
	    };
	    /*\
	     * Raphael.bezierBBox
	     [ method ]
	     **
	     * Utility method
	     **
	     * Return bounding box of a given cubic bezier curve
	     > Parameters
	     - p1x (number) x of the first point of the curve
	     - p1y (number) y of the first point of the curve
	     - c1x (number) x of the first anchor of the curve
	     - c1y (number) y of the first anchor of the curve
	     - c2x (number) x of the second anchor of the curve
	     - c2y (number) y of the second anchor of the curve
	     - p2x (number) x of the second point of the curve
	     - p2y (number) y of the second point of the curve
	     * or
	     - bez (array) array of six points for bezier curve
	     = (object) point information in format:
	     o {
	     o     min: {
	     o         x: (number) x coordinate of the left point
	     o         y: (number) y coordinate of the top point
	     o     }
	     o     max: {
	     o         x: (number) x coordinate of the right point
	     o         y: (number) y coordinate of the bottom point
	     o     }
	     o }
	    \*/
	    R.bezierBBox = function (p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y) {
	        if (!R.is(p1x, "array")) {
	            p1x = [p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y];
	        }
	        var bbox = curveDim.apply(null, p1x);
	        return {
	            x: bbox.min.x,
	            y: bbox.min.y,
	            x2: bbox.max.x,
	            y2: bbox.max.y,
	            width: bbox.max.x - bbox.min.x,
	            height: bbox.max.y - bbox.min.y
	        };
	    };
	    /*\
	     * Raphael.isPointInsideBBox
	     [ method ]
	     **
	     * Utility method
	     **
	     * Returns `true` if given point is inside bounding boxes.
	     > Parameters
	     - bbox (string) bounding box
	     - x (string) x coordinate of the point
	     - y (string) y coordinate of the point
	     = (boolean) `true` if point inside
	    \*/
	    R.isPointInsideBBox = function (bbox, x, y) {
	        return x >= bbox.x && x <= bbox.x2 && y >= bbox.y && y <= bbox.y2;
	    };
	    /*\
	     * Raphael.isBBoxIntersect
	     [ method ]
	     **
	     * Utility method
	     **
	     * Returns `true` if two bounding boxes intersect
	     > Parameters
	     - bbox1 (string) first bounding box
	     - bbox2 (string) second bounding box
	     = (boolean) `true` if they intersect
	    \*/
	    R.isBBoxIntersect = function (bbox1, bbox2) {
	        var i = R.isPointInsideBBox;
	        return i(bbox2, bbox1.x, bbox1.y)
	            || i(bbox2, bbox1.x2, bbox1.y)
	            || i(bbox2, bbox1.x, bbox1.y2)
	            || i(bbox2, bbox1.x2, bbox1.y2)
	            || i(bbox1, bbox2.x, bbox2.y)
	            || i(bbox1, bbox2.x2, bbox2.y)
	            || i(bbox1, bbox2.x, bbox2.y2)
	            || i(bbox1, bbox2.x2, bbox2.y2)
	            || (bbox1.x < bbox2.x2 && bbox1.x > bbox2.x || bbox2.x < bbox1.x2 && bbox2.x > bbox1.x)
	            && (bbox1.y < bbox2.y2 && bbox1.y > bbox2.y || bbox2.y < bbox1.y2 && bbox2.y > bbox1.y);
	    };
	    function base3(t, p1, p2, p3, p4) {
	        var t1 = -3 * p1 + 9 * p2 - 9 * p3 + 3 * p4,
	            t2 = t * t1 + 6 * p1 - 12 * p2 + 6 * p3;
	        return t * t2 - 3 * p1 + 3 * p2;
	    }
	    function bezlen(x1, y1, x2, y2, x3, y3, x4, y4, z) {
	        if (z == null) {
	            z = 1;
	        }
	        z = z > 1 ? 1 : z < 0 ? 0 : z;
	        var z2 = z / 2,
	            n = 12,
	            Tvalues = [-0.1252,0.1252,-0.3678,0.3678,-0.5873,0.5873,-0.7699,0.7699,-0.9041,0.9041,-0.9816,0.9816],
	            Cvalues = [0.2491,0.2491,0.2335,0.2335,0.2032,0.2032,0.1601,0.1601,0.1069,0.1069,0.0472,0.0472],
	            sum = 0;
	        for (var i = 0; i < n; i++) {
	            var ct = z2 * Tvalues[i] + z2,
	                xbase = base3(ct, x1, x2, x3, x4),
	                ybase = base3(ct, y1, y2, y3, y4),
	                comb = xbase * xbase + ybase * ybase;
	            sum += Cvalues[i] * math.sqrt(comb);
	        }
	        return z2 * sum;
	    }
	    function getTatLen(x1, y1, x2, y2, x3, y3, x4, y4, ll) {
	        if (ll < 0 || bezlen(x1, y1, x2, y2, x3, y3, x4, y4) < ll) {
	            return;
	        }
	        var t = 1,
	            step = t / 2,
	            t2 = t - step,
	            l,
	            e = .01;
	        l = bezlen(x1, y1, x2, y2, x3, y3, x4, y4, t2);
	        while (abs(l - ll) > e) {
	            step /= 2;
	            t2 += (l < ll ? 1 : -1) * step;
	            l = bezlen(x1, y1, x2, y2, x3, y3, x4, y4, t2);
	        }
	        return t2;
	    }
	    function intersect(x1, y1, x2, y2, x3, y3, x4, y4) {
	        if (
	            mmax(x1, x2) < mmin(x3, x4) ||
	            mmin(x1, x2) > mmax(x3, x4) ||
	            mmax(y1, y2) < mmin(y3, y4) ||
	            mmin(y1, y2) > mmax(y3, y4)
	        ) {
	            return;
	        }
	        var nx = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4),
	            ny = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4),
	            denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

	        if (!denominator) {
	            return;
	        }
	        var px = nx / denominator,
	            py = ny / denominator,
	            px2 = +px.toFixed(2),
	            py2 = +py.toFixed(2);
	        if (
	            px2 < +mmin(x1, x2).toFixed(2) ||
	            px2 > +mmax(x1, x2).toFixed(2) ||
	            px2 < +mmin(x3, x4).toFixed(2) ||
	            px2 > +mmax(x3, x4).toFixed(2) ||
	            py2 < +mmin(y1, y2).toFixed(2) ||
	            py2 > +mmax(y1, y2).toFixed(2) ||
	            py2 < +mmin(y3, y4).toFixed(2) ||
	            py2 > +mmax(y3, y4).toFixed(2)
	        ) {
	            return;
	        }
	        return {x: px, y: py};
	    }
	    function inter(bez1, bez2) {
	        return interHelper(bez1, bez2);
	    }
	    function interCount(bez1, bez2) {
	        return interHelper(bez1, bez2, 1);
	    }
	    function interHelper(bez1, bez2, justCount) {
	        var bbox1 = R.bezierBBox(bez1),
	            bbox2 = R.bezierBBox(bez2);
	        if (!R.isBBoxIntersect(bbox1, bbox2)) {
	            return justCount ? 0 : [];
	        }
	        var l1 = bezlen.apply(0, bez1),
	            l2 = bezlen.apply(0, bez2),
	            n1 = mmax(~~(l1 / 5), 1),
	            n2 = mmax(~~(l2 / 5), 1),
	            dots1 = [],
	            dots2 = [],
	            xy = {},
	            res = justCount ? 0 : [];
	        for (var i = 0; i < n1 + 1; i++) {
	            var p = R.findDotsAtSegment.apply(R, bez1.concat(i / n1));
	            dots1.push({x: p.x, y: p.y, t: i / n1});
	        }
	        for (i = 0; i < n2 + 1; i++) {
	            p = R.findDotsAtSegment.apply(R, bez2.concat(i / n2));
	            dots2.push({x: p.x, y: p.y, t: i / n2});
	        }
	        for (i = 0; i < n1; i++) {
	            for (var j = 0; j < n2; j++) {
	                var di = dots1[i],
	                    di1 = dots1[i + 1],
	                    dj = dots2[j],
	                    dj1 = dots2[j + 1],
	                    ci = abs(di1.x - di.x) < .001 ? "y" : "x",
	                    cj = abs(dj1.x - dj.x) < .001 ? "y" : "x",
	                    is = intersect(di.x, di.y, di1.x, di1.y, dj.x, dj.y, dj1.x, dj1.y);
	                if (is) {
	                    if (xy[is.x.toFixed(4)] == is.y.toFixed(4)) {
	                        continue;
	                    }
	                    xy[is.x.toFixed(4)] = is.y.toFixed(4);
	                    var t1 = di.t + abs((is[ci] - di[ci]) / (di1[ci] - di[ci])) * (di1.t - di.t),
	                        t2 = dj.t + abs((is[cj] - dj[cj]) / (dj1[cj] - dj[cj])) * (dj1.t - dj.t);
	                    if (t1 >= 0 && t1 <= 1.001 && t2 >= 0 && t2 <= 1.001) {
	                        if (justCount) {
	                            res++;
	                        } else {
	                            res.push({
	                                x: is.x,
	                                y: is.y,
	                                t1: mmin(t1, 1),
	                                t2: mmin(t2, 1)
	                            });
	                        }
	                    }
	                }
	            }
	        }
	        return res;
	    }
	    /*\
	     * Raphael.pathIntersection
	     [ method ]
	     **
	     * Utility method
	     **
	     * Finds intersections of two paths
	     > Parameters
	     - path1 (string) path string
	     - path2 (string) path string
	     = (array) dots of intersection
	     o [
	     o     {
	     o         x: (number) x coordinate of the point
	     o         y: (number) y coordinate of the point
	     o         t1: (number) t value for segment of path1
	     o         t2: (number) t value for segment of path2
	     o         segment1: (number) order number for segment of path1
	     o         segment2: (number) order number for segment of path2
	     o         bez1: (array) eight coordinates representing beziér curve for the segment of path1
	     o         bez2: (array) eight coordinates representing beziér curve for the segment of path2
	     o     }
	     o ]
	    \*/
	    R.pathIntersection = function (path1, path2) {
	        return interPathHelper(path1, path2);
	    };
	    R.pathIntersectionNumber = function (path1, path2) {
	        return interPathHelper(path1, path2, 1);
	    };
	    function interPathHelper(path1, path2, justCount) {
	        path1 = R._path2curve(path1);
	        path2 = R._path2curve(path2);
	        var x1, y1, x2, y2, x1m, y1m, x2m, y2m, bez1, bez2,
	            res = justCount ? 0 : [];
	        for (var i = 0, ii = path1.length; i < ii; i++) {
	            var pi = path1[i];
	            if (pi[0] == "M") {
	                x1 = x1m = pi[1];
	                y1 = y1m = pi[2];
	            } else {
	                if (pi[0] == "C") {
	                    bez1 = [x1, y1].concat(pi.slice(1));
	                    x1 = bez1[6];
	                    y1 = bez1[7];
	                } else {
	                    bez1 = [x1, y1, x1, y1, x1m, y1m, x1m, y1m];
	                    x1 = x1m;
	                    y1 = y1m;
	                }
	                for (var j = 0, jj = path2.length; j < jj; j++) {
	                    var pj = path2[j];
	                    if (pj[0] == "M") {
	                        x2 = x2m = pj[1];
	                        y2 = y2m = pj[2];
	                    } else {
	                        if (pj[0] == "C") {
	                            bez2 = [x2, y2].concat(pj.slice(1));
	                            x2 = bez2[6];
	                            y2 = bez2[7];
	                        } else {
	                            bez2 = [x2, y2, x2, y2, x2m, y2m, x2m, y2m];
	                            x2 = x2m;
	                            y2 = y2m;
	                        }
	                        var intr = interHelper(bez1, bez2, justCount);
	                        if (justCount) {
	                            res += intr;
	                        } else {
	                            for (var k = 0, kk = intr.length; k < kk; k++) {
	                                intr[k].segment1 = i;
	                                intr[k].segment2 = j;
	                                intr[k].bez1 = bez1;
	                                intr[k].bez2 = bez2;
	                            }
	                            res = res.concat(intr);
	                        }
	                    }
	                }
	            }
	        }
	        return res;
	    }
	    /*\
	     * Raphael.isPointInsidePath
	     [ method ]
	     **
	     * Utility method
	     **
	     * Returns `true` if given point is inside a given closed path.
	     > Parameters
	     - path (string) path string
	     - x (number) x of the point
	     - y (number) y of the point
	     = (boolean) true, if point is inside the path
	    \*/
	    R.isPointInsidePath = function (path, x, y) {
	        var bbox = R.pathBBox(path);
	        return R.isPointInsideBBox(bbox, x, y) &&
	               interPathHelper(path, [["M", x, y], ["H", bbox.x2 + 10]], 1) % 2 == 1;
	    };
	    R._removedFactory = function (methodname) {
	        return function () {
	            eve("raphael.log", null, "Rapha\xebl: you are calling to method \u201c" + methodname + "\u201d of removed object", methodname);
	        };
	    };
	    /*\
	     * Raphael.pathBBox
	     [ method ]
	     **
	     * Utility method
	     **
	     * Return bounding box of a given path
	     > Parameters
	     - path (string) path string
	     = (object) bounding box
	     o {
	     o     x: (number) x coordinate of the left top point of the box
	     o     y: (number) y coordinate of the left top point of the box
	     o     x2: (number) x coordinate of the right bottom point of the box
	     o     y2: (number) y coordinate of the right bottom point of the box
	     o     width: (number) width of the box
	     o     height: (number) height of the box
	     o     cx: (number) x coordinate of the center of the box
	     o     cy: (number) y coordinate of the center of the box
	     o }
	    \*/
	    var pathDimensions = R.pathBBox = function (path) {
	        var pth = paths(path);
	        if (pth.bbox) {
	            return clone(pth.bbox);
	        }
	        if (!path) {
	            return {x: 0, y: 0, width: 0, height: 0, x2: 0, y2: 0};
	        }
	        path = path2curve(path);
	        var x = 0,
	            y = 0,
	            X = [],
	            Y = [],
	            p;
	        for (var i = 0, ii = path.length; i < ii; i++) {
	            p = path[i];
	            if (p[0] == "M") {
	                x = p[1];
	                y = p[2];
	                X.push(x);
	                Y.push(y);
	            } else {
	                var dim = curveDim(x, y, p[1], p[2], p[3], p[4], p[5], p[6]);
	                X = X[concat](dim.min.x, dim.max.x);
	                Y = Y[concat](dim.min.y, dim.max.y);
	                x = p[5];
	                y = p[6];
	            }
	        }
	        var xmin = mmin[apply](0, X),
	            ymin = mmin[apply](0, Y),
	            xmax = mmax[apply](0, X),
	            ymax = mmax[apply](0, Y),
	            width = xmax - xmin,
	            height = ymax - ymin,
	                bb = {
	                x: xmin,
	                y: ymin,
	                x2: xmax,
	                y2: ymax,
	                width: width,
	                height: height,
	                cx: xmin + width / 2,
	                cy: ymin + height / 2
	            };
	        pth.bbox = clone(bb);
	        return bb;
	    },
	        pathClone = function (pathArray) {
	            var res = clone(pathArray);
	            res.toString = R._path2string;
	            return res;
	        },
	        pathToRelative = R._pathToRelative = function (pathArray) {
	            var pth = paths(pathArray);
	            if (pth.rel) {
	                return pathClone(pth.rel);
	            }
	            if (!R.is(pathArray, array) || !R.is(pathArray && pathArray[0], array)) { // rough assumption
	                pathArray = R.parsePathString(pathArray);
	            }
	            var res = [],
	                x = 0,
	                y = 0,
	                mx = 0,
	                my = 0,
	                start = 0;
	            if (pathArray[0][0] == "M") {
	                x = pathArray[0][1];
	                y = pathArray[0][2];
	                mx = x;
	                my = y;
	                start++;
	                res.push(["M", x, y]);
	            }
	            for (var i = start, ii = pathArray.length; i < ii; i++) {
	                var r = res[i] = [],
	                    pa = pathArray[i];
	                if (pa[0] != lowerCase.call(pa[0])) {
	                    r[0] = lowerCase.call(pa[0]);
	                    switch (r[0]) {
	                        case "a":
	                            r[1] = pa[1];
	                            r[2] = pa[2];
	                            r[3] = pa[3];
	                            r[4] = pa[4];
	                            r[5] = pa[5];
	                            r[6] = +(pa[6] - x).toFixed(3);
	                            r[7] = +(pa[7] - y).toFixed(3);
	                            break;
	                        case "v":
	                            r[1] = +(pa[1] - y).toFixed(3);
	                            break;
	                        case "m":
	                            mx = pa[1];
	                            my = pa[2];
	                        default:
	                            for (var j = 1, jj = pa.length; j < jj; j++) {
	                                r[j] = +(pa[j] - ((j % 2) ? x : y)).toFixed(3);
	                            }
	                    }
	                } else {
	                    r = res[i] = [];
	                    if (pa[0] == "m") {
	                        mx = pa[1] + x;
	                        my = pa[2] + y;
	                    }
	                    for (var k = 0, kk = pa.length; k < kk; k++) {
	                        res[i][k] = pa[k];
	                    }
	                }
	                var len = res[i].length;
	                switch (res[i][0]) {
	                    case "z":
	                        x = mx;
	                        y = my;
	                        break;
	                    case "h":
	                        x += +res[i][len - 1];
	                        break;
	                    case "v":
	                        y += +res[i][len - 1];
	                        break;
	                    default:
	                        x += +res[i][len - 2];
	                        y += +res[i][len - 1];
	                }
	            }
	            res.toString = R._path2string;
	            pth.rel = pathClone(res);
	            return res;
	        },
	        pathToAbsolute = R._pathToAbsolute = function (pathArray) {
	            var pth = paths(pathArray);
	            if (pth.abs) {
	                return pathClone(pth.abs);
	            }
	            if (!R.is(pathArray, array) || !R.is(pathArray && pathArray[0], array)) { // rough assumption
	                pathArray = R.parsePathString(pathArray);
	            }
	            if (!pathArray || !pathArray.length) {
	                return [["M", 0, 0]];
	            }
	            var res = [],
	                x = 0,
	                y = 0,
	                mx = 0,
	                my = 0,
	                start = 0;
	            if (pathArray[0][0] == "M") {
	                x = +pathArray[0][1];
	                y = +pathArray[0][2];
	                mx = x;
	                my = y;
	                start++;
	                res[0] = ["M", x, y];
	            }
	            var crz = pathArray.length == 3 && pathArray[0][0] == "M" && pathArray[1][0].toUpperCase() == "R" && pathArray[2][0].toUpperCase() == "Z";
	            for (var r, pa, i = start, ii = pathArray.length; i < ii; i++) {
	                res.push(r = []);
	                pa = pathArray[i];
	                if (pa[0] != upperCase.call(pa[0])) {
	                    r[0] = upperCase.call(pa[0]);
	                    switch (r[0]) {
	                        case "A":
	                            r[1] = pa[1];
	                            r[2] = pa[2];
	                            r[3] = pa[3];
	                            r[4] = pa[4];
	                            r[5] = pa[5];
	                            r[6] = +(pa[6] + x);
	                            r[7] = +(pa[7] + y);
	                            break;
	                        case "V":
	                            r[1] = +pa[1] + y;
	                            break;
	                        case "H":
	                            r[1] = +pa[1] + x;
	                            break;
	                        case "R":
	                            var dots = [x, y][concat](pa.slice(1));
	                            for (var j = 2, jj = dots.length; j < jj; j++) {
	                                dots[j] = +dots[j] + x;
	                                dots[++j] = +dots[j] + y;
	                            }
	                            res.pop();
	                            res = res[concat](catmullRom2bezier(dots, crz));
	                            break;
	                        case "M":
	                            mx = +pa[1] + x;
	                            my = +pa[2] + y;
	                        default:
	                            for (j = 1, jj = pa.length; j < jj; j++) {
	                                r[j] = +pa[j] + ((j % 2) ? x : y);
	                            }
	                    }
	                } else if (pa[0] == "R") {
	                    dots = [x, y][concat](pa.slice(1));
	                    res.pop();
	                    res = res[concat](catmullRom2bezier(dots, crz));
	                    r = ["R"][concat](pa.slice(-2));
	                } else {
	                    for (var k = 0, kk = pa.length; k < kk; k++) {
	                        r[k] = pa[k];
	                    }
	                }
	                switch (r[0]) {
	                    case "Z":
	                        x = mx;
	                        y = my;
	                        break;
	                    case "H":
	                        x = r[1];
	                        break;
	                    case "V":
	                        y = r[1];
	                        break;
	                    case "M":
	                        mx = r[r.length - 2];
	                        my = r[r.length - 1];
	                    default:
	                        x = r[r.length - 2];
	                        y = r[r.length - 1];
	                }
	            }
	            res.toString = R._path2string;
	            pth.abs = pathClone(res);
	            return res;
	        },
	        l2c = function (x1, y1, x2, y2) {
	            return [x1, y1, x2, y2, x2, y2];
	        },
	        q2c = function (x1, y1, ax, ay, x2, y2) {
	            var _13 = 1 / 3,
	                _23 = 2 / 3;
	            return [
	                    _13 * x1 + _23 * ax,
	                    _13 * y1 + _23 * ay,
	                    _13 * x2 + _23 * ax,
	                    _13 * y2 + _23 * ay,
	                    x2,
	                    y2
	                ];
	        },
	        a2c = function (x1, y1, rx, ry, angle, large_arc_flag, sweep_flag, x2, y2, recursive) {
	            // for more information of where this math came from visit:
	            // http://www.w3.org/TR/SVG11/implnote.html#ArcImplementationNotes
	            var _120 = PI * 120 / 180,
	                rad = PI / 180 * (+angle || 0),
	                res = [],
	                xy,
	                rotate = cacher(function (x, y, rad) {
	                    var X = x * math.cos(rad) - y * math.sin(rad),
	                        Y = x * math.sin(rad) + y * math.cos(rad);
	                    return {x: X, y: Y};
	                });
	            if (!recursive) {
	                xy = rotate(x1, y1, -rad);
	                x1 = xy.x;
	                y1 = xy.y;
	                xy = rotate(x2, y2, -rad);
	                x2 = xy.x;
	                y2 = xy.y;
	                var cos = math.cos(PI / 180 * angle),
	                    sin = math.sin(PI / 180 * angle),
	                    x = (x1 - x2) / 2,
	                    y = (y1 - y2) / 2;
	                var h = (x * x) / (rx * rx) + (y * y) / (ry * ry);
	                if (h > 1) {
	                    h = math.sqrt(h);
	                    rx = h * rx;
	                    ry = h * ry;
	                }
	                var rx2 = rx * rx,
	                    ry2 = ry * ry,
	                    k = (large_arc_flag == sweep_flag ? -1 : 1) *
	                        math.sqrt(abs((rx2 * ry2 - rx2 * y * y - ry2 * x * x) / (rx2 * y * y + ry2 * x * x))),
	                    cx = k * rx * y / ry + (x1 + x2) / 2,
	                    cy = k * -ry * x / rx + (y1 + y2) / 2,
	                    f1 = math.asin(((y1 - cy) / ry).toFixed(9)),
	                    f2 = math.asin(((y2 - cy) / ry).toFixed(9));

	                f1 = x1 < cx ? PI - f1 : f1;
	                f2 = x2 < cx ? PI - f2 : f2;
	                f1 < 0 && (f1 = PI * 2 + f1);
	                f2 < 0 && (f2 = PI * 2 + f2);
	                if (sweep_flag && f1 > f2) {
	                    f1 = f1 - PI * 2;
	                }
	                if (!sweep_flag && f2 > f1) {
	                    f2 = f2 - PI * 2;
	                }
	            } else {
	                f1 = recursive[0];
	                f2 = recursive[1];
	                cx = recursive[2];
	                cy = recursive[3];
	            }
	            var df = f2 - f1;
	            if (abs(df) > _120) {
	                var f2old = f2,
	                    x2old = x2,
	                    y2old = y2;
	                f2 = f1 + _120 * (sweep_flag && f2 > f1 ? 1 : -1);
	                x2 = cx + rx * math.cos(f2);
	                y2 = cy + ry * math.sin(f2);
	                res = a2c(x2, y2, rx, ry, angle, 0, sweep_flag, x2old, y2old, [f2, f2old, cx, cy]);
	            }
	            df = f2 - f1;
	            var c1 = math.cos(f1),
	                s1 = math.sin(f1),
	                c2 = math.cos(f2),
	                s2 = math.sin(f2),
	                t = math.tan(df / 4),
	                hx = 4 / 3 * rx * t,
	                hy = 4 / 3 * ry * t,
	                m1 = [x1, y1],
	                m2 = [x1 + hx * s1, y1 - hy * c1],
	                m3 = [x2 + hx * s2, y2 - hy * c2],
	                m4 = [x2, y2];
	            m2[0] = 2 * m1[0] - m2[0];
	            m2[1] = 2 * m1[1] - m2[1];
	            if (recursive) {
	                return [m2, m3, m4][concat](res);
	            } else {
	                res = [m2, m3, m4][concat](res).join()[split](",");
	                var newres = [];
	                for (var i = 0, ii = res.length; i < ii; i++) {
	                    newres[i] = i % 2 ? rotate(res[i - 1], res[i], rad).y : rotate(res[i], res[i + 1], rad).x;
	                }
	                return newres;
	            }
	        },
	        findDotAtSegment = function (p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t) {
	            var t1 = 1 - t;
	            return {
	                x: pow(t1, 3) * p1x + pow(t1, 2) * 3 * t * c1x + t1 * 3 * t * t * c2x + pow(t, 3) * p2x,
	                y: pow(t1, 3) * p1y + pow(t1, 2) * 3 * t * c1y + t1 * 3 * t * t * c2y + pow(t, 3) * p2y
	            };
	        },
	        curveDim = cacher(function (p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y) {
	            var a = (c2x - 2 * c1x + p1x) - (p2x - 2 * c2x + c1x),
	                b = 2 * (c1x - p1x) - 2 * (c2x - c1x),
	                c = p1x - c1x,
	                t1 = (-b + math.sqrt(b * b - 4 * a * c)) / 2 / a,
	                t2 = (-b - math.sqrt(b * b - 4 * a * c)) / 2 / a,
	                y = [p1y, p2y],
	                x = [p1x, p2x],
	                dot;
	            abs(t1) > "1e12" && (t1 = .5);
	            abs(t2) > "1e12" && (t2 = .5);
	            if (t1 > 0 && t1 < 1) {
	                dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t1);
	                x.push(dot.x);
	                y.push(dot.y);
	            }
	            if (t2 > 0 && t2 < 1) {
	                dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t2);
	                x.push(dot.x);
	                y.push(dot.y);
	            }
	            a = (c2y - 2 * c1y + p1y) - (p2y - 2 * c2y + c1y);
	            b = 2 * (c1y - p1y) - 2 * (c2y - c1y);
	            c = p1y - c1y;
	            t1 = (-b + math.sqrt(b * b - 4 * a * c)) / 2 / a;
	            t2 = (-b - math.sqrt(b * b - 4 * a * c)) / 2 / a;
	            abs(t1) > "1e12" && (t1 = .5);
	            abs(t2) > "1e12" && (t2 = .5);
	            if (t1 > 0 && t1 < 1) {
	                dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t1);
	                x.push(dot.x);
	                y.push(dot.y);
	            }
	            if (t2 > 0 && t2 < 1) {
	                dot = findDotAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, t2);
	                x.push(dot.x);
	                y.push(dot.y);
	            }
	            return {
	                min: {x: mmin[apply](0, x), y: mmin[apply](0, y)},
	                max: {x: mmax[apply](0, x), y: mmax[apply](0, y)}
	            };
	        }),
	        path2curve = R._path2curve = cacher(function (path, path2) {
	            var pth = !path2 && paths(path);
	            if (!path2 && pth.curve) {
	                return pathClone(pth.curve);
	            }
	            var p = pathToAbsolute(path),
	                p2 = path2 && pathToAbsolute(path2),
	                attrs = {x: 0, y: 0, bx: 0, by: 0, X: 0, Y: 0, qx: null, qy: null},
	                attrs2 = {x: 0, y: 0, bx: 0, by: 0, X: 0, Y: 0, qx: null, qy: null},
	                processPath = function (path, d, pcom) {
	                    var nx, ny, tq = {T:1, Q:1};
	                    if (!path) {
	                        return ["C", d.x, d.y, d.x, d.y, d.x, d.y];
	                    }
	                    !(path[0] in tq) && (d.qx = d.qy = null);
	                    switch (path[0]) {
	                        case "M":
	                            d.X = path[1];
	                            d.Y = path[2];
	                            break;
	                        case "A":
	                            path = ["C"][concat](a2c[apply](0, [d.x, d.y][concat](path.slice(1))));
	                            break;
	                        case "S":
	                            if (pcom == "C" || pcom == "S") { // In "S" case we have to take into account, if the previous command is C/S.
	                                nx = d.x * 2 - d.bx;          // And reflect the previous
	                                ny = d.y * 2 - d.by;          // command's control point relative to the current point.
	                            }
	                            else {                            // or some else or nothing
	                                nx = d.x;
	                                ny = d.y;
	                            }
	                            path = ["C", nx, ny][concat](path.slice(1));
	                            break;
	                        case "T":
	                            if (pcom == "Q" || pcom == "T") { // In "T" case we have to take into account, if the previous command is Q/T.
	                                d.qx = d.x * 2 - d.qx;        // And make a reflection similar
	                                d.qy = d.y * 2 - d.qy;        // to case "S".
	                            }
	                            else {                            // or something else or nothing
	                                d.qx = d.x;
	                                d.qy = d.y;
	                            }
	                            path = ["C"][concat](q2c(d.x, d.y, d.qx, d.qy, path[1], path[2]));
	                            break;
	                        case "Q":
	                            d.qx = path[1];
	                            d.qy = path[2];
	                            path = ["C"][concat](q2c(d.x, d.y, path[1], path[2], path[3], path[4]));
	                            break;
	                        case "L":
	                            path = ["C"][concat](l2c(d.x, d.y, path[1], path[2]));
	                            break;
	                        case "H":
	                            path = ["C"][concat](l2c(d.x, d.y, path[1], d.y));
	                            break;
	                        case "V":
	                            path = ["C"][concat](l2c(d.x, d.y, d.x, path[1]));
	                            break;
	                        case "Z":
	                            path = ["C"][concat](l2c(d.x, d.y, d.X, d.Y));
	                            break;
	                    }
	                    return path;
	                },
	                fixArc = function (pp, i) {
	                    if (pp[i].length > 7) {
	                        pp[i].shift();
	                        var pi = pp[i];
	                        while (pi.length) {
	                            pcoms1[i]="A"; // if created multiple C:s, their original seg is saved
	                            p2 && (pcoms2[i]="A"); // the same as above
	                            pp.splice(i++, 0, ["C"][concat](pi.splice(0, 6)));
	                        }
	                        pp.splice(i, 1);
	                        ii = mmax(p.length, p2 && p2.length || 0);
	                    }
	                },
	                fixM = function (path1, path2, a1, a2, i) {
	                    if (path1 && path2 && path1[i][0] == "M" && path2[i][0] != "M") {
	                        path2.splice(i, 0, ["M", a2.x, a2.y]);
	                        a1.bx = 0;
	                        a1.by = 0;
	                        a1.x = path1[i][1];
	                        a1.y = path1[i][2];
	                        ii = mmax(p.length, p2 && p2.length || 0);
	                    }
	                },
	                pcoms1 = [], // path commands of original path p
	                pcoms2 = [], // path commands of original path p2
	                pfirst = "", // temporary holder for original path command
	                pcom = ""; // holder for previous path command of original path
	            for (var i = 0, ii = mmax(p.length, p2 && p2.length || 0); i < ii; i++) {
	                p[i] && (pfirst = p[i][0]); // save current path command

	                if (pfirst != "C") // C is not saved yet, because it may be result of conversion
	                {
	                    pcoms1[i] = pfirst; // Save current path command
	                    i && ( pcom = pcoms1[i-1]); // Get previous path command pcom
	                }
	                p[i] = processPath(p[i], attrs, pcom); // Previous path command is inputted to processPath

	                if (pcoms1[i] != "A" && pfirst == "C") pcoms1[i] = "C"; // A is the only command
	                // which may produce multiple C:s
	                // so we have to make sure that C is also C in original path

	                fixArc(p, i); // fixArc adds also the right amount of A:s to pcoms1

	                if (p2) { // the same procedures is done to p2
	                    p2[i] && (pfirst = p2[i][0]);
	                    if (pfirst != "C")
	                    {
	                        pcoms2[i] = pfirst;
	                        i && (pcom = pcoms2[i-1]);
	                    }
	                    p2[i] = processPath(p2[i], attrs2, pcom);

	                    if (pcoms2[i]!="A" && pfirst=="C") pcoms2[i]="C";

	                    fixArc(p2, i);
	                }
	                fixM(p, p2, attrs, attrs2, i);
	                fixM(p2, p, attrs2, attrs, i);
	                var seg = p[i],
	                    seg2 = p2 && p2[i],
	                    seglen = seg.length,
	                    seg2len = p2 && seg2.length;
	                attrs.x = seg[seglen - 2];
	                attrs.y = seg[seglen - 1];
	                attrs.bx = toFloat(seg[seglen - 4]) || attrs.x;
	                attrs.by = toFloat(seg[seglen - 3]) || attrs.y;
	                attrs2.bx = p2 && (toFloat(seg2[seg2len - 4]) || attrs2.x);
	                attrs2.by = p2 && (toFloat(seg2[seg2len - 3]) || attrs2.y);
	                attrs2.x = p2 && seg2[seg2len - 2];
	                attrs2.y = p2 && seg2[seg2len - 1];
	            }
	            if (!p2) {
	                pth.curve = pathClone(p);
	            }
	            return p2 ? [p, p2] : p;
	        }, null, pathClone),
	        parseDots = R._parseDots = cacher(function (gradient) {
	            var dots = [];
	            for (var i = 0, ii = gradient.length; i < ii; i++) {
	                var dot = {},
	                    par = gradient[i].match(/^([^:]*):?([\d\.]*)/);
	                dot.color = R.getRGB(par[1]);
	                if (dot.color.error) {
	                    return null;
	                }
	                dot.opacity = dot.color.opacity;
	                dot.color = dot.color.hex;
	                par[2] && (dot.offset = par[2] + "%");
	                dots.push(dot);
	            }
	            for (i = 1, ii = dots.length - 1; i < ii; i++) {
	                if (!dots[i].offset) {
	                    var start = toFloat(dots[i - 1].offset || 0),
	                        end = 0;
	                    for (var j = i + 1; j < ii; j++) {
	                        if (dots[j].offset) {
	                            end = dots[j].offset;
	                            break;
	                        }
	                    }
	                    if (!end) {
	                        end = 100;
	                        j = ii;
	                    }
	                    end = toFloat(end);
	                    var d = (end - start) / (j - i + 1);
	                    for (; i < j; i++) {
	                        start += d;
	                        dots[i].offset = start + "%";
	                    }
	                }
	            }
	            return dots;
	        }),
	        tear = R._tear = function (el, paper) {
	            el == paper.top && (paper.top = el.prev);
	            el == paper.bottom && (paper.bottom = el.next);
	            el.next && (el.next.prev = el.prev);
	            el.prev && (el.prev.next = el.next);
	        },
	        tofront = R._tofront = function (el, paper) {
	            if (paper.top === el) {
	                return;
	            }
	            tear(el, paper);
	            el.next = null;
	            el.prev = paper.top;
	            paper.top.next = el;
	            paper.top = el;
	        },
	        toback = R._toback = function (el, paper) {
	            if (paper.bottom === el) {
	                return;
	            }
	            tear(el, paper);
	            el.next = paper.bottom;
	            el.prev = null;
	            paper.bottom.prev = el;
	            paper.bottom = el;
	        },
	        insertafter = R._insertafter = function (el, el2, paper) {
	            tear(el, paper);
	            el2 == paper.top && (paper.top = el);
	            el2.next && (el2.next.prev = el);
	            el.next = el2.next;
	            el.prev = el2;
	            el2.next = el;
	        },
	        insertbefore = R._insertbefore = function (el, el2, paper) {
	            tear(el, paper);
	            el2 == paper.bottom && (paper.bottom = el);
	            el2.prev && (el2.prev.next = el);
	            el.prev = el2.prev;
	            el2.prev = el;
	            el.next = el2;
	        },
	        /*\
	         * Raphael.toMatrix
	         [ method ]
	         **
	         * Utility method
	         **
	         * Returns matrix of transformations applied to a given path
	         > Parameters
	         - path (string) path string
	         - transform (string|array) transformation string
	         = (object) @Matrix
	        \*/
	        toMatrix = R.toMatrix = function (path, transform) {
	            var bb = pathDimensions(path),
	                el = {
	                    _: {
	                        transform: E
	                    },
	                    getBBox: function () {
	                        return bb;
	                    }
	                };
	            extractTransform(el, transform);
	            return el.matrix;
	        },
	        /*\
	         * Raphael.transformPath
	         [ method ]
	         **
	         * Utility method
	         **
	         * Returns path transformed by a given transformation
	         > Parameters
	         - path (string) path string
	         - transform (string|array) transformation string
	         = (string) path
	        \*/
	        transformPath = R.transformPath = function (path, transform) {
	            return mapPath(path, toMatrix(path, transform));
	        },
	        extractTransform = R._extractTransform = function (el, tstr) {
	            if (tstr == null) {
	                return el._.transform;
	            }
	            tstr = Str(tstr).replace(/\.{3}|\u2026/g, el._.transform || E);
	            var tdata = R.parseTransformString(tstr),
	                deg = 0,
	                dx = 0,
	                dy = 0,
	                sx = 1,
	                sy = 1,
	                _ = el._,
	                m = new Matrix;
	            _.transform = tdata || [];
	            if (tdata) {
	                for (var i = 0, ii = tdata.length; i < ii; i++) {
	                    var t = tdata[i],
	                        tlen = t.length,
	                        command = Str(t[0]).toLowerCase(),
	                        absolute = t[0] != command,
	                        inver = absolute ? m.invert() : 0,
	                        x1,
	                        y1,
	                        x2,
	                        y2,
	                        bb;
	                    if (command == "t" && tlen == 3) {
	                        if (absolute) {
	                            x1 = inver.x(0, 0);
	                            y1 = inver.y(0, 0);
	                            x2 = inver.x(t[1], t[2]);
	                            y2 = inver.y(t[1], t[2]);
	                            m.translate(x2 - x1, y2 - y1);
	                        } else {
	                            m.translate(t[1], t[2]);
	                        }
	                    } else if (command == "r") {
	                        if (tlen == 2) {
	                            bb = bb || el.getBBox(1);
	                            m.rotate(t[1], bb.x + bb.width / 2, bb.y + bb.height / 2);
	                            deg += t[1];
	                        } else if (tlen == 4) {
	                            if (absolute) {
	                                x2 = inver.x(t[2], t[3]);
	                                y2 = inver.y(t[2], t[3]);
	                                m.rotate(t[1], x2, y2);
	                            } else {
	                                m.rotate(t[1], t[2], t[3]);
	                            }
	                            deg += t[1];
	                        }
	                    } else if (command == "s") {
	                        if (tlen == 2 || tlen == 3) {
	                            bb = bb || el.getBBox(1);
	                            m.scale(t[1], t[tlen - 1], bb.x + bb.width / 2, bb.y + bb.height / 2);
	                            sx *= t[1];
	                            sy *= t[tlen - 1];
	                        } else if (tlen == 5) {
	                            if (absolute) {
	                                x2 = inver.x(t[3], t[4]);
	                                y2 = inver.y(t[3], t[4]);
	                                m.scale(t[1], t[2], x2, y2);
	                            } else {
	                                m.scale(t[1], t[2], t[3], t[4]);
	                            }
	                            sx *= t[1];
	                            sy *= t[2];
	                        }
	                    } else if (command == "m" && tlen == 7) {
	                        m.add(t[1], t[2], t[3], t[4], t[5], t[6]);
	                    }
	                    _.dirtyT = 1;
	                    el.matrix = m;
	                }
	            }

	            /*\
	             * Element.matrix
	             [ property (object) ]
	             **
	             * Keeps @Matrix object, which represents element transformation
	            \*/
	            el.matrix = m;

	            _.sx = sx;
	            _.sy = sy;
	            _.deg = deg;
	            _.dx = dx = m.e;
	            _.dy = dy = m.f;

	            if (sx == 1 && sy == 1 && !deg && _.bbox) {
	                _.bbox.x += +dx;
	                _.bbox.y += +dy;
	            } else {
	                _.dirtyT = 1;
	            }
	        },
	        getEmpty = function (item) {
	            var l = item[0];
	            switch (l.toLowerCase()) {
	                case "t": return [l, 0, 0];
	                case "m": return [l, 1, 0, 0, 1, 0, 0];
	                case "r": if (item.length == 4) {
	                    return [l, 0, item[2], item[3]];
	                } else {
	                    return [l, 0];
	                }
	                case "s": if (item.length == 5) {
	                    return [l, 1, 1, item[3], item[4]];
	                } else if (item.length == 3) {
	                    return [l, 1, 1];
	                } else {
	                    return [l, 1];
	                }
	            }
	        },
	        equaliseTransform = R._equaliseTransform = function (t1, t2) {
	            t2 = Str(t2).replace(/\.{3}|\u2026/g, t1);
	            t1 = R.parseTransformString(t1) || [];
	            t2 = R.parseTransformString(t2) || [];
	            var maxlength = mmax(t1.length, t2.length),
	                from = [],
	                to = [],
	                i = 0, j, jj,
	                tt1, tt2;
	            for (; i < maxlength; i++) {
	                tt1 = t1[i] || getEmpty(t2[i]);
	                tt2 = t2[i] || getEmpty(tt1);
	                if ((tt1[0] != tt2[0]) ||
	                    (tt1[0].toLowerCase() == "r" && (tt1[2] != tt2[2] || tt1[3] != tt2[3])) ||
	                    (tt1[0].toLowerCase() == "s" && (tt1[3] != tt2[3] || tt1[4] != tt2[4]))
	                    ) {
	                    return;
	                }
	                from[i] = [];
	                to[i] = [];
	                for (j = 0, jj = mmax(tt1.length, tt2.length); j < jj; j++) {
	                    j in tt1 && (from[i][j] = tt1[j]);
	                    j in tt2 && (to[i][j] = tt2[j]);
	                }
	            }
	            return {
	                from: from,
	                to: to
	            };
	        };
	    R._getContainer = function (x, y, w, h) {
	        var container;
	        container = h == null && !R.is(x, "object") ? g.doc.getElementById(x) : x;
	        if (container == null) {
	            return;
	        }
	        if (container.tagName) {
	            if (y == null) {
	                return {
	                    container: container,
	                    width: container.style.pixelWidth || container.offsetWidth,
	                    height: container.style.pixelHeight || container.offsetHeight
	                };
	            } else {
	                return {
	                    container: container,
	                    width: y,
	                    height: w
	                };
	            }
	        }
	        return {
	            container: 1,
	            x: x,
	            y: y,
	            width: w,
	            height: h
	        };
	    };
	    /*\
	     * Raphael.pathToRelative
	     [ method ]
	     **
	     * Utility method
	     **
	     * Converts path to relative form
	     > Parameters
	     - pathString (string|array) path string or array of segments
	     = (array) array of segments.
	    \*/
	    R.pathToRelative = pathToRelative;
	    R._engine = {};
	    /*\
	     * Raphael.path2curve
	     [ method ]
	     **
	     * Utility method
	     **
	     * Converts path to a new path where all segments are cubic bezier curves.
	     > Parameters
	     - pathString (string|array) path string or array of segments
	     = (array) array of segments.
	    \*/
	    R.path2curve = path2curve;
	    /*\
	     * Raphael.matrix
	     [ method ]
	     **
	     * Utility method
	     **
	     * Returns matrix based on given parameters.
	     > Parameters
	     - a (number)
	     - b (number)
	     - c (number)
	     - d (number)
	     - e (number)
	     - f (number)
	     = (object) @Matrix
	    \*/
	    R.matrix = function (a, b, c, d, e, f) {
	        return new Matrix(a, b, c, d, e, f);
	    };
	    function Matrix(a, b, c, d, e, f) {
	        if (a != null) {
	            this.a = +a;
	            this.b = +b;
	            this.c = +c;
	            this.d = +d;
	            this.e = +e;
	            this.f = +f;
	        } else {
	            this.a = 1;
	            this.b = 0;
	            this.c = 0;
	            this.d = 1;
	            this.e = 0;
	            this.f = 0;
	        }
	    }
	    (function (matrixproto) {
	        /*\
	         * Matrix.add
	         [ method ]
	         **
	         * Adds given matrix to existing one.
	         > Parameters
	         - a (number)
	         - b (number)
	         - c (number)
	         - d (number)
	         - e (number)
	         - f (number)
	         or
	         - matrix (object) @Matrix
	        \*/
	        matrixproto.add = function (a, b, c, d, e, f) {
	            var out = [[], [], []],
	                m = [[this.a, this.c, this.e], [this.b, this.d, this.f], [0, 0, 1]],
	                matrix = [[a, c, e], [b, d, f], [0, 0, 1]],
	                x, y, z, res;

	            if (a && a instanceof Matrix) {
	                matrix = [[a.a, a.c, a.e], [a.b, a.d, a.f], [0, 0, 1]];
	            }

	            for (x = 0; x < 3; x++) {
	                for (y = 0; y < 3; y++) {
	                    res = 0;
	                    for (z = 0; z < 3; z++) {
	                        res += m[x][z] * matrix[z][y];
	                    }
	                    out[x][y] = res;
	                }
	            }
	            this.a = out[0][0];
	            this.b = out[1][0];
	            this.c = out[0][1];
	            this.d = out[1][1];
	            this.e = out[0][2];
	            this.f = out[1][2];
	        };
	        /*\
	         * Matrix.invert
	         [ method ]
	         **
	         * Returns inverted version of the matrix
	         = (object) @Matrix
	        \*/
	        matrixproto.invert = function () {
	            var me = this,
	                x = me.a * me.d - me.b * me.c;
	            return new Matrix(me.d / x, -me.b / x, -me.c / x, me.a / x, (me.c * me.f - me.d * me.e) / x, (me.b * me.e - me.a * me.f) / x);
	        };
	        /*\
	         * Matrix.clone
	         [ method ]
	         **
	         * Returns copy of the matrix
	         = (object) @Matrix
	        \*/
	        matrixproto.clone = function () {
	            return new Matrix(this.a, this.b, this.c, this.d, this.e, this.f);
	        };
	        /*\
	         * Matrix.translate
	         [ method ]
	         **
	         * Translate the matrix
	         > Parameters
	         - x (number)
	         - y (number)
	        \*/
	        matrixproto.translate = function (x, y) {
	            this.add(1, 0, 0, 1, x, y);
	        };
	        /*\
	         * Matrix.scale
	         [ method ]
	         **
	         * Scales the matrix
	         > Parameters
	         - x (number)
	         - y (number) #optional
	         - cx (number) #optional
	         - cy (number) #optional
	        \*/
	        matrixproto.scale = function (x, y, cx, cy) {
	            y == null && (y = x);
	            (cx || cy) && this.add(1, 0, 0, 1, cx, cy);
	            this.add(x, 0, 0, y, 0, 0);
	            (cx || cy) && this.add(1, 0, 0, 1, -cx, -cy);
	        };
	        /*\
	         * Matrix.rotate
	         [ method ]
	         **
	         * Rotates the matrix
	         > Parameters
	         - a (number)
	         - x (number)
	         - y (number)
	        \*/
	        matrixproto.rotate = function (a, x, y) {
	            a = R.rad(a);
	            x = x || 0;
	            y = y || 0;
	            var cos = +math.cos(a).toFixed(9),
	                sin = +math.sin(a).toFixed(9);
	            this.add(cos, sin, -sin, cos, x, y);
	            this.add(1, 0, 0, 1, -x, -y);
	        };
	        /*\
	         * Matrix.x
	         [ method ]
	         **
	         * Return x coordinate for given point after transformation described by the matrix. See also @Matrix.y
	         > Parameters
	         - x (number)
	         - y (number)
	         = (number) x
	        \*/
	        matrixproto.x = function (x, y) {
	            return x * this.a + y * this.c + this.e;
	        };
	        /*\
	         * Matrix.y
	         [ method ]
	         **
	         * Return y coordinate for given point after transformation described by the matrix. See also @Matrix.x
	         > Parameters
	         - x (number)
	         - y (number)
	         = (number) y
	        \*/
	        matrixproto.y = function (x, y) {
	            return x * this.b + y * this.d + this.f;
	        };
	        matrixproto.get = function (i) {
	            return +this[Str.fromCharCode(97 + i)].toFixed(4);
	        };
	        matrixproto.toString = function () {
	            return R.svg ?
	                "matrix(" + [this.get(0), this.get(1), this.get(2), this.get(3), this.get(4), this.get(5)].join() + ")" :
	                [this.get(0), this.get(2), this.get(1), this.get(3), 0, 0].join();
	        };
	        matrixproto.toFilter = function () {
	            return "progid:DXImageTransform.Microsoft.Matrix(M11=" + this.get(0) +
	                ", M12=" + this.get(2) + ", M21=" + this.get(1) + ", M22=" + this.get(3) +
	                ", Dx=" + this.get(4) + ", Dy=" + this.get(5) + ", sizingmethod='auto expand')";
	        };
	        matrixproto.offset = function () {
	            return [this.e.toFixed(4), this.f.toFixed(4)];
	        };
	        function norm(a) {
	            return a[0] * a[0] + a[1] * a[1];
	        }
	        function normalize(a) {
	            var mag = math.sqrt(norm(a));
	            a[0] && (a[0] /= mag);
	            a[1] && (a[1] /= mag);
	        }
	        /*\
	         * Matrix.split
	         [ method ]
	         **
	         * Splits matrix into primitive transformations
	         = (object) in format:
	         o dx (number) translation by x
	         o dy (number) translation by y
	         o scalex (number) scale by x
	         o scaley (number) scale by y
	         o shear (number) shear
	         o rotate (number) rotation in deg
	         o isSimple (boolean) could it be represented via simple transformations
	        \*/
	        matrixproto.split = function () {
	            var out = {};
	            // translation
	            out.dx = this.e;
	            out.dy = this.f;

	            // scale and shear
	            var row = [[this.a, this.c], [this.b, this.d]];
	            out.scalex = math.sqrt(norm(row[0]));
	            normalize(row[0]);

	            out.shear = row[0][0] * row[1][0] + row[0][1] * row[1][1];
	            row[1] = [row[1][0] - row[0][0] * out.shear, row[1][1] - row[0][1] * out.shear];

	            out.scaley = math.sqrt(norm(row[1]));
	            normalize(row[1]);
	            out.shear /= out.scaley;

	            // rotation
	            var sin = -row[0][1],
	                cos = row[1][1];
	            if (cos < 0) {
	                out.rotate = R.deg(math.acos(cos));
	                if (sin < 0) {
	                    out.rotate = 360 - out.rotate;
	                }
	            } else {
	                out.rotate = R.deg(math.asin(sin));
	            }

	            out.isSimple = !+out.shear.toFixed(9) && (out.scalex.toFixed(9) == out.scaley.toFixed(9) || !out.rotate);
	            out.isSuperSimple = !+out.shear.toFixed(9) && out.scalex.toFixed(9) == out.scaley.toFixed(9) && !out.rotate;
	            out.noRotation = !+out.shear.toFixed(9) && !out.rotate;
	            return out;
	        };
	        /*\
	         * Matrix.toTransformString
	         [ method ]
	         **
	         * Return transform string that represents given matrix
	         = (string) transform string
	        \*/
	        matrixproto.toTransformString = function (shorter) {
	            var s = shorter || this[split]();
	            if (s.isSimple) {
	                s.scalex = +s.scalex.toFixed(4);
	                s.scaley = +s.scaley.toFixed(4);
	                s.rotate = +s.rotate.toFixed(4);
	                return  (s.dx || s.dy ? "t" + [s.dx, s.dy] : E) +
	                        (s.scalex != 1 || s.scaley != 1 ? "s" + [s.scalex, s.scaley, 0, 0] : E) +
	                        (s.rotate ? "r" + [s.rotate, 0, 0] : E);
	            } else {
	                return "m" + [this.get(0), this.get(1), this.get(2), this.get(3), this.get(4), this.get(5)];
	            }
	        };
	    })(Matrix.prototype);

	    var preventDefault = function () {
	        this.returnValue = false;
	    },
	    preventTouch = function () {
	        return this.originalEvent.preventDefault();
	    },
	    stopPropagation = function () {
	        this.cancelBubble = true;
	    },
	    stopTouch = function () {
	        return this.originalEvent.stopPropagation();
	    },
	    getEventPosition = function (e) {
	        var scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop,
	            scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft;

	        return {
	            x: e.clientX + scrollX,
	            y: e.clientY + scrollY
	        };
	    },
	    addEvent = (function () {
	        if (g.doc.addEventListener) {
	            return function (obj, type, fn, element) {
	                var f = function (e) {
	                    var pos = getEventPosition(e);
	                    return fn.call(element, e, pos.x, pos.y);
	                };
	                obj.addEventListener(type, f, false);

	                if (supportsTouch && touchMap[type]) {
	                    var _f = function (e) {
	                        var pos = getEventPosition(e),
	                            olde = e;

	                        for (var i = 0, ii = e.targetTouches && e.targetTouches.length; i < ii; i++) {
	                            if (e.targetTouches[i].target == obj) {
	                                e = e.targetTouches[i];
	                                e.originalEvent = olde;
	                                e.preventDefault = preventTouch;
	                                e.stopPropagation = stopTouch;
	                                break;
	                            }
	                        }

	                        return fn.call(element, e, pos.x, pos.y);
	                    };
	                    obj.addEventListener(touchMap[type], _f, false);
	                }

	                return function () {
	                    obj.removeEventListener(type, f, false);

	                    if (supportsTouch && touchMap[type])
	                        obj.removeEventListener(touchMap[type], _f, false);

	                    return true;
	                };
	            };
	        } else if (g.doc.attachEvent) {
	            return function (obj, type, fn, element) {
	                var f = function (e) {
	                    e = e || g.win.event;
	                    var scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop,
	                        scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft,
	                        x = e.clientX + scrollX,
	                        y = e.clientY + scrollY;
	                    e.preventDefault = e.preventDefault || preventDefault;
	                    e.stopPropagation = e.stopPropagation || stopPropagation;
	                    return fn.call(element, e, x, y);
	                };
	                obj.attachEvent("on" + type, f);
	                var detacher = function () {
	                    obj.detachEvent("on" + type, f);
	                    return true;
	                };
	                return detacher;
	            };
	        }
	    })(),
	    drag = [],
	    dragMove = function (e) {
	        var x = e.clientX,
	            y = e.clientY,
	            scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop,
	            scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft,
	            dragi,
	            j = drag.length;
	        while (j--) {
	            dragi = drag[j];
	            if (supportsTouch && e.touches) {
	                var i = e.touches.length,
	                    touch;
	                while (i--) {
	                    touch = e.touches[i];
	                    if (touch.identifier == dragi.el._drag.id) {
	                        x = touch.clientX;
	                        y = touch.clientY;
	                        (e.originalEvent ? e.originalEvent : e).preventDefault();
	                        break;
	                    }
	                }
	            } else {
	                e.preventDefault();
	            }
	            var node = dragi.el.node,
	                o,
	                next = node.nextSibling,
	                parent = node.parentNode,
	                display = node.style.display;
	            g.win.opera && parent.removeChild(node);
	            node.style.display = "none";
	            o = dragi.el.paper.getElementByPoint(x, y);
	            node.style.display = display;
	            g.win.opera && (next ? parent.insertBefore(node, next) : parent.appendChild(node));
	            o && eve("raphael.drag.over." + dragi.el.id, dragi.el, o);
	            x += scrollX;
	            y += scrollY;
	            eve("raphael.drag.move." + dragi.el.id, dragi.move_scope || dragi.el, x - dragi.el._drag.x, y - dragi.el._drag.y, x, y, e);
	        }
	    },
	    dragUp = function (e) {
	        R.unmousemove(dragMove).unmouseup(dragUp);
	        var i = drag.length,
	            dragi;
	        while (i--) {
	            dragi = drag[i];
	            dragi.el._drag = {};
	            eve("raphael.drag.end." + dragi.el.id, dragi.end_scope || dragi.start_scope || dragi.move_scope || dragi.el, e);
	        }
	        drag = [];
	    },
	    /*\
	     * Raphael.el
	     [ property (object) ]
	     **
	     * You can add your own method to elements. This is useful when you want to hack default functionality or
	     * want to wrap some common transformation or attributes in one method. In difference to canvas methods,
	     * you can redefine element method at any time. Expending element methods wouldn’t affect set.
	     > Usage
	     | Raphael.el.red = function () {
	     |     this.attr({fill: "#f00"});
	     | };
	     | // then use it
	     | paper.circle(100, 100, 20).red();
	    \*/
	    elproto = R.el = {};
	    /*\
	     * Element.click
	     [ method ]
	     **
	     * Adds event handler for click for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unclick
	     [ method ]
	     **
	     * Removes event handler for click for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.dblclick
	     [ method ]
	     **
	     * Adds event handler for double click for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.undblclick
	     [ method ]
	     **
	     * Removes event handler for double click for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.mousedown
	     [ method ]
	     **
	     * Adds event handler for mousedown for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unmousedown
	     [ method ]
	     **
	     * Removes event handler for mousedown for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.mousemove
	     [ method ]
	     **
	     * Adds event handler for mousemove for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unmousemove
	     [ method ]
	     **
	     * Removes event handler for mousemove for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.mouseout
	     [ method ]
	     **
	     * Adds event handler for mouseout for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unmouseout
	     [ method ]
	     **
	     * Removes event handler for mouseout for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.mouseover
	     [ method ]
	     **
	     * Adds event handler for mouseover for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unmouseover
	     [ method ]
	     **
	     * Removes event handler for mouseover for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.mouseup
	     [ method ]
	     **
	     * Adds event handler for mouseup for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.unmouseup
	     [ method ]
	     **
	     * Removes event handler for mouseup for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.touchstart
	     [ method ]
	     **
	     * Adds event handler for touchstart for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.untouchstart
	     [ method ]
	     **
	     * Removes event handler for touchstart for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.touchmove
	     [ method ]
	     **
	     * Adds event handler for touchmove for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.untouchmove
	     [ method ]
	     **
	     * Removes event handler for touchmove for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.touchend
	     [ method ]
	     **
	     * Adds event handler for touchend for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.untouchend
	     [ method ]
	     **
	     * Removes event handler for touchend for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/

	    /*\
	     * Element.touchcancel
	     [ method ]
	     **
	     * Adds event handler for touchcancel for the element.
	     > Parameters
	     - handler (function) handler for the event
	     = (object) @Element
	    \*/
	    /*\
	     * Element.untouchcancel
	     [ method ]
	     **
	     * Removes event handler for touchcancel for the element.
	     > Parameters
	     - handler (function) #optional handler for the event
	     = (object) @Element
	    \*/
	    for (var i = events.length; i--;) {
	        (function (eventName) {
	            R[eventName] = elproto[eventName] = function (fn, scope) {
	                if (R.is(fn, "function")) {
	                    this.events = this.events || [];
	                    this.events.push({name: eventName, f: fn, unbind: addEvent(this.shape || this.node || g.doc, eventName, fn, scope || this)});
	                }
	                return this;
	            };
	            R["un" + eventName] = elproto["un" + eventName] = function (fn) {
	                var events = this.events || [],
	                    l = events.length;
	                while (l--){
	                    if (events[l].name == eventName && (R.is(fn, "undefined") || events[l].f == fn)) {
	                        events[l].unbind();
	                        events.splice(l, 1);
	                        !events.length && delete this.events;
	                    }
	                }
	                return this;
	            };
	        })(events[i]);
	    }

	    /*\
	     * Element.data
	     [ method ]
	     **
	     * Adds or retrieves given value associated with given key.
	     **
	     * See also @Element.removeData
	     > Parameters
	     - key (string) key to store data
	     - value (any) #optional value to store
	     = (object) @Element
	     * or, if value is not specified:
	     = (any) value
	     * or, if key and value are not specified:
	     = (object) Key/value pairs for all the data associated with the element.
	     > Usage
	     | for (var i = 0, i < 5, i++) {
	     |     paper.circle(10 + 15 * i, 10, 10)
	     |          .attr({fill: "#000"})
	     |          .data("i", i)
	     |          .click(function () {
	     |             alert(this.data("i"));
	     |          });
	     | }
	    \*/
	    elproto.data = function (key, value) {
	        var data = eldata[this.id] = eldata[this.id] || {};
	        if (arguments.length == 0) {
	            return data;
	        }
	        if (arguments.length == 1) {
	            if (R.is(key, "object")) {
	                for (var i in key) if (key[has](i)) {
	                    this.data(i, key[i]);
	                }
	                return this;
	            }
	            eve("raphael.data.get." + this.id, this, data[key], key);
	            return data[key];
	        }
	        data[key] = value;
	        eve("raphael.data.set." + this.id, this, value, key);
	        return this;
	    };
	    /*\
	     * Element.removeData
	     [ method ]
	     **
	     * Removes value associated with an element by given key.
	     * If key is not provided, removes all the data of the element.
	     > Parameters
	     - key (string) #optional key
	     = (object) @Element
	    \*/
	    elproto.removeData = function (key) {
	        if (key == null) {
	            eldata[this.id] = {};
	        } else {
	            eldata[this.id] && delete eldata[this.id][key];
	        }
	        return this;
	    };
	     /*\
	     * Element.getData
	     [ method ]
	     **
	     * Retrieves the element data
	     = (object) data
	    \*/
	    elproto.getData = function () {
	        return clone(eldata[this.id] || {});
	    };
	    /*\
	     * Element.hover
	     [ method ]
	     **
	     * Adds event handlers for hover for the element.
	     > Parameters
	     - f_in (function) handler for hover in
	     - f_out (function) handler for hover out
	     - icontext (object) #optional context for hover in handler
	     - ocontext (object) #optional context for hover out handler
	     = (object) @Element
	    \*/
	    elproto.hover = function (f_in, f_out, scope_in, scope_out) {
	        return this.mouseover(f_in, scope_in).mouseout(f_out, scope_out || scope_in);
	    };
	    /*\
	     * Element.unhover
	     [ method ]
	     **
	     * Removes event handlers for hover for the element.
	     > Parameters
	     - f_in (function) handler for hover in
	     - f_out (function) handler for hover out
	     = (object) @Element
	    \*/
	    elproto.unhover = function (f_in, f_out) {
	        return this.unmouseover(f_in).unmouseout(f_out);
	    };
	    var draggable = [];
	    /*\
	     * Element.drag
	     [ method ]
	     **
	     * Adds event handlers for drag of the element.
	     > Parameters
	     - onmove (function) handler for moving
	     - onstart (function) handler for drag start
	     - onend (function) handler for drag end
	     - mcontext (object) #optional context for moving handler
	     - scontext (object) #optional context for drag start handler
	     - econtext (object) #optional context for drag end handler
	     * Additionally following `drag` events will be triggered: `drag.start.<id>` on start,
	     * `drag.end.<id>` on end and `drag.move.<id>` on every move. When element will be dragged over another element
	     * `drag.over.<id>` will be fired as well.
	     *
	     * Start event and start handler will be called in specified context or in context of the element with following parameters:
	     o x (number) x position of the mouse
	     o y (number) y position of the mouse
	     o event (object) DOM event object
	     * Move event and move handler will be called in specified context or in context of the element with following parameters:
	     o dx (number) shift by x from the start point
	     o dy (number) shift by y from the start point
	     o x (number) x position of the mouse
	     o y (number) y position of the mouse
	     o event (object) DOM event object
	     * End event and end handler will be called in specified context or in context of the element with following parameters:
	     o event (object) DOM event object
	     = (object) @Element
	    \*/
	    elproto.drag = function (onmove, onstart, onend, move_scope, start_scope, end_scope) {
	        function start(e) {
	            (e.originalEvent || e).preventDefault();
	            var x = e.clientX,
	                y = e.clientY,
	                scrollY = g.doc.documentElement.scrollTop || g.doc.body.scrollTop,
	                scrollX = g.doc.documentElement.scrollLeft || g.doc.body.scrollLeft;
	            this._drag.id = e.identifier;
	            if (supportsTouch && e.touches) {
	                var i = e.touches.length, touch;
	                while (i--) {
	                    touch = e.touches[i];
	                    this._drag.id = touch.identifier;
	                    if (touch.identifier == this._drag.id) {
	                        x = touch.clientX;
	                        y = touch.clientY;
	                        break;
	                    }
	                }
	            }
	            this._drag.x = x + scrollX;
	            this._drag.y = y + scrollY;
	            !drag.length && R.mousemove(dragMove).mouseup(dragUp);
	            drag.push({el: this, move_scope: move_scope, start_scope: start_scope, end_scope: end_scope});
	            onstart && eve.on("raphael.drag.start." + this.id, onstart);
	            onmove && eve.on("raphael.drag.move." + this.id, onmove);
	            onend && eve.on("raphael.drag.end." + this.id, onend);
	            eve("raphael.drag.start." + this.id, start_scope || move_scope || this, e.clientX + scrollX, e.clientY + scrollY, e);
	        }
	        this._drag = {};
	        draggable.push({el: this, start: start});
	        this.mousedown(start);
	        return this;
	    };
	    /*\
	     * Element.onDragOver
	     [ method ]
	     **
	     * Shortcut for assigning event handler for `drag.over.<id>` event, where id is id of the element (see @Element.id).
	     > Parameters
	     - f (function) handler for event, first argument would be the element you are dragging over
	    \*/
	    elproto.onDragOver = function (f) {
	        f ? eve.on("raphael.drag.over." + this.id, f) : eve.unbind("raphael.drag.over." + this.id);
	    };
	    /*\
	     * Element.undrag
	     [ method ]
	     **
	     * Removes all drag event handlers from given element.
	    \*/
	    elproto.undrag = function () {
	        var i = draggable.length;
	        while (i--) if (draggable[i].el == this) {
	            this.unmousedown(draggable[i].start);
	            draggable.splice(i, 1);
	            eve.unbind("raphael.drag.*." + this.id);
	        }
	        !draggable.length && R.unmousemove(dragMove).unmouseup(dragUp);
	        drag = [];
	    };
	    /*\
	     * Paper.circle
	     [ method ]
	     **
	     * Draws a circle.
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the centre
	     - y (number) y coordinate of the centre
	     - r (number) radius
	     = (object) Raphaël element object with type “circle”
	     **
	     > Usage
	     | var c = paper.circle(50, 50, 40);
	    \*/
	    paperproto.circle = function (x, y, r) {
	        var out = R._engine.circle(this, x || 0, y || 0, r || 0);
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.rect
	     [ method ]
	     *
	     * Draws a rectangle.
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the top left corner
	     - y (number) y coordinate of the top left corner
	     - width (number) width
	     - height (number) height
	     - r (number) #optional radius for rounded corners, default is 0
	     = (object) Raphaël element object with type “rect”
	     **
	     > Usage
	     | // regular rectangle
	     | var c = paper.rect(10, 10, 50, 50);
	     | // rectangle with rounded corners
	     | var c = paper.rect(40, 40, 50, 50, 10);
	    \*/
	    paperproto.rect = function (x, y, w, h, r) {
	        var out = R._engine.rect(this, x || 0, y || 0, w || 0, h || 0, r || 0);
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.ellipse
	     [ method ]
	     **
	     * Draws an ellipse.
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the centre
	     - y (number) y coordinate of the centre
	     - rx (number) horizontal radius
	     - ry (number) vertical radius
	     = (object) Raphaël element object with type “ellipse”
	     **
	     > Usage
	     | var c = paper.ellipse(50, 50, 40, 20);
	    \*/
	    paperproto.ellipse = function (x, y, rx, ry) {
	        var out = R._engine.ellipse(this, x || 0, y || 0, rx || 0, ry || 0);
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.path
	     [ method ]
	     **
	     * Creates a path element by given path data string.
	     > Parameters
	     - pathString (string) #optional path string in SVG format.
	     * Path string consists of one-letter commands, followed by comma seprarated arguments in numercal form. Example:
	     | "M10,20L30,40"
	     * Here we can see two commands: “M”, with arguments `(10, 20)` and “L” with arguments `(30, 40)`. Upper case letter mean command is absolute, lower case—relative.
	     *
	     # <p>Here is short list of commands available, for more details see <a href="http://www.w3.org/TR/SVG/paths.html#PathData" title="Details of a path's data attribute's format are described in the SVG specification.">SVG path string format</a>.</p>
	     # <table><thead><tr><th>Command</th><th>Name</th><th>Parameters</th></tr></thead><tbody>
	     # <tr><td>M</td><td>moveto</td><td>(x y)+</td></tr>
	     # <tr><td>Z</td><td>closepath</td><td>(none)</td></tr>
	     # <tr><td>L</td><td>lineto</td><td>(x y)+</td></tr>
	     # <tr><td>H</td><td>horizontal lineto</td><td>x+</td></tr>
	     # <tr><td>V</td><td>vertical lineto</td><td>y+</td></tr>
	     # <tr><td>C</td><td>curveto</td><td>(x1 y1 x2 y2 x y)+</td></tr>
	     # <tr><td>S</td><td>smooth curveto</td><td>(x2 y2 x y)+</td></tr>
	     # <tr><td>Q</td><td>quadratic Bézier curveto</td><td>(x1 y1 x y)+</td></tr>
	     # <tr><td>T</td><td>smooth quadratic Bézier curveto</td><td>(x y)+</td></tr>
	     # <tr><td>A</td><td>elliptical arc</td><td>(rx ry x-axis-rotation large-arc-flag sweep-flag x y)+</td></tr>
	     # <tr><td>R</td><td><a href="http://en.wikipedia.org/wiki/Catmull–Rom_spline#Catmull.E2.80.93Rom_spline">Catmull-Rom curveto</a>*</td><td>x1 y1 (x y)+</td></tr></tbody></table>
	     * * “Catmull-Rom curveto” is a not standard SVG command and added in 2.0 to make life easier.
	     * Note: there is a special case when path consist of just three commands: “M10,10R…z”. In this case path will smoothly connects to its beginning.
	     > Usage
	     | var c = paper.path("M10 10L90 90");
	     | // draw a diagonal line:
	     | // move to 10,10, line to 90,90
	     * For example of path strings, check out these icons: http://raphaeljs.com/icons/
	    \*/
	    paperproto.path = function (pathString) {
	        pathString && !R.is(pathString, string) && !R.is(pathString[0], array) && (pathString += E);
	        var out = R._engine.path(R.format[apply](R, arguments), this);
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.image
	     [ method ]
	     **
	     * Embeds an image into the surface.
	     **
	     > Parameters
	     **
	     - src (string) URI of the source image
	     - x (number) x coordinate position
	     - y (number) y coordinate position
	     - width (number) width of the image
	     - height (number) height of the image
	     = (object) Raphaël element object with type “image”
	     **
	     > Usage
	     | var c = paper.image("apple.png", 10, 10, 80, 80);
	    \*/
	    paperproto.image = function (src, x, y, w, h) {
	        var out = R._engine.image(this, src || "about:blank", x || 0, y || 0, w || 0, h || 0);
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.text
	     [ method ]
	     **
	     * Draws a text string. If you need line breaks, put “\n” in the string.
	     **
	     > Parameters
	     **
	     - x (number) x coordinate position
	     - y (number) y coordinate position
	     - text (string) The text string to draw
	     = (object) Raphaël element object with type “text”
	     **
	     > Usage
	     | var t = paper.text(50, 50, "Raphaël\nkicks\nbutt!");
	    \*/
	    paperproto.text = function (x, y, text) {
	        var out = R._engine.text(this, x || 0, y || 0, Str(text));
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Paper.set
	     [ method ]
	     **
	     * Creates array-like object to keep and operate several elements at once.
	     * Warning: it doesn’t create any elements for itself in the page, it just groups existing elements.
	     * Sets act as pseudo elements — all methods available to an element can be used on a set.
	     = (object) array-like object that represents set of elements
	     **
	     > Usage
	     | var st = paper.set();
	     | st.push(
	     |     paper.circle(10, 10, 5),
	     |     paper.circle(30, 10, 5)
	     | );
	     | st.attr({fill: "red"}); // changes the fill of both circles
	    \*/
	    paperproto.set = function (itemsArray) {
	        !R.is(itemsArray, "array") && (itemsArray = Array.prototype.splice.call(arguments, 0, arguments.length));
	        var out = new Set(itemsArray);
	        this.__set__ && this.__set__.push(out);
	        out["paper"] = this;
	        out["type"] = "set";
	        return out;
	    };
	    /*\
	     * Paper.setStart
	     [ method ]
	     **
	     * Creates @Paper.set. All elements that will be created after calling this method and before calling
	     * @Paper.setFinish will be added to the set.
	     **
	     > Usage
	     | paper.setStart();
	     | paper.circle(10, 10, 5),
	     | paper.circle(30, 10, 5)
	     | var st = paper.setFinish();
	     | st.attr({fill: "red"}); // changes the fill of both circles
	    \*/
	    paperproto.setStart = function (set) {
	        this.__set__ = set || this.set();
	    };
	    /*\
	     * Paper.setFinish
	     [ method ]
	     **
	     * See @Paper.setStart. This method finishes catching and returns resulting set.
	     **
	     = (object) set
	    \*/
	    paperproto.setFinish = function (set) {
	        var out = this.__set__;
	        delete this.__set__;
	        return out;
	    };
	    /*\
	     * Paper.getSize
	     [ method ]
	     **
	     * Obtains current paper actual size.
	     **
	     = (object)
	     \*/
	    paperproto.getSize = function () {
	        var container = this.canvas.parentNode;
	        return {
	            width: container.offsetWidth,
	            height: container.offsetHeight
	                };
	        };
	    /*\
	     * Paper.setSize
	     [ method ]
	     **
	     * If you need to change dimensions of the canvas call this method
	     **
	     > Parameters
	     **
	     - width (number) new width of the canvas
	     - height (number) new height of the canvas
	    \*/
	    paperproto.setSize = function (width, height) {
	        return R._engine.setSize.call(this, width, height);
	    };
	    /*\
	     * Paper.setViewBox
	     [ method ]
	     **
	     * Sets the view box of the paper. Practically it gives you ability to zoom and pan whole paper surface by
	     * specifying new boundaries.
	     **
	     > Parameters
	     **
	     - x (number) new x position, default is `0`
	     - y (number) new y position, default is `0`
	     - w (number) new width of the canvas
	     - h (number) new height of the canvas
	     - fit (boolean) `true` if you want graphics to fit into new boundary box
	    \*/
	    paperproto.setViewBox = function (x, y, w, h, fit) {
	        return R._engine.setViewBox.call(this, x, y, w, h, fit);
	    };
	    /*\
	     * Paper.top
	     [ property ]
	     **
	     * Points to the topmost element on the paper
	    \*/
	    /*\
	     * Paper.bottom
	     [ property ]
	     **
	     * Points to the bottom element on the paper
	    \*/
	    paperproto.top = paperproto.bottom = null;
	    /*\
	     * Paper.raphael
	     [ property ]
	     **
	     * Points to the @Raphael object/function
	    \*/
	    paperproto.raphael = R;
	    var getOffset = function (elem) {
	        var box = elem.getBoundingClientRect(),
	            doc = elem.ownerDocument,
	            body = doc.body,
	            docElem = doc.documentElement,
	            clientTop = docElem.clientTop || body.clientTop || 0, clientLeft = docElem.clientLeft || body.clientLeft || 0,
	            top  = box.top  + (g.win.pageYOffset || docElem.scrollTop || body.scrollTop ) - clientTop,
	            left = box.left + (g.win.pageXOffset || docElem.scrollLeft || body.scrollLeft) - clientLeft;
	        return {
	            y: top,
	            x: left
	        };
	    };
	    /*\
	     * Paper.getElementByPoint
	     [ method ]
	     **
	     * Returns you topmost element under given point.
	     **
	     = (object) Raphaël element object
	     > Parameters
	     **
	     - x (number) x coordinate from the top left corner of the window
	     - y (number) y coordinate from the top left corner of the window
	     > Usage
	     | paper.getElementByPoint(mouseX, mouseY).attr({stroke: "#f00"});
	    \*/
	    paperproto.getElementByPoint = function (x, y) {
	        var paper = this,
	            svg = paper.canvas,
	            target = g.doc.elementFromPoint(x, y);
	        if (g.win.opera && target.tagName == "svg") {
	            var so = getOffset(svg),
	                sr = svg.createSVGRect();
	            sr.x = x - so.x;
	            sr.y = y - so.y;
	            sr.width = sr.height = 1;
	            var hits = svg.getIntersectionList(sr, null);
	            if (hits.length) {
	                target = hits[hits.length - 1];
	            }
	        }
	        if (!target) {
	            return null;
	        }
	        while (target.parentNode && target != svg.parentNode && !target.raphael) {
	            target = target.parentNode;
	        }
	        target == paper.canvas.parentNode && (target = svg);
	        target = target && target.raphael ? paper.getById(target.raphaelid) : null;
	        return target;
	    };

	    /*\
	     * Paper.getElementsByBBox
	     [ method ]
	     **
	     * Returns set of elements that have an intersecting bounding box
	     **
	     > Parameters
	     **
	     - bbox (object) bbox to check with
	     = (object) @Set
	     \*/
	    paperproto.getElementsByBBox = function (bbox) {
	        var set = this.set();
	        this.forEach(function (el) {
	            if (R.isBBoxIntersect(el.getBBox(), bbox)) {
	                set.push(el);
	            }
	        });
	        return set;
	    };

	    /*\
	     * Paper.getById
	     [ method ]
	     **
	     * Returns you element by its internal ID.
	     **
	     > Parameters
	     **
	     - id (number) id
	     = (object) Raphaël element object
	    \*/
	    paperproto.getById = function (id) {
	        var bot = this.bottom;
	        while (bot) {
	            if (bot.id == id) {
	                return bot;
	            }
	            bot = bot.next;
	        }
	        return null;
	    };
	    /*\
	     * Paper.forEach
	     [ method ]
	     **
	     * Executes given function for each element on the paper
	     *
	     * If callback function returns `false` it will stop loop running.
	     **
	     > Parameters
	     **
	     - callback (function) function to run
	     - thisArg (object) context object for the callback
	     = (object) Paper object
	     > Usage
	     | paper.forEach(function (el) {
	     |     el.attr({ stroke: "blue" });
	     | });
	    \*/
	    paperproto.forEach = function (callback, thisArg) {
	        var bot = this.bottom;
	        while (bot) {
	            if (callback.call(thisArg, bot) === false) {
	                return this;
	            }
	            bot = bot.next;
	        }
	        return this;
	    };
	    /*\
	     * Paper.getElementsByPoint
	     [ method ]
	     **
	     * Returns set of elements that have common point inside
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the point
	     - y (number) y coordinate of the point
	     = (object) @Set
	    \*/
	    paperproto.getElementsByPoint = function (x, y) {
	        var set = this.set();
	        this.forEach(function (el) {
	            if (el.isPointInside(x, y)) {
	                set.push(el);
	            }
	        });
	        return set;
	    };
	    function x_y() {
	        return this.x + S + this.y;
	    }
	    function x_y_w_h() {
	        return this.x + S + this.y + S + this.width + " \xd7 " + this.height;
	    }
	    /*\
	     * Element.isPointInside
	     [ method ]
	     **
	     * Determine if given point is inside this element’s shape
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the point
	     - y (number) y coordinate of the point
	     = (boolean) `true` if point inside the shape
	    \*/
	    elproto.isPointInside = function (x, y) {
	        var rp = this.realPath = getPath[this.type](this);
	        if (this.attr('transform') && this.attr('transform').length) {
	            rp = R.transformPath(rp, this.attr('transform'));
	        }
	        return R.isPointInsidePath(rp, x, y);
	    };
	    /*\
	     * Element.getBBox
	     [ method ]
	     **
	     * Return bounding box for a given element
	     **
	     > Parameters
	     **
	     - isWithoutTransform (boolean) flag, `true` if you want to have bounding box before transformations. Default is `false`.
	     = (object) Bounding box object:
	     o {
	     o     x: (number) top left corner x
	     o     y: (number) top left corner y
	     o     x2: (number) bottom right corner x
	     o     y2: (number) bottom right corner y
	     o     width: (number) width
	     o     height: (number) height
	     o }
	    \*/
	    elproto.getBBox = function (isWithoutTransform) {
	        if (this.removed) {
	            return {};
	        }
	        var _ = this._;
	        if (isWithoutTransform) {
	            if (_.dirty || !_.bboxwt) {
	                this.realPath = getPath[this.type](this);
	                _.bboxwt = pathDimensions(this.realPath);
	                _.bboxwt.toString = x_y_w_h;
	                _.dirty = 0;
	            }
	            return _.bboxwt;
	        }
	        if (_.dirty || _.dirtyT || !_.bbox) {
	            if (_.dirty || !this.realPath) {
	                _.bboxwt = 0;
	                this.realPath = getPath[this.type](this);
	            }
	            _.bbox = pathDimensions(mapPath(this.realPath, this.matrix));
	            _.bbox.toString = x_y_w_h;
	            _.dirty = _.dirtyT = 0;
	        }
	        return _.bbox;
	    };
	    /*\
	     * Element.clone
	     [ method ]
	     **
	     = (object) clone of a given element
	     **
	    \*/
	    elproto.clone = function () {
	        if (this.removed) {
	            return null;
	        }
	        var out = this.paper[this.type]().attr(this.attr());
	        this.__set__ && this.__set__.push(out);
	        return out;
	    };
	    /*\
	     * Element.glow
	     [ method ]
	     **
	     * Return set of elements that create glow-like effect around given element. See @Paper.set.
	     *
	     * Note: Glow is not connected to the element. If you change element attributes it won’t adjust itself.
	     **
	     > Parameters
	     **
	     - glow (object) #optional parameters object with all properties optional:
	     o {
	     o     width (number) size of the glow, default is `10`
	     o     fill (boolean) will it be filled, default is `false`
	     o     opacity (number) opacity, default is `0.5`
	     o     offsetx (number) horizontal offset, default is `0`
	     o     offsety (number) vertical offset, default is `0`
	     o     color (string) glow colour, default is `black`
	     o }
	     = (object) @Paper.set of elements that represents glow
	    \*/
	    elproto.glow = function (glow) {
	        if (this.type == "text") {
	            return null;
	        }
	        glow = glow || {};
	        var s = {
	            width: (glow.width || 10) + (+this.attr("stroke-width") || 1),
	            fill: glow.fill || false,
	            opacity: glow.opacity == null ? .5 : glow.opacity,
	            offsetx: glow.offsetx || 0,
	            offsety: glow.offsety || 0,
	            color: glow.color || "#000"
	        },
	            c = s.width / 2,
	            r = this.paper,
	            out = r.set(),
	            path = this.realPath || getPath[this.type](this);
	        path = this.matrix ? mapPath(path, this.matrix) : path;
	        for (var i = 1; i < c + 1; i++) {
	            out.push(r.path(path).attr({
	                stroke: s.color,
	                fill: s.fill ? s.color : "none",
	                "stroke-linejoin": "round",
	                "stroke-linecap": "round",
	                "stroke-width": +(s.width / c * i).toFixed(3),
	                opacity: +(s.opacity / c).toFixed(3)
	            }));
	        }
	        return out.insertBefore(this).translate(s.offsetx, s.offsety);
	    };
	    var curveslengths = {},
	    getPointAtSegmentLength = function (p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, length) {
	        if (length == null) {
	            return bezlen(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y);
	        } else {
	            return R.findDotsAtSegment(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, getTatLen(p1x, p1y, c1x, c1y, c2x, c2y, p2x, p2y, length));
	        }
	    },
	    getLengthFactory = function (istotal, subpath) {
	        return function (path, length, onlystart) {
	            path = path2curve(path);
	            var x, y, p, l, sp = "", subpaths = {}, point,
	                len = 0;
	            for (var i = 0, ii = path.length; i < ii; i++) {
	                p = path[i];
	                if (p[0] == "M") {
	                    x = +p[1];
	                    y = +p[2];
	                } else {
	                    l = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6]);
	                    if (len + l > length) {
	                        if (subpath && !subpaths.start) {
	                            point = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6], length - len);
	                            sp += ["C" + point.start.x, point.start.y, point.m.x, point.m.y, point.x, point.y];
	                            if (onlystart) {return sp;}
	                            subpaths.start = sp;
	                            sp = ["M" + point.x, point.y + "C" + point.n.x, point.n.y, point.end.x, point.end.y, p[5], p[6]].join();
	                            len += l;
	                            x = +p[5];
	                            y = +p[6];
	                            continue;
	                        }
	                        if (!istotal && !subpath) {
	                            point = getPointAtSegmentLength(x, y, p[1], p[2], p[3], p[4], p[5], p[6], length - len);
	                            return {x: point.x, y: point.y, alpha: point.alpha};
	                        }
	                    }
	                    len += l;
	                    x = +p[5];
	                    y = +p[6];
	                }
	                sp += p.shift() + p;
	            }
	            subpaths.end = sp;
	            point = istotal ? len : subpath ? subpaths : R.findDotsAtSegment(x, y, p[0], p[1], p[2], p[3], p[4], p[5], 1);
	            point.alpha && (point = {x: point.x, y: point.y, alpha: point.alpha});
	            return point;
	        };
	    };
	    var getTotalLength = getLengthFactory(1),
	        getPointAtLength = getLengthFactory(),
	        getSubpathsAtLength = getLengthFactory(0, 1);
	    /*\
	     * Raphael.getTotalLength
	     [ method ]
	     **
	     * Returns length of the given path in pixels.
	     **
	     > Parameters
	     **
	     - path (string) SVG path string.
	     **
	     = (number) length.
	    \*/
	    R.getTotalLength = getTotalLength;
	    /*\
	     * Raphael.getPointAtLength
	     [ method ]
	     **
	     * Return coordinates of the point located at the given length on the given path.
	     **
	     > Parameters
	     **
	     - path (string) SVG path string
	     - length (number)
	     **
	     = (object) representation of the point:
	     o {
	     o     x: (number) x coordinate
	     o     y: (number) y coordinate
	     o     alpha: (number) angle of derivative
	     o }
	    \*/
	    R.getPointAtLength = getPointAtLength;
	    /*\
	     * Raphael.getSubpath
	     [ method ]
	     **
	     * Return subpath of a given path from given length to given length.
	     **
	     > Parameters
	     **
	     - path (string) SVG path string
	     - from (number) position of the start of the segment
	     - to (number) position of the end of the segment
	     **
	     = (string) pathstring for the segment
	    \*/
	    R.getSubpath = function (path, from, to) {
	        if (this.getTotalLength(path) - to < 1e-6) {
	            return getSubpathsAtLength(path, from).end;
	        }
	        var a = getSubpathsAtLength(path, to, 1);
	        return from ? getSubpathsAtLength(a, from).end : a;
	    };
	    /*\
	     * Element.getTotalLength
	     [ method ]
	     **
	     * Returns length of the path in pixels. Only works for element of “path” type.
	     = (number) length.
	    \*/
	    elproto.getTotalLength = function () {
	        var path = this.getPath();
	        if (!path) {
	            return;
	        }

	        if (this.node.getTotalLength) {
	            return this.node.getTotalLength();
	        }

	        return getTotalLength(path);
	    };
	    /*\
	     * Element.getPointAtLength
	     [ method ]
	     **
	     * Return coordinates of the point located at the given length on the given path. Only works for element of “path” type.
	     **
	     > Parameters
	     **
	     - length (number)
	     **
	     = (object) representation of the point:
	     o {
	     o     x: (number) x coordinate
	     o     y: (number) y coordinate
	     o     alpha: (number) angle of derivative
	     o }
	    \*/
	    elproto.getPointAtLength = function (length) {
	        var path = this.getPath();
	        if (!path) {
	            return;
	        }

	        return getPointAtLength(path, length);
	    };
	    /*\
	     * Element.getPath
	     [ method ]
	     **
	     * Returns path of the element. Only works for elements of “path” type and simple elements like circle.
	     = (object) path
	     **
	    \*/
	    elproto.getPath = function () {
	        var path,
	            getPath = R._getPath[this.type];

	        if (this.type == "text" || this.type == "set") {
	            return;
	        }

	        if (getPath) {
	            path = getPath(this);
	        }

	        return path;
	    };
	    /*\
	     * Element.getSubpath
	     [ method ]
	     **
	     * Return subpath of a given element from given length to given length. Only works for element of “path” type.
	     **
	     > Parameters
	     **
	     - from (number) position of the start of the segment
	     - to (number) position of the end of the segment
	     **
	     = (string) pathstring for the segment
	    \*/
	    elproto.getSubpath = function (from, to) {
	        var path = this.getPath();
	        if (!path) {
	            return;
	        }

	        return R.getSubpath(path, from, to);
	    };
	    /*\
	     * Raphael.easing_formulas
	     [ property ]
	     **
	     * Object that contains easing formulas for animation. You could extend it with your own. By default it has following list of easing:
	     # <ul>
	     #     <li>“linear”</li>
	     #     <li>“&lt;” or “easeIn” or “ease-in”</li>
	     #     <li>“>” or “easeOut” or “ease-out”</li>
	     #     <li>“&lt;>” or “easeInOut” or “ease-in-out”</li>
	     #     <li>“backIn” or “back-in”</li>
	     #     <li>“backOut” or “back-out”</li>
	     #     <li>“elastic”</li>
	     #     <li>“bounce”</li>
	     # </ul>
	     # <p>See also <a href="http://raphaeljs.com/easing.html">Easing demo</a>.</p>
	    \*/
	    var ef = R.easing_formulas = {
	        linear: function (n) {
	            return n;
	        },
	        "<": function (n) {
	            return pow(n, 1.7);
	        },
	        ">": function (n) {
	            return pow(n, .48);
	        },
	        "<>": function (n) {
	            var q = .48 - n / 1.04,
	                Q = math.sqrt(.1734 + q * q),
	                x = Q - q,
	                X = pow(abs(x), 1 / 3) * (x < 0 ? -1 : 1),
	                y = -Q - q,
	                Y = pow(abs(y), 1 / 3) * (y < 0 ? -1 : 1),
	                t = X + Y + .5;
	            return (1 - t) * 3 * t * t + t * t * t;
	        },
	        backIn: function (n) {
	            var s = 1.70158;
	            return n * n * ((s + 1) * n - s);
	        },
	        backOut: function (n) {
	            n = n - 1;
	            var s = 1.70158;
	            return n * n * ((s + 1) * n + s) + 1;
	        },
	        elastic: function (n) {
	            if (n == !!n) {
	                return n;
	            }
	            return pow(2, -10 * n) * math.sin((n - .075) * (2 * PI) / .3) + 1;
	        },
	        bounce: function (n) {
	            var s = 7.5625,
	                p = 2.75,
	                l;
	            if (n < (1 / p)) {
	                l = s * n * n;
	            } else {
	                if (n < (2 / p)) {
	                    n -= (1.5 / p);
	                    l = s * n * n + .75;
	                } else {
	                    if (n < (2.5 / p)) {
	                        n -= (2.25 / p);
	                        l = s * n * n + .9375;
	                    } else {
	                        n -= (2.625 / p);
	                        l = s * n * n + .984375;
	                    }
	                }
	            }
	            return l;
	        }
	    };
	    ef.easeIn = ef["ease-in"] = ef["<"];
	    ef.easeOut = ef["ease-out"] = ef[">"];
	    ef.easeInOut = ef["ease-in-out"] = ef["<>"];
	    ef["back-in"] = ef.backIn;
	    ef["back-out"] = ef.backOut;

	    var animationElements = [],
	        requestAnimFrame = window.requestAnimationFrame       ||
	                           window.webkitRequestAnimationFrame ||
	                           window.mozRequestAnimationFrame    ||
	                           window.oRequestAnimationFrame      ||
	                           window.msRequestAnimationFrame     ||
	                           function (callback) {
	                               setTimeout(callback, 16);
	                           },
	        animation = function () {
	            var Now = +new Date,
	                l = 0;
	            for (; l < animationElements.length; l++) {
	                var e = animationElements[l];
	                if (e.el.removed || e.paused) {
	                    continue;
	                }
	                var time = Now - e.start,
	                    ms = e.ms,
	                    easing = e.easing,
	                    from = e.from,
	                    diff = e.diff,
	                    to = e.to,
	                    t = e.t,
	                    that = e.el,
	                    set = {},
	                    now,
	                    init = {},
	                    key;
	                if (e.initstatus) {
	                    time = (e.initstatus * e.anim.top - e.prev) / (e.percent - e.prev) * ms;
	                    e.status = e.initstatus;
	                    delete e.initstatus;
	                    e.stop && animationElements.splice(l--, 1);
	                } else {
	                    e.status = (e.prev + (e.percent - e.prev) * (time / ms)) / e.anim.top;
	                }
	                if (time < 0) {
	                    continue;
	                }
	                if (time < ms) {
	                    var pos = easing(time / ms);
	                    for (var attr in from) if (from[has](attr)) {
	                        switch (availableAnimAttrs[attr]) {
	                            case nu:
	                                now = +from[attr] + pos * ms * diff[attr];
	                                break;
	                            case "colour":
	                                now = "rgb(" + [
	                                    upto255(round(from[attr].r + pos * ms * diff[attr].r)),
	                                    upto255(round(from[attr].g + pos * ms * diff[attr].g)),
	                                    upto255(round(from[attr].b + pos * ms * diff[attr].b))
	                                ].join(",") + ")";
	                                break;
	                            case "path":
	                                now = [];
	                                for (var i = 0, ii = from[attr].length; i < ii; i++) {
	                                    now[i] = [from[attr][i][0]];
	                                    for (var j = 1, jj = from[attr][i].length; j < jj; j++) {
	                                        now[i][j] = +from[attr][i][j] + pos * ms * diff[attr][i][j];
	                                    }
	                                    now[i] = now[i].join(S);
	                                }
	                                now = now.join(S);
	                                break;
	                            case "transform":
	                                if (diff[attr].real) {
	                                    now = [];
	                                    for (i = 0, ii = from[attr].length; i < ii; i++) {
	                                        now[i] = [from[attr][i][0]];
	                                        for (j = 1, jj = from[attr][i].length; j < jj; j++) {
	                                            now[i][j] = from[attr][i][j] + pos * ms * diff[attr][i][j];
	                                        }
	                                    }
	                                } else {
	                                    var get = function (i) {
	                                        return +from[attr][i] + pos * ms * diff[attr][i];
	                                    };
	                                    // now = [["r", get(2), 0, 0], ["t", get(3), get(4)], ["s", get(0), get(1), 0, 0]];
	                                    now = [["m", get(0), get(1), get(2), get(3), get(4), get(5)]];
	                                }
	                                break;
	                            case "csv":
	                                if (attr == "clip-rect") {
	                                    now = [];
	                                    i = 4;
	                                    while (i--) {
	                                        now[i] = +from[attr][i] + pos * ms * diff[attr][i];
	                                    }
	                                }
	                                break;
	                            default:
	                                var from2 = [][concat](from[attr]);
	                                now = [];
	                                i = that.paper.customAttributes[attr].length;
	                                while (i--) {
	                                    now[i] = +from2[i] + pos * ms * diff[attr][i];
	                                }
	                                break;
	                        }
	                        set[attr] = now;
	                    }
	                    that.attr(set);
	                    (function (id, that, anim) {
	                        setTimeout(function () {
	                            eve("raphael.anim.frame." + id, that, anim);
	                        });
	                    })(that.id, that, e.anim);
	                } else {
	                    (function(f, el, a) {
	                        setTimeout(function() {
	                            eve("raphael.anim.frame." + el.id, el, a);
	                            eve("raphael.anim.finish." + el.id, el, a);
	                            R.is(f, "function") && f.call(el);
	                        });
	                    })(e.callback, that, e.anim);
	                    that.attr(to);
	                    animationElements.splice(l--, 1);
	                    if (e.repeat > 1 && !e.next) {
	                        for (key in to) if (to[has](key)) {
	                            init[key] = e.totalOrigin[key];
	                        }
	                        e.el.attr(init);
	                        runAnimation(e.anim, e.el, e.anim.percents[0], null, e.totalOrigin, e.repeat - 1);
	                    }
	                    if (e.next && !e.stop) {
	                        runAnimation(e.anim, e.el, e.next, null, e.totalOrigin, e.repeat);
	                    }
	                }
	            }
	            animationElements.length && requestAnimFrame(animation);
	        },
	        upto255 = function (color) {
	            return color > 255 ? 255 : color < 0 ? 0 : color;
	        };
	    /*\
	     * Element.animateWith
	     [ method ]
	     **
	     * Acts similar to @Element.animate, but ensure that given animation runs in sync with another given element.
	     **
	     > Parameters
	     **
	     - el (object) element to sync with
	     - anim (object) animation to sync with
	     - params (object) #optional final attributes for the element, see also @Element.attr
	     - ms (number) #optional number of milliseconds for animation to run
	     - easing (string) #optional easing type. Accept on of @Raphael.easing_formulas or CSS format: `cubic&#x2010;bezier(XX,&#160;XX,&#160;XX,&#160;XX)`
	     - callback (function) #optional callback function. Will be called at the end of animation.
	     * or
	     - element (object) element to sync with
	     - anim (object) animation to sync with
	     - animation (object) #optional animation object, see @Raphael.animation
	     **
	     = (object) original element
	    \*/
	    elproto.animateWith = function (el, anim, params, ms, easing, callback) {
	        var element = this;
	        if (element.removed) {
	            callback && callback.call(element);
	            return element;
	        }
	        var a = params instanceof Animation ? params : R.animation(params, ms, easing, callback),
	            x, y;
	        runAnimation(a, element, a.percents[0], null, element.attr());
	        for (var i = 0, ii = animationElements.length; i < ii; i++) {
	            if (animationElements[i].anim == anim && animationElements[i].el == el) {
	                animationElements[ii - 1].start = animationElements[i].start;
	                break;
	            }
	        }
	        return element;
	        //
	        //
	        // var a = params ? R.animation(params, ms, easing, callback) : anim,
	        //     status = element.status(anim);
	        // return this.animate(a).status(a, status * anim.ms / a.ms);
	    };
	    function CubicBezierAtTime(t, p1x, p1y, p2x, p2y, duration) {
	        var cx = 3 * p1x,
	            bx = 3 * (p2x - p1x) - cx,
	            ax = 1 - cx - bx,
	            cy = 3 * p1y,
	            by = 3 * (p2y - p1y) - cy,
	            ay = 1 - cy - by;
	        function sampleCurveX(t) {
	            return ((ax * t + bx) * t + cx) * t;
	        }
	        function solve(x, epsilon) {
	            var t = solveCurveX(x, epsilon);
	            return ((ay * t + by) * t + cy) * t;
	        }
	        function solveCurveX(x, epsilon) {
	            var t0, t1, t2, x2, d2, i;
	            for(t2 = x, i = 0; i < 8; i++) {
	                x2 = sampleCurveX(t2) - x;
	                if (abs(x2) < epsilon) {
	                    return t2;
	                }
	                d2 = (3 * ax * t2 + 2 * bx) * t2 + cx;
	                if (abs(d2) < 1e-6) {
	                    break;
	                }
	                t2 = t2 - x2 / d2;
	            }
	            t0 = 0;
	            t1 = 1;
	            t2 = x;
	            if (t2 < t0) {
	                return t0;
	            }
	            if (t2 > t1) {
	                return t1;
	            }
	            while (t0 < t1) {
	                x2 = sampleCurveX(t2);
	                if (abs(x2 - x) < epsilon) {
	                    return t2;
	                }
	                if (x > x2) {
	                    t0 = t2;
	                } else {
	                    t1 = t2;
	                }
	                t2 = (t1 - t0) / 2 + t0;
	            }
	            return t2;
	        }
	        return solve(t, 1 / (200 * duration));
	    }
	    elproto.onAnimation = function (f) {
	        f ? eve.on("raphael.anim.frame." + this.id, f) : eve.unbind("raphael.anim.frame." + this.id);
	        return this;
	    };
	    function Animation(anim, ms) {
	        var percents = [],
	            newAnim = {};
	        this.ms = ms;
	        this.times = 1;
	        if (anim) {
	            for (var attr in anim) if (anim[has](attr)) {
	                newAnim[toFloat(attr)] = anim[attr];
	                percents.push(toFloat(attr));
	            }
	            percents.sort(sortByNumber);
	        }
	        this.anim = newAnim;
	        this.top = percents[percents.length - 1];
	        this.percents = percents;
	    }
	    /*\
	     * Animation.delay
	     [ method ]
	     **
	     * Creates a copy of existing animation object with given delay.
	     **
	     > Parameters
	     **
	     - delay (number) number of ms to pass between animation start and actual animation
	     **
	     = (object) new altered Animation object
	     | var anim = Raphael.animation({cx: 10, cy: 20}, 2e3);
	     | circle1.animate(anim); // run the given animation immediately
	     | circle2.animate(anim.delay(500)); // run the given animation after 500 ms
	    \*/
	    Animation.prototype.delay = function (delay) {
	        var a = new Animation(this.anim, this.ms);
	        a.times = this.times;
	        a.del = +delay || 0;
	        return a;
	    };
	    /*\
	     * Animation.repeat
	     [ method ]
	     **
	     * Creates a copy of existing animation object with given repetition.
	     **
	     > Parameters
	     **
	     - repeat (number) number iterations of animation. For infinite animation pass `Infinity`
	     **
	     = (object) new altered Animation object
	    \*/
	    Animation.prototype.repeat = function (times) {
	        var a = new Animation(this.anim, this.ms);
	        a.del = this.del;
	        a.times = math.floor(mmax(times, 0)) || 1;
	        return a;
	    };
	    function runAnimation(anim, element, percent, status, totalOrigin, times) {
	        percent = toFloat(percent);
	        var params,
	            isInAnim,
	            isInAnimSet,
	            percents = [],
	            next,
	            prev,
	            timestamp,
	            ms = anim.ms,
	            from = {},
	            to = {},
	            diff = {};
	        if (status) {
	            for (i = 0, ii = animationElements.length; i < ii; i++) {
	                var e = animationElements[i];
	                if (e.el.id == element.id && e.anim == anim) {
	                    if (e.percent != percent) {
	                        animationElements.splice(i, 1);
	                        isInAnimSet = 1;
	                    } else {
	                        isInAnim = e;
	                    }
	                    element.attr(e.totalOrigin);
	                    break;
	                }
	            }
	        } else {
	            status = +to; // NaN
	        }
	        for (var i = 0, ii = anim.percents.length; i < ii; i++) {
	            if (anim.percents[i] == percent || anim.percents[i] > status * anim.top) {
	                percent = anim.percents[i];
	                prev = anim.percents[i - 1] || 0;
	                ms = ms / anim.top * (percent - prev);
	                next = anim.percents[i + 1];
	                params = anim.anim[percent];
	                break;
	            } else if (status) {
	                element.attr(anim.anim[anim.percents[i]]);
	            }
	        }
	        if (!params) {
	            return;
	        }
	        if (!isInAnim) {
	            for (var attr in params) if (params[has](attr)) {
	                if (availableAnimAttrs[has](attr) || element.paper.customAttributes[has](attr)) {
	                    from[attr] = element.attr(attr);
	                    (from[attr] == null) && (from[attr] = availableAttrs[attr]);
	                    to[attr] = params[attr];
	                    switch (availableAnimAttrs[attr]) {
	                        case nu:
	                            diff[attr] = (to[attr] - from[attr]) / ms;
	                            break;
	                        case "colour":
	                            from[attr] = R.getRGB(from[attr]);
	                            var toColour = R.getRGB(to[attr]);
	                            diff[attr] = {
	                                r: (toColour.r - from[attr].r) / ms,
	                                g: (toColour.g - from[attr].g) / ms,
	                                b: (toColour.b - from[attr].b) / ms
	                            };
	                            break;
	                        case "path":
	                            var pathes = path2curve(from[attr], to[attr]),
	                                toPath = pathes[1];
	                            from[attr] = pathes[0];
	                            diff[attr] = [];
	                            for (i = 0, ii = from[attr].length; i < ii; i++) {
	                                diff[attr][i] = [0];
	                                for (var j = 1, jj = from[attr][i].length; j < jj; j++) {
	                                    diff[attr][i][j] = (toPath[i][j] - from[attr][i][j]) / ms;
	                                }
	                            }
	                            break;
	                        case "transform":
	                            var _ = element._,
	                                eq = equaliseTransform(_[attr], to[attr]);
	                            if (eq) {
	                                from[attr] = eq.from;
	                                to[attr] = eq.to;
	                                diff[attr] = [];
	                                diff[attr].real = true;
	                                for (i = 0, ii = from[attr].length; i < ii; i++) {
	                                    diff[attr][i] = [from[attr][i][0]];
	                                    for (j = 1, jj = from[attr][i].length; j < jj; j++) {
	                                        diff[attr][i][j] = (to[attr][i][j] - from[attr][i][j]) / ms;
	                                    }
	                                }
	                            } else {
	                                var m = (element.matrix || new Matrix),
	                                    to2 = {
	                                        _: {transform: _.transform},
	                                        getBBox: function () {
	                                            return element.getBBox(1);
	                                        }
	                                    };
	                                from[attr] = [
	                                    m.a,
	                                    m.b,
	                                    m.c,
	                                    m.d,
	                                    m.e,
	                                    m.f
	                                ];
	                                extractTransform(to2, to[attr]);
	                                to[attr] = to2._.transform;
	                                diff[attr] = [
	                                    (to2.matrix.a - m.a) / ms,
	                                    (to2.matrix.b - m.b) / ms,
	                                    (to2.matrix.c - m.c) / ms,
	                                    (to2.matrix.d - m.d) / ms,
	                                    (to2.matrix.e - m.e) / ms,
	                                    (to2.matrix.f - m.f) / ms
	                                ];
	                                // from[attr] = [_.sx, _.sy, _.deg, _.dx, _.dy];
	                                // var to2 = {_:{}, getBBox: function () { return element.getBBox(); }};
	                                // extractTransform(to2, to[attr]);
	                                // diff[attr] = [
	                                //     (to2._.sx - _.sx) / ms,
	                                //     (to2._.sy - _.sy) / ms,
	                                //     (to2._.deg - _.deg) / ms,
	                                //     (to2._.dx - _.dx) / ms,
	                                //     (to2._.dy - _.dy) / ms
	                                // ];
	                            }
	                            break;
	                        case "csv":
	                            var values = Str(params[attr])[split](separator),
	                                from2 = Str(from[attr])[split](separator);
	                            if (attr == "clip-rect") {
	                                from[attr] = from2;
	                                diff[attr] = [];
	                                i = from2.length;
	                                while (i--) {
	                                    diff[attr][i] = (values[i] - from[attr][i]) / ms;
	                                }
	                            }
	                            to[attr] = values;
	                            break;
	                        default:
	                            values = [][concat](params[attr]);
	                            from2 = [][concat](from[attr]);
	                            diff[attr] = [];
	                            i = element.paper.customAttributes[attr].length;
	                            while (i--) {
	                                diff[attr][i] = ((values[i] || 0) - (from2[i] || 0)) / ms;
	                            }
	                            break;
	                    }
	                }
	            }
	            var easing = params.easing,
	                easyeasy = R.easing_formulas[easing];
	            if (!easyeasy) {
	                easyeasy = Str(easing).match(bezierrg);
	                if (easyeasy && easyeasy.length == 5) {
	                    var curve = easyeasy;
	                    easyeasy = function (t) {
	                        return CubicBezierAtTime(t, +curve[1], +curve[2], +curve[3], +curve[4], ms);
	                    };
	                } else {
	                    easyeasy = pipe;
	                }
	            }
	            timestamp = params.start || anim.start || +new Date;
	            e = {
	                anim: anim,
	                percent: percent,
	                timestamp: timestamp,
	                start: timestamp + (anim.del || 0),
	                status: 0,
	                initstatus: status || 0,
	                stop: false,
	                ms: ms,
	                easing: easyeasy,
	                from: from,
	                diff: diff,
	                to: to,
	                el: element,
	                callback: params.callback,
	                prev: prev,
	                next: next,
	                repeat: times || anim.times,
	                origin: element.attr(),
	                totalOrigin: totalOrigin
	            };
	            animationElements.push(e);
	            if (status && !isInAnim && !isInAnimSet) {
	                e.stop = true;
	                e.start = new Date - ms * status;
	                if (animationElements.length == 1) {
	                    return animation();
	                }
	            }
	            if (isInAnimSet) {
	                e.start = new Date - e.ms * status;
	            }
	            animationElements.length == 1 && requestAnimFrame(animation);
	        } else {
	            isInAnim.initstatus = status;
	            isInAnim.start = new Date - isInAnim.ms * status;
	        }
	        eve("raphael.anim.start." + element.id, element, anim);
	    }
	    /*\
	     * Raphael.animation
	     [ method ]
	     **
	     * Creates an animation object that can be passed to the @Element.animate or @Element.animateWith methods.
	     * See also @Animation.delay and @Animation.repeat methods.
	     **
	     > Parameters
	     **
	     - params (object) final attributes for the element, see also @Element.attr
	     - ms (number) number of milliseconds for animation to run
	     - easing (string) #optional easing type. Accept one of @Raphael.easing_formulas or CSS format: `cubic&#x2010;bezier(XX,&#160;XX,&#160;XX,&#160;XX)`
	     - callback (function) #optional callback function. Will be called at the end of animation.
	     **
	     = (object) @Animation
	    \*/
	    R.animation = function (params, ms, easing, callback) {
	        if (params instanceof Animation) {
	            return params;
	        }
	        if (R.is(easing, "function") || !easing) {
	            callback = callback || easing || null;
	            easing = null;
	        }
	        params = Object(params);
	        ms = +ms || 0;
	        var p = {},
	            json,
	            attr;
	        for (attr in params) if (params[has](attr) && toFloat(attr) != attr && toFloat(attr) + "%" != attr) {
	            json = true;
	            p[attr] = params[attr];
	        }
	        if (!json) {
	            // if percent-like syntax is used and end-of-all animation callback used
	            if(callback){
	                // find the last one
	                var lastKey = 0;
	                for(var i in params){
	                    var percent = toInt(i);
	                    if(params[has](i) && percent > lastKey){
	                        lastKey = percent;
	                    }
	                }
	                lastKey += '%';
	                // if already defined callback in the last keyframe, skip
	                !params[lastKey].callback && (params[lastKey].callback = callback);
	            }
	          return new Animation(params, ms);
	        } else {
	            easing && (p.easing = easing);
	            callback && (p.callback = callback);
	            return new Animation({100: p}, ms);
	        }
	    };
	    /*\
	     * Element.animate
	     [ method ]
	     **
	     * Creates and starts animation for given element.
	     **
	     > Parameters
	     **
	     - params (object) final attributes for the element, see also @Element.attr
	     - ms (number) number of milliseconds for animation to run
	     - easing (string) #optional easing type. Accept one of @Raphael.easing_formulas or CSS format: `cubic&#x2010;bezier(XX,&#160;XX,&#160;XX,&#160;XX)`
	     - callback (function) #optional callback function. Will be called at the end of animation.
	     * or
	     - animation (object) animation object, see @Raphael.animation
	     **
	     = (object) original element
	    \*/
	    elproto.animate = function (params, ms, easing, callback) {
	        var element = this;
	        if (element.removed) {
	            callback && callback.call(element);
	            return element;
	        }
	        var anim = params instanceof Animation ? params : R.animation(params, ms, easing, callback);
	        runAnimation(anim, element, anim.percents[0], null, element.attr());
	        return element;
	    };
	    /*\
	     * Element.setTime
	     [ method ]
	     **
	     * Sets the status of animation of the element in milliseconds. Similar to @Element.status method.
	     **
	     > Parameters
	     **
	     - anim (object) animation object
	     - value (number) number of milliseconds from the beginning of the animation
	     **
	     = (object) original element if `value` is specified
	     * Note, that during animation following events are triggered:
	     *
	     * On each animation frame event `anim.frame.<id>`, on start `anim.start.<id>` and on end `anim.finish.<id>`.
	    \*/
	    elproto.setTime = function (anim, value) {
	        if (anim && value != null) {
	            this.status(anim, mmin(value, anim.ms) / anim.ms);
	        }
	        return this;
	    };
	    /*\
	     * Element.status
	     [ method ]
	     **
	     * Gets or sets the status of animation of the element.
	     **
	     > Parameters
	     **
	     - anim (object) #optional animation object
	     - value (number) #optional 0 – 1. If specified, method works like a setter and sets the status of a given animation to the value. This will cause animation to jump to the given position.
	     **
	     = (number) status
	     * or
	     = (array) status if `anim` is not specified. Array of objects in format:
	     o {
	     o     anim: (object) animation object
	     o     status: (number) status
	     o }
	     * or
	     = (object) original element if `value` is specified
	    \*/
	    elproto.status = function (anim, value) {
	        var out = [],
	            i = 0,
	            len,
	            e;
	        if (value != null) {
	            runAnimation(anim, this, -1, mmin(value, 1));
	            return this;
	        } else {
	            len = animationElements.length;
	            for (; i < len; i++) {
	                e = animationElements[i];
	                if (e.el.id == this.id && (!anim || e.anim == anim)) {
	                    if (anim) {
	                        return e.status;
	                    }
	                    out.push({
	                        anim: e.anim,
	                        status: e.status
	                    });
	                }
	            }
	            if (anim) {
	                return 0;
	            }
	            return out;
	        }
	    };
	    /*\
	     * Element.pause
	     [ method ]
	     **
	     * Stops animation of the element with ability to resume it later on.
	     **
	     > Parameters
	     **
	     - anim (object) #optional animation object
	     **
	     = (object) original element
	    \*/
	    elproto.pause = function (anim) {
	        for (var i = 0; i < animationElements.length; i++) if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
	            if (eve("raphael.anim.pause." + this.id, this, animationElements[i].anim) !== false) {
	                animationElements[i].paused = true;
	            }
	        }
	        return this;
	    };
	    /*\
	     * Element.resume
	     [ method ]
	     **
	     * Resumes animation if it was paused with @Element.pause method.
	     **
	     > Parameters
	     **
	     - anim (object) #optional animation object
	     **
	     = (object) original element
	    \*/
	    elproto.resume = function (anim) {
	        for (var i = 0; i < animationElements.length; i++) if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
	            var e = animationElements[i];
	            if (eve("raphael.anim.resume." + this.id, this, e.anim) !== false) {
	                delete e.paused;
	                this.status(e.anim, e.status);
	            }
	        }
	        return this;
	    };
	    /*\
	     * Element.stop
	     [ method ]
	     **
	     * Stops animation of the element.
	     **
	     > Parameters
	     **
	     - anim (object) #optional animation object
	     **
	     = (object) original element
	    \*/
	    elproto.stop = function (anim) {
	        for (var i = 0; i < animationElements.length; i++) if (animationElements[i].el.id == this.id && (!anim || animationElements[i].anim == anim)) {
	            if (eve("raphael.anim.stop." + this.id, this, animationElements[i].anim) !== false) {
	                animationElements.splice(i--, 1);
	            }
	        }
	        return this;
	    };
	    function stopAnimation(paper) {
	        for (var i = 0; i < animationElements.length; i++) if (animationElements[i].el.paper == paper) {
	            animationElements.splice(i--, 1);
	        }
	    }
	    eve.on("raphael.remove", stopAnimation);
	    eve.on("raphael.clear", stopAnimation);
	    elproto.toString = function () {
	        return "Rapha\xebl\u2019s object";
	    };

	    // Set
	    var Set = function (items) {
	        this.items = [];
	        this.length = 0;
	        this.type = "set";
	        if (items) {
	            for (var i = 0, ii = items.length; i < ii; i++) {
	                if (items[i] && (items[i].constructor == elproto.constructor || items[i].constructor == Set)) {
	                    this[this.items.length] = this.items[this.items.length] = items[i];
	                    this.length++;
	                }
	            }
	        }
	    },
	    setproto = Set.prototype;
	    /*\
	     * Set.push
	     [ method ]
	     **
	     * Adds each argument to the current set.
	     = (object) original element
	    \*/
	    setproto.push = function () {
	        var item,
	            len;
	        for (var i = 0, ii = arguments.length; i < ii; i++) {
	            item = arguments[i];
	            if (item && (item.constructor == elproto.constructor || item.constructor == Set)) {
	                len = this.items.length;
	                this[len] = this.items[len] = item;
	                this.length++;
	            }
	        }
	        return this;
	    };
	    /*\
	     * Set.pop
	     [ method ]
	     **
	     * Removes last element and returns it.
	     = (object) element
	    \*/
	    setproto.pop = function () {
	        this.length && delete this[this.length--];
	        return this.items.pop();
	    };
	    /*\
	     * Set.forEach
	     [ method ]
	     **
	     * Executes given function for each element in the set.
	     *
	     * If function returns `false` it will stop loop running.
	     **
	     > Parameters
	     **
	     - callback (function) function to run
	     - thisArg (object) context object for the callback
	     = (object) Set object
	    \*/
	    setproto.forEach = function (callback, thisArg) {
	        for (var i = 0, ii = this.items.length; i < ii; i++) {
	            if (callback.call(thisArg, this.items[i], i) === false) {
	                return this;
	            }
	        }
	        return this;
	    };
	    for (var method in elproto) if (elproto[has](method)) {
	        setproto[method] = (function (methodname) {
	            return function () {
	                var arg = arguments;
	                return this.forEach(function (el) {
	                    el[methodname][apply](el, arg);
	                });
	            };
	        })(method);
	    }
	    setproto.attr = function (name, value) {
	        if (name && R.is(name, array) && R.is(name[0], "object")) {
	            for (var j = 0, jj = name.length; j < jj; j++) {
	                this.items[j].attr(name[j]);
	            }
	        } else {
	            for (var i = 0, ii = this.items.length; i < ii; i++) {
	                this.items[i].attr(name, value);
	            }
	        }
	        return this;
	    };
	    /*\
	     * Set.clear
	     [ method ]
	     **
	     * Removes all elements from the set
	    \*/
	    setproto.clear = function () {
	        while (this.length) {
	            this.pop();
	        }
	    };
	    /*\
	     * Set.splice
	     [ method ]
	     **
	     * Removes given element from the set
	     **
	     > Parameters
	     **
	     - index (number) position of the deletion
	     - count (number) number of element to remove
	     - insertion… (object) #optional elements to insert
	     = (object) set elements that were deleted
	    \*/
	    setproto.splice = function (index, count, insertion) {
	        index = index < 0 ? mmax(this.length + index, 0) : index;
	        count = mmax(0, mmin(this.length - index, count));
	        var tail = [],
	            todel = [],
	            args = [],
	            i;
	        for (i = 2; i < arguments.length; i++) {
	            args.push(arguments[i]);
	        }
	        for (i = 0; i < count; i++) {
	            todel.push(this[index + i]);
	        }
	        for (; i < this.length - index; i++) {
	            tail.push(this[index + i]);
	        }
	        var arglen = args.length;
	        for (i = 0; i < arglen + tail.length; i++) {
	            this.items[index + i] = this[index + i] = i < arglen ? args[i] : tail[i - arglen];
	        }
	        i = this.items.length = this.length -= count - arglen;
	        while (this[i]) {
	            delete this[i++];
	        }
	        return new Set(todel);
	    };
	    /*\
	     * Set.exclude
	     [ method ]
	     **
	     * Removes given element from the set
	     **
	     > Parameters
	     **
	     - element (object) element to remove
	     = (boolean) `true` if object was found & removed from the set
	    \*/
	    setproto.exclude = function (el) {
	        for (var i = 0, ii = this.length; i < ii; i++) if (this[i] == el) {
	            this.splice(i, 1);
	            return true;
	        }
	    };
	    setproto.animate = function (params, ms, easing, callback) {
	        (R.is(easing, "function") || !easing) && (callback = easing || null);
	        var len = this.items.length,
	            i = len,
	            item,
	            set = this,
	            collector;
	        if (!len) {
	            return this;
	        }
	        callback && (collector = function () {
	            !--len && callback.call(set);
	        });
	        easing = R.is(easing, string) ? easing : collector;
	        var anim = R.animation(params, ms, easing, collector);
	        item = this.items[--i].animate(anim);
	        while (i--) {
	            this.items[i] && !this.items[i].removed && this.items[i].animateWith(item, anim, anim);
	            (this.items[i] && !this.items[i].removed) || len--;
	        }
	        return this;
	    };
	    setproto.insertAfter = function (el) {
	        var i = this.items.length;
	        while (i--) {
	            this.items[i].insertAfter(el);
	        }
	        return this;
	    };
	    setproto.getBBox = function () {
	        var x = [],
	            y = [],
	            x2 = [],
	            y2 = [];
	        for (var i = this.items.length; i--;) if (!this.items[i].removed) {
	            var box = this.items[i].getBBox();
	            x.push(box.x);
	            y.push(box.y);
	            x2.push(box.x + box.width);
	            y2.push(box.y + box.height);
	        }
	        x = mmin[apply](0, x);
	        y = mmin[apply](0, y);
	        x2 = mmax[apply](0, x2);
	        y2 = mmax[apply](0, y2);
	        return {
	            x: x,
	            y: y,
	            x2: x2,
	            y2: y2,
	            width: x2 - x,
	            height: y2 - y
	        };
	    };
	    setproto.clone = function (s) {
	        s = this.paper.set();
	        for (var i = 0, ii = this.items.length; i < ii; i++) {
	            s.push(this.items[i].clone());
	        }
	        return s;
	    };
	    setproto.toString = function () {
	        return "Rapha\xebl\u2018s set";
	    };

	    setproto.glow = function(glowConfig) {
	        var ret = this.paper.set();
	        this.forEach(function(shape, index){
	            var g = shape.glow(glowConfig);
	            if(g != null){
	                g.forEach(function(shape2, index2){
	                    ret.push(shape2);
	                });
	            }
	        });
	        return ret;
	    };


	    /*\
	     * Set.isPointInside
	     [ method ]
	     **
	     * Determine if given point is inside this set’s elements
	     **
	     > Parameters
	     **
	     - x (number) x coordinate of the point
	     - y (number) y coordinate of the point
	     = (boolean) `true` if point is inside any of the set's elements
	     \*/
	    setproto.isPointInside = function (x, y) {
	        var isPointInside = false;
	        this.forEach(function (el) {
	            if (el.isPointInside(x, y)) {
	                isPointInside = true;
	                return false; // stop loop
	            }
	        });
	        return isPointInside;
	    };

	    /*\
	     * Raphael.registerFont
	     [ method ]
	     **
	     * Adds given font to the registered set of fonts for Raphaël. Should be used as an internal call from within Cufón’s font file.
	     * Returns original parameter, so it could be used with chaining.
	     # <a href="http://wiki.github.com/sorccu/cufon/about">More about Cufón and how to convert your font form TTF, OTF, etc to JavaScript file.</a>
	     **
	     > Parameters
	     **
	     - font (object) the font to register
	     = (object) the font you passed in
	     > Usage
	     | Cufon.registerFont(Raphael.registerFont({…}));
	    \*/
	    R.registerFont = function (font) {
	        if (!font.face) {
	            return font;
	        }
	        this.fonts = this.fonts || {};
	        var fontcopy = {
	                w: font.w,
	                face: {},
	                glyphs: {}
	            },
	            family = font.face["font-family"];
	        for (var prop in font.face) if (font.face[has](prop)) {
	            fontcopy.face[prop] = font.face[prop];
	        }
	        if (this.fonts[family]) {
	            this.fonts[family].push(fontcopy);
	        } else {
	            this.fonts[family] = [fontcopy];
	        }
	        if (!font.svg) {
	            fontcopy.face["units-per-em"] = toInt(font.face["units-per-em"], 10);
	            for (var glyph in font.glyphs) if (font.glyphs[has](glyph)) {
	                var path = font.glyphs[glyph];
	                fontcopy.glyphs[glyph] = {
	                    w: path.w,
	                    k: {},
	                    d: path.d && "M" + path.d.replace(/[mlcxtrv]/g, function (command) {
	                            return {l: "L", c: "C", x: "z", t: "m", r: "l", v: "c"}[command] || "M";
	                        }) + "z"
	                };
	                if (path.k) {
	                    for (var k in path.k) if (path[has](k)) {
	                        fontcopy.glyphs[glyph].k[k] = path.k[k];
	                    }
	                }
	            }
	        }
	        return font;
	    };
	    /*\
	     * Paper.getFont
	     [ method ]
	     **
	     * Finds font object in the registered fonts by given parameters. You could specify only one word from the font name, like “Myriad” for “Myriad Pro”.
	     **
	     > Parameters
	     **
	     - family (string) font family name or any word from it
	     - weight (string) #optional font weight
	     - style (string) #optional font style
	     - stretch (string) #optional font stretch
	     = (object) the font object
	     > Usage
	     | paper.print(100, 100, "Test string", paper.getFont("Times", 800), 30);
	    \*/
	    paperproto.getFont = function (family, weight, style, stretch) {
	        stretch = stretch || "normal";
	        style = style || "normal";
	        weight = +weight || {normal: 400, bold: 700, lighter: 300, bolder: 800}[weight] || 400;
	        if (!R.fonts) {
	            return;
	        }
	        var font = R.fonts[family];
	        if (!font) {
	            var name = new RegExp("(^|\\s)" + family.replace(/[^\w\d\s+!~.:_-]/g, E) + "(\\s|$)", "i");
	            for (var fontName in R.fonts) if (R.fonts[has](fontName)) {
	                if (name.test(fontName)) {
	                    font = R.fonts[fontName];
	                    break;
	                }
	            }
	        }
	        var thefont;
	        if (font) {
	            for (var i = 0, ii = font.length; i < ii; i++) {
	                thefont = font[i];
	                if (thefont.face["font-weight"] == weight && (thefont.face["font-style"] == style || !thefont.face["font-style"]) && thefont.face["font-stretch"] == stretch) {
	                    break;
	                }
	            }
	        }
	        return thefont;
	    };
	    /*\
	     * Paper.print
	     [ method ]
	     **
	     * Creates path that represent given text written using given font at given position with given size.
	     * Result of the method is path element that contains whole text as a separate path.
	     **
	     > Parameters
	     **
	     - x (number) x position of the text
	     - y (number) y position of the text
	     - string (string) text to print
	     - font (object) font object, see @Paper.getFont
	     - size (number) #optional size of the font, default is `16`
	     - origin (string) #optional could be `"baseline"` or `"middle"`, default is `"middle"`
	     - letter_spacing (number) #optional number in range `-1..1`, default is `0`
	     - line_spacing (number) #optional number in range `1..3`, default is `1`
	     = (object) resulting path element, which consist of all letters
	     > Usage
	     | var txt = r.print(10, 50, "print", r.getFont("Museo"), 30).attr({fill: "#fff"});
	    \*/
	    paperproto.print = function (x, y, string, font, size, origin, letter_spacing, line_spacing) {
	        origin = origin || "middle"; // baseline|middle
	        letter_spacing = mmax(mmin(letter_spacing || 0, 1), -1);
	        line_spacing = mmax(mmin(line_spacing || 1, 3), 1);
	        var letters = Str(string)[split](E),
	            shift = 0,
	            notfirst = 0,
	            path = E,
	            scale;
	        R.is(font, "string") && (font = this.getFont(font));
	        if (font) {
	            scale = (size || 16) / font.face["units-per-em"];
	            var bb = font.face.bbox[split](separator),
	                top = +bb[0],
	                lineHeight = bb[3] - bb[1],
	                shifty = 0,
	                height = +bb[1] + (origin == "baseline" ? lineHeight + (+font.face.descent) : lineHeight / 2);
	            for (var i = 0, ii = letters.length; i < ii; i++) {
	                if (letters[i] == "\n") {
	                    shift = 0;
	                    curr = 0;
	                    notfirst = 0;
	                    shifty += lineHeight * line_spacing;
	                } else {
	                    var prev = notfirst && font.glyphs[letters[i - 1]] || {},
	                        curr = font.glyphs[letters[i]];
	                    shift += notfirst ? (prev.w || font.w) + (prev.k && prev.k[letters[i]] || 0) + (font.w * letter_spacing) : 0;
	                    notfirst = 1;
	                }
	                if (curr && curr.d) {
	                    path += R.transformPath(curr.d, ["t", shift * scale, shifty * scale, "s", scale, scale, top, height, "t", (x - top) / scale, (y - height) / scale]);
	                }
	            }
	        }
	        return this.path(path).attr({
	            fill: "#000",
	            stroke: "none"
	        });
	    };

	    /*\
	     * Paper.add
	     [ method ]
	     **
	     * Imports elements in JSON array in format `{type: type, <attributes>}`
	     **
	     > Parameters
	     **
	     - json (array)
	     = (object) resulting set of imported elements
	     > Usage
	     | paper.add([
	     |     {
	     |         type: "circle",
	     |         cx: 10,
	     |         cy: 10,
	     |         r: 5
	     |     },
	     |     {
	     |         type: "rect",
	     |         x: 10,
	     |         y: 10,
	     |         width: 10,
	     |         height: 10,
	     |         fill: "#fc0"
	     |     }
	     | ]);
	    \*/
	    paperproto.add = function (json) {
	        if (R.is(json, "array")) {
	            var res = this.set(),
	                i = 0,
	                ii = json.length,
	                j;
	            for (; i < ii; i++) {
	                j = json[i] || {};
	                elements[has](j.type) && res.push(this[j.type]().attr(j));
	            }
	        }
	        return res;
	    };

	    /*\
	     * Raphael.format
	     [ method ]
	     **
	     * Simple format function. Replaces construction of type “`{<number>}`” to the corresponding argument.
	     **
	     > Parameters
	     **
	     - token (string) string to format
	     - … (string) rest of arguments will be treated as parameters for replacement
	     = (string) formated string
	     > Usage
	     | var x = 10,
	     |     y = 20,
	     |     width = 40,
	     |     height = 50;
	     | // this will draw a rectangular shape equivalent to "M10,20h40v50h-40z"
	     | paper.path(Raphael.format("M{0},{1}h{2}v{3}h{4}z", x, y, width, height, -width));
	    \*/
	    R.format = function (token, params) {
	        var args = R.is(params, array) ? [0][concat](params) : arguments;
	        token && R.is(token, string) && args.length - 1 && (token = token.replace(formatrg, function (str, i) {
	            return args[++i] == null ? E : args[i];
	        }));
	        return token || E;
	    };
	    /*\
	     * Raphael.fullfill
	     [ method ]
	     **
	     * A little bit more advanced format function than @Raphael.format. Replaces construction of type “`{<name>}`” to the corresponding argument.
	     **
	     > Parameters
	     **
	     - token (string) string to format
	     - json (object) object which properties will be used as a replacement
	     = (string) formated string
	     > Usage
	     | // this will draw a rectangular shape equivalent to "M10,20h40v50h-40z"
	     | paper.path(Raphael.fullfill("M{x},{y}h{dim.width}v{dim.height}h{dim['negative width']}z", {
	     |     x: 10,
	     |     y: 20,
	     |     dim: {
	     |         width: 40,
	     |         height: 50,
	     |         "negative width": -40
	     |     }
	     | }));
	    \*/
	    R.fullfill = (function () {
	        var tokenRegex = /\{([^\}]+)\}/g,
	            objNotationRegex = /(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g, // matches .xxxxx or ["xxxxx"] to run over object properties
	            replacer = function (all, key, obj) {
	                var res = obj;
	                key.replace(objNotationRegex, function (all, name, quote, quotedName, isFunc) {
	                    name = name || quotedName;
	                    if (res) {
	                        if (name in res) {
	                            res = res[name];
	                        }
	                        typeof res == "function" && isFunc && (res = res());
	                    }
	                });
	                res = (res == null || res == obj ? all : res) + "";
	                return res;
	            };
	        return function (str, obj) {
	            return String(str).replace(tokenRegex, function (all, key) {
	                return replacer(all, key, obj);
	            });
	        };
	    })();
	    /*\
	     * Raphael.ninja
	     [ method ]
	     **
	     * If you want to leave no trace of Raphaël (Well, Raphaël creates only one global variable `Raphael`, but anyway.) You can use `ninja` method.
	     * Beware, that in this case plugins could stop working, because they are depending on global variable existence.
	     **
	     = (object) Raphael object
	     > Usage
	     | (function (local_raphael) {
	     |     var paper = local_raphael(10, 10, 320, 200);
	     |     …
	     | })(Raphael.ninja());
	    \*/
	    R.ninja = function () {
	        if (oldRaphael.was) {
	            g.win.Raphael = oldRaphael.is;
	        } else {
	            // IE8 raises an error when deleting window property
	            window.Raphael = undefined;
	            try {
	                delete window.Raphael;
	            } catch(e) {}
	        }
	        return R;
	    };
	    /*\
	     * Raphael.st
	     [ property (object) ]
	     **
	     * You can add your own method to elements and sets. It is wise to add a set method for each element method
	     * you added, so you will be able to call the same method on sets too.
	     **
	     * See also @Raphael.el.
	     > Usage
	     | Raphael.el.red = function () {
	     |     this.attr({fill: "#f00"});
	     | };
	     | Raphael.st.red = function () {
	     |     this.forEach(function (el) {
	     |         el.red();
	     |     });
	     | };
	     | // then use it
	     | paper.set(paper.circle(100, 100, 20), paper.circle(110, 100, 20)).red();
	    \*/
	    R.st = setproto;

	    eve.on("raphael.DOMload", function () {
	        loaded = true;
	    });

	    // Firefox <3.6 fix: http://webreflection.blogspot.com/2009/11/195-chars-to-help-lazy-loading.html
	    (function (doc, loaded, f) {
	        if (doc.readyState == null && doc.addEventListener){
	            doc.addEventListener(loaded, f = function () {
	                doc.removeEventListener(loaded, f, false);
	                doc.readyState = "complete";
	            }, false);
	            doc.readyState = "loading";
	        }
	        function isLoaded() {
	            (/in/).test(doc.readyState) ? setTimeout(isLoaded, 9) : R.eve("raphael.DOMload");
	        }
	        isLoaded();
	    })(document, "DOMContentLoaded");

	    return R;
	}.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;// Copyright (c) 2013 Adobe Systems Incorporated. All rights reserved.
	// 
	// Licensed under the Apache License, Version 2.0 (the "License");
	// you may not use this file except in compliance with the License.
	// You may obtain a copy of the License at
	// 
	// http://www.apache.org/licenses/LICENSE-2.0
	// 
	// Unless required by applicable law or agreed to in writing, software
	// distributed under the License is distributed on an "AS IS" BASIS,
	// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	// See the License for the specific language governing permissions and
	// limitations under the License.
	// ┌────────────────────────────────────────────────────────────┐ \\
	// │ Eve 0.5.0 - JavaScript Events Library                      │ \\
	// ├────────────────────────────────────────────────────────────┤ \\
	// │ Author Dmitry Baranovskiy (http://dmitry.baranovskiy.com/) │ \\
	// └────────────────────────────────────────────────────────────┘ \\

	(function (glob) {
	    var version = "0.5.0",
	        has = "hasOwnProperty",
	        separator = /[\.\/]/,
	        comaseparator = /\s*,\s*/,
	        wildcard = "*",
	        fun = function () {},
	        numsort = function (a, b) {
	            return a - b;
	        },
	        current_event,
	        stop,
	        events = {n: {}},
	        firstDefined = function () {
	            for (var i = 0, ii = this.length; i < ii; i++) {
	                if (typeof this[i] != "undefined") {
	                    return this[i];
	                }
	            }
	        },
	        lastDefined = function () {
	            var i = this.length;
	            while (--i) {
	                if (typeof this[i] != "undefined") {
	                    return this[i];
	                }
	            }
	        },
	        objtos = Object.prototype.toString,
	        Str = String,
	        isArray = Array.isArray || function (ar) {
	            return ar instanceof Array || objtos.call(ar) == "[object Array]";
	        };
	    /*\
	     * eve
	     [ method ]

	     * Fires event with given `name`, given scope and other parameters.

	     > Arguments

	     - name (string) name of the *event*, dot (`.`) or slash (`/`) separated
	     - scope (object) context for the event handlers
	     - varargs (...) the rest of arguments will be sent to event handlers

	     = (object) array of returned values from the listeners. Array has two methods `.firstDefined()` and `.lastDefined()` to get first or last not `undefined` value.
	    \*/
	        eve = function (name, scope) {
	            var e = events,
	                oldstop = stop,
	                args = Array.prototype.slice.call(arguments, 2),
	                listeners = eve.listeners(name),
	                z = 0,
	                f = false,
	                l,
	                indexed = [],
	                queue = {},
	                out = [],
	                ce = current_event,
	                errors = [];
	            out.firstDefined = firstDefined;
	            out.lastDefined = lastDefined;
	            current_event = name;
	            stop = 0;
	            for (var i = 0, ii = listeners.length; i < ii; i++) if ("zIndex" in listeners[i]) {
	                indexed.push(listeners[i].zIndex);
	                if (listeners[i].zIndex < 0) {
	                    queue[listeners[i].zIndex] = listeners[i];
	                }
	            }
	            indexed.sort(numsort);
	            while (indexed[z] < 0) {
	                l = queue[indexed[z++]];
	                out.push(l.apply(scope, args));
	                if (stop) {
	                    stop = oldstop;
	                    return out;
	                }
	            }
	            for (i = 0; i < ii; i++) {
	                l = listeners[i];
	                if ("zIndex" in l) {
	                    if (l.zIndex == indexed[z]) {
	                        out.push(l.apply(scope, args));
	                        if (stop) {
	                            break;
	                        }
	                        do {
	                            z++;
	                            l = queue[indexed[z]];
	                            l && out.push(l.apply(scope, args));
	                            if (stop) {
	                                break;
	                            }
	                        } while (l)
	                    } else {
	                        queue[l.zIndex] = l;
	                    }
	                } else {
	                    out.push(l.apply(scope, args));
	                    if (stop) {
	                        break;
	                    }
	                }
	            }
	            stop = oldstop;
	            current_event = ce;
	            return out;
	        };
	        // Undocumented. Debug only.
	        eve._events = events;
	    /*\
	     * eve.listeners
	     [ method ]

	     * Internal method which gives you array of all event handlers that will be triggered by the given `name`.

	     > Arguments

	     - name (string) name of the event, dot (`.`) or slash (`/`) separated

	     = (array) array of event handlers
	    \*/
	    eve.listeners = function (name) {
	        var names = isArray(name) ? name : name.split(separator),
	            e = events,
	            item,
	            items,
	            k,
	            i,
	            ii,
	            j,
	            jj,
	            nes,
	            es = [e],
	            out = [];
	        for (i = 0, ii = names.length; i < ii; i++) {
	            nes = [];
	            for (j = 0, jj = es.length; j < jj; j++) {
	                e = es[j].n;
	                items = [e[names[i]], e[wildcard]];
	                k = 2;
	                while (k--) {
	                    item = items[k];
	                    if (item) {
	                        nes.push(item);
	                        out = out.concat(item.f || []);
	                    }
	                }
	            }
	            es = nes;
	        }
	        return out;
	    };
	    /*\
	     * eve.separator
	     [ method ]

	     * If for some reasons you don’t like default separators (`.` or `/`) you can specify yours
	     * here. Be aware that if you pass a string longer than one character it will be treated as
	     * a list of characters.

	     - separator (string) new separator. Empty string resets to default: `.` or `/`.
	    \*/
	    eve.separator = function (sep) {
	        if (sep) {
	            sep = Str(sep).replace(/(?=[\.\^\]\[\-])/g, "\\");
	            sep = "[" + sep + "]";
	            separator = new RegExp(sep);
	        } else {
	            separator = /[\.\/]/;
	        }
	    };
	    /*\
	     * eve.on
	     [ method ]
	     **
	     * Binds given event handler with a given name. You can use wildcards “`*`” for the names:
	     | eve.on("*.under.*", f);
	     | eve("mouse.under.floor"); // triggers f
	     * Use @eve to trigger the listener.
	     **
	     - name (string) name of the event, dot (`.`) or slash (`/`) separated, with optional wildcards
	     - f (function) event handler function
	     **
	     - name (array) if you don’t want to use separators, you can use array of strings
	     - f (function) event handler function
	     **
	     = (function) returned function accepts a single numeric parameter that represents z-index of the handler. It is an optional feature and only used when you need to ensure that some subset of handlers will be invoked in a given order, despite of the order of assignment. 
	     > Example:
	     | eve.on("mouse", eatIt)(2);
	     | eve.on("mouse", scream);
	     | eve.on("mouse", catchIt)(1);
	     * This will ensure that `catchIt` function will be called before `eatIt`.
	     *
	     * If you want to put your handler before non-indexed handlers, specify a negative value.
	     * Note: I assume most of the time you don’t need to worry about z-index, but it’s nice to have this feature “just in case”.
	    \*/
	    eve.on = function (name, f) {
	        if (typeof f != "function") {
	            return function () {};
	        }
	        var names = isArray(name) ? (isArray(name[0]) ? name : [name]) : Str(name).split(comaseparator);
	        for (var i = 0, ii = names.length; i < ii; i++) {
	            (function (name) {
	                var names = isArray(name) ? name : Str(name).split(separator),
	                    e = events,
	                    exist;
	                for (var i = 0, ii = names.length; i < ii; i++) {
	                    e = e.n;
	                    e = e.hasOwnProperty(names[i]) && e[names[i]] || (e[names[i]] = {n: {}});
	                }
	                e.f = e.f || [];
	                for (i = 0, ii = e.f.length; i < ii; i++) if (e.f[i] == f) {
	                    exist = true;
	                    break;
	                }
	                !exist && e.f.push(f);
	            }(names[i]));
	        }
	        return function (zIndex) {
	            if (+zIndex == +zIndex) {
	                f.zIndex = +zIndex;
	            }
	        };
	    };
	    /*\
	     * eve.f
	     [ method ]
	     **
	     * Returns function that will fire given event with optional arguments.
	     * Arguments that will be passed to the result function will be also
	     * concated to the list of final arguments.
	     | el.onclick = eve.f("click", 1, 2);
	     | eve.on("click", function (a, b, c) {
	     |     console.log(a, b, c); // 1, 2, [event object]
	     | });
	     > Arguments
	     - event (string) event name
	     - varargs (…) and any other arguments
	     = (function) possible event handler function
	    \*/
	    eve.f = function (event) {
	        var attrs = [].slice.call(arguments, 1);
	        return function () {
	            eve.apply(null, [event, null].concat(attrs).concat([].slice.call(arguments, 0)));
	        };
	    };
	    /*\
	     * eve.stop
	     [ method ]
	     **
	     * Is used inside an event handler to stop the event, preventing any subsequent listeners from firing.
	    \*/
	    eve.stop = function () {
	        stop = 1;
	    };
	    /*\
	     * eve.nt
	     [ method ]
	     **
	     * Could be used inside event handler to figure out actual name of the event.
	     **
	     > Arguments
	     **
	     - subname (string) #optional subname of the event
	     **
	     = (string) name of the event, if `subname` is not specified
	     * or
	     = (boolean) `true`, if current event’s name contains `subname`
	    \*/
	    eve.nt = function (subname) {
	        var cur = isArray(current_event) ? current_event.join(".") : current_event;
	        if (subname) {
	            return new RegExp("(?:\\.|\\/|^)" + subname + "(?:\\.|\\/|$)").test(cur);
	        }
	        return cur;
	    };
	    /*\
	     * eve.nts
	     [ method ]
	     **
	     * Could be used inside event handler to figure out actual name of the event.
	     **
	     **
	     = (array) names of the event
	    \*/
	    eve.nts = function () {
	        return isArray(current_event) ? current_event : current_event.split(separator);
	    };
	    /*\
	     * eve.off
	     [ method ]
	     **
	     * Removes given function from the list of event listeners assigned to given name.
	     * If no arguments specified all the events will be cleared.
	     **
	     > Arguments
	     **
	     - name (string) name of the event, dot (`.`) or slash (`/`) separated, with optional wildcards
	     - f (function) event handler function
	    \*/
	    /*\
	     * eve.unbind
	     [ method ]
	     **
	     * See @eve.off
	    \*/
	    eve.off = eve.unbind = function (name, f) {
	        if (!name) {
	            eve._events = events = {n: {}};
	            return;
	        }
	        var names = isArray(name) ? (isArray(name[0]) ? name : [name]) : Str(name).split(comaseparator);
	        if (names.length > 1) {
	            for (var i = 0, ii = names.length; i < ii; i++) {
	                eve.off(names[i], f);
	            }
	            return;
	        }
	        names = isArray(name) ? name : Str(name).split(separator);
	        var e,
	            key,
	            splice,
	            i, ii, j, jj,
	            cur = [events];
	        for (i = 0, ii = names.length; i < ii; i++) {
	            for (j = 0; j < cur.length; j += splice.length - 2) {
	                splice = [j, 1];
	                e = cur[j].n;
	                if (names[i] != wildcard) {
	                    if (e[names[i]]) {
	                        splice.push(e[names[i]]);
	                    }
	                } else {
	                    for (key in e) if (e[has](key)) {
	                        splice.push(e[key]);
	                    }
	                }
	                cur.splice.apply(cur, splice);
	            }
	        }
	        for (i = 0, ii = cur.length; i < ii; i++) {
	            e = cur[i];
	            while (e.n) {
	                if (f) {
	                    if (e.f) {
	                        for (j = 0, jj = e.f.length; j < jj; j++) if (e.f[j] == f) {
	                            e.f.splice(j, 1);
	                            break;
	                        }
	                        !e.f.length && delete e.f;
	                    }
	                    for (key in e.n) if (e.n[has](key) && e.n[key].f) {
	                        var funcs = e.n[key].f;
	                        for (j = 0, jj = funcs.length; j < jj; j++) if (funcs[j] == f) {
	                            funcs.splice(j, 1);
	                            break;
	                        }
	                        !funcs.length && delete e.n[key].f;
	                    }
	                } else {
	                    delete e.f;
	                    for (key in e.n) if (e.n[has](key) && e.n[key].f) {
	                        delete e.n[key].f;
	                    }
	                }
	                e = e.n;
	            }
	        }
	    };
	    /*\
	     * eve.once
	     [ method ]
	     **
	     * Binds given event handler with a given name to only run once then unbind itself.
	     | eve.once("login", f);
	     | eve("login"); // triggers f
	     | eve("login"); // no listeners
	     * Use @eve to trigger the listener.
	     **
	     > Arguments
	     **
	     - name (string) name of the event, dot (`.`) or slash (`/`) separated, with optional wildcards
	     - f (function) event handler function
	     **
	     = (function) same return function as @eve.on
	    \*/
	    eve.once = function (name, f) {
	        var f2 = function () {
	            eve.off(name, f2);
	            return f.apply(this, arguments);
	        };
	        return eve.on(name, f2);
	    };
	    /*\
	     * eve.version
	     [ property (string) ]
	     **
	     * Current version of the library.
	    \*/
	    eve.version = version;
	    eve.toString = function () {
	        return "You are running Eve " + version;
	    };
	    (typeof module != "undefined" && module.exports) ? (module.exports = eve) : ( true ? (!(__WEBPACK_AMD_DEFINE_ARRAY__ = [], __WEBPACK_AMD_DEFINE_RESULT__ = function() { return eve; }.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__))) : (glob.eve = eve));
	})(this);


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;!(__WEBPACK_AMD_DEFINE_ARRAY__ = [__webpack_require__(1)], __WEBPACK_AMD_DEFINE_RESULT__ = function(R) {
	    if (R && !R.svg) {
	        return;
	    }

	    var has = "hasOwnProperty",
	        Str = String,
	        toFloat = parseFloat,
	        toInt = parseInt,
	        math = Math,
	        mmax = math.max,
	        abs = math.abs,
	        pow = math.pow,
	        separator = /[, ]+/,
	        eve = R.eve,
	        E = "",
	        S = " ";
	    var xlink = "http://www.w3.org/1999/xlink",
	        markers = {
	            block: "M5,0 0,2.5 5,5z",
	            classic: "M5,0 0,2.5 5,5 3.5,3 3.5,2z",
	            diamond: "M2.5,0 5,2.5 2.5,5 0,2.5z",
	            open: "M6,1 1,3.5 6,6",
	            oval: "M2.5,0A2.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,0z"
	        },
	        markerCounter = {};
	    R.toString = function () {
	        return  "Your browser supports SVG.\nYou are running Rapha\xebl " + this.version;
	    };
	    var $ = function (el, attr) {
	        if (attr) {
	            if (typeof el == "string") {
	                el = $(el);
	            }
	            for (var key in attr) if (attr[has](key)) {
	                if (key.substring(0, 6) == "xlink:") {
	                    el.setAttributeNS(xlink, key.substring(6), Str(attr[key]));
	                } else {
	                    el.setAttribute(key, Str(attr[key]));
	                }
	            }
	        } else {
	            el = R._g.doc.createElementNS("http://www.w3.org/2000/svg", el);
	            el.style && (el.style.webkitTapHighlightColor = "rgba(0,0,0,0)");
	        }
	        return el;
	    },
	    addGradientFill = function (element, gradient) {
	        var type = "linear",
	            id = element.id + gradient,
	            fx = .5, fy = .5,
	            o = element.node,
	            SVG = element.paper,
	            s = o.style,
	            el = R._g.doc.getElementById(id);
	        if (!el) {
	            gradient = Str(gradient).replace(R._radial_gradient, function (all, _fx, _fy) {
	                type = "radial";
	                if (_fx && _fy) {
	                    fx = toFloat(_fx);
	                    fy = toFloat(_fy);
	                    var dir = ((fy > .5) * 2 - 1);
	                    pow(fx - .5, 2) + pow(fy - .5, 2) > .25 &&
	                        (fy = math.sqrt(.25 - pow(fx - .5, 2)) * dir + .5) &&
	                        fy != .5 &&
	                        (fy = fy.toFixed(5) - 1e-5 * dir);
	                }
	                return E;
	            });
	            gradient = gradient.split(/\s*\-\s*/);
	            if (type == "linear") {
	                var angle = gradient.shift();
	                angle = -toFloat(angle);
	                if (isNaN(angle)) {
	                    return null;
	                }
	                var vector = [0, 0, math.cos(R.rad(angle)), math.sin(R.rad(angle))],
	                    max = 1 / (mmax(abs(vector[2]), abs(vector[3])) || 1);
	                vector[2] *= max;
	                vector[3] *= max;
	                if (vector[2] < 0) {
	                    vector[0] = -vector[2];
	                    vector[2] = 0;
	                }
	                if (vector[3] < 0) {
	                    vector[1] = -vector[3];
	                    vector[3] = 0;
	                }
	            }
	            var dots = R._parseDots(gradient);
	            if (!dots) {
	                return null;
	            }
	            id = id.replace(/[\(\)\s,\xb0#]/g, "_");

	            if (element.gradient && id != element.gradient.id) {
	                SVG.defs.removeChild(element.gradient);
	                delete element.gradient;
	            }

	            if (!element.gradient) {
	                el = $(type + "Gradient", {id: id});
	                element.gradient = el;
	                $(el, type == "radial" ? {
	                    fx: fx,
	                    fy: fy
	                } : {
	                    x1: vector[0],
	                    y1: vector[1],
	                    x2: vector[2],
	                    y2: vector[3],
	                    gradientTransform: element.matrix.invert()
	                });
	                SVG.defs.appendChild(el);
	                for (var i = 0, ii = dots.length; i < ii; i++) {
	                    el.appendChild($("stop", {
	                        offset: dots[i].offset ? dots[i].offset : i ? "100%" : "0%",
	                        "stop-color": dots[i].color || "#fff",
	                        "stop-opacity": isFinite(dots[i].opacity) ? dots[i].opacity : 1
	                    }));
	                }
	            }
	        }
	        $(o, {
	            fill: fillurl(id),
	            opacity: 1,
	            "fill-opacity": 1
	        });
	        s.fill = E;
	        s.opacity = 1;
	        s.fillOpacity = 1;
	        return 1;
	    },
	    isIE9or10 = function () {
	      var mode = document.documentMode;
	      return mode && (mode === 9 || mode === 10);
	    },
	    fillurl = function (id) {
	      if (isIE9or10()) {
	          return "url('#" + id + "')";
	      }
	      var location = document.location;
	      var locationString = (
	          location.protocol + '//' +
	          location.host +
	          location.pathname +
	          location.search
	      );
	      return "url('" + locationString + "#" + id + "')";
	    },
	    updatePosition = function (o) {
	        var bbox = o.getBBox(1);
	        $(o.pattern, {patternTransform: o.matrix.invert() + " translate(" + bbox.x + "," + bbox.y + ")"});
	    },
	    addArrow = function (o, value, isEnd) {
	        if (o.type == "path") {
	            var values = Str(value).toLowerCase().split("-"),
	                p = o.paper,
	                se = isEnd ? "end" : "start",
	                node = o.node,
	                attrs = o.attrs,
	                stroke = attrs["stroke-width"],
	                i = values.length,
	                type = "classic",
	                from,
	                to,
	                dx,
	                refX,
	                attr,
	                w = 3,
	                h = 3,
	                t = 5;
	            while (i--) {
	                switch (values[i]) {
	                    case "block":
	                    case "classic":
	                    case "oval":
	                    case "diamond":
	                    case "open":
	                    case "none":
	                        type = values[i];
	                        break;
	                    case "wide": h = 5; break;
	                    case "narrow": h = 2; break;
	                    case "long": w = 5; break;
	                    case "short": w = 2; break;
	                }
	            }
	            if (type == "open") {
	                w += 2;
	                h += 2;
	                t += 2;
	                dx = 1;
	                refX = isEnd ? 4 : 1;
	                attr = {
	                    fill: "none",
	                    stroke: attrs.stroke
	                };
	            } else {
	                refX = dx = w / 2;
	                attr = {
	                    fill: attrs.stroke,
	                    stroke: "none"
	                };
	            }
	            if (o._.arrows) {
	                if (isEnd) {
	                    o._.arrows.endPath && markerCounter[o._.arrows.endPath]--;
	                    o._.arrows.endMarker && markerCounter[o._.arrows.endMarker]--;
	                } else {
	                    o._.arrows.startPath && markerCounter[o._.arrows.startPath]--;
	                    o._.arrows.startMarker && markerCounter[o._.arrows.startMarker]--;
	                }
	            } else {
	                o._.arrows = {};
	            }
	            if (type != "none") {
	                var pathId = "raphael-marker-" + type,
	                    markerId = "raphael-marker-" + se + type + w + h + "-obj" + o.id;
	                if (!R._g.doc.getElementById(pathId)) {
	                    p.defs.appendChild($($("path"), {
	                        "stroke-linecap": "round",
	                        d: markers[type],
	                        id: pathId
	                    }));
	                    markerCounter[pathId] = 1;
	                } else {
	                    markerCounter[pathId]++;
	                }
	                var marker = R._g.doc.getElementById(markerId),
	                    use;
	                if (!marker) {
	                    marker = $($("marker"), {
	                        id: markerId,
	                        markerHeight: h,
	                        markerWidth: w,
	                        orient: "auto",
	                        refX: refX,
	                        refY: h / 2
	                    });
	                    use = $($("use"), {
	                        "xlink:href": "#" + pathId,
	                        transform: (isEnd ? "rotate(180 " + w / 2 + " " + h / 2 + ") " : E) + "scale(" + w / t + "," + h / t + ")",
	                        "stroke-width": (1 / ((w / t + h / t) / 2)).toFixed(4)
	                    });
	                    marker.appendChild(use);
	                    p.defs.appendChild(marker);
	                    markerCounter[markerId] = 1;
	                } else {
	                    markerCounter[markerId]++;
	                    use = marker.getElementsByTagName("use")[0];
	                }
	                $(use, attr);
	                var delta = dx * (type != "diamond" && type != "oval");
	                if (isEnd) {
	                    from = o._.arrows.startdx * stroke || 0;
	                    to = R.getTotalLength(attrs.path) - delta * stroke;
	                } else {
	                    from = delta * stroke;
	                    to = R.getTotalLength(attrs.path) - (o._.arrows.enddx * stroke || 0);
	                }
	                attr = {};
	                attr["marker-" + se] = "url(#" + markerId + ")";
	                if (to || from) {
	                    attr.d = R.getSubpath(attrs.path, from, to);
	                }
	                $(node, attr);
	                o._.arrows[se + "Path"] = pathId;
	                o._.arrows[se + "Marker"] = markerId;
	                o._.arrows[se + "dx"] = delta;
	                o._.arrows[se + "Type"] = type;
	                o._.arrows[se + "String"] = value;
	            } else {
	                if (isEnd) {
	                    from = o._.arrows.startdx * stroke || 0;
	                    to = R.getTotalLength(attrs.path) - from;
	                } else {
	                    from = 0;
	                    to = R.getTotalLength(attrs.path) - (o._.arrows.enddx * stroke || 0);
	                }
	                o._.arrows[se + "Path"] && $(node, {d: R.getSubpath(attrs.path, from, to)});
	                delete o._.arrows[se + "Path"];
	                delete o._.arrows[se + "Marker"];
	                delete o._.arrows[se + "dx"];
	                delete o._.arrows[se + "Type"];
	                delete o._.arrows[se + "String"];
	            }
	            for (attr in markerCounter) if (markerCounter[has](attr) && !markerCounter[attr]) {
	                var item = R._g.doc.getElementById(attr);
	                item && item.parentNode.removeChild(item);
	            }
	        }
	    },
	    dasharray = {
	        "-": [3, 1],
	        ".": [1, 1],
	        "-.": [3, 1, 1, 1],
	        "-..": [3, 1, 1, 1, 1, 1],
	        ". ": [1, 3],
	        "- ": [4, 3],
	        "--": [8, 3],
	        "- .": [4, 3, 1, 3],
	        "--.": [8, 3, 1, 3],
	        "--..": [8, 3, 1, 3, 1, 3]
	    },
	    addDashes = function (o, value, params) {
	        value = dasharray[Str(value).toLowerCase()];
	        if (value) {
	            var width = o.attrs["stroke-width"] || "1",
	                butt = {round: width, square: width, butt: 0}[o.attrs["stroke-linecap"] || params["stroke-linecap"]] || 0,
	                dashes = [],
	                i = value.length;
	            while (i--) {
	                dashes[i] = value[i] * width + ((i % 2) ? 1 : -1) * butt;
	            }
	            $(o.node, {"stroke-dasharray": dashes.join(",")});
	        }
	        else {
	          $(o.node, {"stroke-dasharray": "none"});
	        }
	    },
	    setFillAndStroke = function (o, params) {
	        var node = o.node,
	            attrs = o.attrs,
	            vis = node.style.visibility;
	        node.style.visibility = "hidden";
	        for (var att in params) {
	            if (params[has](att)) {
	                if (!R._availableAttrs[has](att)) {
	                    continue;
	                }
	                var value = params[att];
	                attrs[att] = value;
	                switch (att) {
	                    case "blur":
	                        o.blur(value);
	                        break;
	                    case "title":
	                        var title = node.getElementsByTagName("title");

	                        // Use the existing <title>.
	                        if (title.length && (title = title[0])) {
	                          title.firstChild.nodeValue = value;
	                        } else {
	                          title = $("title");
	                          var val = R._g.doc.createTextNode(value);
	                          title.appendChild(val);
	                          node.appendChild(title);
	                        }
	                        break;
	                    case "href":
	                    case "target":
	                        var pn = node.parentNode;
	                        if (pn.tagName.toLowerCase() != "a") {
	                            var hl = $("a");
	                            pn.insertBefore(hl, node);
	                            hl.appendChild(node);
	                            pn = hl;
	                        }
	                        if (att == "target") {
	                            pn.setAttributeNS(xlink, "show", value == "blank" ? "new" : value);
	                        } else {
	                            pn.setAttributeNS(xlink, att, value);
	                        }
	                        break;
	                    case "cursor":
	                        node.style.cursor = value;
	                        break;
	                    case "transform":
	                        o.transform(value);
	                        break;
	                    case "arrow-start":
	                        addArrow(o, value);
	                        break;
	                    case "arrow-end":
	                        addArrow(o, value, 1);
	                        break;
	                    case "clip-rect":
	                        var rect = Str(value).split(separator);
	                        if (rect.length == 4) {
	                            o.clip && o.clip.parentNode.parentNode.removeChild(o.clip.parentNode);
	                            var el = $("clipPath"),
	                                rc = $("rect");
	                            el.id = R.createUUID();
	                            $(rc, {
	                                x: rect[0],
	                                y: rect[1],
	                                width: rect[2],
	                                height: rect[3]
	                            });
	                            el.appendChild(rc);
	                            o.paper.defs.appendChild(el);
	                            $(node, {"clip-path": "url(#" + el.id + ")"});
	                            o.clip = rc;
	                        }
	                        if (!value) {
	                            var path = node.getAttribute("clip-path");
	                            if (path) {
	                                var clip = R._g.doc.getElementById(path.replace(/(^url\(#|\)$)/g, E));
	                                clip && clip.parentNode.removeChild(clip);
	                                $(node, {"clip-path": E});
	                                delete o.clip;
	                            }
	                        }
	                    break;
	                    case "path":
	                        if (o.type == "path") {
	                            $(node, {d: value ? attrs.path = R._pathToAbsolute(value) : "M0,0"});
	                            o._.dirty = 1;
	                            if (o._.arrows) {
	                                "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
	                                "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
	                            }
	                        }
	                        break;
	                    case "width":
	                        node.setAttribute(att, value);
	                        o._.dirty = 1;
	                        if (attrs.fx) {
	                            att = "x";
	                            value = attrs.x;
	                        } else {
	                            break;
	                        }
	                    case "x":
	                        if (attrs.fx) {
	                            value = -attrs.x - (attrs.width || 0);
	                        }
	                    case "rx":
	                        if (att == "rx" && o.type == "rect") {
	                            break;
	                        }
	                    case "cx":
	                        node.setAttribute(att, value);
	                        o.pattern && updatePosition(o);
	                        o._.dirty = 1;
	                        break;
	                    case "height":
	                        node.setAttribute(att, value);
	                        o._.dirty = 1;
	                        if (attrs.fy) {
	                            att = "y";
	                            value = attrs.y;
	                        } else {
	                            break;
	                        }
	                    case "y":
	                        if (attrs.fy) {
	                            value = -attrs.y - (attrs.height || 0);
	                        }
	                    case "ry":
	                        if (att == "ry" && o.type == "rect") {
	                            break;
	                        }
	                    case "cy":
	                        node.setAttribute(att, value);
	                        o.pattern && updatePosition(o);
	                        o._.dirty = 1;
	                        break;
	                    case "r":
	                        if (o.type == "rect") {
	                            $(node, {rx: value, ry: value});
	                        } else {
	                            node.setAttribute(att, value);
	                        }
	                        o._.dirty = 1;
	                        break;
	                    case "src":
	                        if (o.type == "image") {
	                            node.setAttributeNS(xlink, "href", value);
	                        }
	                        break;
	                    case "stroke-width":
	                        if (o._.sx != 1 || o._.sy != 1) {
	                            value /= mmax(abs(o._.sx), abs(o._.sy)) || 1;
	                        }
	                        node.setAttribute(att, value);
	                        if (attrs["stroke-dasharray"]) {
	                            addDashes(o, attrs["stroke-dasharray"], params);
	                        }
	                        if (o._.arrows) {
	                            "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
	                            "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
	                        }
	                        break;
	                    case "stroke-dasharray":
	                        addDashes(o, value, params);
	                        break;
	                    case "fill":
	                        var isURL = Str(value).match(R._ISURL);
	                        if (isURL) {
	                            el = $("pattern");
	                            var ig = $("image");
	                            el.id = R.createUUID();
	                            $(el, {x: 0, y: 0, patternUnits: "userSpaceOnUse", height: 1, width: 1});
	                            $(ig, {x: 0, y: 0, "xlink:href": isURL[1]});
	                            el.appendChild(ig);

	                            (function (el) {
	                                R._preload(isURL[1], function () {
	                                    var w = this.offsetWidth,
	                                        h = this.offsetHeight;
	                                    $(el, {width: w, height: h});
	                                    $(ig, {width: w, height: h});
	                                });
	                            })(el);
	                            o.paper.defs.appendChild(el);
	                            $(node, {fill: "url(#" + el.id + ")"});
	                            o.pattern = el;
	                            o.pattern && updatePosition(o);
	                            break;
	                        }
	                        var clr = R.getRGB(value);
	                        if (!clr.error) {
	                            delete params.gradient;
	                            delete attrs.gradient;
	                            !R.is(attrs.opacity, "undefined") &&
	                                R.is(params.opacity, "undefined") &&
	                                $(node, {opacity: attrs.opacity});
	                            !R.is(attrs["fill-opacity"], "undefined") &&
	                                R.is(params["fill-opacity"], "undefined") &&
	                                $(node, {"fill-opacity": attrs["fill-opacity"]});
	                        } else if ((o.type == "circle" || o.type == "ellipse" || Str(value).charAt() != "r") && addGradientFill(o, value)) {
	                            if ("opacity" in attrs || "fill-opacity" in attrs) {
	                                var gradient = R._g.doc.getElementById(node.getAttribute("fill").replace(/^url\(#|\)$/g, E));
	                                if (gradient) {
	                                    var stops = gradient.getElementsByTagName("stop");
	                                    $(stops[stops.length - 1], {"stop-opacity": ("opacity" in attrs ? attrs.opacity : 1) * ("fill-opacity" in attrs ? attrs["fill-opacity"] : 1)});
	                                }
	                            }
	                            attrs.gradient = value;
	                            attrs.fill = "none";
	                            break;
	                        }
	                        clr[has]("opacity") && $(node, {"fill-opacity": clr.opacity > 1 ? clr.opacity / 100 : clr.opacity});
	                    case "stroke":
	                        clr = R.getRGB(value);
	                        node.setAttribute(att, clr.hex);
	                        att == "stroke" && clr[has]("opacity") && $(node, {"stroke-opacity": clr.opacity > 1 ? clr.opacity / 100 : clr.opacity});
	                        if (att == "stroke" && o._.arrows) {
	                            "startString" in o._.arrows && addArrow(o, o._.arrows.startString);
	                            "endString" in o._.arrows && addArrow(o, o._.arrows.endString, 1);
	                        }
	                        break;
	                    case "gradient":
	                        (o.type == "circle" || o.type == "ellipse" || Str(value).charAt() != "r") && addGradientFill(o, value);
	                        break;
	                    case "opacity":
	                        if (attrs.gradient && !attrs[has]("stroke-opacity")) {
	                            $(node, {"stroke-opacity": value > 1 ? value / 100 : value});
	                        }
	                        // fall
	                    case "fill-opacity":
	                        if (attrs.gradient) {
	                            gradient = R._g.doc.getElementById(node.getAttribute("fill").replace(/^url\(#|\)$/g, E));
	                            if (gradient) {
	                                stops = gradient.getElementsByTagName("stop");
	                                $(stops[stops.length - 1], {"stop-opacity": value});
	                            }
	                            break;
	                        }
	                    default:
	                        att == "font-size" && (value = toInt(value, 10) + "px");
	                        var cssrule = att.replace(/(\-.)/g, function (w) {
	                            return w.substring(1).toUpperCase();
	                        });
	                        node.style[cssrule] = value;
	                        o._.dirty = 1;
	                        node.setAttribute(att, value);
	                        break;
	                }
	            }
	        }

	        tuneText(o, params);
	        node.style.visibility = vis;
	    },
	    leading = 1.2,
	    tuneText = function (el, params) {
	        if (el.type != "text" || !(params[has]("text") || params[has]("font") || params[has]("font-size") || params[has]("x") || params[has]("y"))) {
	            return;
	        }
	        var a = el.attrs,
	            node = el.node,
	            fontSize = node.firstChild ? toInt(R._g.doc.defaultView.getComputedStyle(node.firstChild, E).getPropertyValue("font-size"), 10) : 10;

	        if (params[has]("text")) {
	            a.text = params.text;
	            while (node.firstChild) {
	                node.removeChild(node.firstChild);
	            }
	            var texts = Str(params.text).split("\n"),
	                tspans = [],
	                tspan;
	            for (var i = 0, ii = texts.length; i < ii; i++) {
	                tspan = $("tspan");
	                i && $(tspan, {dy: fontSize * leading, x: a.x});
	                tspan.appendChild(R._g.doc.createTextNode(texts[i]));
	                node.appendChild(tspan);
	                tspans[i] = tspan;
	            }
	        } else {
	            tspans = node.getElementsByTagName("tspan");
	            for (i = 0, ii = tspans.length; i < ii; i++) if (i) {
	                $(tspans[i], {dy: fontSize * leading, x: a.x});
	            } else {
	                $(tspans[0], {dy: 0});
	            }
	        }
	        $(node, {x: a.x, y: a.y});
	        el._.dirty = 1;
	        var bb = el._getBBox(),
	            dif = a.y - (bb.y + bb.height / 2);
	        dif && R.is(dif, "finite") && $(tspans[0], {dy: dif});
	    },
	    getRealNode = function (node) {
	        if (node.parentNode && node.parentNode.tagName.toLowerCase() === "a") {
	            return node.parentNode;
	        } else {
	            return node;
	        }
	    },
	    Element = function (node, svg) {
	        var X = 0,
	            Y = 0;
	        /*\
	         * Element.node
	         [ property (object) ]
	         **
	         * Gives you a reference to the DOM object, so you can assign event handlers or just mess around.
	         **
	         * Note: Don’t mess with it.
	         > Usage
	         | // draw a circle at coordinate 10,10 with radius of 10
	         | var c = paper.circle(10, 10, 10);
	         | c.node.onclick = function () {
	         |     c.attr("fill", "red");
	         | };
	        \*/
	        this[0] = this.node = node;
	        /*\
	         * Element.raphael
	         [ property (object) ]
	         **
	         * Internal reference to @Raphael object. In case it is not available.
	         > Usage
	         | Raphael.el.red = function () {
	         |     var hsb = this.paper.raphael.rgb2hsb(this.attr("fill"));
	         |     hsb.h = 1;
	         |     this.attr({fill: this.paper.raphael.hsb2rgb(hsb).hex});
	         | }
	        \*/
	        node.raphael = true;
	        /*\
	         * Element.id
	         [ property (number) ]
	         **
	         * Unique id of the element. Especially useful when you want to listen to events of the element,
	         * because all events are fired in format `<module>.<action>.<id>`. Also useful for @Paper.getById method.
	        \*/
	        this.id = guid();
	        node.raphaelid = this.id;

	        /**
	        * Method that returns a 5 letter/digit id, enough for 36^5 = 60466176 elements
	        * @returns {string} id
	        */
	        function guid() {
	            return ("0000" + (Math.random()*Math.pow(36,5) << 0).toString(36)).slice(-5);
	        }

	        this.matrix = R.matrix();
	        this.realPath = null;
	        /*\
	         * Element.paper
	         [ property (object) ]
	         **
	         * Internal reference to “paper” where object drawn. Mainly for use in plugins and element extensions.
	         > Usage
	         | Raphael.el.cross = function () {
	         |     this.attr({fill: "red"});
	         |     this.paper.path("M10,10L50,50M50,10L10,50")
	         |         .attr({stroke: "red"});
	         | }
	        \*/
	        this.paper = svg;
	        this.attrs = this.attrs || {};
	        this._ = {
	            transform: [],
	            sx: 1,
	            sy: 1,
	            deg: 0,
	            dx: 0,
	            dy: 0,
	            dirty: 1
	        };
	        !svg.bottom && (svg.bottom = this);
	        /*\
	         * Element.prev
	         [ property (object) ]
	         **
	         * Reference to the previous element in the hierarchy.
	        \*/
	        this.prev = svg.top;
	        svg.top && (svg.top.next = this);
	        svg.top = this;
	        /*\
	         * Element.next
	         [ property (object) ]
	         **
	         * Reference to the next element in the hierarchy.
	        \*/
	        this.next = null;
	    },
	    elproto = R.el;

	    Element.prototype = elproto;
	    elproto.constructor = Element;

	    R._engine.path = function (pathString, SVG) {
	        var el = $("path");
	        SVG.canvas && SVG.canvas.appendChild(el);
	        var p = new Element(el, SVG);
	        p.type = "path";
	        setFillAndStroke(p, {
	            fill: "none",
	            stroke: "#000",
	            path: pathString
	        });
	        return p;
	    };
	    /*\
	     * Element.rotate
	     [ method ]
	     **
	     * Deprecated! Use @Element.transform instead.
	     * Adds rotation by given angle around given point to the list of
	     * transformations of the element.
	     > Parameters
	     - deg (number) angle in degrees
	     - cx (number) #optional x coordinate of the centre of rotation
	     - cy (number) #optional y coordinate of the centre of rotation
	     * If cx & cy aren’t specified centre of the shape is used as a point of rotation.
	     = (object) @Element
	    \*/
	    elproto.rotate = function (deg, cx, cy) {
	        if (this.removed) {
	            return this;
	        }
	        deg = Str(deg).split(separator);
	        if (deg.length - 1) {
	            cx = toFloat(deg[1]);
	            cy = toFloat(deg[2]);
	        }
	        deg = toFloat(deg[0]);
	        (cy == null) && (cx = cy);
	        if (cx == null || cy == null) {
	            var bbox = this.getBBox(1);
	            cx = bbox.x + bbox.width / 2;
	            cy = bbox.y + bbox.height / 2;
	        }
	        this.transform(this._.transform.concat([["r", deg, cx, cy]]));
	        return this;
	    };
	    /*\
	     * Element.scale
	     [ method ]
	     **
	     * Deprecated! Use @Element.transform instead.
	     * Adds scale by given amount relative to given point to the list of
	     * transformations of the element.
	     > Parameters
	     - sx (number) horisontal scale amount
	     - sy (number) vertical scale amount
	     - cx (number) #optional x coordinate of the centre of scale
	     - cy (number) #optional y coordinate of the centre of scale
	     * If cx & cy aren’t specified centre of the shape is used instead.
	     = (object) @Element
	    \*/
	    elproto.scale = function (sx, sy, cx, cy) {
	        if (this.removed) {
	            return this;
	        }
	        sx = Str(sx).split(separator);
	        if (sx.length - 1) {
	            sy = toFloat(sx[1]);
	            cx = toFloat(sx[2]);
	            cy = toFloat(sx[3]);
	        }
	        sx = toFloat(sx[0]);
	        (sy == null) && (sy = sx);
	        (cy == null) && (cx = cy);
	        if (cx == null || cy == null) {
	            var bbox = this.getBBox(1);
	        }
	        cx = cx == null ? bbox.x + bbox.width / 2 : cx;
	        cy = cy == null ? bbox.y + bbox.height / 2 : cy;
	        this.transform(this._.transform.concat([["s", sx, sy, cx, cy]]));
	        return this;
	    };
	    /*\
	     * Element.translate
	     [ method ]
	     **
	     * Deprecated! Use @Element.transform instead.
	     * Adds translation by given amount to the list of transformations of the element.
	     > Parameters
	     - dx (number) horisontal shift
	     - dy (number) vertical shift
	     = (object) @Element
	    \*/
	    elproto.translate = function (dx, dy) {
	        if (this.removed) {
	            return this;
	        }
	        dx = Str(dx).split(separator);
	        if (dx.length - 1) {
	            dy = toFloat(dx[1]);
	        }
	        dx = toFloat(dx[0]) || 0;
	        dy = +dy || 0;
	        this.transform(this._.transform.concat([["t", dx, dy]]));
	        return this;
	    };
	    /*\
	     * Element.transform
	     [ method ]
	     **
	     * Adds transformation to the element which is separate to other attributes,
	     * i.e. translation doesn’t change `x` or `y` of the rectange. The format
	     * of transformation string is similar to the path string syntax:
	     | "t100,100r30,100,100s2,2,100,100r45s1.5"
	     * Each letter is a command. There are four commands: `t` is for translate, `r` is for rotate, `s` is for
	     * scale and `m` is for matrix.
	     *
	     * There are also alternative “absolute” translation, rotation and scale: `T`, `R` and `S`. They will not take previous transformation into account. For example, `...T100,0` will always move element 100 px horisontally, while `...t100,0` could move it vertically if there is `r90` before. Just compare results of `r90t100,0` and `r90T100,0`.
	     *
	     * So, the example line above could be read like “translate by 100, 100; rotate 30° around 100, 100; scale twice around 100, 100;
	     * rotate 45° around centre; scale 1.5 times relative to centre”. As you can see rotate and scale commands have origin
	     * coordinates as optional parameters, the default is the centre point of the element.
	     * Matrix accepts six parameters.
	     > Usage
	     | var el = paper.rect(10, 20, 300, 200);
	     | // translate 100, 100, rotate 45°, translate -100, 0
	     | el.transform("t100,100r45t-100,0");
	     | // if you want you can append or prepend transformations
	     | el.transform("...t50,50");
	     | el.transform("s2...");
	     | // or even wrap
	     | el.transform("t50,50...t-50-50");
	     | // to reset transformation call method with empty string
	     | el.transform("");
	     | // to get current value call it without parameters
	     | console.log(el.transform());
	     > Parameters
	     - tstr (string) #optional transformation string
	     * If tstr isn’t specified
	     = (string) current transformation string
	     * else
	     = (object) @Element
	    \*/
	    elproto.transform = function (tstr) {
	        var _ = this._;
	        if (tstr == null) {
	            return _.transform;
	        }
	        R._extractTransform(this, tstr);

	        this.clip && $(this.clip, {transform: this.matrix.invert()});
	        this.pattern && updatePosition(this);
	        this.node && $(this.node, {transform: this.matrix});

	        if (_.sx != 1 || _.sy != 1) {
	            var sw = this.attrs[has]("stroke-width") ? this.attrs["stroke-width"] : 1;
	            this.attr({"stroke-width": sw});
	        }

	        return this;
	    };
	    /*\
	     * Element.hide
	     [ method ]
	     **
	     * Makes element invisible. See @Element.show.
	     = (object) @Element
	    \*/
	    elproto.hide = function () {
	        if(!this.removed) this.node.style.display = "none";
	        return this;
	    };
	    /*\
	     * Element.show
	     [ method ]
	     **
	     * Makes element visible. See @Element.hide.
	     = (object) @Element
	    \*/
	    elproto.show = function () {
	        if(!this.removed) this.node.style.display = "";
	        return this;
	    };
	    /*\
	     * Element.remove
	     [ method ]
	     **
	     * Removes element from the paper.
	    \*/
	    elproto.remove = function () {
	        var node = getRealNode(this.node);
	        if (this.removed || !node.parentNode) {
	            return;
	        }
	        var paper = this.paper;
	        paper.__set__ && paper.__set__.exclude(this);
	        eve.unbind("raphael.*.*." + this.id);
	        if (this.gradient) {
	            paper.defs.removeChild(this.gradient);
	        }
	        R._tear(this, paper);

	        node.parentNode.removeChild(node);

	        // Remove custom data for element
	        this.removeData();

	        for (var i in this) {
	            this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
	        }
	        this.removed = true;
	    };
	    elproto._getBBox = function () {
	        if (this.node.style.display == "none") {
	            this.show();
	            var hide = true;
	        }
	        var canvasHidden = false,
	            containerStyle;
	        if (this.paper.canvas.parentElement) {
	          containerStyle = this.paper.canvas.parentElement.style;
	        } //IE10+ can't find parentElement
	        else if (this.paper.canvas.parentNode) {
	          containerStyle = this.paper.canvas.parentNode.style;
	        }

	        if(containerStyle && containerStyle.display == "none") {
	          canvasHidden = true;
	          containerStyle.display = "";
	        }
	        var bbox = {};
	        try {
	            bbox = this.node.getBBox();
	        } catch(e) {
	            // Firefox 3.0.x, 25.0.1 (probably more versions affected) play badly here - possible fix
	            bbox = {
	                x: this.node.clientLeft,
	                y: this.node.clientTop,
	                width: this.node.clientWidth,
	                height: this.node.clientHeight
	            }
	        } finally {
	            bbox = bbox || {};
	            if(canvasHidden){
	              containerStyle.display = "none";
	            }
	        }
	        hide && this.hide();
	        return bbox;
	    };
	    /*\
	     * Element.attr
	     [ method ]
	     **
	     * Sets the attributes of the element.
	     > Parameters
	     - attrName (string) attribute’s name
	     - value (string) value
	     * or
	     - params (object) object of name/value pairs
	     * or
	     - attrName (string) attribute’s name
	     * or
	     - attrNames (array) in this case method returns array of current values for given attribute names
	     = (object) @Element if attrsName & value or params are passed in.
	     = (...) value of the attribute if only attrsName is passed in.
	     = (array) array of values of the attribute if attrsNames is passed in.
	     = (object) object of attributes if nothing is passed in.
	     > Possible parameters
	     # <p>Please refer to the <a href="http://www.w3.org/TR/SVG/" title="The W3C Recommendation for the SVG language describes these properties in detail.">SVG specification</a> for an explanation of these parameters.</p>
	     o arrow-end (string) arrowhead on the end of the path. The format for string is `<type>[-<width>[-<length>]]`. Possible types: `classic`, `block`, `open`, `oval`, `diamond`, `none`, width: `wide`, `narrow`, `medium`, length: `long`, `short`, `midium`.
	     o clip-rect (string) comma or space separated values: x, y, width and height
	     o cursor (string) CSS type of the cursor
	     o cx (number) the x-axis coordinate of the center of the circle, or ellipse
	     o cy (number) the y-axis coordinate of the center of the circle, or ellipse
	     o fill (string) colour, gradient or image
	     o fill-opacity (number)
	     o font (string)
	     o font-family (string)
	     o font-size (number) font size in pixels
	     o font-weight (string)
	     o height (number)
	     o href (string) URL, if specified element behaves as hyperlink
	     o opacity (number)
	     o path (string) SVG path string format
	     o r (number) radius of the circle, ellipse or rounded corner on the rect
	     o rx (number) horisontal radius of the ellipse
	     o ry (number) vertical radius of the ellipse
	     o src (string) image URL, only works for @Element.image element
	     o stroke (string) stroke colour
	     o stroke-dasharray (string) [“”, “none”, “`-`”, “`.`”, “`-.`”, “`-..`”, “`. `”, “`- `”, “`--`”, “`- .`”, “`--.`”, “`--..`”]
	     o stroke-linecap (string) [“`butt`”, “`square`”, “`round`”]
	     o stroke-linejoin (string) [“`bevel`”, “`round`”, “`miter`”]
	     o stroke-miterlimit (number)
	     o stroke-opacity (number)
	     o stroke-width (number) stroke width in pixels, default is '1'
	     o target (string) used with href
	     o text (string) contents of the text element. Use `\n` for multiline text
	     o text-anchor (string) [“`start`”, “`middle`”, “`end`”], default is “`middle`”
	     o title (string) will create tooltip with a given text
	     o transform (string) see @Element.transform
	     o width (number)
	     o x (number)
	     o y (number)
	     > Gradients
	     * Linear gradient format: “`‹angle›-‹colour›[-‹colour›[:‹offset›]]*-‹colour›`”, example: “`90-#fff-#000`” – 90°
	     * gradient from white to black or “`0-#fff-#f00:20-#000`” – 0° gradient from white via red (at 20%) to black.
	     *
	     * radial gradient: “`r[(‹fx›, ‹fy›)]‹colour›[-‹colour›[:‹offset›]]*-‹colour›`”, example: “`r#fff-#000`” –
	     * gradient from white to black or “`r(0.25, 0.75)#fff-#000`” – gradient from white to black with focus point
	     * at 0.25, 0.75. Focus point coordinates are in 0..1 range. Radial gradients can only be applied to circles and ellipses.
	     > Path String
	     # <p>Please refer to <a href="http://www.w3.org/TR/SVG/paths.html#PathData" title="Details of a path’s data attribute’s format are described in the SVG specification.">SVG documentation regarding path string</a>. Raphaël fully supports it.</p>
	     > Colour Parsing
	     # <ul>
	     #     <li>Colour name (“<code>red</code>”, “<code>green</code>”, “<code>cornflowerblue</code>”, etc)</li>
	     #     <li>#••• — shortened HTML colour: (“<code>#000</code>”, “<code>#fc0</code>”, etc)</li>
	     #     <li>#•••••• — full length HTML colour: (“<code>#000000</code>”, “<code>#bd2300</code>”)</li>
	     #     <li>rgb(•••, •••, •••) — red, green and blue channels’ values: (“<code>rgb(200,&nbsp;100,&nbsp;0)</code>”)</li>
	     #     <li>rgb(•••%, •••%, •••%) — same as above, but in %: (“<code>rgb(100%,&nbsp;175%,&nbsp;0%)</code>”)</li>
	     #     <li>rgba(•••, •••, •••, •••) — red, green and blue channels’ values: (“<code>rgba(200,&nbsp;100,&nbsp;0, .5)</code>”)</li>
	     #     <li>rgba(•••%, •••%, •••%, •••%) — same as above, but in %: (“<code>rgba(100%,&nbsp;175%,&nbsp;0%, 50%)</code>”)</li>
	     #     <li>hsb(•••, •••, •••) — hue, saturation and brightness values: (“<code>hsb(0.5,&nbsp;0.25,&nbsp;1)</code>”)</li>
	     #     <li>hsb(•••%, •••%, •••%) — same as above, but in %</li>
	     #     <li>hsba(•••, •••, •••, •••) — same as above, but with opacity</li>
	     #     <li>hsl(•••, •••, •••) — almost the same as hsb, see <a href="http://en.wikipedia.org/wiki/HSL_and_HSV" title="HSL and HSV - Wikipedia, the free encyclopedia">Wikipedia page</a></li>
	     #     <li>hsl(•••%, •••%, •••%) — same as above, but in %</li>
	     #     <li>hsla(•••, •••, •••, •••) — same as above, but with opacity</li>
	     #     <li>Optionally for hsb and hsl you could specify hue as a degree: “<code>hsl(240deg,&nbsp;1,&nbsp;.5)</code>” or, if you want to go fancy, “<code>hsl(240°,&nbsp;1,&nbsp;.5)</code>”</li>
	     # </ul>
	    \*/
	    elproto.attr = function (name, value) {
	        if (this.removed) {
	            return this;
	        }
	        if (name == null) {
	            var res = {};
	            for (var a in this.attrs) if (this.attrs[has](a)) {
	                res[a] = this.attrs[a];
	            }
	            res.gradient && res.fill == "none" && (res.fill = res.gradient) && delete res.gradient;
	            res.transform = this._.transform;
	            return res;
	        }
	        if (value == null && R.is(name, "string")) {
	            if (name == "fill" && this.attrs.fill == "none" && this.attrs.gradient) {
	                return this.attrs.gradient;
	            }
	            if (name == "transform") {
	                return this._.transform;
	            }
	            var names = name.split(separator),
	                out = {};
	            for (var i = 0, ii = names.length; i < ii; i++) {
	                name = names[i];
	                if (name in this.attrs) {
	                    out[name] = this.attrs[name];
	                } else if (R.is(this.paper.customAttributes[name], "function")) {
	                    out[name] = this.paper.customAttributes[name].def;
	                } else {
	                    out[name] = R._availableAttrs[name];
	                }
	            }
	            return ii - 1 ? out : out[names[0]];
	        }
	        if (value == null && R.is(name, "array")) {
	            out = {};
	            for (i = 0, ii = name.length; i < ii; i++) {
	                out[name[i]] = this.attr(name[i]);
	            }
	            return out;
	        }
	        if (value != null) {
	            var params = {};
	            params[name] = value;
	        } else if (name != null && R.is(name, "object")) {
	            params = name;
	        }
	        for (var key in params) {
	            eve("raphael.attr." + key + "." + this.id, this, params[key]);
	        }
	        for (key in this.paper.customAttributes) if (this.paper.customAttributes[has](key) && params[has](key) && R.is(this.paper.customAttributes[key], "function")) {
	            var par = this.paper.customAttributes[key].apply(this, [].concat(params[key]));
	            this.attrs[key] = params[key];
	            for (var subkey in par) if (par[has](subkey)) {
	                params[subkey] = par[subkey];
	            }
	        }
	        setFillAndStroke(this, params);
	        return this;
	    };
	    /*\
	     * Element.toFront
	     [ method ]
	     **
	     * Moves the element so it is the closest to the viewer’s eyes, on top of other elements.
	     = (object) @Element
	    \*/
	    elproto.toFront = function () {
	        if (this.removed) {
	            return this;
	        }
	        var node = getRealNode(this.node);
	        node.parentNode.appendChild(node);
	        var svg = this.paper;
	        svg.top != this && R._tofront(this, svg);
	        return this;
	    };
	    /*\
	     * Element.toBack
	     [ method ]
	     **
	     * Moves the element so it is the furthest from the viewer’s eyes, behind other elements.
	     = (object) @Element
	    \*/
	    elproto.toBack = function () {
	        if (this.removed) {
	            return this;
	        }
	        var node = getRealNode(this.node);
	        var parentNode = node.parentNode;
	        parentNode.insertBefore(node, parentNode.firstChild);
	        R._toback(this, this.paper);
	        var svg = this.paper;
	        return this;
	    };
	    /*\
	     * Element.insertAfter
	     [ method ]
	     **
	     * Inserts current object after the given one.
	     = (object) @Element
	    \*/
	    elproto.insertAfter = function (element) {
	        if (this.removed || !element) {
	            return this;
	        }

	        var node = getRealNode(this.node);
	        var afterNode = getRealNode(element.node || element[element.length - 1].node);
	        if (afterNode.nextSibling) {
	            afterNode.parentNode.insertBefore(node, afterNode.nextSibling);
	        } else {
	            afterNode.parentNode.appendChild(node);
	        }
	        R._insertafter(this, element, this.paper);
	        return this;
	    };
	    /*\
	     * Element.insertBefore
	     [ method ]
	     **
	     * Inserts current object before the given one.
	     = (object) @Element
	    \*/
	    elproto.insertBefore = function (element) {
	        if (this.removed || !element) {
	            return this;
	        }

	        var node = getRealNode(this.node);
	        var beforeNode = getRealNode(element.node || element[0].node);
	        beforeNode.parentNode.insertBefore(node, beforeNode);
	        R._insertbefore(this, element, this.paper);
	        return this;
	    };
	    elproto.blur = function (size) {
	        // Experimental. No Safari support. Use it on your own risk.
	        var t = this;
	        if (+size !== 0) {
	            var fltr = $("filter"),
	                blur = $("feGaussianBlur");
	            t.attrs.blur = size;
	            fltr.id = R.createUUID();
	            $(blur, {stdDeviation: +size || 1.5});
	            fltr.appendChild(blur);
	            t.paper.defs.appendChild(fltr);
	            t._blur = fltr;
	            $(t.node, {filter: "url(#" + fltr.id + ")"});
	        } else {
	            if (t._blur) {
	                t._blur.parentNode.removeChild(t._blur);
	                delete t._blur;
	                delete t.attrs.blur;
	            }
	            t.node.removeAttribute("filter");
	        }
	        return t;
	    };
	    R._engine.circle = function (svg, x, y, r) {
	        var el = $("circle");
	        svg.canvas && svg.canvas.appendChild(el);
	        var res = new Element(el, svg);
	        res.attrs = {cx: x, cy: y, r: r, fill: "none", stroke: "#000"};
	        res.type = "circle";
	        $(el, res.attrs);
	        return res;
	    };
	    R._engine.rect = function (svg, x, y, w, h, r) {
	        var el = $("rect");
	        svg.canvas && svg.canvas.appendChild(el);
	        var res = new Element(el, svg);
	        res.attrs = {x: x, y: y, width: w, height: h, rx: r || 0, ry: r || 0, fill: "none", stroke: "#000"};
	        res.type = "rect";
	        $(el, res.attrs);
	        return res;
	    };
	    R._engine.ellipse = function (svg, x, y, rx, ry) {
	        var el = $("ellipse");
	        svg.canvas && svg.canvas.appendChild(el);
	        var res = new Element(el, svg);
	        res.attrs = {cx: x, cy: y, rx: rx, ry: ry, fill: "none", stroke: "#000"};
	        res.type = "ellipse";
	        $(el, res.attrs);
	        return res;
	    };
	    R._engine.image = function (svg, src, x, y, w, h) {
	        var el = $("image");
	        $(el, {x: x, y: y, width: w, height: h, preserveAspectRatio: "none"});
	        el.setAttributeNS(xlink, "href", src);
	        svg.canvas && svg.canvas.appendChild(el);
	        var res = new Element(el, svg);
	        res.attrs = {x: x, y: y, width: w, height: h, src: src};
	        res.type = "image";
	        return res;
	    };
	    R._engine.text = function (svg, x, y, text) {
	        var el = $("text");
	        svg.canvas && svg.canvas.appendChild(el);
	        var res = new Element(el, svg);
	        res.attrs = {
	            x: x,
	            y: y,
	            "text-anchor": "middle",
	            text: text,
	            "font-family": R._availableAttrs["font-family"],
	            "font-size": R._availableAttrs["font-size"],
	            stroke: "none",
	            fill: "#000"
	        };
	        res.type = "text";
	        setFillAndStroke(res, res.attrs);
	        return res;
	    };
	    R._engine.setSize = function (width, height) {
	        this.width = width || this.width;
	        this.height = height || this.height;
	        this.canvas.setAttribute("width", this.width);
	        this.canvas.setAttribute("height", this.height);
	        if (this._viewBox) {
	            this.setViewBox.apply(this, this._viewBox);
	        }
	        return this;
	    };
	    R._engine.create = function () {
	        var con = R._getContainer.apply(0, arguments),
	            container = con && con.container,
	            x = con.x,
	            y = con.y,
	            width = con.width,
	            height = con.height;
	        if (!container) {
	            throw new Error("SVG container not found.");
	        }
	        var cnvs = $("svg"),
	            css = "overflow:hidden;",
	            isFloating;
	        x = x || 0;
	        y = y || 0;
	        width = width || 512;
	        height = height || 342;
	        $(cnvs, {
	            height: height,
	            version: 1.1,
	            width: width,
	            xmlns: "http://www.w3.org/2000/svg",
	            "xmlns:xlink": "http://www.w3.org/1999/xlink"
	        });
	        if (container == 1) {
	            cnvs.style.cssText = css + "position:absolute;left:" + x + "px;top:" + y + "px";
	            R._g.doc.body.appendChild(cnvs);
	            isFloating = 1;
	        } else {
	            cnvs.style.cssText = css + "position:relative";
	            if (container.firstChild) {
	                container.insertBefore(cnvs, container.firstChild);
	            } else {
	                container.appendChild(cnvs);
	            }
	        }
	        container = new R._Paper;
	        container.width = width;
	        container.height = height;
	        container.canvas = cnvs;
	        container.clear();
	        container._left = container._top = 0;
	        isFloating && (container.renderfix = function () {});
	        container.renderfix();
	        return container;
	    };
	    R._engine.setViewBox = function (x, y, w, h, fit) {
	        eve("raphael.setViewBox", this, this._viewBox, [x, y, w, h, fit]);
	        var paperSize = this.getSize(),
	            size = mmax(w / paperSize.width, h / paperSize.height),
	            top = this.top,
	            aspectRatio = fit ? "xMidYMid meet" : "xMinYMin",
	            vb,
	            sw;
	        if (x == null) {
	            if (this._vbSize) {
	                size = 1;
	            }
	            delete this._vbSize;
	            vb = "0 0 " + this.width + S + this.height;
	        } else {
	            this._vbSize = size;
	            vb = x + S + y + S + w + S + h;
	        }
	        $(this.canvas, {
	            viewBox: vb,
	            preserveAspectRatio: aspectRatio
	        });
	        while (size && top) {
	            sw = "stroke-width" in top.attrs ? top.attrs["stroke-width"] : 1;
	            top.attr({"stroke-width": sw});
	            top._.dirty = 1;
	            top._.dirtyT = 1;
	            top = top.prev;
	        }
	        this._viewBox = [x, y, w, h, !!fit];
	        return this;
	    };
	    /*\
	     * Paper.renderfix
	     [ method ]
	     **
	     * Fixes the issue of Firefox and IE9 regarding subpixel rendering. If paper is dependent
	     * on other elements after reflow it could shift half pixel which cause for lines to lost their crispness.
	     * This method fixes the issue.
	     **
	       Special thanks to Mariusz Nowak (http://www.medikoo.com/) for this method.
	    \*/
	    R.prototype.renderfix = function () {
	        var cnvs = this.canvas,
	            s = cnvs.style,
	            pos;
	        try {
	            pos = cnvs.getScreenCTM() || cnvs.createSVGMatrix();
	        } catch (e) {
	            pos = cnvs.createSVGMatrix();
	        }
	        var left = -pos.e % 1,
	            top = -pos.f % 1;
	        if (left || top) {
	            if (left) {
	                this._left = (this._left + left) % 1;
	                s.left = this._left + "px";
	            }
	            if (top) {
	                this._top = (this._top + top) % 1;
	                s.top = this._top + "px";
	            }
	        }
	    };
	    /*\
	     * Paper.clear
	     [ method ]
	     **
	     * Clears the paper, i.e. removes all the elements.
	    \*/
	    R.prototype.clear = function () {
	        R.eve("raphael.clear", this);
	        var c = this.canvas;
	        while (c.firstChild) {
	            c.removeChild(c.firstChild);
	        }
	        this.bottom = this.top = null;
	        (this.desc = $("desc")).appendChild(R._g.doc.createTextNode("Created with Rapha\xebl " + R.version));
	        c.appendChild(this.desc);
	        c.appendChild(this.defs = $("defs"));
	    };
	    /*\
	     * Paper.remove
	     [ method ]
	     **
	     * Removes the paper from the DOM.
	    \*/
	    R.prototype.remove = function () {
	        eve("raphael.remove", this);
	        this.canvas.parentNode && this.canvas.parentNode.removeChild(this.canvas);
	        for (var i in this) {
	            this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
	        }
	    };
	    var setproto = R.st;
	    for (var method in elproto) if (elproto[has](method) && !setproto[has](method)) {
	        setproto[method] = (function (methodname) {
	            return function () {
	                var arg = arguments;
	                return this.forEach(function (el) {
	                    el[methodname].apply(el, arg);
	                });
	            };
	        })(method);
	    }
	}.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;!(__WEBPACK_AMD_DEFINE_ARRAY__ = [__webpack_require__(1)], __WEBPACK_AMD_DEFINE_RESULT__ = function(R) {
	    if (R && !R.vml) {
	        return;
	    }

	    var has = "hasOwnProperty",
	        Str = String,
	        toFloat = parseFloat,
	        math = Math,
	        round = math.round,
	        mmax = math.max,
	        mmin = math.min,
	        abs = math.abs,
	        fillString = "fill",
	        separator = /[, ]+/,
	        eve = R.eve,
	        ms = " progid:DXImageTransform.Microsoft",
	        S = " ",
	        E = "",
	        map = {M: "m", L: "l", C: "c", Z: "x", m: "t", l: "r", c: "v", z: "x"},
	        bites = /([clmz]),?([^clmz]*)/gi,
	        blurregexp = / progid:\S+Blur\([^\)]+\)/g,
	        val = /-?[^,\s-]+/g,
	        cssDot = "position:absolute;left:0;top:0;width:1px;height:1px;behavior:url(#default#VML)",
	        zoom = 21600,
	        pathTypes = {path: 1, rect: 1, image: 1},
	        ovalTypes = {circle: 1, ellipse: 1},
	        path2vml = function (path) {
	            var total =  /[ahqstv]/ig,
	                command = R._pathToAbsolute;
	            Str(path).match(total) && (command = R._path2curve);
	            total = /[clmz]/g;
	            if (command == R._pathToAbsolute && !Str(path).match(total)) {
	                var res = Str(path).replace(bites, function (all, command, args) {
	                    var vals = [],
	                        isMove = command.toLowerCase() == "m",
	                        res = map[command];
	                    args.replace(val, function (value) {
	                        if (isMove && vals.length == 2) {
	                            res += vals + map[command == "m" ? "l" : "L"];
	                            vals = [];
	                        }
	                        vals.push(round(value * zoom));
	                    });
	                    return res + vals;
	                });
	                return res;
	            }
	            var pa = command(path), p, r;
	            res = [];
	            for (var i = 0, ii = pa.length; i < ii; i++) {
	                p = pa[i];
	                r = pa[i][0].toLowerCase();
	                r == "z" && (r = "x");
	                for (var j = 1, jj = p.length; j < jj; j++) {
	                    r += round(p[j] * zoom) + (j != jj - 1 ? "," : E);
	                }
	                res.push(r);
	            }
	            return res.join(S);
	        },
	        compensation = function (deg, dx, dy) {
	            var m = R.matrix();
	            m.rotate(-deg, .5, .5);
	            return {
	                dx: m.x(dx, dy),
	                dy: m.y(dx, dy)
	            };
	        },
	        setCoords = function (p, sx, sy, dx, dy, deg) {
	            var _ = p._,
	                m = p.matrix,
	                fillpos = _.fillpos,
	                o = p.node,
	                s = o.style,
	                y = 1,
	                flip = "",
	                dxdy,
	                kx = zoom / sx,
	                ky = zoom / sy;
	            s.visibility = "hidden";
	            if (!sx || !sy) {
	                return;
	            }
	            o.coordsize = abs(kx) + S + abs(ky);
	            s.rotation = deg * (sx * sy < 0 ? -1 : 1);
	            if (deg) {
	                var c = compensation(deg, dx, dy);
	                dx = c.dx;
	                dy = c.dy;
	            }
	            sx < 0 && (flip += "x");
	            sy < 0 && (flip += " y") && (y = -1);
	            s.flip = flip;
	            o.coordorigin = (dx * -kx) + S + (dy * -ky);
	            if (fillpos || _.fillsize) {
	                var fill = o.getElementsByTagName(fillString);
	                fill = fill && fill[0];
	                o.removeChild(fill);
	                if (fillpos) {
	                    c = compensation(deg, m.x(fillpos[0], fillpos[1]), m.y(fillpos[0], fillpos[1]));
	                    fill.position = c.dx * y + S + c.dy * y;
	                }
	                if (_.fillsize) {
	                    fill.size = _.fillsize[0] * abs(sx) + S + _.fillsize[1] * abs(sy);
	                }
	                o.appendChild(fill);
	            }
	            s.visibility = "visible";
	        };
	    R.toString = function () {
	        return  "Your browser doesn\u2019t support SVG. Falling down to VML.\nYou are running Rapha\xebl " + this.version;
	    };
	    var addArrow = function (o, value, isEnd) {
	        var values = Str(value).toLowerCase().split("-"),
	            se = isEnd ? "end" : "start",
	            i = values.length,
	            type = "classic",
	            w = "medium",
	            h = "medium";
	        while (i--) {
	            switch (values[i]) {
	                case "block":
	                case "classic":
	                case "oval":
	                case "diamond":
	                case "open":
	                case "none":
	                    type = values[i];
	                    break;
	                case "wide":
	                case "narrow": h = values[i]; break;
	                case "long":
	                case "short": w = values[i]; break;
	            }
	        }
	        var stroke = o.node.getElementsByTagName("stroke")[0];
	        stroke[se + "arrow"] = type;
	        stroke[se + "arrowlength"] = w;
	        stroke[se + "arrowwidth"] = h;
	    },
	    setFillAndStroke = function (o, params) {
	        // o.paper.canvas.style.display = "none";
	        o.attrs = o.attrs || {};
	        var node = o.node,
	            a = o.attrs,
	            s = node.style,
	            xy,
	            newpath = pathTypes[o.type] && (params.x != a.x || params.y != a.y || params.width != a.width || params.height != a.height || params.cx != a.cx || params.cy != a.cy || params.rx != a.rx || params.ry != a.ry || params.r != a.r),
	            isOval = ovalTypes[o.type] && (a.cx != params.cx || a.cy != params.cy || a.r != params.r || a.rx != params.rx || a.ry != params.ry),
	            res = o;


	        for (var par in params) if (params[has](par)) {
	            a[par] = params[par];
	        }
	        if (newpath) {
	            a.path = R._getPath[o.type](o);
	            o._.dirty = 1;
	        }
	        params.href && (node.href = params.href);
	        params.title && (node.title = params.title);
	        params.target && (node.target = params.target);
	        params.cursor && (s.cursor = params.cursor);
	        "blur" in params && o.blur(params.blur);
	        if (params.path && o.type == "path" || newpath) {
	            node.path = path2vml(~Str(a.path).toLowerCase().indexOf("r") ? R._pathToAbsolute(a.path) : a.path);
	            o._.dirty = 1;
	            if (o.type == "image") {
	                o._.fillpos = [a.x, a.y];
	                o._.fillsize = [a.width, a.height];
	                setCoords(o, 1, 1, 0, 0, 0);
	            }
	        }
	        "transform" in params && o.transform(params.transform);
	        if (isOval) {
	            var cx = +a.cx,
	                cy = +a.cy,
	                rx = +a.rx || +a.r || 0,
	                ry = +a.ry || +a.r || 0;
	            node.path = R.format("ar{0},{1},{2},{3},{4},{1},{4},{1}x", round((cx - rx) * zoom), round((cy - ry) * zoom), round((cx + rx) * zoom), round((cy + ry) * zoom), round(cx * zoom));
	            o._.dirty = 1;
	        }
	        if ("clip-rect" in params) {
	            var rect = Str(params["clip-rect"]).split(separator);
	            if (rect.length == 4) {
	                rect[2] = +rect[2] + (+rect[0]);
	                rect[3] = +rect[3] + (+rect[1]);
	                var div = node.clipRect || R._g.doc.createElement("div"),
	                    dstyle = div.style;
	                dstyle.clip = R.format("rect({1}px {2}px {3}px {0}px)", rect);
	                if (!node.clipRect) {
	                    dstyle.position = "absolute";
	                    dstyle.top = 0;
	                    dstyle.left = 0;
	                    dstyle.width = o.paper.width + "px";
	                    dstyle.height = o.paper.height + "px";
	                    node.parentNode.insertBefore(div, node);
	                    div.appendChild(node);
	                    node.clipRect = div;
	                }
	            }
	            if (!params["clip-rect"]) {
	                node.clipRect && (node.clipRect.style.clip = "auto");
	            }
	        }
	        if (o.textpath) {
	            var textpathStyle = o.textpath.style;
	            params.font && (textpathStyle.font = params.font);
	            params["font-family"] && (textpathStyle.fontFamily = '"' + params["font-family"].split(",")[0].replace(/^['"]+|['"]+$/g, E) + '"');
	            params["font-size"] && (textpathStyle.fontSize = params["font-size"]);
	            params["font-weight"] && (textpathStyle.fontWeight = params["font-weight"]);
	            params["font-style"] && (textpathStyle.fontStyle = params["font-style"]);
	        }
	        if ("arrow-start" in params) {
	            addArrow(res, params["arrow-start"]);
	        }
	        if ("arrow-end" in params) {
	            addArrow(res, params["arrow-end"], 1);
	        }
	        if (params.opacity != null ||
	            params.fill != null ||
	            params.src != null ||
	            params.stroke != null ||
	            params["stroke-width"] != null ||
	            params["stroke-opacity"] != null ||
	            params["fill-opacity"] != null ||
	            params["stroke-dasharray"] != null ||
	            params["stroke-miterlimit"] != null ||
	            params["stroke-linejoin"] != null ||
	            params["stroke-linecap"] != null) {
	            var fill = node.getElementsByTagName(fillString),
	                newfill = false;
	            fill = fill && fill[0];
	            !fill && (newfill = fill = createNode(fillString));
	            if (o.type == "image" && params.src) {
	                fill.src = params.src;
	            }
	            params.fill && (fill.on = true);
	            if (fill.on == null || params.fill == "none" || params.fill === null) {
	                fill.on = false;
	            }
	            if (fill.on && params.fill) {
	                var isURL = Str(params.fill).match(R._ISURL);
	                if (isURL) {
	                    fill.parentNode == node && node.removeChild(fill);
	                    fill.rotate = true;
	                    fill.src = isURL[1];
	                    fill.type = "tile";
	                    var bbox = o.getBBox(1);
	                    fill.position = bbox.x + S + bbox.y;
	                    o._.fillpos = [bbox.x, bbox.y];

	                    R._preload(isURL[1], function () {
	                        o._.fillsize = [this.offsetWidth, this.offsetHeight];
	                    });
	                } else {
	                    fill.color = R.getRGB(params.fill).hex;
	                    fill.src = E;
	                    fill.type = "solid";
	                    if (R.getRGB(params.fill).error && (res.type in {circle: 1, ellipse: 1} || Str(params.fill).charAt() != "r") && addGradientFill(res, params.fill, fill)) {
	                        a.fill = "none";
	                        a.gradient = params.fill;
	                        fill.rotate = false;
	                    }
	                }
	            }
	            if ("fill-opacity" in params || "opacity" in params) {
	                var opacity = ((+a["fill-opacity"] + 1 || 2) - 1) * ((+a.opacity + 1 || 2) - 1) * ((+R.getRGB(params.fill).o + 1 || 2) - 1);
	                opacity = mmin(mmax(opacity, 0), 1);
	                fill.opacity = opacity;
	                if (fill.src) {
	                    fill.color = "none";
	                }
	            }
	            node.appendChild(fill);
	            var stroke = (node.getElementsByTagName("stroke") && node.getElementsByTagName("stroke")[0]),
	            newstroke = false;
	            !stroke && (newstroke = stroke = createNode("stroke"));
	            if ((params.stroke && params.stroke != "none") ||
	                params["stroke-width"] ||
	                params["stroke-opacity"] != null ||
	                params["stroke-dasharray"] ||
	                params["stroke-miterlimit"] ||
	                params["stroke-linejoin"] ||
	                params["stroke-linecap"]) {
	                stroke.on = true;
	            }
	            (params.stroke == "none" || params.stroke === null || stroke.on == null || params.stroke == 0 || params["stroke-width"] == 0) && (stroke.on = false);
	            var strokeColor = R.getRGB(params.stroke);
	            stroke.on && params.stroke && (stroke.color = strokeColor.hex);
	            opacity = ((+a["stroke-opacity"] + 1 || 2) - 1) * ((+a.opacity + 1 || 2) - 1) * ((+strokeColor.o + 1 || 2) - 1);
	            var width = (toFloat(params["stroke-width"]) || 1) * .75;
	            opacity = mmin(mmax(opacity, 0), 1);
	            params["stroke-width"] == null && (width = a["stroke-width"]);
	            params["stroke-width"] && (stroke.weight = width);
	            width && width < 1 && (opacity *= width) && (stroke.weight = 1);
	            stroke.opacity = opacity;

	            params["stroke-linejoin"] && (stroke.joinstyle = params["stroke-linejoin"] || "miter");
	            stroke.miterlimit = params["stroke-miterlimit"] || 8;
	            params["stroke-linecap"] && (stroke.endcap = params["stroke-linecap"] == "butt" ? "flat" : params["stroke-linecap"] == "square" ? "square" : "round");
	            if ("stroke-dasharray" in params) {
	                var dasharray = {
	                    "-": "shortdash",
	                    ".": "shortdot",
	                    "-.": "shortdashdot",
	                    "-..": "shortdashdotdot",
	                    ". ": "dot",
	                    "- ": "dash",
	                    "--": "longdash",
	                    "- .": "dashdot",
	                    "--.": "longdashdot",
	                    "--..": "longdashdotdot"
	                };
	                stroke.dashstyle = dasharray[has](params["stroke-dasharray"]) ? dasharray[params["stroke-dasharray"]] : E;
	            }
	            newstroke && node.appendChild(stroke);
	        }
	        if (res.type == "text") {
	            res.paper.canvas.style.display = E;
	            var span = res.paper.span,
	                m = 100,
	                fontSize = a.font && a.font.match(/\d+(?:\.\d*)?(?=px)/);
	            s = span.style;
	            a.font && (s.font = a.font);
	            a["font-family"] && (s.fontFamily = a["font-family"]);
	            a["font-weight"] && (s.fontWeight = a["font-weight"]);
	            a["font-style"] && (s.fontStyle = a["font-style"]);
	            fontSize = toFloat(a["font-size"] || fontSize && fontSize[0]) || 10;
	            s.fontSize = fontSize * m + "px";
	            res.textpath.string && (span.innerHTML = Str(res.textpath.string).replace(/</g, "&#60;").replace(/&/g, "&#38;").replace(/\n/g, "<br>"));
	            var brect = span.getBoundingClientRect();
	            res.W = a.w = (brect.right - brect.left) / m;
	            res.H = a.h = (brect.bottom - brect.top) / m;
	            // res.paper.canvas.style.display = "none";
	            res.X = a.x;
	            res.Y = a.y + res.H / 2;

	            ("x" in params || "y" in params) && (res.path.v = R.format("m{0},{1}l{2},{1}", round(a.x * zoom), round(a.y * zoom), round(a.x * zoom) + 1));
	            var dirtyattrs = ["x", "y", "text", "font", "font-family", "font-weight", "font-style", "font-size"];
	            for (var d = 0, dd = dirtyattrs.length; d < dd; d++) if (dirtyattrs[d] in params) {
	                res._.dirty = 1;
	                break;
	            }

	            // text-anchor emulation
	            switch (a["text-anchor"]) {
	                case "start":
	                    res.textpath.style["v-text-align"] = "left";
	                    res.bbx = res.W / 2;
	                break;
	                case "end":
	                    res.textpath.style["v-text-align"] = "right";
	                    res.bbx = -res.W / 2;
	                break;
	                default:
	                    res.textpath.style["v-text-align"] = "center";
	                    res.bbx = 0;
	                break;
	            }
	            res.textpath.style["v-text-kern"] = true;
	        }
	        // res.paper.canvas.style.display = E;
	    },
	    addGradientFill = function (o, gradient, fill) {
	        o.attrs = o.attrs || {};
	        var attrs = o.attrs,
	            pow = Math.pow,
	            opacity,
	            oindex,
	            type = "linear",
	            fxfy = ".5 .5";
	        o.attrs.gradient = gradient;
	        gradient = Str(gradient).replace(R._radial_gradient, function (all, fx, fy) {
	            type = "radial";
	            if (fx && fy) {
	                fx = toFloat(fx);
	                fy = toFloat(fy);
	                pow(fx - .5, 2) + pow(fy - .5, 2) > .25 && (fy = math.sqrt(.25 - pow(fx - .5, 2)) * ((fy > .5) * 2 - 1) + .5);
	                fxfy = fx + S + fy;
	            }
	            return E;
	        });
	        gradient = gradient.split(/\s*\-\s*/);
	        if (type == "linear") {
	            var angle = gradient.shift();
	            angle = -toFloat(angle);
	            if (isNaN(angle)) {
	                return null;
	            }
	        }
	        var dots = R._parseDots(gradient);
	        if (!dots) {
	            return null;
	        }
	        o = o.shape || o.node;
	        if (dots.length) {
	            o.removeChild(fill);
	            fill.on = true;
	            fill.method = "none";
	            fill.color = dots[0].color;
	            fill.color2 = dots[dots.length - 1].color;
	            var clrs = [];
	            for (var i = 0, ii = dots.length; i < ii; i++) {
	                dots[i].offset && clrs.push(dots[i].offset + S + dots[i].color);
	            }
	            fill.colors = clrs.length ? clrs.join() : "0% " + fill.color;
	            if (type == "radial") {
	                fill.type = "gradientTitle";
	                fill.focus = "100%";
	                fill.focussize = "0 0";
	                fill.focusposition = fxfy;
	                fill.angle = 0;
	            } else {
	                // fill.rotate= true;
	                fill.type = "gradient";
	                fill.angle = (270 - angle) % 360;
	            }
	            o.appendChild(fill);
	        }
	        return 1;
	    },
	    Element = function (node, vml) {
	        this[0] = this.node = node;
	        node.raphael = true;
	        this.id = R._oid++;
	        node.raphaelid = this.id;
	        this.X = 0;
	        this.Y = 0;
	        this.attrs = {};
	        this.paper = vml;
	        this.matrix = R.matrix();
	        this._ = {
	            transform: [],
	            sx: 1,
	            sy: 1,
	            dx: 0,
	            dy: 0,
	            deg: 0,
	            dirty: 1,
	            dirtyT: 1
	        };
	        !vml.bottom && (vml.bottom = this);
	        this.prev = vml.top;
	        vml.top && (vml.top.next = this);
	        vml.top = this;
	        this.next = null;
	    };
	    var elproto = R.el;

	    Element.prototype = elproto;
	    elproto.constructor = Element;
	    elproto.transform = function (tstr) {
	        if (tstr == null) {
	            return this._.transform;
	        }
	        var vbs = this.paper._viewBoxShift,
	            vbt = vbs ? "s" + [vbs.scale, vbs.scale] + "-1-1t" + [vbs.dx, vbs.dy] : E,
	            oldt;
	        if (vbs) {
	            oldt = tstr = Str(tstr).replace(/\.{3}|\u2026/g, this._.transform || E);
	        }
	        R._extractTransform(this, vbt + tstr);
	        var matrix = this.matrix.clone(),
	            skew = this.skew,
	            o = this.node,
	            split,
	            isGrad = ~Str(this.attrs.fill).indexOf("-"),
	            isPatt = !Str(this.attrs.fill).indexOf("url(");
	        matrix.translate(1, 1);
	        if (isPatt || isGrad || this.type == "image") {
	            skew.matrix = "1 0 0 1";
	            skew.offset = "0 0";
	            split = matrix.split();
	            if ((isGrad && split.noRotation) || !split.isSimple) {
	                o.style.filter = matrix.toFilter();
	                var bb = this.getBBox(),
	                    bbt = this.getBBox(1),
	                    dx = bb.x - bbt.x,
	                    dy = bb.y - bbt.y;
	                o.coordorigin = (dx * -zoom) + S + (dy * -zoom);
	                setCoords(this, 1, 1, dx, dy, 0);
	            } else {
	                o.style.filter = E;
	                setCoords(this, split.scalex, split.scaley, split.dx, split.dy, split.rotate);
	            }
	        } else {
	            o.style.filter = E;
	            skew.matrix = Str(matrix);
	            skew.offset = matrix.offset();
	        }
	        if (oldt !== null) { // empty string value is true as well
	            this._.transform = oldt;
	            R._extractTransform(this, oldt);
	        }
	        return this;
	    };
	    elproto.rotate = function (deg, cx, cy) {
	        if (this.removed) {
	            return this;
	        }
	        if (deg == null) {
	            return;
	        }
	        deg = Str(deg).split(separator);
	        if (deg.length - 1) {
	            cx = toFloat(deg[1]);
	            cy = toFloat(deg[2]);
	        }
	        deg = toFloat(deg[0]);
	        (cy == null) && (cx = cy);
	        if (cx == null || cy == null) {
	            var bbox = this.getBBox(1);
	            cx = bbox.x + bbox.width / 2;
	            cy = bbox.y + bbox.height / 2;
	        }
	        this._.dirtyT = 1;
	        this.transform(this._.transform.concat([["r", deg, cx, cy]]));
	        return this;
	    };
	    elproto.translate = function (dx, dy) {
	        if (this.removed) {
	            return this;
	        }
	        dx = Str(dx).split(separator);
	        if (dx.length - 1) {
	            dy = toFloat(dx[1]);
	        }
	        dx = toFloat(dx[0]) || 0;
	        dy = +dy || 0;
	        if (this._.bbox) {
	            this._.bbox.x += dx;
	            this._.bbox.y += dy;
	        }
	        this.transform(this._.transform.concat([["t", dx, dy]]));
	        return this;
	    };
	    elproto.scale = function (sx, sy, cx, cy) {
	        if (this.removed) {
	            return this;
	        }
	        sx = Str(sx).split(separator);
	        if (sx.length - 1) {
	            sy = toFloat(sx[1]);
	            cx = toFloat(sx[2]);
	            cy = toFloat(sx[3]);
	            isNaN(cx) && (cx = null);
	            isNaN(cy) && (cy = null);
	        }
	        sx = toFloat(sx[0]);
	        (sy == null) && (sy = sx);
	        (cy == null) && (cx = cy);
	        if (cx == null || cy == null) {
	            var bbox = this.getBBox(1);
	        }
	        cx = cx == null ? bbox.x + bbox.width / 2 : cx;
	        cy = cy == null ? bbox.y + bbox.height / 2 : cy;

	        this.transform(this._.transform.concat([["s", sx, sy, cx, cy]]));
	        this._.dirtyT = 1;
	        return this;
	    };
	    elproto.hide = function () {
	        !this.removed && (this.node.style.display = "none");
	        return this;
	    };
	    elproto.show = function () {
	        !this.removed && (this.node.style.display = E);
	        return this;
	    };
	    // Needed to fix the vml setViewBox issues
	    elproto.auxGetBBox = R.el.getBBox;
	    elproto.getBBox = function(){
	      var b = this.auxGetBBox();
	      if (this.paper && this.paper._viewBoxShift)
	      {
	        var c = {};
	        var z = 1/this.paper._viewBoxShift.scale;
	        c.x = b.x - this.paper._viewBoxShift.dx;
	        c.x *= z;
	        c.y = b.y - this.paper._viewBoxShift.dy;
	        c.y *= z;
	        c.width  = b.width  * z;
	        c.height = b.height * z;
	        c.x2 = c.x + c.width;
	        c.y2 = c.y + c.height;
	        return c;
	      }
	      return b;
	    };
	    elproto._getBBox = function () {
	        if (this.removed) {
	            return {};
	        }
	        return {
	            x: this.X + (this.bbx || 0) - this.W / 2,
	            y: this.Y - this.H,
	            width: this.W,
	            height: this.H
	        };
	    };
	    elproto.remove = function () {
	        if (this.removed || !this.node.parentNode) {
	            return;
	        }
	        this.paper.__set__ && this.paper.__set__.exclude(this);
	        R.eve.unbind("raphael.*.*." + this.id);
	        R._tear(this, this.paper);
	        this.node.parentNode.removeChild(this.node);
	        this.shape && this.shape.parentNode.removeChild(this.shape);
	        for (var i in this) {
	            this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
	        }
	        this.removed = true;
	    };
	    elproto.attr = function (name, value) {
	        if (this.removed) {
	            return this;
	        }
	        if (name == null) {
	            var res = {};
	            for (var a in this.attrs) if (this.attrs[has](a)) {
	                res[a] = this.attrs[a];
	            }
	            res.gradient && res.fill == "none" && (res.fill = res.gradient) && delete res.gradient;
	            res.transform = this._.transform;
	            return res;
	        }
	        if (value == null && R.is(name, "string")) {
	            if (name == fillString && this.attrs.fill == "none" && this.attrs.gradient) {
	                return this.attrs.gradient;
	            }
	            var names = name.split(separator),
	                out = {};
	            for (var i = 0, ii = names.length; i < ii; i++) {
	                name = names[i];
	                if (name in this.attrs) {
	                    out[name] = this.attrs[name];
	                } else if (R.is(this.paper.customAttributes[name], "function")) {
	                    out[name] = this.paper.customAttributes[name].def;
	                } else {
	                    out[name] = R._availableAttrs[name];
	                }
	            }
	            return ii - 1 ? out : out[names[0]];
	        }
	        if (this.attrs && value == null && R.is(name, "array")) {
	            out = {};
	            for (i = 0, ii = name.length; i < ii; i++) {
	                out[name[i]] = this.attr(name[i]);
	            }
	            return out;
	        }
	        var params;
	        if (value != null) {
	            params = {};
	            params[name] = value;
	        }
	        value == null && R.is(name, "object") && (params = name);
	        for (var key in params) {
	            eve("raphael.attr." + key + "." + this.id, this, params[key]);
	        }
	        if (params) {
	            for (key in this.paper.customAttributes) if (this.paper.customAttributes[has](key) && params[has](key) && R.is(this.paper.customAttributes[key], "function")) {
	                var par = this.paper.customAttributes[key].apply(this, [].concat(params[key]));
	                this.attrs[key] = params[key];
	                for (var subkey in par) if (par[has](subkey)) {
	                    params[subkey] = par[subkey];
	                }
	            }
	            // this.paper.canvas.style.display = "none";
	            if (params.text && this.type == "text") {
	                this.textpath.string = params.text;
	            }
	            setFillAndStroke(this, params);
	            // this.paper.canvas.style.display = E;
	        }
	        return this;
	    };
	    elproto.toFront = function () {
	        !this.removed && this.node.parentNode.appendChild(this.node);
	        this.paper && this.paper.top != this && R._tofront(this, this.paper);
	        return this;
	    };
	    elproto.toBack = function () {
	        if (this.removed) {
	            return this;
	        }
	        if (this.node.parentNode.firstChild != this.node) {
	            this.node.parentNode.insertBefore(this.node, this.node.parentNode.firstChild);
	            R._toback(this, this.paper);
	        }
	        return this;
	    };
	    elproto.insertAfter = function (element) {
	        if (this.removed) {
	            return this;
	        }
	        if (element.constructor == R.st.constructor) {
	            element = element[element.length - 1];
	        }
	        if (element.node.nextSibling) {
	            element.node.parentNode.insertBefore(this.node, element.node.nextSibling);
	        } else {
	            element.node.parentNode.appendChild(this.node);
	        }
	        R._insertafter(this, element, this.paper);
	        return this;
	    };
	    elproto.insertBefore = function (element) {
	        if (this.removed) {
	            return this;
	        }
	        if (element.constructor == R.st.constructor) {
	            element = element[0];
	        }
	        element.node.parentNode.insertBefore(this.node, element.node);
	        R._insertbefore(this, element, this.paper);
	        return this;
	    };
	    elproto.blur = function (size) {
	        var s = this.node.runtimeStyle,
	            f = s.filter;
	        f = f.replace(blurregexp, E);
	        if (+size !== 0) {
	            this.attrs.blur = size;
	            s.filter = f + S + ms + ".Blur(pixelradius=" + (+size || 1.5) + ")";
	            s.margin = R.format("-{0}px 0 0 -{0}px", round(+size || 1.5));
	        } else {
	            s.filter = f;
	            s.margin = 0;
	            delete this.attrs.blur;
	        }
	        return this;
	    };

	    R._engine.path = function (pathString, vml) {
	        var el = createNode("shape");
	        el.style.cssText = cssDot;
	        el.coordsize = zoom + S + zoom;
	        el.coordorigin = vml.coordorigin;
	        var p = new Element(el, vml),
	            attr = {fill: "none", stroke: "#000"};
	        pathString && (attr.path = pathString);
	        p.type = "path";
	        p.path = [];
	        p.Path = E;
	        setFillAndStroke(p, attr);
	        vml.canvas && vml.canvas.appendChild(el);
	        var skew = createNode("skew");
	        skew.on = true;
	        el.appendChild(skew);
	        p.skew = skew;
	        p.transform(E);
	        return p;
	    };
	    R._engine.rect = function (vml, x, y, w, h, r) {
	        var path = R._rectPath(x, y, w, h, r),
	            res = vml.path(path),
	            a = res.attrs;
	        res.X = a.x = x;
	        res.Y = a.y = y;
	        res.W = a.width = w;
	        res.H = a.height = h;
	        a.r = r;
	        a.path = path;
	        res.type = "rect";
	        return res;
	    };
	    R._engine.ellipse = function (vml, x, y, rx, ry) {
	        var res = vml.path(),
	            a = res.attrs;
	        res.X = x - rx;
	        res.Y = y - ry;
	        res.W = rx * 2;
	        res.H = ry * 2;
	        res.type = "ellipse";
	        setFillAndStroke(res, {
	            cx: x,
	            cy: y,
	            rx: rx,
	            ry: ry
	        });
	        return res;
	    };
	    R._engine.circle = function (vml, x, y, r) {
	        var res = vml.path(),
	            a = res.attrs;
	        res.X = x - r;
	        res.Y = y - r;
	        res.W = res.H = r * 2;
	        res.type = "circle";
	        setFillAndStroke(res, {
	            cx: x,
	            cy: y,
	            r: r
	        });
	        return res;
	    };
	    R._engine.image = function (vml, src, x, y, w, h) {
	        var path = R._rectPath(x, y, w, h),
	            res = vml.path(path).attr({stroke: "none"}),
	            a = res.attrs,
	            node = res.node,
	            fill = node.getElementsByTagName(fillString)[0];
	        a.src = src;
	        res.X = a.x = x;
	        res.Y = a.y = y;
	        res.W = a.width = w;
	        res.H = a.height = h;
	        a.path = path;
	        res.type = "image";
	        fill.parentNode == node && node.removeChild(fill);
	        fill.rotate = true;
	        fill.src = src;
	        fill.type = "tile";
	        res._.fillpos = [x, y];
	        res._.fillsize = [w, h];
	        node.appendChild(fill);
	        setCoords(res, 1, 1, 0, 0, 0);
	        return res;
	    };
	    R._engine.text = function (vml, x, y, text) {
	        var el = createNode("shape"),
	            path = createNode("path"),
	            o = createNode("textpath");
	        x = x || 0;
	        y = y || 0;
	        text = text || "";
	        path.v = R.format("m{0},{1}l{2},{1}", round(x * zoom), round(y * zoom), round(x * zoom) + 1);
	        path.textpathok = true;
	        o.string = Str(text);
	        o.on = true;
	        el.style.cssText = cssDot;
	        el.coordsize = zoom + S + zoom;
	        el.coordorigin = "0 0";
	        var p = new Element(el, vml),
	            attr = {
	                fill: "#000",
	                stroke: "none",
	                font: R._availableAttrs.font,
	                text: text
	            };
	        p.shape = el;
	        p.path = path;
	        p.textpath = o;
	        p.type = "text";
	        p.attrs.text = Str(text);
	        p.attrs.x = x;
	        p.attrs.y = y;
	        p.attrs.w = 1;
	        p.attrs.h = 1;
	        setFillAndStroke(p, attr);
	        el.appendChild(o);
	        el.appendChild(path);
	        vml.canvas.appendChild(el);
	        var skew = createNode("skew");
	        skew.on = true;
	        el.appendChild(skew);
	        p.skew = skew;
	        p.transform(E);
	        return p;
	    };
	    R._engine.setSize = function (width, height) {
	        var cs = this.canvas.style;
	        this.width = width;
	        this.height = height;
	        width == +width && (width += "px");
	        height == +height && (height += "px");
	        cs.width = width;
	        cs.height = height;
	        cs.clip = "rect(0 " + width + " " + height + " 0)";
	        if (this._viewBox) {
	            R._engine.setViewBox.apply(this, this._viewBox);
	        }
	        return this;
	    };
	    R._engine.setViewBox = function (x, y, w, h, fit) {
	        R.eve("raphael.setViewBox", this, this._viewBox, [x, y, w, h, fit]);
	        var paperSize = this.getSize(),
	            width = paperSize.width,
	            height = paperSize.height,
	            H, W;
	        if (fit) {
	            H = height / h;
	            W = width / w;
	            if (w * H < width) {
	                x -= (width - w * H) / 2 / H;
	            }
	            if (h * W < height) {
	                y -= (height - h * W) / 2 / W;
	            }
	        }
	        this._viewBox = [x, y, w, h, !!fit];
	        this._viewBoxShift = {
	            dx: -x,
	            dy: -y,
	            scale: paperSize
	        };
	        this.forEach(function (el) {
	            el.transform("...");
	        });
	        return this;
	    };
	    var createNode;
	    R._engine.initWin = function (win) {
	            var doc = win.document;
	            if (doc.styleSheets.length < 31) {
	                doc.createStyleSheet().addRule(".rvml", "behavior:url(#default#VML)");
	            } else {
	                // no more room, add to the existing one
	                // http://msdn.microsoft.com/en-us/library/ms531194%28VS.85%29.aspx
	                doc.styleSheets[0].addRule(".rvml", "behavior:url(#default#VML)");
	            }
	            try {
	                !doc.namespaces.rvml && doc.namespaces.add("rvml", "urn:schemas-microsoft-com:vml");
	                createNode = function (tagName) {
	                    return doc.createElement('<rvml:' + tagName + ' class="rvml">');
	                };
	            } catch (e) {
	                createNode = function (tagName) {
	                    return doc.createElement('<' + tagName + ' xmlns="urn:schemas-microsoft.com:vml" class="rvml">');
	                };
	            }
	        };
	    R._engine.initWin(R._g.win);
	    R._engine.create = function () {
	        var con = R._getContainer.apply(0, arguments),
	            container = con.container,
	            height = con.height,
	            s,
	            width = con.width,
	            x = con.x,
	            y = con.y;
	        if (!container) {
	            throw new Error("VML container not found.");
	        }
	        var res = new R._Paper,
	            c = res.canvas = R._g.doc.createElement("div"),
	            cs = c.style;
	        x = x || 0;
	        y = y || 0;
	        width = width || 512;
	        height = height || 342;
	        res.width = width;
	        res.height = height;
	        width == +width && (width += "px");
	        height == +height && (height += "px");
	        res.coordsize = zoom * 1e3 + S + zoom * 1e3;
	        res.coordorigin = "0 0";
	        res.span = R._g.doc.createElement("span");
	        res.span.style.cssText = "position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;";
	        c.appendChild(res.span);
	        cs.cssText = R.format("top:0;left:0;width:{0};height:{1};display:inline-block;position:relative;clip:rect(0 {0} {1} 0);overflow:hidden", width, height);
	        if (container == 1) {
	            R._g.doc.body.appendChild(c);
	            cs.left = x + "px";
	            cs.top = y + "px";
	            cs.position = "absolute";
	        } else {
	            if (container.firstChild) {
	                container.insertBefore(c, container.firstChild);
	            } else {
	                container.appendChild(c);
	            }
	        }
	        res.renderfix = function () {};
	        return res;
	    };
	    R.prototype.clear = function () {
	        R.eve("raphael.clear", this);
	        this.canvas.innerHTML = E;
	        this.span = R._g.doc.createElement("span");
	        this.span.style.cssText = "position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;";
	        this.canvas.appendChild(this.span);
	        this.bottom = this.top = null;
	    };
	    R.prototype.remove = function () {
	        R.eve("raphael.remove", this);
	        this.canvas.parentNode.removeChild(this.canvas);
	        for (var i in this) {
	            this[i] = typeof this[i] == "function" ? R._removedFactory(i) : null;
	        }
	        return true;
	    };

	    var setproto = R.st;
	    for (var method in elproto) if (elproto[has](method) && !setproto[has](method)) {
	        setproto[method] = (function (methodname) {
	            return function () {
	                var arg = arguments;
	                return this.forEach(function (el) {
	                    el[methodname].apply(el, arg);
	                });
	            };
	        })(method);
	    }
	}.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));


/***/ }
/******/ ])
});
;
/* @license
morris.js v0.5.0
Copyright 2014 Olly Smith All rights reserved.
Licensed under the BSD-2-Clause License.
*/
(function(){var a,b,c,d,e=[].slice,f=function(a,b){return function(){return a.apply(b,arguments)}},g={}.hasOwnProperty,h=function(a,b){function c(){this.constructor=a}for(var d in b)g.call(b,d)&&(a[d]=b[d]);return c.prototype=b.prototype,a.prototype=new c,a.__super__=b.prototype,a},i=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};b=window.Morris={},a=jQuery,b.EventEmitter=function(){function a(){}return a.prototype.on=function(a,b){return null==this.handlers&&(this.handlers={}),null==this.handlers[a]&&(this.handlers[a]=[]),this.handlers[a].push(b),this},a.prototype.fire=function(){var a,b,c,d,f,g,h;if(c=arguments[0],a=2<=arguments.length?e.call(arguments,1):[],null!=this.handlers&&null!=this.handlers[c]){for(g=this.handlers[c],h=[],d=0,f=g.length;f>d;d++)b=g[d],h.push(b.apply(null,a));return h}},a}(),b.commas=function(a){var b,c,d,e;return null!=a?(d=0>a?"-":"",b=Math.abs(a),c=Math.floor(b).toFixed(0),d+=c.replace(/(?=(?:\d{3})+$)(?!^)/g,","),e=b.toString(),e.length>c.length&&(d+=e.slice(c.length)),d):"-"},b.pad2=function(a){return(10>a?"0":"")+a},b.Grid=function(c){function d(b){this.resizeHandler=f(this.resizeHandler,this);var c=this;if(this.el="string"==typeof b.element?a(document.getElementById(b.element)):a(b.element),null==this.el||0===this.el.length)throw new Error("Graph container element not found");"static"===this.el.css("position")&&this.el.css("position","relative"),this.options=a.extend({},this.gridDefaults,this.defaults||{},b),"string"==typeof this.options.units&&(this.options.postUnits=b.units),this.raphael=new Raphael(this.el[0]),this.elementWidth=null,this.elementHeight=null,this.dirty=!1,this.selectFrom=null,this.init&&this.init(),this.setData(this.options.data),this.el.bind("mousemove",function(a){var b,d,e,f,g;return d=c.el.offset(),g=a.pageX-d.left,c.selectFrom?(b=c.data[c.hitTest(Math.min(g,c.selectFrom))]._x,e=c.data[c.hitTest(Math.max(g,c.selectFrom))]._x,f=e-b,c.selectionRect.attr({x:b,width:f})):c.fire("hovermove",g,a.pageY-d.top)}),this.el.bind("mouseleave",function(){return c.selectFrom&&(c.selectionRect.hide(),c.selectFrom=null),c.fire("hoverout")}),this.el.bind("touchstart touchmove touchend",function(a){var b,d;return d=a.originalEvent.touches[0]||a.originalEvent.changedTouches[0],b=c.el.offset(),c.fire("hovermove",d.pageX-b.left,d.pageY-b.top)}),this.el.bind("click",function(a){var b;return b=c.el.offset(),c.fire("gridclick",a.pageX-b.left,a.pageY-b.top)}),this.options.rangeSelect&&(this.selectionRect=this.raphael.rect(0,0,0,this.el.innerHeight()).attr({fill:this.options.rangeSelectColor,stroke:!1}).toBack().hide(),this.el.bind("mousedown",function(a){var b;return b=c.el.offset(),c.startRange(a.pageX-b.left)}),this.el.bind("mouseup",function(a){var b;return b=c.el.offset(),c.endRange(a.pageX-b.left),c.fire("hovermove",a.pageX-b.left,a.pageY-b.top)})),this.options.resize&&a(window).bind("resize",function(){return null!=c.timeoutId&&window.clearTimeout(c.timeoutId),c.timeoutId=window.setTimeout(c.resizeHandler,100)}),this.el.css("-webkit-tap-highlight-color","rgba(0,0,0,0)"),this.postInit&&this.postInit()}return h(d,c),d.prototype.gridDefaults={dateFormat:null,axes:!0,grid:!0,gridLineColor:"#aaa",gridStrokeWidth:.5,gridTextColor:"#888",gridTextSize:12,gridTextFamily:"sans-serif",gridTextWeight:"normal",hideHover:!1,yLabelFormat:null,xLabelAngle:0,numLines:5,padding:25,parseTime:!0,postUnits:"",preUnits:"",ymax:"auto",ymin:"auto 0",goals:[],goalStrokeWidth:1,goalLineColors:["#666633","#999966","#cc6666","#663333"],events:[],eventStrokeWidth:1,eventLineColors:["#005a04","#ccffbb","#3a5f0b","#005502"],rangeSelect:null,rangeSelectColor:"#eef",resize:!1},d.prototype.setData=function(a,c){var d,e,f,g,h,i,j,k,l,m,n,o,p,q,r;return null==c&&(c=!0),this.options.data=a,null==a||0===a.length?(this.data=[],this.raphael.clear(),null!=this.hover&&this.hover.hide(),void 0):(o=this.cumulative?0:null,p=this.cumulative?0:null,this.options.goals.length>0&&(h=Math.min.apply(Math,this.options.goals),g=Math.max.apply(Math,this.options.goals),p=null!=p?Math.min(p,h):h,o=null!=o?Math.max(o,g):g),this.data=function(){var c,d,g;for(g=[],f=c=0,d=a.length;d>c;f=++c)j=a[f],i={src:j},i.label=j[this.options.xkey],this.options.parseTime?(i.x=b.parseDate(i.label),this.options.dateFormat?i.label=this.options.dateFormat(i.x):"number"==typeof i.label&&(i.label=new Date(i.label).toString())):(i.x=f,this.options.xLabelFormat&&(i.label=this.options.xLabelFormat(i))),l=0,i.y=function(){var a,b,c,d;for(c=this.options.ykeys,d=[],e=a=0,b=c.length;b>a;e=++a)n=c[e],q=j[n],"string"==typeof q&&(q=parseFloat(q)),null!=q&&"number"!=typeof q&&(q=null),null!=q&&(this.cumulative?l+=q:null!=o?(o=Math.max(q,o),p=Math.min(q,p)):o=p=q),this.cumulative&&null!=l&&(o=Math.max(l,o),p=Math.min(l,p)),d.push(q);return d}.call(this),g.push(i);return g}.call(this),this.options.parseTime&&(this.data=this.data.sort(function(a,b){return(a.x>b.x)-(b.x>a.x)})),this.xmin=this.data[0].x,this.xmax=this.data[this.data.length-1].x,this.events=[],this.options.events.length>0&&(this.events=this.options.parseTime?function(){var a,c,e,f;for(e=this.options.events,f=[],a=0,c=e.length;c>a;a++)d=e[a],f.push(b.parseDate(d));return f}.call(this):this.options.events,this.xmax=Math.max(this.xmax,Math.max.apply(Math,this.events)),this.xmin=Math.min(this.xmin,Math.min.apply(Math,this.events))),this.xmin===this.xmax&&(this.xmin-=1,this.xmax+=1),this.ymin=this.yboundary("min",p),this.ymax=this.yboundary("max",o),this.ymin===this.ymax&&(p&&(this.ymin-=1),this.ymax+=1),((r=this.options.axes)===!0||"both"===r||"y"===r||this.options.grid===!0)&&(this.options.ymax===this.gridDefaults.ymax&&this.options.ymin===this.gridDefaults.ymin?(this.grid=this.autoGridLines(this.ymin,this.ymax,this.options.numLines),this.ymin=Math.min(this.ymin,this.grid[0]),this.ymax=Math.max(this.ymax,this.grid[this.grid.length-1])):(k=(this.ymax-this.ymin)/(this.options.numLines-1),this.grid=function(){var a,b,c,d;for(d=[],m=a=b=this.ymin,c=this.ymax;k>0?c>=a:a>=c;m=a+=k)d.push(m);return d}.call(this))),this.dirty=!0,c?this.redraw():void 0)},d.prototype.yboundary=function(a,b){var c,d;return c=this.options["y"+a],"string"==typeof c?"auto"===c.slice(0,4)?c.length>5?(d=parseInt(c.slice(5),10),null==b?d:Math[a](b,d)):null!=b?b:0:parseInt(c,10):c},d.prototype.autoGridLines=function(a,b,c){var d,e,f,g,h,i,j,k,l;return h=b-a,l=Math.floor(Math.log(h)/Math.log(10)),j=Math.pow(10,l),e=Math.floor(a/j)*j,d=Math.ceil(b/j)*j,i=(d-e)/(c-1),1===j&&i>1&&Math.ceil(i)!==i&&(i=Math.ceil(i),d=e+i*(c-1)),0>e&&d>0&&(e=Math.floor(a/i)*i,d=Math.ceil(b/i)*i),1>i?(g=Math.floor(Math.log(i)/Math.log(10)),f=function(){var a,b;for(b=[],k=a=e;i>0?d>=a:a>=d;k=a+=i)b.push(parseFloat(k.toFixed(1-g)));return b}()):f=function(){var a,b;for(b=[],k=a=e;i>0?d>=a:a>=d;k=a+=i)b.push(k);return b}(),f},d.prototype._calc=function(){var a,b,c,d,e,f,g,h;return e=this.el.width(),c=this.el.height(),(this.elementWidth!==e||this.elementHeight!==c||this.dirty)&&(this.elementWidth=e,this.elementHeight=c,this.dirty=!1,this.left=this.options.padding,this.right=this.elementWidth-this.options.padding,this.top=this.options.padding,this.bottom=this.elementHeight-this.options.padding,((g=this.options.axes)===!0||"both"===g||"y"===g)&&(f=function(){var a,c,d,e;for(d=this.grid,e=[],a=0,c=d.length;c>a;a++)b=d[a],e.push(this.measureText(this.yAxisFormat(b)).width);return e}.call(this),this.left+=Math.max.apply(Math,f)),((h=this.options.axes)===!0||"both"===h||"x"===h)&&(a=function(){var a,b,c;for(c=[],d=a=0,b=this.data.length;b>=0?b>a:a>b;d=b>=0?++a:--a)c.push(this.measureText(this.data[d].text,-this.options.xLabelAngle).height);return c}.call(this),this.bottom-=Math.max.apply(Math,a)),this.width=Math.max(1,this.right-this.left),this.height=Math.max(1,this.bottom-this.top),this.dx=this.width/(this.xmax-this.xmin),this.dy=this.height/(this.ymax-this.ymin),this.calc)?this.calc():void 0},d.prototype.transY=function(a){return this.bottom-(a-this.ymin)*this.dy},d.prototype.transX=function(a){return 1===this.data.length?(this.left+this.right)/2:this.left+(a-this.xmin)*this.dx},d.prototype.redraw=function(){return this.raphael.clear(),this._calc(),this.drawGrid(),this.drawGoals(),this.drawEvents(),this.draw?this.draw():void 0},d.prototype.measureText=function(a,b){var c,d;return null==b&&(b=0),d=this.raphael.text(100,100,a).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).rotate(b),c=d.getBBox(),d.remove(),c},d.prototype.yAxisFormat=function(a){return this.yLabelFormat(a)},d.prototype.yLabelFormat=function(a){return"function"==typeof this.options.yLabelFormat?this.options.yLabelFormat(a):""+this.options.preUnits+b.commas(a)+this.options.postUnits},d.prototype.drawGrid=function(){var a,b,c,d,e,f,g,h;if(this.options.grid!==!1||(e=this.options.axes)===!0||"both"===e||"y"===e){for(f=this.grid,h=[],c=0,d=f.length;d>c;c++)a=f[c],b=this.transY(a),((g=this.options.axes)===!0||"both"===g||"y"===g)&&this.drawYAxisLabel(this.left-this.options.padding/2,b,this.yAxisFormat(a)),this.options.grid?h.push(this.drawGridLine("M"+this.left+","+b+"H"+(this.left+this.width))):h.push(void 0);return h}},d.prototype.drawGoals=function(){var a,b,c,d,e,f,g;for(f=this.options.goals,g=[],c=d=0,e=f.length;e>d;c=++d)b=f[c],a=this.options.goalLineColors[c%this.options.goalLineColors.length],g.push(this.drawGoal(b,a));return g},d.prototype.drawEvents=function(){var a,b,c,d,e,f,g;for(f=this.events,g=[],c=d=0,e=f.length;e>d;c=++d)b=f[c],a=this.options.eventLineColors[c%this.options.eventLineColors.length],g.push(this.drawEvent(b,a));return g},d.prototype.drawGoal=function(a,b){return this.raphael.path("M"+this.left+","+this.transY(a)+"H"+this.right).attr("stroke",b).attr("stroke-width",this.options.goalStrokeWidth)},d.prototype.drawEvent=function(a,b){return this.raphael.path("M"+this.transX(a)+","+this.bottom+"V"+this.top).attr("stroke",b).attr("stroke-width",this.options.eventStrokeWidth)},d.prototype.drawYAxisLabel=function(a,b,c){return this.raphael.text(a,b,c).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor).attr("text-anchor","end")},d.prototype.drawGridLine=function(a){return this.raphael.path(a).attr("stroke",this.options.gridLineColor).attr("stroke-width",this.options.gridStrokeWidth)},d.prototype.startRange=function(a){return this.hover.hide(),this.selectFrom=a,this.selectionRect.attr({x:a,width:0}).show()},d.prototype.endRange=function(a){var b,c;return this.selectFrom?(c=Math.min(this.selectFrom,a),b=Math.max(this.selectFrom,a),this.options.rangeSelect.call(this.el,{start:this.data[this.hitTest(c)].x,end:this.data[this.hitTest(b)].x}),this.selectFrom=null):void 0},d.prototype.resizeHandler=function(){return this.timeoutId=null,this.raphael.setSize(this.el.width(),this.el.height()),this.redraw()},d}(b.EventEmitter),b.parseDate=function(a){var b,c,d,e,f,g,h,i,j,k,l;return"number"==typeof a?a:(c=a.match(/^(\d+) Q(\d)$/),e=a.match(/^(\d+)-(\d+)$/),f=a.match(/^(\d+)-(\d+)-(\d+)$/),h=a.match(/^(\d+) W(\d+)$/),i=a.match(/^(\d+)-(\d+)-(\d+)[ T](\d+):(\d+)(Z|([+-])(\d\d):?(\d\d))?$/),j=a.match(/^(\d+)-(\d+)-(\d+)[ T](\d+):(\d+):(\d+(\.\d+)?)(Z|([+-])(\d\d):?(\d\d))?$/),c?new Date(parseInt(c[1],10),3*parseInt(c[2],10)-1,1).getTime():e?new Date(parseInt(e[1],10),parseInt(e[2],10)-1,1).getTime():f?new Date(parseInt(f[1],10),parseInt(f[2],10)-1,parseInt(f[3],10)).getTime():h?(k=new Date(parseInt(h[1],10),0,1),4!==k.getDay()&&k.setMonth(0,1+(4-k.getDay()+7)%7),k.getTime()+6048e5*parseInt(h[2],10)):i?i[6]?(g=0,"Z"!==i[6]&&(g=60*parseInt(i[8],10)+parseInt(i[9],10),"+"===i[7]&&(g=0-g)),Date.UTC(parseInt(i[1],10),parseInt(i[2],10)-1,parseInt(i[3],10),parseInt(i[4],10),parseInt(i[5],10)+g)):new Date(parseInt(i[1],10),parseInt(i[2],10)-1,parseInt(i[3],10),parseInt(i[4],10),parseInt(i[5],10)).getTime():j?(l=parseFloat(j[6]),b=Math.floor(l),d=Math.round(1e3*(l-b)),j[8]?(g=0,"Z"!==j[8]&&(g=60*parseInt(j[10],10)+parseInt(j[11],10),"+"===j[9]&&(g=0-g)),Date.UTC(parseInt(j[1],10),parseInt(j[2],10)-1,parseInt(j[3],10),parseInt(j[4],10),parseInt(j[5],10)+g,b,d)):new Date(parseInt(j[1],10),parseInt(j[2],10)-1,parseInt(j[3],10),parseInt(j[4],10),parseInt(j[5],10),b,d).getTime()):new Date(parseInt(a,10),0,1).getTime())},b.Hover=function(){function c(c){null==c&&(c={}),this.options=a.extend({},b.Hover.defaults,c),this.el=a("<div class='"+this.options["class"]+"'></div>"),this.el.hide(),this.options.parent.append(this.el)}return c.defaults={"class":"morris-hover morris-default-style"},c.prototype.update=function(a,b,c){return a?(this.html(a),this.show(),this.moveTo(b,c)):this.hide()},c.prototype.html=function(a){return this.el.html(a)},c.prototype.moveTo=function(a,b){var c,d,e,f,g,h;return g=this.options.parent.innerWidth(),f=this.options.parent.innerHeight(),d=this.el.outerWidth(),c=this.el.outerHeight(),e=Math.min(Math.max(0,a-d/2),g-d),null!=b?(h=b-c-10,0>h&&(h=b+10,h+c>f&&(h=f/2-c/2))):h=f/2-c/2,this.el.css({left:e+"px",top:parseInt(h)+"px"})},c.prototype.show=function(){return this.el.show()},c.prototype.hide=function(){return this.el.hide()},c}(),b.Line=function(a){function c(a){return this.hilight=f(this.hilight,this),this.onHoverOut=f(this.onHoverOut,this),this.onHoverMove=f(this.onHoverMove,this),this.onGridClick=f(this.onGridClick,this),this instanceof b.Line?(c.__super__.constructor.call(this,a),void 0):new b.Line(a)}return h(c,a),c.prototype.init=function(){return"always"!==this.options.hideHover?(this.hover=new b.Hover({parent:this.el}),this.on("hovermove",this.onHoverMove),this.on("hoverout",this.onHoverOut),this.on("gridclick",this.onGridClick)):void 0},c.prototype.defaults={lineWidth:3,pointSize:4,lineColors:["#0b62a4","#7A92A3","#4da74d","#afd8f8","#edc240","#cb4b4b","#9440ed"],pointStrokeWidths:[1],pointStrokeColors:["#ffffff"],pointFillColors:[],smooth:!0,xLabels:"auto",xLabelFormat:null,xLabelMargin:24,hideHover:!1},c.prototype.calc=function(){return this.calcPoints(),this.generatePaths()},c.prototype.calcPoints=function(){var a,b,c,d,e,f;for(e=this.data,f=[],c=0,d=e.length;d>c;c++)a=e[c],a._x=this.transX(a.x),a._y=function(){var c,d,e,f;for(e=a.y,f=[],c=0,d=e.length;d>c;c++)b=e[c],null!=b?f.push(this.transY(b)):f.push(b);return f}.call(this),f.push(a._ymax=Math.min.apply(Math,[this.bottom].concat(function(){var c,d,e,f;for(e=a._y,f=[],c=0,d=e.length;d>c;c++)b=e[c],null!=b&&f.push(b);return f}())));return f},c.prototype.hitTest=function(a){var b,c,d,e,f;if(0===this.data.length)return null;for(f=this.data.slice(1),b=d=0,e=f.length;e>d&&(c=f[b],!(a<(c._x+this.data[b]._x)/2));b=++d);return b},c.prototype.onGridClick=function(a,b){var c;return c=this.hitTest(a),this.fire("click",c,this.data[c].src,a,b)},c.prototype.onHoverMove=function(a){var b;return b=this.hitTest(a),this.displayHoverForRow(b)},c.prototype.onHoverOut=function(){return this.options.hideHover!==!1?this.displayHoverForRow(null):void 0},c.prototype.displayHoverForRow=function(a){var b;return null!=a?((b=this.hover).update.apply(b,this.hoverContentForRow(a)),this.hilight(a)):(this.hover.hide(),this.hilight())},c.prototype.hoverContentForRow=function(a){var b,c,d,e,f,g,h;for(d=this.data[a],b="<div class='morris-hover-row-label'>"+d.label+"</div>",h=d.y,c=f=0,g=h.length;g>f;c=++f)e=h[c],b+="<div class='morris-hover-point' style='color: "+this.colorFor(d,c,"label")+"'>\n  "+this.options.labels[c]+":\n  "+this.yLabelFormat(e)+"\n</div>";return"function"==typeof this.options.hoverCallback&&(b=this.options.hoverCallback(a,this.options,b,d.src)),[b,d._x,d._ymax]},c.prototype.generatePaths=function(){var a,c,d,e;return this.paths=function(){var f,g,h,j;for(j=[],c=f=0,g=this.options.ykeys.length;g>=0?g>f:f>g;c=g>=0?++f:--f)e="boolean"==typeof this.options.smooth?this.options.smooth:(h=this.options.ykeys[c],i.call(this.options.smooth,h)>=0),a=function(){var a,b,e,f;for(e=this.data,f=[],a=0,b=e.length;b>a;a++)d=e[a],void 0!==d._y[c]&&f.push({x:d._x,y:d._y[c]});return f}.call(this),a.length>1?j.push(b.Line.createPath(a,e,this.bottom)):j.push(null);return j}.call(this)},c.prototype.draw=function(){var a;return((a=this.options.axes)===!0||"both"===a||"x"===a)&&this.drawXAxis(),this.drawSeries(),this.options.hideHover===!1?this.displayHoverForRow(this.data.length-1):void 0},c.prototype.drawXAxis=function(){var a,c,d,e,f,g,h,i,j,k,l=this;for(h=this.bottom+this.options.padding/2,f=null,e=null,a=function(a,b){var c,d,g,i,j;return c=l.drawXAxisLabel(l.transX(b),h,a),j=c.getBBox(),c.transform("r"+-l.options.xLabelAngle),d=c.getBBox(),c.transform("t0,"+d.height/2+"..."),0!==l.options.xLabelAngle&&(i=-.5*j.width*Math.cos(l.options.xLabelAngle*Math.PI/180),c.transform("t"+i+",0...")),d=c.getBBox(),(null==f||f>=d.x+d.width||null!=e&&e>=d.x)&&d.x>=0&&d.x+d.width<l.el.width()?(0!==l.options.xLabelAngle&&(g=1.25*l.options.gridTextSize/Math.sin(l.options.xLabelAngle*Math.PI/180),e=d.x-g),f=d.x-l.options.xLabelMargin):c.remove()},d=this.options.parseTime?1===this.data.length&&"auto"===this.options.xLabels?[[this.data[0].label,this.data[0].x]]:b.labelSeries(this.xmin,this.xmax,this.width,this.options.xLabels,this.options.xLabelFormat):function(){var a,b,c,d;for(c=this.data,d=[],a=0,b=c.length;b>a;a++)g=c[a],d.push([g.label,g.x]);return d}.call(this),d.reverse(),k=[],i=0,j=d.length;j>i;i++)c=d[i],k.push(a(c[0],c[1]));return k},c.prototype.drawSeries=function(){var a,b,c,d,e,f;for(this.seriesPoints=[],a=b=d=this.options.ykeys.length-1;0>=d?0>=b:b>=0;a=0>=d?++b:--b)this._drawLineFor(a);for(f=[],a=c=e=this.options.ykeys.length-1;0>=e?0>=c:c>=0;a=0>=e?++c:--c)f.push(this._drawPointFor(a));return f},c.prototype._drawPointFor=function(a){var b,c,d,e,f,g;for(this.seriesPoints[a]=[],f=this.data,g=[],d=0,e=f.length;e>d;d++)c=f[d],b=null,null!=c._y[a]&&(b=this.drawLinePoint(c._x,c._y[a],this.colorFor(c,a,"point"),a)),g.push(this.seriesPoints[a].push(b));return g},c.prototype._drawLineFor=function(a){var b;return b=this.paths[a],null!==b?this.drawLinePath(b,this.colorFor(null,a,"line"),a):void 0},c.createPath=function(a,c,d){var e,f,g,h,i,j,k,l,m,n,o,p,q,r;for(k="",c&&(g=b.Line.gradients(a)),l={y:null},h=q=0,r=a.length;r>q;h=++q)e=a[h],null!=e.y&&(null!=l.y?c?(f=g[h],j=g[h-1],i=(e.x-l.x)/4,m=l.x+i,o=Math.min(d,l.y+i*j),n=e.x-i,p=Math.min(d,e.y-i*f),k+="C"+m+","+o+","+n+","+p+","+e.x+","+e.y):k+="L"+e.x+","+e.y:c&&null==g[h]||(k+="M"+e.x+","+e.y)),l=e;return k},c.gradients=function(a){var b,c,d,e,f,g,h,i;for(c=function(a,b){return(a.y-b.y)/(a.x-b.x)},i=[],d=g=0,h=a.length;h>g;d=++g)b=a[d],null!=b.y?(e=a[d+1]||{y:null},f=a[d-1]||{y:null},null!=f.y&&null!=e.y?i.push(c(f,e)):null!=f.y?i.push(c(f,b)):null!=e.y?i.push(c(b,e)):i.push(null)):i.push(null);return i},c.prototype.hilight=function(a){var b,c,d,e,f;if(null!==this.prevHilight&&this.prevHilight!==a)for(b=c=0,e=this.seriesPoints.length-1;e>=0?e>=c:c>=e;b=e>=0?++c:--c)this.seriesPoints[b][this.prevHilight]&&this.seriesPoints[b][this.prevHilight].animate(this.pointShrinkSeries(b));if(null!==a&&this.prevHilight!==a)for(b=d=0,f=this.seriesPoints.length-1;f>=0?f>=d:d>=f;b=f>=0?++d:--d)this.seriesPoints[b][a]&&this.seriesPoints[b][a].animate(this.pointGrowSeries(b));return this.prevHilight=a},c.prototype.colorFor=function(a,b,c){return"function"==typeof this.options.lineColors?this.options.lineColors.call(this,a,b,c):"point"===c?this.options.pointFillColors[b%this.options.pointFillColors.length]||this.options.lineColors[b%this.options.lineColors.length]:this.options.lineColors[b%this.options.lineColors.length]},c.prototype.drawXAxisLabel=function(a,b,c){return this.raphael.text(a,b,c).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor)},c.prototype.drawLinePath=function(a,b,c){return this.raphael.path(a).attr("stroke",b).attr("stroke-width",this.lineWidthForSeries(c))},c.prototype.drawLinePoint=function(a,b,c,d){return this.raphael.circle(a,b,this.pointSizeForSeries(d)).attr("fill",c).attr("stroke-width",this.pointStrokeWidthForSeries(d)).attr("stroke",this.pointStrokeColorForSeries(d))},c.prototype.pointStrokeWidthForSeries=function(a){return this.options.pointStrokeWidths[a%this.options.pointStrokeWidths.length]},c.prototype.pointStrokeColorForSeries=function(a){return this.options.pointStrokeColors[a%this.options.pointStrokeColors.length]},c.prototype.lineWidthForSeries=function(a){return this.options.lineWidth instanceof Array?this.options.lineWidth[a%this.options.lineWidth.length]:this.options.lineWidth},c.prototype.pointSizeForSeries=function(a){return this.options.pointSize instanceof Array?this.options.pointSize[a%this.options.pointSize.length]:this.options.pointSize},c.prototype.pointGrowSeries=function(a){return Raphael.animation({r:this.pointSizeForSeries(a)+3},25,"linear")},c.prototype.pointShrinkSeries=function(a){return Raphael.animation({r:this.pointSizeForSeries(a)},25,"linear")},c}(b.Grid),b.labelSeries=function(c,d,e,f,g){var h,i,j,k,l,m,n,o,p,q,r;if(j=200*(d-c)/e,i=new Date(c),n=b.LABEL_SPECS[f],void 0===n)for(r=b.AUTO_LABEL_ORDER,p=0,q=r.length;q>p;p++)if(k=r[p],m=b.LABEL_SPECS[k],j>=m.span){n=m;break}for(void 0===n&&(n=b.LABEL_SPECS.second),g&&(n=a.extend({},n,{fmt:g})),h=n.start(i),l=[];(o=h.getTime())<=d;)o>=c&&l.push([n.fmt(h),o]),n.incr(h);return l},c=function(a){return{span:60*a*1e3,start:function(a){return new Date(a.getFullYear(),a.getMonth(),a.getDate(),a.getHours())},fmt:function(a){return""+b.pad2(a.getHours())+":"+b.pad2(a.getMinutes())},incr:function(b){return b.setUTCMinutes(b.getUTCMinutes()+a)}}},d=function(a){return{span:1e3*a,start:function(a){return new Date(a.getFullYear(),a.getMonth(),a.getDate(),a.getHours(),a.getMinutes())},fmt:function(a){return""+b.pad2(a.getHours())+":"+b.pad2(a.getMinutes())+":"+b.pad2(a.getSeconds())},incr:function(b){return b.setUTCSeconds(b.getUTCSeconds()+a)}}},b.LABEL_SPECS={decade:{span:1728e8,start:function(a){return new Date(a.getFullYear()-a.getFullYear()%10,0,1)},fmt:function(a){return""+a.getFullYear()},incr:function(a){return a.setFullYear(a.getFullYear()+10)}},year:{span:1728e7,start:function(a){return new Date(a.getFullYear(),0,1)},fmt:function(a){return""+a.getFullYear()},incr:function(a){return a.setFullYear(a.getFullYear()+1)}},month:{span:24192e5,start:function(a){return new Date(a.getFullYear(),a.getMonth(),1)},fmt:function(a){return""+a.getFullYear()+"-"+b.pad2(a.getMonth()+1)},incr:function(a){return a.setMonth(a.getMonth()+1)}},week:{span:6048e5,start:function(a){return new Date(a.getFullYear(),a.getMonth(),a.getDate())},fmt:function(a){return""+a.getFullYear()+"-"+b.pad2(a.getMonth()+1)+"-"+b.pad2(a.getDate())},incr:function(a){return a.setDate(a.getDate()+7)}},day:{span:864e5,start:function(a){return new Date(a.getFullYear(),a.getMonth(),a.getDate())},fmt:function(a){return""+a.getFullYear()+"-"+b.pad2(a.getMonth()+1)+"-"+b.pad2(a.getDate())},incr:function(a){return a.setDate(a.getDate()+1)}},hour:c(60),"30min":c(30),"15min":c(15),"10min":c(10),"5min":c(5),minute:c(1),"30sec":d(30),"15sec":d(15),"10sec":d(10),"5sec":d(5),second:d(1)},b.AUTO_LABEL_ORDER=["decade","year","month","week","day","hour","30min","15min","10min","5min","minute","30sec","15sec","10sec","5sec","second"],b.Area=function(c){function d(c){var f;return this instanceof b.Area?(f=a.extend({},e,c),this.cumulative=!f.behaveLikeLine,"auto"===f.fillOpacity&&(f.fillOpacity=f.behaveLikeLine?.8:1),d.__super__.constructor.call(this,f),void 0):new b.Area(c)}var e;return h(d,c),e={fillOpacity:"auto",behaveLikeLine:!1},d.prototype.calcPoints=function(){var a,b,c,d,e,f,g;for(f=this.data,g=[],d=0,e=f.length;e>d;d++)a=f[d],a._x=this.transX(a.x),b=0,a._y=function(){var d,e,f,g;for(f=a.y,g=[],d=0,e=f.length;e>d;d++)c=f[d],this.options.behaveLikeLine?g.push(this.transY(c)):(b+=c||0,g.push(this.transY(b)));return g}.call(this),g.push(a._ymax=Math.max.apply(Math,a._y));return g},d.prototype.drawSeries=function(){var a,b,c,d,e,f,g,h;for(this.seriesPoints=[],b=this.options.behaveLikeLine?function(){f=[];for(var a=0,b=this.options.ykeys.length-1;b>=0?b>=a:a>=b;b>=0?a++:a--)f.push(a);return f}.apply(this):function(){g=[];for(var a=e=this.options.ykeys.length-1;0>=e?0>=a:a>=0;0>=e?a++:a--)g.push(a);return g}.apply(this),h=[],c=0,d=b.length;d>c;c++)a=b[c],this._drawFillFor(a),this._drawLineFor(a),h.push(this._drawPointFor(a));return h},d.prototype._drawFillFor=function(a){var b;return b=this.paths[a],null!==b?(b+="L"+this.transX(this.xmax)+","+this.bottom+"L"+this.transX(this.xmin)+","+this.bottom+"Z",this.drawFilledPath(b,this.fillForSeries(a))):void 0},d.prototype.fillForSeries=function(a){var b;return b=Raphael.rgb2hsl(this.colorFor(this.data[a],a,"line")),Raphael.hsl(b.h,this.options.behaveLikeLine?.9*b.s:.75*b.s,Math.min(.98,this.options.behaveLikeLine?1.2*b.l:1.25*b.l))},d.prototype.drawFilledPath=function(a,b){return this.raphael.path(a).attr("fill",b).attr("fill-opacity",this.options.fillOpacity).attr("stroke","none")},d}(b.Line),b.Bar=function(c){function d(c){return this.onHoverOut=f(this.onHoverOut,this),this.onHoverMove=f(this.onHoverMove,this),this.onGridClick=f(this.onGridClick,this),this instanceof b.Bar?(d.__super__.constructor.call(this,a.extend({},c,{parseTime:!1})),void 0):new b.Bar(c)}return h(d,c),d.prototype.init=function(){return this.cumulative=this.options.stacked,"always"!==this.options.hideHover?(this.hover=new b.Hover({parent:this.el}),this.on("hovermove",this.onHoverMove),this.on("hoverout",this.onHoverOut),this.on("gridclick",this.onGridClick)):void 0},d.prototype.defaults={barSizeRatio:.75,barGap:3,barColors:["#0b62a4","#7a92a3","#4da74d","#afd8f8","#edc240","#cb4b4b","#9440ed"],barOpacity:1,barRadius:[0,0,0,0],xLabelMargin:50},d.prototype.calc=function(){var a;return this.calcBars(),this.options.hideHover===!1?(a=this.hover).update.apply(a,this.hoverContentForRow(this.data.length-1)):void 0},d.prototype.calcBars=function(){var a,b,c,d,e,f,g;for(f=this.data,g=[],a=d=0,e=f.length;e>d;a=++d)b=f[a],b._x=this.left+this.width*(a+.5)/this.data.length,g.push(b._y=function(){var a,d,e,f;for(e=b.y,f=[],a=0,d=e.length;d>a;a++)c=e[a],null!=c?f.push(this.transY(c)):f.push(null);return f}.call(this));return g},d.prototype.draw=function(){var a;return((a=this.options.axes)===!0||"both"===a||"x"===a)&&this.drawXAxis(),this.drawSeries()},d.prototype.drawXAxis=function(){var a,b,c,d,e,f,g,h,i,j,k,l,m;for(j=this.bottom+(this.options.xAxisLabelTopPadding||this.options.padding/2),g=null,f=null,m=[],a=k=0,l=this.data.length;l>=0?l>k:k>l;a=l>=0?++k:--k)h=this.data[this.data.length-1-a],b=this.drawXAxisLabel(h._x,j,h.label),i=b.getBBox(),b.transform("r"+-this.options.xLabelAngle),c=b.getBBox(),b.transform("t0,"+c.height/2+"..."),0!==this.options.xLabelAngle&&(e=-.5*i.width*Math.cos(this.options.xLabelAngle*Math.PI/180),b.transform("t"+e+",0...")),(null==g||g>=c.x+c.width||null!=f&&f>=c.x)&&c.x>=0&&c.x+c.width<this.el.width()?(0!==this.options.xLabelAngle&&(d=1.25*this.options.gridTextSize/Math.sin(this.options.xLabelAngle*Math.PI/180),f=c.x-d),m.push(g=c.x-this.options.xLabelMargin)):m.push(b.remove());return m},d.prototype.drawSeries=function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o;return c=this.width/this.options.data.length,h=this.options.stacked?1:this.options.ykeys.length,a=(c*this.options.barSizeRatio-this.options.barGap*(h-1))/h,this.options.barSize&&(a=Math.min(a,this.options.barSize)),l=c-a*h-this.options.barGap*(h-1),g=l/2,o=this.ymin<=0&&this.ymax>=0?this.transY(0):null,this.bars=function(){var h,l,p,q;for(p=this.data,q=[],d=h=0,l=p.length;l>h;d=++h)i=p[d],e=0,q.push(function(){var h,l,p,q;for(p=i._y,q=[],j=h=0,l=p.length;l>h;j=++h)n=p[j],null!==n?(o?(m=Math.min(n,o),b=Math.max(n,o)):(m=n,b=this.bottom),f=this.left+d*c+g,this.options.stacked||(f+=j*(a+this.options.barGap)),k=b-m,this.options.verticalGridCondition&&this.options.verticalGridCondition(i.x)&&this.drawBar(this.left+d*c,this.top,c,Math.abs(this.top-this.bottom),this.options.verticalGridColor,this.options.verticalGridOpacity,this.options.barRadius),this.options.stacked&&(m-=e),this.drawBar(f,m,a,k,this.colorFor(i,j,"bar"),this.options.barOpacity,this.options.barRadius),q.push(e+=k)):q.push(null);return q}.call(this));return q}.call(this)},d.prototype.colorFor=function(a,b,c){var d,e;return"function"==typeof this.options.barColors?(d={x:a.x,y:a.y[b],label:a.label},e={index:b,key:this.options.ykeys[b],label:this.options.labels[b]},this.options.barColors.call(this,d,e,c)):this.options.barColors[b%this.options.barColors.length]},d.prototype.hitTest=function(a){return 0===this.data.length?null:(a=Math.max(Math.min(a,this.right),this.left),Math.min(this.data.length-1,Math.floor((a-this.left)/(this.width/this.data.length))))},d.prototype.onGridClick=function(a,b){var c;return c=this.hitTest(a),this.fire("click",c,this.data[c].src,a,b)},d.prototype.onHoverMove=function(a){var b,c;return b=this.hitTest(a),(c=this.hover).update.apply(c,this.hoverContentForRow(b))},d.prototype.onHoverOut=function(){return this.options.hideHover!==!1?this.hover.hide():void 0},d.prototype.hoverContentForRow=function(a){var b,c,d,e,f,g,h,i;for(d=this.data[a],b="<div class='morris-hover-row-label'>"+d.label+"</div>",i=d.y,c=g=0,h=i.length;h>g;c=++g)f=i[c],b+="<div class='morris-hover-point' style='color: "+this.colorFor(d,c,"label")+"'>\n  "+this.options.labels[c]+":\n  "+this.yLabelFormat(f)+"\n</div>";return"function"==typeof this.options.hoverCallback&&(b=this.options.hoverCallback(a,this.options,b,d.src)),e=this.left+(a+.5)*this.width/this.data.length,[b,e]},d.prototype.drawXAxisLabel=function(a,b,c){var d;return d=this.raphael.text(a,b,c).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor)},d.prototype.drawBar=function(a,b,c,d,e,f,g){var h,i;return h=Math.max.apply(Math,g),i=0===h||h>d?this.raphael.rect(a,b,c,d):this.raphael.path(this.roundedRect(a,b,c,d,g)),i.attr("fill",e).attr("fill-opacity",f).attr("stroke","none")},d.prototype.roundedRect=function(a,b,c,d,e){return null==e&&(e=[0,0,0,0]),["M",a,e[0]+b,"Q",a,b,a+e[0],b,"L",a+c-e[1],b,"Q",a+c,b,a+c,b+e[1],"L",a+c,b+d-e[2],"Q",a+c,b+d,a+c-e[2],b+d,"L",a+e[3],b+d,"Q",a,b+d,a,b+d-e[3],"Z"]},d}(b.Grid),b.Donut=function(c){function d(c){this.resizeHandler=f(this.resizeHandler,this),this.select=f(this.select,this),this.click=f(this.click,this);var d=this;if(!(this instanceof b.Donut))return new b.Donut(c);if(this.options=a.extend({},this.defaults,c),this.el="string"==typeof c.element?a(document.getElementById(c.element)):a(c.element),null===this.el||0===this.el.length)throw new Error("Graph placeholder not found.");void 0!==c.data&&0!==c.data.length&&(this.raphael=new Raphael(this.el[0]),this.options.resize&&a(window).bind("resize",function(){return null!=d.timeoutId&&window.clearTimeout(d.timeoutId),d.timeoutId=window.setTimeout(d.resizeHandler,100)}),this.setData(c.data))}return h(d,c),d.prototype.defaults={colors:["#0B62A4","#3980B5","#679DC6","#95BBD7","#B0CCE1","#095791","#095085","#083E67","#052C48","#042135"],backgroundColor:"#FFFFFF",labelColor:"#000000",formatter:b.commas,resize:!1},d.prototype.redraw=function(){var a,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x;for(this.raphael.clear(),c=this.el.width()/2,d=this.el.height()/2,n=(Math.min(c,d)-10)/3,l=0,u=this.values,o=0,r=u.length;r>o;o++)m=u[o],l+=m;for(i=5/(2*n),a=1.9999*Math.PI-i*this.data.length,g=0,f=0,this.segments=[],v=this.values,e=p=0,s=v.length;s>p;e=++p)m=v[e],j=g+i+a*(m/l),k=new b.DonutSegment(c,d,2*n,n,g,j,this.data[e].color||this.options.colors[f%this.options.colors.length],this.options.backgroundColor,f,this.raphael),k.render(),this.segments.push(k),k.on("hover",this.select),k.on("click",this.click),g=j,f+=1;for(this.text1=this.drawEmptyDonutLabel(c,d-10,this.options.labelColor,15,800),this.text2=this.drawEmptyDonutLabel(c,d+10,this.options.labelColor,14),h=Math.max.apply(Math,this.values),f=0,w=this.values,x=[],q=0,t=w.length;t>q;q++){if(m=w[q],m===h){this.select(f);
break}x.push(f+=1)}return x},d.prototype.setData=function(a){var b;return this.data=a,this.values=function(){var a,c,d,e;for(d=this.data,e=[],a=0,c=d.length;c>a;a++)b=d[a],e.push(parseFloat(b.value));return e}.call(this),this.redraw()},d.prototype.click=function(a){return this.fire("click",a,this.data[a])},d.prototype.select=function(a){var b,c,d,e,f,g;for(g=this.segments,e=0,f=g.length;f>e;e++)c=g[e],c.deselect();return d=this.segments[a],d.select(),b=this.data[a],this.setLabels(b.label,this.options.formatter(b.value,b))},d.prototype.setLabels=function(a,b){var c,d,e,f,g,h,i,j;return c=2*(Math.min(this.el.width()/2,this.el.height()/2)-10)/3,f=1.8*c,e=c/2,d=c/3,this.text1.attr({text:a,transform:""}),g=this.text1.getBBox(),h=Math.min(f/g.width,e/g.height),this.text1.attr({transform:"S"+h+","+h+","+(g.x+g.width/2)+","+(g.y+g.height)}),this.text2.attr({text:b,transform:""}),i=this.text2.getBBox(),j=Math.min(f/i.width,d/i.height),this.text2.attr({transform:"S"+j+","+j+","+(i.x+i.width/2)+","+i.y})},d.prototype.drawEmptyDonutLabel=function(a,b,c,d,e){var f;return f=this.raphael.text(a,b,"").attr("font-size",d).attr("fill",c),null!=e&&f.attr("font-weight",e),f},d.prototype.resizeHandler=function(){return this.timeoutId=null,this.raphael.setSize(this.el.width(),this.el.height()),this.redraw()},d}(b.EventEmitter),b.DonutSegment=function(a){function b(a,b,c,d,e,g,h,i,j,k){this.cx=a,this.cy=b,this.inner=c,this.outer=d,this.color=h,this.backgroundColor=i,this.index=j,this.raphael=k,this.deselect=f(this.deselect,this),this.select=f(this.select,this),this.sin_p0=Math.sin(e),this.cos_p0=Math.cos(e),this.sin_p1=Math.sin(g),this.cos_p1=Math.cos(g),this.is_long=g-e>Math.PI?1:0,this.path=this.calcSegment(this.inner+3,this.inner+this.outer-5),this.selectedPath=this.calcSegment(this.inner+3,this.inner+this.outer),this.hilight=this.calcArc(this.inner)}return h(b,a),b.prototype.calcArcPoints=function(a){return[this.cx+a*this.sin_p0,this.cy+a*this.cos_p0,this.cx+a*this.sin_p1,this.cy+a*this.cos_p1]},b.prototype.calcSegment=function(a,b){var c,d,e,f,g,h,i,j,k,l;return k=this.calcArcPoints(a),c=k[0],e=k[1],d=k[2],f=k[3],l=this.calcArcPoints(b),g=l[0],i=l[1],h=l[2],j=l[3],"M"+c+","+e+("A"+a+","+a+",0,"+this.is_long+",0,"+d+","+f)+("L"+h+","+j)+("A"+b+","+b+",0,"+this.is_long+",1,"+g+","+i)+"Z"},b.prototype.calcArc=function(a){var b,c,d,e,f;return f=this.calcArcPoints(a),b=f[0],d=f[1],c=f[2],e=f[3],"M"+b+","+d+("A"+a+","+a+",0,"+this.is_long+",0,"+c+","+e)},b.prototype.render=function(){var a=this;return this.arc=this.drawDonutArc(this.hilight,this.color),this.seg=this.drawDonutSegment(this.path,this.color,this.backgroundColor,function(){return a.fire("hover",a.index)},function(){return a.fire("click",a.index)})},b.prototype.drawDonutArc=function(a,b){return this.raphael.path(a).attr({stroke:b,"stroke-width":2,opacity:0})},b.prototype.drawDonutSegment=function(a,b,c,d,e){return this.raphael.path(a).attr({fill:b,stroke:c,"stroke-width":3}).hover(d).click(e)},b.prototype.select=function(){return this.selected?void 0:(this.seg.animate({path:this.selectedPath},150,"<>"),this.arc.animate({opacity:1},150,"<>"),this.selected=!0)},b.prototype.deselect=function(){return this.selected?(this.seg.animate({path:this.path},150,"<>"),this.arc.animate({opacity:0},150,"<>"),this.selected=!1):void 0},b}(b.EventEmitter)}).call(this);
/*!
 * ClockPicker v0.0.7 (http://weareoutman.github.io/clockpicker/)
 * Copyright 2014 Wang Shenwei.
 * Licensed under MIT (https://github.com/weareoutman/clockpicker/blob/master/LICENSE)
 */
!function(){function t(t){return document.createElementNS(a,t)}function i(t){return(10>t?"0":"")+t}function e(t){var i=++v+"";return t?t+i:i}function s(s,n){function a(t,i){var e=h.offset(),s=/^touch/.test(t.type),c=e.left+m,a=e.top+m,l=(s?t.originalEvent.touches[0]:t).pageX-c,u=(s?t.originalEvent.touches[0]:t).pageY-a,f=Math.sqrt(l*l+u*u),v=!1;if(!i||!(g-w>f||f>g+w)){t.preventDefault();var b=setTimeout(function(){o.addClass("clockpicker-moving")},200);p&&h.append(H.canvas),H.setHand(l,u,!i,!0),r.off(k).on(k,function(t){t.preventDefault();var i=/^touch/.test(t.type),e=(i?t.originalEvent.touches[0]:t).pageX-c,s=(i?t.originalEvent.touches[0]:t).pageY-a;(v||e!==l||s!==u)&&(v=!0,H.setHand(e,s,!1,!0))}),r.off(d).on(d,function(t){r.off(d),t.preventDefault();var e=/^touch/.test(t.type),s=(e?t.originalEvent.changedTouches[0]:t).pageX-c,p=(e?t.originalEvent.changedTouches[0]:t).pageY-a;(i||v)&&s===l&&p===u&&H.setHand(s,p),"hours"===H.currentView?H.toggleView("minutes",M/2):n.autoclose&&(H.minutesView.addClass("clockpicker-dial-out"),setTimeout(function(){H.done()},M/2)),h.prepend(O),clearTimeout(b),o.removeClass("clockpicker-moving"),r.off(k)})}}var l=c(A),h=l.find(".clockpicker-plate"),f=l.find(".clockpicker-hours"),v=l.find(".clockpicker-minutes"),T=l.find(".clockpicker-am-pm-block"),V="INPUT"===s.prop("tagName"),C=V?s:s.find("input"),P=s.find(".input-group-addon"),H=this;if(this.id=e("cp"),this.element=s,this.options=n,this.isAppended=!1,this.isShown=!1,this.currentView="hours",this.isInput=V,this.input=C,this.addon=P,this.popover=l,this.plate=h,this.hoursView=f,this.minutesView=v,this.amPmBlock=T,this.spanHours=l.find(".clockpicker-span-hours"),this.spanMinutes=l.find(".clockpicker-span-minutes"),this.spanAmPm=l.find(".clockpicker-span-am-pm"),this.amOrPm="PM",n.twelvehour){{var x=['<div class="clockpicker-am-pm-block">','<button type="button" class="btn btn-sm btn-default clockpicker-button clockpicker-am-button">',"AM</button>",'<button type="button" class="btn btn-sm btn-default clockpicker-button clockpicker-pm-button">',"PM</button>","</div>"].join("");c(x)}c('<button type="button" class="btn btn-sm btn-default clockpicker-button am-button">AM</button>').on("click",function(){H.amOrPm="AM",c(".clockpicker-span-am-pm").empty().append("AM")}).appendTo(this.amPmBlock),c('<button type="button" class="btn btn-sm btn-default clockpicker-button pm-button">PM</button>').on("click",function(){H.amOrPm="PM",c(".clockpicker-span-am-pm").empty().append("PM")}).appendTo(this.amPmBlock)}n.autoclose||c('<button type="button" class="btn btn-sm btn-default btn-block clockpicker-button">'+n.donetext+"</button>").click(c.proxy(this.done,this)).appendTo(l),"top"!==n.placement&&"bottom"!==n.placement||"top"!==n.align&&"bottom"!==n.align||(n.align="left"),"left"!==n.placement&&"right"!==n.placement||"left"!==n.align&&"right"!==n.align||(n.align="top"),l.addClass(n.placement),l.addClass("clockpicker-align-"+n.align),this.spanHours.click(c.proxy(this.toggleView,this,"hours")),this.spanMinutes.click(c.proxy(this.toggleView,this,"minutes")),C.on("focus.clockpicker click.clockpicker",c.proxy(this.show,this)),P.on("click.clockpicker",c.proxy(this.toggle,this));var E,S,I,D=c('<div class="clockpicker-tick"></div>');if(n.twelvehour)for(E=1;13>E;E+=1){S=D.clone(),I=E/6*Math.PI;var B=g;S.css("font-size","120%"),S.css({left:m+Math.sin(I)*B-w,top:m-Math.cos(I)*B-w}),S.html(0===E?"00":E),f.append(S),S.on(u,a)}else for(E=0;24>E;E+=1){S=D.clone(),I=E/6*Math.PI;var z=E>0&&13>E,B=z?b:g;S.css({left:m+Math.sin(I)*B-w,top:m-Math.cos(I)*B-w}),z&&S.css("font-size","120%"),S.html(0===E?"00":E),f.append(S),S.on(u,a)}for(E=0;60>E;E+=5)S=D.clone(),I=E/30*Math.PI,S.css({left:m+Math.sin(I)*g-w,top:m-Math.cos(I)*g-w}),S.css("font-size","120%"),S.html(i(E)),v.append(S),S.on(u,a);if(h.on(u,function(t){0===c(t.target).closest(".clockpicker-tick").length&&a(t,!0)}),p){var O=l.find(".clockpicker-canvas"),j=t("svg");j.setAttribute("class","clockpicker-svg"),j.setAttribute("width",y),j.setAttribute("height",y);var L=t("g");L.setAttribute("transform","translate("+m+","+m+")");var U=t("circle");U.setAttribute("class","clockpicker-canvas-bearing"),U.setAttribute("cx",0),U.setAttribute("cy",0),U.setAttribute("r",2);var W=t("line");W.setAttribute("x1",0),W.setAttribute("y1",0);var N=t("circle");N.setAttribute("class","clockpicker-canvas-bg"),N.setAttribute("r",w);var X=t("circle");X.setAttribute("class","clockpicker-canvas-fg"),X.setAttribute("r",3.5),L.appendChild(W),L.appendChild(N),L.appendChild(X),L.appendChild(U),j.appendChild(L),O.append(j),this.hand=W,this.bg=N,this.fg=X,this.bearing=U,this.g=L,this.canvas=O}}var o,c=window.jQuery,n=c(window),r=c(document),a="http://www.w3.org/2000/svg",p="SVGAngle"in window&&function(){var t,i=document.createElement("div");return i.innerHTML="<svg/>",t=(i.firstChild&&i.firstChild.namespaceURI)==a,i.innerHTML="",t}(),l=function(){var t=document.createElement("div").style;return"transition"in t||"WebkitTransition"in t||"MozTransition"in t||"msTransition"in t||"OTransition"in t}(),h="ontouchstart"in window,u="mousedown"+(h?" touchstart":""),k="mousemove.clockpicker"+(h?" touchmove.clockpicker":""),d="mouseup.clockpicker"+(h?" touchend.clockpicker":""),f=navigator.vibrate?"vibrate":navigator.webkitVibrate?"webkitVibrate":null,v=0,m=100,g=80,b=54,w=13,y=2*m,M=l?350:1,A=['<div class="popover clockpicker-popover">','<div class="arrow"></div>','<div class="popover-title">','<span class="clockpicker-span-hours text-primary"></span>'," : ",'<span class="clockpicker-span-minutes"></span>','<span class="clockpicker-span-am-pm"></span>',"</div>",'<div class="popover-content">','<div class="clockpicker-plate">','<div class="clockpicker-canvas"></div>','<div class="clockpicker-dial clockpicker-hours"></div>','<div class="clockpicker-dial clockpicker-minutes clockpicker-dial-out"></div>',"</div>",'<span class="clockpicker-am-pm-block">',"</span>","</div>","</div>"].join("");s.DEFAULTS={"default":"",fromnow:0,placement:"bottom",align:"left",donetext:"完成",autoclose:!1,twelvehour:!1,vibrate:!0},s.prototype.toggle=function(){this[this.isShown?"hide":"show"]()},s.prototype.locate=function(){var t=this.element,i=this.popover,e=t.offset(),s=t.outerWidth(),o=t.outerHeight(),c=this.options.placement,n=this.options.align,r={};switch(i.show(),c){case"bottom":r.top=e.top+o;break;case"right":r.left=e.left+s;break;case"top":r.top=e.top-i.outerHeight();break;case"left":r.left=e.left-i.outerWidth()}switch(n){case"left":r.left=e.left;break;case"right":r.left=e.left+s-i.outerWidth();break;case"top":r.top=e.top;break;case"bottom":r.top=e.top+o-i.outerHeight()}i.css(r)},s.prototype.show=function(){if(!this.isShown){var t=this;this.isAppended||(o=c(document.body).append(this.popover),n.on("resize.clockpicker"+this.id,function(){t.isShown&&t.locate()}),this.isAppended=!0);var e=((this.input.prop("value")||this.options["default"]||"")+"").split(":");if("now"===e[0]){var s=new Date(+new Date+this.options.fromnow);e=[s.getHours(),s.getMinutes()]}this.hours=+e[0]||0,this.minutes=+e[1]||0,this.spanHours.html(i(this.hours)),this.spanMinutes.html(i(this.minutes)),this.toggleView("hours"),this.locate(),this.isShown=!0,r.on("click.clockpicker."+this.id+" focusin.clockpicker."+this.id,function(i){var e=c(i.target);0===e.closest(t.popover).length&&0===e.closest(t.addon).length&&0===e.closest(t.input).length&&t.hide()}),r.on("keyup.clockpicker."+this.id,function(i){27===i.keyCode&&t.hide()})}},s.prototype.hide=function(){this.isShown=!1,r.off("click.clockpicker."+this.id+" focusin.clockpicker."+this.id),r.off("keyup.clockpicker."+this.id),this.popover.hide()},s.prototype.toggleView=function(t,i){var e="hours"===t,s=e?this.hoursView:this.minutesView,o=e?this.minutesView:this.hoursView;this.currentView=t,this.spanHours.toggleClass("text-primary",e),this.spanMinutes.toggleClass("text-primary",!e),o.addClass("clockpicker-dial-out"),s.css("visibility","visible").removeClass("clockpicker-dial-out"),this.resetClock(i),clearTimeout(this.toggleViewTimer),this.toggleViewTimer=setTimeout(function(){o.css("visibility","hidden")},M)},s.prototype.resetClock=function(t){var i=this.currentView,e=this[i],s="hours"===i,o=Math.PI/(s?6:30),c=e*o,n=s&&e>0&&13>e?b:g,r=Math.sin(c)*n,a=-Math.cos(c)*n,l=this;p&&t?(l.canvas.addClass("clockpicker-canvas-out"),setTimeout(function(){l.canvas.removeClass("clockpicker-canvas-out"),l.setHand(r,a)},t)):this.setHand(r,a)},s.prototype.setHand=function(t,e,s,o){var n,r=Math.atan2(t,-e),a="hours"===this.currentView,l=Math.PI/(a||s?6:30),h=Math.sqrt(t*t+e*e),u=this.options,k=a&&(g+b)/2>h,d=k?b:g;if(u.twelvehour&&(d=g),0>r&&(r=2*Math.PI+r),n=Math.round(r/l),r=n*l,u.twelvehour?a?0===n&&(n=12):(s&&(n*=5),60===n&&(n=0)):a?(12===n&&(n=0),n=k?0===n?12:n:0===n?0:n+12):(s&&(n*=5),60===n&&(n=0)),this[this.currentView]!==n&&f&&this.options.vibrate&&(this.vibrateTimer||(navigator[f](10),this.vibrateTimer=setTimeout(c.proxy(function(){this.vibrateTimer=null},this),100))),this[this.currentView]=n,this[a?"spanHours":"spanMinutes"].html(i(n)),!p)return void this[a?"hoursView":"minutesView"].find(".clockpicker-tick").each(function(){var t=c(this);t.toggleClass("active",n===+t.html())});o||!a&&n%5?(this.g.insertBefore(this.hand,this.bearing),this.g.insertBefore(this.bg,this.fg),this.bg.setAttribute("class","clockpicker-canvas-bg clockpicker-canvas-bg-trans")):(this.g.insertBefore(this.hand,this.bg),this.g.insertBefore(this.fg,this.bg),this.bg.setAttribute("class","clockpicker-canvas-bg"));var v=Math.sin(r)*d,m=-Math.cos(r)*d;this.hand.setAttribute("x2",v),this.hand.setAttribute("y2",m),this.bg.setAttribute("cx",v),this.bg.setAttribute("cy",m),this.fg.setAttribute("cx",v),this.fg.setAttribute("cy",m)},s.prototype.done=function(){this.hide();var t=this.input.prop("value"),e=i(this.hours)+":"+i(this.minutes);this.options.twelvehour&&(e+=this.amOrPm),this.input.prop("value",e),e!==t&&(this.input.triggerHandler("change"),this.isInput||this.element.trigger("change")),this.options.autoclose&&this.input.trigger("blur")},s.prototype.remove=function(){this.element.removeData("clockpicker"),this.input.off("focus.clockpicker click.clockpicker"),this.addon.off("click.clockpicker"),this.isShown&&this.hide(),this.isAppended&&(n.off("resize.clockpicker"+this.id),this.popover.remove())},c.fn.clockpicker=function(t){var i=Array.prototype.slice.call(arguments,1);return this.each(function(){var e=c(this),o=e.data("clockpicker");if(o)"function"==typeof o[t]&&o[t].apply(o,i);else{var n=c.extend({},s.DEFAULTS,e.data(),"object"==typeof t&&t);e.data("clockpicker",new s(e,n))}})}}();
/*
 * jwerty - Awesome handling of keyboard events
 *
 * jwerty is a JS lib which allows you to bind, fire and assert key combination
 * strings against elements and events. It normalises the poor std api into
 * something easy to use and clear.
 *
 * This code is licensed under the MIT
 * For the full license see: http://keithamus.mit-license.org/
 * For more information see: http://keithamus.github.com/jwerty
 *
 * @author Keith Cirkel ('keithamus') <jwerty@keithcirkel.co.uk>
 * @license http://keithamus.mit-license.org/
 * @copyright Copyright © 2011, Keith Cirkel
 *
 */
(function (global, exports) {
    
    // Helper methods & vars:
    var $d = global.document
    ,   $ = (global.jQuery || global.Zepto || global.ender || $d)
    ,   $$
    ,   $b
    ,   ke = 'keydown';
    
    function realTypeOf(v, s) {
        return (v === null) ? s === 'null'
        : (v === undefined) ? s === 'undefined'
        : (v.is && v instanceof $) ? s === 'element'
        : Object.prototype.toString.call(v).toLowerCase().indexOf(s) > 7;
    }
    
    if ($ === $d) {
        $$ = function (selector, context) {
            return selector ? $.querySelector(selector, context || $) : $;
        };
        
        $b = function (e, fn) { e.addEventListener(ke, fn, false); };
        $f = function (e, jwertyEv) {
            var ret = document.createEvent('Event')
            ,   i;
            
            ret.initEvent(ke, true, true);
            
            for (i in jwertyEv) ret[i] = jwertyEv[i];
            
            return (e || $).dispatchEvent(ret);
        }
    } else {
        $$ = function (selector, context, fn) { return $(selector || $d, context); };
        $b = function (e, fn) { $(e).bind(ke + '.jwerty', fn); };
        $f = function (e, ob) { $(e || $d).trigger($.Event(ke, ob)); };
    }
    
    // Private
    var _modProps = { 16: 'shiftKey', 17: 'ctrlKey', 18: 'altKey', 91: 'metaKey' };
    
    // Generate key mappings for common keys that are not printable.
    var _keys = {
        
        // MOD aka toggleable keys
        mods: {
            // Shift key, ⇧
            '⇧': 16, shift: 16,
            // CTRL key, on Mac: ⌃
            '⌃': 17, ctrl: 17,
            // ALT key, on Mac: ⌥ (Alt)
            '⌥': 18, alt: 18, option: 18,
            // META, on Mac: ⌘ (CMD), on Windows (Win), on Linux (Super)
            '⌘': 91, meta: 91, cmd: 91, 'super': 91, win: 91
        },
        
        // Normal keys
        keys: {
            // Backspace key, on Mac: ⌫ (Backspace)
            '⌫': 8, backspace: 8,
            // Tab Key, on Mac: ⇥ (Tab), on Windows ⇥⇥
            '⇥': 9, '⇆': 9, tab: 9,
            // Return key, ↩
            '↩': 13, 'return': 13, enter: 13, '⌅': 13,
            // Pause/Break key
            'pause': 19, 'pause-break': 19,
            // Caps Lock key, ⇪
            '⇪': 20, caps: 20, 'caps-lock': 20,
            // Escape key, on Mac: ⎋, on Windows: Esc
            '⎋': 27, escape: 27, esc: 27,
            // Space key
            space: 32,
            // Page-Up key, or pgup, on Mac: ↖
            '↖': 33, pgup: 33, 'page-up': 33,
            // Page-Down key, or pgdown, on Mac: ↘
            '↘': 34, pgdown: 34, 'page-down': 34,
            // END key, on Mac: ⇟
            '⇟': 35, end: 35,
            // HOME key, on Mac: ⇞
            '⇞': 36, home: 36,
            // Insert key, or ins
            ins: 45, insert: 45,
            // Delete key, on Mac: ⌫ (Delete)
            del: 46, 'delete': 46,
            
            // Left Arrow Key, or ←
            '←': 37, left: 37, 'arrow-left': 37,
            // Up Arrow Key, or ↑
            '↑': 38, up: 38, 'arrow-up': 38,
            // Right Arrow Key, or →
            '→': 39, right: 39, 'arrow-right': 39,
            // Up Arrow Key, or ↓
            '↓': 40, down: 40, 'arrow-down': 40,
            
            // odities, printing characters that come out wrong:
            // Num-Multiply, or *
            '*': 106, star: 106, asterisk: 106, multiply: 106,
            // Num-Plus or +
            '+': 107, 'plus': 107,
            // Num-Subtract, or -
            '-': 109, subtract: 109,
            // Semicolon
            ';': 186, semicolon:186,
            // = or equals
            '=': 187, 'equals': 187,
            // Comma, or ,
            ',': 188, comma: 188,
            //'-': 189, //???
            // Period, or ., or full-stop
            '.': 190, period: 190, 'full-stop': 190,
            // Slash, or /, or forward-slash
            '/': 191, slash: 191, 'forward-slash': 191,
            // Tick, or `, or back-quote 
            '`': 192, tick: 192, 'back-quote': 192,
            // Open bracket, or [
            '[': 219, 'open-bracket': 219,
            // Back slash, or \
            '\\': 220, 'back-slash': 220,
            // Close backet, or ]
            ']': 221, 'close-bracket': 221,
            // Apostraphe, or Quote, or '
            '\'': 222, quote: 222, apostraphe: 222
        }
        
    };
    
    // To minimise code bloat, add all of the NUMPAD 0-9 keys in a loop
    i = 95, n = 0;
    while(++i < 106) {
        _keys.keys['num-' + n] = i;
        ++n;
    }
    
    // To minimise code bloat, add all of the top row 0-9 keys in a loop
    i = 47, n = 0;
    while(++i < 58) {
        _keys.keys[n] = i;
        ++n;
    }
    
    // To minimise code bloat, add all of the F1-F25 keys in a loop
    i = 111, n = 1;
    while(++i < 136) {
        _keys.keys['f' + n] = i;
        ++n;
    }
    
    // To minimise code bloat, add all of the letters of the alphabet in a loop
    var i = 64;
    while(++i < 91) {
        _keys.keys[String.fromCharCode(i).toLowerCase()] = i;
    }
    
    function JwertyCode(jwertyCode) {
        var i
        ,   c
        ,   n
        ,   z
        ,   keyCombo
        ,   optionals
        ,   jwertyCodeFragment
        ,   rangeMatches
        ,   rangeI;
        
        // In-case we get called with an instance of ourselves, just return that.
        if (jwertyCode instanceof JwertyCode) return jwertyCode;
        
        // If jwertyCode isn't an array, cast it as a string and split into array.
        if (!realTypeOf(jwertyCode, 'array')) {
            jwertyCode = (String(jwertyCode)).replace(/\s/g, '').toLowerCase().
                match(/(?:\+,|[^,])+/g);
        }
        
        // Loop through each key sequence in jwertyCode
        for (i = 0, c = jwertyCode.length; i < c; ++i) {
            
            // If the key combo at this part of the sequence isn't an array,
            // cast as a string and split into an array.
            if (!realTypeOf(jwertyCode[i], 'array')) {
                jwertyCode[i] = String(jwertyCode[i])
                    .match(/(?:\+\/|[^\/])+/g);
            }
            
            // Parse the key optionals in this sequence
            optionals = [], n = jwertyCode[i].length;
            while (n--) {
                
                // Begin creating the object for this key combo
                var jwertyCodeFragment = jwertyCode[i][n];
                
                keyCombo = {
                    jwertyCombo: String(jwertyCodeFragment),
                    shiftKey: false,
                    ctrlKey: false,
                    altKey: false,
                    metaKey: false
                }
                
                // If jwertyCodeFragment isn't an array then cast as a string
                // and split it into one.
                if (!realTypeOf(jwertyCodeFragment, 'array')) {
                    jwertyCodeFragment = String(jwertyCodeFragment).toLowerCase()
                        .match(/(?:(?:[^\+])+|\+\+|^\+$)/g);
                }
                
                z = jwertyCodeFragment.length;
                while (z--) {
                    
                    // Normalise matching errors
                    if (jwertyCodeFragment[z] === '++') jwertyCodeFragment[z] = '+';
                    
                    // Inject either keyCode or ctrl/meta/shift/altKey into keyCombo
                    if (jwertyCodeFragment[z] in _keys.mods) {
                        keyCombo[_modProps[_keys.mods[jwertyCodeFragment[z]]]] = true;
                    } else if(jwertyCodeFragment[z] in _keys.keys) {
                        keyCombo.keyCode = _keys.keys[jwertyCodeFragment[z]];
                    } else {
                        rangeMatches = jwertyCodeFragment[z].match(/^\[([^-]+\-?[^-]*)-([^-]+\-?[^-]*)\]$/);
                    }
                }
                if (realTypeOf(keyCombo.keyCode, 'undefined')) {
                    // If we picked up a range match earlier...
                    if (rangeMatches && (rangeMatches[1] in _keys.keys) && (rangeMatches[2] in _keys.keys)) {
                        rangeMatches[2] = _keys.keys[rangeMatches[2]];
                        rangeMatches[1] = _keys.keys[rangeMatches[1]];
                        
                        // Go from match 1 and capture all key-comobs up to match 2
                        for (rangeI = rangeMatches[1]; rangeI < rangeMatches[2]; ++rangeI) {
                            optionals.push({
                                altKey: keyCombo.altKey,
                                shiftKey: keyCombo.shiftKey,
                                metaKey: keyCombo.metaKey,
                                ctrlKey: keyCombo.ctrlKey,
                                keyCode: rangeI,
                                jwertyCombo: String(jwertyCodeFragment)
                            });
                            
                        }
                        keyCombo.keyCode = rangeI;
                    // Inject either keyCode or ctrl/meta/shift/altKey into keyCombo
                    } else {
                        keyCombo.keyCode = 0;
                    }
                }
                optionals.push(keyCombo);
            
            }
            this[i] = optionals;
        }
        this.length = i;
        return this;
    }
    
    var jwerty = exports.jwerty = {        
        /**
         * jwerty.event
         *
         * `jwerty.event` will return a function, which expects the first
         *  argument to be a key event. When the key event matches `jwertyCode`,
         *  `callbackFunction` is fired. `jwerty.event` is used by `jwerty.key`
         *  to bind the function it returns. `jwerty.event` is useful for
         *  attaching to your own event listeners. It can be used as a decorator
         *  method to encapsulate functionality that you only want to fire after
         *  a specific key combo. If `callbackContext` is specified then it will
         *  be supplied as `callbackFunction`'s context - in other words, the
         *  keyword `this` will be set to `callbackContext` inside the
         *  `callbackFunction` function.
         *
         *   @param {Mixed} jwertyCode can be an array, or string of key
         *      combinations, which includes optinals and or sequences
         *   @param {Function} callbackFucntion is a function (or boolean) which
         *      is fired when jwertyCode is matched. Return false to
         *      preventDefault()
         *   @param {Object} callbackContext (Optional) The context to call
         *      `callback` with (i.e this)
         *      
         */
        event: function (jwertyCode, callbackFunction, callbackContext /*? this */) {
            
            // Construct a function out of callbackFunction, if it is a boolean.
            if (realTypeOf(callbackFunction, 'boolean')) {
                var bool = callbackFunction;
                callbackFunction = function () { return bool; }
            }
            
            jwertyCode = new JwertyCode(jwertyCode);
            
            // Initialise in-scope vars.
            var i = 0
            ,   c = jwertyCode.length - 1
            ,   returnValue
            ,   jwertyCodeIs;
            
            // This is the event listener function that gets returned...
            return function (event) {
                
                // if jwertyCodeIs returns truthy (string)...
                if ((jwertyCodeIs = jwerty.is(jwertyCode, event, i))) {
                    // ... and this isn't the last key in the sequence,
                    // incriment the key in sequence to check.
                    if (i < c) {
                        ++i;
                        return;
                    // ... and this is the last in the sequence (or the only
                    // one in sequence), then fire the callback
                    } else {
                        returnValue = callbackFunction.call(
                            callbackContext || this, event, jwertyCodeIs);
                        
                        // If the callback returned false, then we should run
                        // preventDefault();
                        if (returnValue === false) event.preventDefault();
                        
                        // Reset i for the next sequence to fire.
                        i = 0;
                        return;
                    }
                }
                
                // If the event didn't hit this time, we should reset i to 0,
                // that is, unless this combo was the first in the sequence,
                // in which case we should reset i to 1.
                i = jwerty.is(jwertyCode, event) ? 1 : 0;
            }
        },
        
        /**
         * jwerty.is
         *
         * `jwerty.is` will return a boolean value, based on if `event` matches
         *  `jwertyCode`. `jwerty.is` is called by `jwerty.event` to check
         *  whether or not to fire the callback. `event` can be a DOM event, or
         *  a jQuery/Zepto/Ender manufactured event. The properties of
         *  `jwertyCode` (speficially ctrlKey, altKey, metaKey, shiftKey and
         *  keyCode) should match `jwertyCode`'s properties - if they do, then
         *  `jwerty.is` will return `true`. If they don't, `jwerty.is` will
         *  return `false`.
         *
         *   @param {Mixed} jwertyCode can be an array, or string of key
         *      combinations, which includes optinals and or sequences
         *   @param {KeyboardEvent} event is the KeyboardEvent to assert against
         *   @param {Integer} i (Optional) checks the `i` key in jwertyCode
         *      sequence
         *      
         */
        is: function (jwertyCode, event, i /*? 0*/) {
            jwertyCode = new JwertyCode(jwertyCode);
            // Default `i` to 0
            i = i || 0;
            // We are only interesting in `i` of jwertyCode;
            jwertyCode = jwertyCode[i];
            // jQuery stores the *real* event in `originalEvent`, which we use
            // because it does annoything stuff to `metaKey`
            event = event.originalEvent || event;
            
            // We'll look at each optional in this jwertyCode sequence...
            var key
            ,   n = jwertyCode.length
            ,   returnValue = false;
            
            // Loop through each fragment of jwertyCode
            while (n--) {
                returnValue = jwertyCode[n].jwertyCombo;
                // For each property in the jwertyCode object, compare to `event`
                for (var p in jwertyCode[n]) {
                    // ...except for jwertyCode.jwertyCombo...
                    if (p !== 'jwertyCombo' && event[p] != jwertyCode[n][p]) returnValue = false;
                }
                // If this jwertyCode optional wasn't falsey, then we can return early.
                if (returnValue !== false) return returnValue;
            }
            return returnValue;
        },
        
        /**
         * jwerty.key
         *
         *  `jwerty.key` will attach an event listener and fire
         *   `callbackFunction` when `jwertyCode` matches. The event listener is
         *   attached to `document`, meaning it will listen for any key events
         *   on the page (a global shortcut listener). If `callbackContext` is
         *   specified then it will be supplied as `callbackFunction`'s context
         *   - in other words, the keyword `this` will be set to
         *   `callbackContext` inside the `callbackFunction` function.
         *
         *   @param {Mixed} jwertyCode can be an array, or string of key
         *      combinations, which includes optinals and or sequences
         *   @param {Function} callbackFunction is a function (or boolean) which
         *      is fired when jwertyCode is matched. Return false to
         *      preventDefault()
         *   @param {Object} callbackContext (Optional) The context to call
         *      `callback` with (i.e this)
         *   @param {Mixed} selector can be a string, jQuery/Zepto/Ender object,
         *      or an HTML*Element on which to bind the eventListener
         *   @param {Mixed} selectorContext can be a string, jQuery/Zepto/Ender
         *      object, or an HTML*Element on which to scope the selector
         *  
         */
        key: function (jwertyCode, callbackFunction, callbackContext /*? this */, selector /*? document */, selectorContext /*? body */) {
            // Because callbackContext is optional, we should check if the
            // `callbackContext` is a string or element, and if it is, then the
            // function was called without a context, and `callbackContext` is
            // actually `selector`
            var realSelector = realTypeOf(callbackContext, 'element') || realTypeOf(callbackContext, 'string') ? callbackContext : selector
            // If `callbackContext` is undefined, or if we skipped it (and
            // therefore it is `realSelector`), set context to `global`.
            ,   realcallbackContext = realSelector === callbackContext ? global : callbackContext
            // Finally if we did skip `callbackContext`, then shift
            // `selectorContext` to the left (take it from `selector`)
            ,    realSelectorContext = realSelector === callbackContext ? selector : selectorContext;
            
            // If `realSelector` is already a jQuery/Zepto/Ender/DOM element,
            // then just use it neat, otherwise find it in DOM using $$()
            $b(realTypeOf(realSelector, 'element') ?
               realSelector : $$(realSelector, realSelectorContext)
            , jwerty.event(jwertyCode, callbackFunction, realcallbackContext));
        },
        
        /**
         * jwerty.fire
         *
         * `jwerty.fire` will construct a keyup event to fire, based on
         *  `jwertyCode`. The event will be fired against `selector`.
         *  `selectorContext` is used to search for `selector` within
         *  `selectorContext`, similar to jQuery's
         *  `$('selector', 'context')`.
         *
         *   @param {Mixed} jwertyCode can be an array, or string of key
         *      combinations, which includes optinals and or sequences
         *   @param {Mixed} selector can be a string, jQuery/Zepto/Ender object,
         *      or an HTML*Element on which to bind the eventListener
         *   @param {Mixed} selectorContext can be a string, jQuery/Zepto/Ender
         *      object, or an HTML*Element on which to scope the selector
         *  
         */
        fire: function (jwertyCode, selector /*? document */, selectorContext /*? body */, i) {
            jwertyCode = new JwertyCode(jwertyCode);
            var realI = realTypeOf(selectorContext, 'number') ? selectorContext : i;
            
            // If `realSelector` is already a jQuery/Zepto/Ender/DOM element,
            // then just use it neat, otherwise find it in DOM using $$()
            $f(realTypeOf(selector, 'element') ?
                selector : $$(selector, selectorContext)
            , jwertyCode[realI || 0][0]);
        },
        
        KEYS: _keys
    };
    
}(this, (typeof module !== 'undefined' && module.exports ? module.exports : this)));
/*!
 DataTables 1.10.13
 ©2008-2016 SpryMedia Ltd - datatables.net/license
*/
(function(h){"function"===typeof define&&define.amd?define(["jquery"],function(E){return h(E,window,document)}):"object"===typeof exports?module.exports=function(E,H){E||(E=window);H||(H="undefined"!==typeof window?require("jquery"):require("jquery")(E));return h(H,E,E.document)}:h(jQuery,window,document)})(function(h,E,H,k){function Y(a){var b,c,d={};h.each(a,function(e){if((b=e.match(/^([^A-Z]+?)([A-Z])/))&&-1!=="a aa ai ao as b fn i m o s ".indexOf(b[1]+" "))c=e.replace(b[0],b[2].toLowerCase()),
d[c]=e,"o"===b[1]&&Y(a[e])});a._hungarianMap=d}function J(a,b,c){a._hungarianMap||Y(a);var d;h.each(b,function(e){d=a._hungarianMap[e];if(d!==k&&(c||b[d]===k))"o"===d.charAt(0)?(b[d]||(b[d]={}),h.extend(!0,b[d],b[e]),J(a[d],b[d],c)):b[d]=b[e]})}function Fa(a){var b=m.defaults.oLanguage,c=a.sZeroRecords;!a.sEmptyTable&&(c&&"No data available in table"===b.sEmptyTable)&&F(a,a,"sZeroRecords","sEmptyTable");!a.sLoadingRecords&&(c&&"Loading..."===b.sLoadingRecords)&&F(a,a,"sZeroRecords","sLoadingRecords");
a.sInfoThousands&&(a.sThousands=a.sInfoThousands);(a=a.sDecimal)&&fb(a)}function gb(a){A(a,"ordering","bSort");A(a,"orderMulti","bSortMulti");A(a,"orderClasses","bSortClasses");A(a,"orderCellsTop","bSortCellsTop");A(a,"order","aaSorting");A(a,"orderFixed","aaSortingFixed");A(a,"paging","bPaginate");A(a,"pagingType","sPaginationType");A(a,"pageLength","iDisplayLength");A(a,"searching","bFilter");"boolean"===typeof a.sScrollX&&(a.sScrollX=a.sScrollX?"100%":"");"boolean"===typeof a.scrollX&&(a.scrollX=
a.scrollX?"100%":"");if(a=a.aoSearchCols)for(var b=0,c=a.length;b<c;b++)a[b]&&J(m.models.oSearch,a[b])}function hb(a){A(a,"orderable","bSortable");A(a,"orderData","aDataSort");A(a,"orderSequence","asSorting");A(a,"orderDataType","sortDataType");var b=a.aDataSort;b&&!h.isArray(b)&&(a.aDataSort=[b])}function ib(a){if(!m.__browser){var b={};m.__browser=b;var c=h("<div/>").css({position:"fixed",top:0,left:-1*h(E).scrollLeft(),height:1,width:1,overflow:"hidden"}).append(h("<div/>").css({position:"absolute",
top:1,left:1,width:100,overflow:"scroll"}).append(h("<div/>").css({width:"100%",height:10}))).appendTo("body"),d=c.children(),e=d.children();b.barWidth=d[0].offsetWidth-d[0].clientWidth;b.bScrollOversize=100===e[0].offsetWidth&&100!==d[0].clientWidth;b.bScrollbarLeft=1!==Math.round(e.offset().left);b.bBounding=c[0].getBoundingClientRect().width?!0:!1;c.remove()}h.extend(a.oBrowser,m.__browser);a.oScroll.iBarWidth=m.__browser.barWidth}function jb(a,b,c,d,e,f){var g,j=!1;c!==k&&(g=c,j=!0);for(;d!==
e;)a.hasOwnProperty(d)&&(g=j?b(g,a[d],d,a):a[d],j=!0,d+=f);return g}function Ga(a,b){var c=m.defaults.column,d=a.aoColumns.length,c=h.extend({},m.models.oColumn,c,{nTh:b?b:H.createElement("th"),sTitle:c.sTitle?c.sTitle:b?b.innerHTML:"",aDataSort:c.aDataSort?c.aDataSort:[d],mData:c.mData?c.mData:d,idx:d});a.aoColumns.push(c);c=a.aoPreSearchCols;c[d]=h.extend({},m.models.oSearch,c[d]);la(a,d,h(b).data())}function la(a,b,c){var b=a.aoColumns[b],d=a.oClasses,e=h(b.nTh);if(!b.sWidthOrig){b.sWidthOrig=
e.attr("width")||null;var f=(e.attr("style")||"").match(/width:\s*(\d+[pxem%]+)/);f&&(b.sWidthOrig=f[1])}c!==k&&null!==c&&(hb(c),J(m.defaults.column,c),c.mDataProp!==k&&!c.mData&&(c.mData=c.mDataProp),c.sType&&(b._sManualType=c.sType),c.className&&!c.sClass&&(c.sClass=c.className),h.extend(b,c),F(b,c,"sWidth","sWidthOrig"),c.iDataSort!==k&&(b.aDataSort=[c.iDataSort]),F(b,c,"aDataSort"));var g=b.mData,j=R(g),i=b.mRender?R(b.mRender):null,c=function(a){return"string"===typeof a&&-1!==a.indexOf("@")};
b._bAttrSrc=h.isPlainObject(g)&&(c(g.sort)||c(g.type)||c(g.filter));b._setter=null;b.fnGetData=function(a,b,c){var d=j(a,b,k,c);return i&&b?i(d,b,a,c):d};b.fnSetData=function(a,b,c){return S(g)(a,b,c)};"number"!==typeof g&&(a._rowReadObject=!0);a.oFeatures.bSort||(b.bSortable=!1,e.addClass(d.sSortableNone));a=-1!==h.inArray("asc",b.asSorting);c=-1!==h.inArray("desc",b.asSorting);!b.bSortable||!a&&!c?(b.sSortingClass=d.sSortableNone,b.sSortingClassJUI=""):a&&!c?(b.sSortingClass=d.sSortableAsc,b.sSortingClassJUI=
d.sSortJUIAscAllowed):!a&&c?(b.sSortingClass=d.sSortableDesc,b.sSortingClassJUI=d.sSortJUIDescAllowed):(b.sSortingClass=d.sSortable,b.sSortingClassJUI=d.sSortJUI)}function Z(a){if(!1!==a.oFeatures.bAutoWidth){var b=a.aoColumns;Ha(a);for(var c=0,d=b.length;c<d;c++)b[c].nTh.style.width=b[c].sWidth}b=a.oScroll;(""!==b.sY||""!==b.sX)&&ma(a);s(a,null,"column-sizing",[a])}function $(a,b){var c=na(a,"bVisible");return"number"===typeof c[b]?c[b]:null}function aa(a,b){var c=na(a,"bVisible"),c=h.inArray(b,
c);return-1!==c?c:null}function ba(a){var b=0;h.each(a.aoColumns,function(a,d){d.bVisible&&"none"!==h(d.nTh).css("display")&&b++});return b}function na(a,b){var c=[];h.map(a.aoColumns,function(a,e){a[b]&&c.push(e)});return c}function Ia(a){var b=a.aoColumns,c=a.aoData,d=m.ext.type.detect,e,f,g,j,i,h,l,q,r;e=0;for(f=b.length;e<f;e++)if(l=b[e],r=[],!l.sType&&l._sManualType)l.sType=l._sManualType;else if(!l.sType){g=0;for(j=d.length;g<j;g++){i=0;for(h=c.length;i<h;i++){r[i]===k&&(r[i]=B(a,i,e,"type"));
q=d[g](r[i],a);if(!q&&g!==d.length-1)break;if("html"===q)break}if(q){l.sType=q;break}}l.sType||(l.sType="string")}}function kb(a,b,c,d){var e,f,g,j,i,n,l=a.aoColumns;if(b)for(e=b.length-1;0<=e;e--){n=b[e];var q=n.targets!==k?n.targets:n.aTargets;h.isArray(q)||(q=[q]);f=0;for(g=q.length;f<g;f++)if("number"===typeof q[f]&&0<=q[f]){for(;l.length<=q[f];)Ga(a);d(q[f],n)}else if("number"===typeof q[f]&&0>q[f])d(l.length+q[f],n);else if("string"===typeof q[f]){j=0;for(i=l.length;j<i;j++)("_all"==q[f]||h(l[j].nTh).hasClass(q[f]))&&
d(j,n)}}if(c){e=0;for(a=c.length;e<a;e++)d(e,c[e])}}function N(a,b,c,d){var e=a.aoData.length,f=h.extend(!0,{},m.models.oRow,{src:c?"dom":"data",idx:e});f._aData=b;a.aoData.push(f);for(var g=a.aoColumns,j=0,i=g.length;j<i;j++)g[j].sType=null;a.aiDisplayMaster.push(e);b=a.rowIdFn(b);b!==k&&(a.aIds[b]=f);(c||!a.oFeatures.bDeferRender)&&Ja(a,e,c,d);return e}function oa(a,b){var c;b instanceof h||(b=h(b));return b.map(function(b,e){c=Ka(a,e);return N(a,c.data,e,c.cells)})}function B(a,b,c,d){var e=a.iDraw,
f=a.aoColumns[c],g=a.aoData[b]._aData,j=f.sDefaultContent,i=f.fnGetData(g,d,{settings:a,row:b,col:c});if(i===k)return a.iDrawError!=e&&null===j&&(K(a,0,"Requested unknown parameter "+("function"==typeof f.mData?"{function}":"'"+f.mData+"'")+" for row "+b+", column "+c,4),a.iDrawError=e),j;if((i===g||null===i)&&null!==j&&d!==k)i=j;else if("function"===typeof i)return i.call(g);return null===i&&"display"==d?"":i}function lb(a,b,c,d){a.aoColumns[c].fnSetData(a.aoData[b]._aData,d,{settings:a,row:b,col:c})}
function La(a){return h.map(a.match(/(\\.|[^\.])+/g)||[""],function(a){return a.replace(/\\\./g,".")})}function R(a){if(h.isPlainObject(a)){var b={};h.each(a,function(a,c){c&&(b[a]=R(c))});return function(a,c,f,g){var j=b[c]||b._;return j!==k?j(a,c,f,g):a}}if(null===a)return function(a){return a};if("function"===typeof a)return function(b,c,f,g){return a(b,c,f,g)};if("string"===typeof a&&(-1!==a.indexOf(".")||-1!==a.indexOf("[")||-1!==a.indexOf("("))){var c=function(a,b,f){var g,j;if(""!==f){j=La(f);
for(var i=0,n=j.length;i<n;i++){f=j[i].match(ca);g=j[i].match(V);if(f){j[i]=j[i].replace(ca,"");""!==j[i]&&(a=a[j[i]]);g=[];j.splice(0,i+1);j=j.join(".");if(h.isArray(a)){i=0;for(n=a.length;i<n;i++)g.push(c(a[i],b,j))}a=f[0].substring(1,f[0].length-1);a=""===a?g:g.join(a);break}else if(g){j[i]=j[i].replace(V,"");a=a[j[i]]();continue}if(null===a||a[j[i]]===k)return k;a=a[j[i]]}}return a};return function(b,e){return c(b,e,a)}}return function(b){return b[a]}}function S(a){if(h.isPlainObject(a))return S(a._);
if(null===a)return function(){};if("function"===typeof a)return function(b,d,e){a(b,"set",d,e)};if("string"===typeof a&&(-1!==a.indexOf(".")||-1!==a.indexOf("[")||-1!==a.indexOf("("))){var b=function(a,d,e){var e=La(e),f;f=e[e.length-1];for(var g,j,i=0,n=e.length-1;i<n;i++){g=e[i].match(ca);j=e[i].match(V);if(g){e[i]=e[i].replace(ca,"");a[e[i]]=[];f=e.slice();f.splice(0,i+1);g=f.join(".");if(h.isArray(d)){j=0;for(n=d.length;j<n;j++)f={},b(f,d[j],g),a[e[i]].push(f)}else a[e[i]]=d;return}j&&(e[i]=e[i].replace(V,
""),a=a[e[i]](d));if(null===a[e[i]]||a[e[i]]===k)a[e[i]]={};a=a[e[i]]}if(f.match(V))a[f.replace(V,"")](d);else a[f.replace(ca,"")]=d};return function(c,d){return b(c,d,a)}}return function(b,d){b[a]=d}}function Ma(a){return D(a.aoData,"_aData")}function pa(a){a.aoData.length=0;a.aiDisplayMaster.length=0;a.aiDisplay.length=0;a.aIds={}}function qa(a,b,c){for(var d=-1,e=0,f=a.length;e<f;e++)a[e]==b?d=e:a[e]>b&&a[e]--; -1!=d&&c===k&&a.splice(d,1)}function da(a,b,c,d){var e=a.aoData[b],f,g=function(c,d){for(;c.childNodes.length;)c.removeChild(c.firstChild);
c.innerHTML=B(a,b,d,"display")};if("dom"===c||(!c||"auto"===c)&&"dom"===e.src)e._aData=Ka(a,e,d,d===k?k:e._aData).data;else{var j=e.anCells;if(j)if(d!==k)g(j[d],d);else{c=0;for(f=j.length;c<f;c++)g(j[c],c)}}e._aSortData=null;e._aFilterData=null;g=a.aoColumns;if(d!==k)g[d].sType=null;else{c=0;for(f=g.length;c<f;c++)g[c].sType=null;Na(a,e)}}function Ka(a,b,c,d){var e=[],f=b.firstChild,g,j,i=0,n,l=a.aoColumns,q=a._rowReadObject,d=d!==k?d:q?{}:[],r=function(a,b){if("string"===typeof a){var c=a.indexOf("@");
-1!==c&&(c=a.substring(c+1),S(a)(d,b.getAttribute(c)))}},m=function(a){if(c===k||c===i)j=l[i],n=h.trim(a.innerHTML),j&&j._bAttrSrc?(S(j.mData._)(d,n),r(j.mData.sort,a),r(j.mData.type,a),r(j.mData.filter,a)):q?(j._setter||(j._setter=S(j.mData)),j._setter(d,n)):d[i]=n;i++};if(f)for(;f;){g=f.nodeName.toUpperCase();if("TD"==g||"TH"==g)m(f),e.push(f);f=f.nextSibling}else{e=b.anCells;f=0;for(g=e.length;f<g;f++)m(e[f])}if(b=b.firstChild?b:b.nTr)(b=b.getAttribute("id"))&&S(a.rowId)(d,b);return{data:d,cells:e}}
function Ja(a,b,c,d){var e=a.aoData[b],f=e._aData,g=[],j,i,n,l,q;if(null===e.nTr){j=c||H.createElement("tr");e.nTr=j;e.anCells=g;j._DT_RowIndex=b;Na(a,e);l=0;for(q=a.aoColumns.length;l<q;l++){n=a.aoColumns[l];i=c?d[l]:H.createElement(n.sCellType);i._DT_CellIndex={row:b,column:l};g.push(i);if((!c||n.mRender||n.mData!==l)&&(!h.isPlainObject(n.mData)||n.mData._!==l+".display"))i.innerHTML=B(a,b,l,"display");n.sClass&&(i.className+=" "+n.sClass);n.bVisible&&!c?j.appendChild(i):!n.bVisible&&c&&i.parentNode.removeChild(i);
n.fnCreatedCell&&n.fnCreatedCell.call(a.oInstance,i,B(a,b,l),f,b,l)}s(a,"aoRowCreatedCallback",null,[j,f,b])}e.nTr.setAttribute("role","row")}function Na(a,b){var c=b.nTr,d=b._aData;if(c){var e=a.rowIdFn(d);e&&(c.id=e);d.DT_RowClass&&(e=d.DT_RowClass.split(" "),b.__rowc=b.__rowc?sa(b.__rowc.concat(e)):e,h(c).removeClass(b.__rowc.join(" ")).addClass(d.DT_RowClass));d.DT_RowAttr&&h(c).attr(d.DT_RowAttr);d.DT_RowData&&h(c).data(d.DT_RowData)}}function mb(a){var b,c,d,e,f,g=a.nTHead,j=a.nTFoot,i=0===
h("th, td",g).length,n=a.oClasses,l=a.aoColumns;i&&(e=h("<tr/>").appendTo(g));b=0;for(c=l.length;b<c;b++)f=l[b],d=h(f.nTh).addClass(f.sClass),i&&d.appendTo(e),a.oFeatures.bSort&&(d.addClass(f.sSortingClass),!1!==f.bSortable&&(d.attr("tabindex",a.iTabIndex).attr("aria-controls",a.sTableId),Oa(a,f.nTh,b))),f.sTitle!=d[0].innerHTML&&d.html(f.sTitle),Pa(a,"header")(a,d,f,n);i&&ea(a.aoHeader,g);h(g).find(">tr").attr("role","row");h(g).find(">tr>th, >tr>td").addClass(n.sHeaderTH);h(j).find(">tr>th, >tr>td").addClass(n.sFooterTH);
if(null!==j){a=a.aoFooter[0];b=0;for(c=a.length;b<c;b++)f=l[b],f.nTf=a[b].cell,f.sClass&&h(f.nTf).addClass(f.sClass)}}function fa(a,b,c){var d,e,f,g=[],j=[],i=a.aoColumns.length,n;if(b){c===k&&(c=!1);d=0;for(e=b.length;d<e;d++){g[d]=b[d].slice();g[d].nTr=b[d].nTr;for(f=i-1;0<=f;f--)!a.aoColumns[f].bVisible&&!c&&g[d].splice(f,1);j.push([])}d=0;for(e=g.length;d<e;d++){if(a=g[d].nTr)for(;f=a.firstChild;)a.removeChild(f);f=0;for(b=g[d].length;f<b;f++)if(n=i=1,j[d][f]===k){a.appendChild(g[d][f].cell);
for(j[d][f]=1;g[d+i]!==k&&g[d][f].cell==g[d+i][f].cell;)j[d+i][f]=1,i++;for(;g[d][f+n]!==k&&g[d][f].cell==g[d][f+n].cell;){for(c=0;c<i;c++)j[d+c][f+n]=1;n++}h(g[d][f].cell).attr("rowspan",i).attr("colspan",n)}}}}function O(a){var b=s(a,"aoPreDrawCallback","preDraw",[a]);if(-1!==h.inArray(!1,b))C(a,!1);else{var b=[],c=0,d=a.asStripeClasses,e=d.length,f=a.oLanguage,g=a.iInitDisplayStart,j="ssp"==y(a),i=a.aiDisplay;a.bDrawing=!0;g!==k&&-1!==g&&(a._iDisplayStart=j?g:g>=a.fnRecordsDisplay()?0:g,a.iInitDisplayStart=
-1);var g=a._iDisplayStart,n=a.fnDisplayEnd();if(a.bDeferLoading)a.bDeferLoading=!1,a.iDraw++,C(a,!1);else if(j){if(!a.bDestroying&&!nb(a))return}else a.iDraw++;if(0!==i.length){f=j?a.aoData.length:n;for(j=j?0:g;j<f;j++){var l=i[j],q=a.aoData[l];null===q.nTr&&Ja(a,l);l=q.nTr;if(0!==e){var r=d[c%e];q._sRowStripe!=r&&(h(l).removeClass(q._sRowStripe).addClass(r),q._sRowStripe=r)}s(a,"aoRowCallback",null,[l,q._aData,c,j]);b.push(l);c++}}else c=f.sZeroRecords,1==a.iDraw&&"ajax"==y(a)?c=f.sLoadingRecords:
f.sEmptyTable&&0===a.fnRecordsTotal()&&(c=f.sEmptyTable),b[0]=h("<tr/>",{"class":e?d[0]:""}).append(h("<td />",{valign:"top",colSpan:ba(a),"class":a.oClasses.sRowEmpty}).html(c))[0];s(a,"aoHeaderCallback","header",[h(a.nTHead).children("tr")[0],Ma(a),g,n,i]);s(a,"aoFooterCallback","footer",[h(a.nTFoot).children("tr")[0],Ma(a),g,n,i]);d=h(a.nTBody);d.children().detach();d.append(h(b));s(a,"aoDrawCallback","draw",[a]);a.bSorted=!1;a.bFiltered=!1;a.bDrawing=!1}}function T(a,b){var c=a.oFeatures,d=c.bFilter;
c.bSort&&ob(a);d?ga(a,a.oPreviousSearch):a.aiDisplay=a.aiDisplayMaster.slice();!0!==b&&(a._iDisplayStart=0);a._drawHold=b;O(a);a._drawHold=!1}function pb(a){var b=a.oClasses,c=h(a.nTable),c=h("<div/>").insertBefore(c),d=a.oFeatures,e=h("<div/>",{id:a.sTableId+"_wrapper","class":b.sWrapper+(a.nTFoot?"":" "+b.sNoFooter)});a.nHolding=c[0];a.nTableWrapper=e[0];a.nTableReinsertBefore=a.nTable.nextSibling;for(var f=a.sDom.split(""),g,j,i,n,l,q,k=0;k<f.length;k++){g=null;j=f[k];if("<"==j){i=h("<div/>")[0];
n=f[k+1];if("'"==n||'"'==n){l="";for(q=2;f[k+q]!=n;)l+=f[k+q],q++;"H"==l?l=b.sJUIHeader:"F"==l&&(l=b.sJUIFooter);-1!=l.indexOf(".")?(n=l.split("."),i.id=n[0].substr(1,n[0].length-1),i.className=n[1]):"#"==l.charAt(0)?i.id=l.substr(1,l.length-1):i.className=l;k+=q}e.append(i);e=h(i)}else if(">"==j)e=e.parent();else if("l"==j&&d.bPaginate&&d.bLengthChange)g=qb(a);else if("f"==j&&d.bFilter)g=rb(a);else if("r"==j&&d.bProcessing)g=sb(a);else if("t"==j)g=tb(a);else if("i"==j&&d.bInfo)g=ub(a);else if("p"==
j&&d.bPaginate)g=vb(a);else if(0!==m.ext.feature.length){i=m.ext.feature;q=0;for(n=i.length;q<n;q++)if(j==i[q].cFeature){g=i[q].fnInit(a);break}}g&&(i=a.aanFeatures,i[j]||(i[j]=[]),i[j].push(g),e.append(g))}c.replaceWith(e);a.nHolding=null}function ea(a,b){var c=h(b).children("tr"),d,e,f,g,j,i,n,l,q,k;a.splice(0,a.length);f=0;for(i=c.length;f<i;f++)a.push([]);f=0;for(i=c.length;f<i;f++){d=c[f];for(e=d.firstChild;e;){if("TD"==e.nodeName.toUpperCase()||"TH"==e.nodeName.toUpperCase()){l=1*e.getAttribute("colspan");
q=1*e.getAttribute("rowspan");l=!l||0===l||1===l?1:l;q=!q||0===q||1===q?1:q;g=0;for(j=a[f];j[g];)g++;n=g;k=1===l?!0:!1;for(j=0;j<l;j++)for(g=0;g<q;g++)a[f+g][n+j]={cell:e,unique:k},a[f+g].nTr=d}e=e.nextSibling}}}function ta(a,b,c){var d=[];c||(c=a.aoHeader,b&&(c=[],ea(c,b)));for(var b=0,e=c.length;b<e;b++)for(var f=0,g=c[b].length;f<g;f++)if(c[b][f].unique&&(!d[f]||!a.bSortCellsTop))d[f]=c[b][f].cell;return d}function ua(a,b,c){s(a,"aoServerParams","serverParams",[b]);if(b&&h.isArray(b)){var d={},
e=/(.*?)\[\]$/;h.each(b,function(a,b){var c=b.name.match(e);c?(c=c[0],d[c]||(d[c]=[]),d[c].push(b.value)):d[b.name]=b.value});b=d}var f,g=a.ajax,j=a.oInstance,i=function(b){s(a,null,"xhr",[a,b,a.jqXHR]);c(b)};if(h.isPlainObject(g)&&g.data){f=g.data;var n=h.isFunction(f)?f(b,a):f,b=h.isFunction(f)&&n?n:h.extend(!0,b,n);delete g.data}n={data:b,success:function(b){var c=b.error||b.sError;c&&K(a,0,c);a.json=b;i(b)},dataType:"json",cache:!1,type:a.sServerMethod,error:function(b,c){var d=s(a,null,"xhr",
[a,null,a.jqXHR]);-1===h.inArray(!0,d)&&("parsererror"==c?K(a,0,"Invalid JSON response",1):4===b.readyState&&K(a,0,"Ajax error",7));C(a,!1)}};a.oAjaxData=b;s(a,null,"preXhr",[a,b]);a.fnServerData?a.fnServerData.call(j,a.sAjaxSource,h.map(b,function(a,b){return{name:b,value:a}}),i,a):a.sAjaxSource||"string"===typeof g?a.jqXHR=h.ajax(h.extend(n,{url:g||a.sAjaxSource})):h.isFunction(g)?a.jqXHR=g.call(j,b,i,a):(a.jqXHR=h.ajax(h.extend(n,g)),g.data=f)}function nb(a){return a.bAjaxDataGet?(a.iDraw++,C(a,
!0),ua(a,wb(a),function(b){xb(a,b)}),!1):!0}function wb(a){var b=a.aoColumns,c=b.length,d=a.oFeatures,e=a.oPreviousSearch,f=a.aoPreSearchCols,g,j=[],i,n,l,k=W(a);g=a._iDisplayStart;i=!1!==d.bPaginate?a._iDisplayLength:-1;var r=function(a,b){j.push({name:a,value:b})};r("sEcho",a.iDraw);r("iColumns",c);r("sColumns",D(b,"sName").join(","));r("iDisplayStart",g);r("iDisplayLength",i);var ra={draw:a.iDraw,columns:[],order:[],start:g,length:i,search:{value:e.sSearch,regex:e.bRegex}};for(g=0;g<c;g++)n=b[g],
l=f[g],i="function"==typeof n.mData?"function":n.mData,ra.columns.push({data:i,name:n.sName,searchable:n.bSearchable,orderable:n.bSortable,search:{value:l.sSearch,regex:l.bRegex}}),r("mDataProp_"+g,i),d.bFilter&&(r("sSearch_"+g,l.sSearch),r("bRegex_"+g,l.bRegex),r("bSearchable_"+g,n.bSearchable)),d.bSort&&r("bSortable_"+g,n.bSortable);d.bFilter&&(r("sSearch",e.sSearch),r("bRegex",e.bRegex));d.bSort&&(h.each(k,function(a,b){ra.order.push({column:b.col,dir:b.dir});r("iSortCol_"+a,b.col);r("sSortDir_"+
a,b.dir)}),r("iSortingCols",k.length));b=m.ext.legacy.ajax;return null===b?a.sAjaxSource?j:ra:b?j:ra}function xb(a,b){var c=va(a,b),d=b.sEcho!==k?b.sEcho:b.draw,e=b.iTotalRecords!==k?b.iTotalRecords:b.recordsTotal,f=b.iTotalDisplayRecords!==k?b.iTotalDisplayRecords:b.recordsFiltered;if(d){if(1*d<a.iDraw)return;a.iDraw=1*d}pa(a);a._iRecordsTotal=parseInt(e,10);a._iRecordsDisplay=parseInt(f,10);d=0;for(e=c.length;d<e;d++)N(a,c[d]);a.aiDisplay=a.aiDisplayMaster.slice();a.bAjaxDataGet=!1;O(a);a._bInitComplete||
wa(a,b);a.bAjaxDataGet=!0;C(a,!1)}function va(a,b){var c=h.isPlainObject(a.ajax)&&a.ajax.dataSrc!==k?a.ajax.dataSrc:a.sAjaxDataProp;return"data"===c?b.aaData||b[c]:""!==c?R(c)(b):b}function rb(a){var b=a.oClasses,c=a.sTableId,d=a.oLanguage,e=a.oPreviousSearch,f=a.aanFeatures,g='<input type="search" class="'+b.sFilterInput+'"/>',j=d.sSearch,j=j.match(/_INPUT_/)?j.replace("_INPUT_",g):j+g,b=h("<div/>",{id:!f.f?c+"_filter":null,"class":b.sFilter}).append(h("<label/>").append(j)),f=function(){var b=!this.value?
"":this.value;b!=e.sSearch&&(ga(a,{sSearch:b,bRegex:e.bRegex,bSmart:e.bSmart,bCaseInsensitive:e.bCaseInsensitive}),a._iDisplayStart=0,O(a))},g=null!==a.searchDelay?a.searchDelay:"ssp"===y(a)?400:0,i=h("input",b).val(e.sSearch).attr("placeholder",d.sSearchPlaceholder).on("keyup.DT search.DT input.DT paste.DT cut.DT",g?Qa(f,g):f).on("keypress.DT",function(a){if(13==a.keyCode)return!1}).attr("aria-controls",c);h(a.nTable).on("search.dt.DT",function(b,c){if(a===c)try{i[0]!==H.activeElement&&i.val(e.sSearch)}catch(d){}});
return b[0]}function ga(a,b,c){var d=a.oPreviousSearch,e=a.aoPreSearchCols,f=function(a){d.sSearch=a.sSearch;d.bRegex=a.bRegex;d.bSmart=a.bSmart;d.bCaseInsensitive=a.bCaseInsensitive};Ia(a);if("ssp"!=y(a)){yb(a,b.sSearch,c,b.bEscapeRegex!==k?!b.bEscapeRegex:b.bRegex,b.bSmart,b.bCaseInsensitive);f(b);for(b=0;b<e.length;b++)zb(a,e[b].sSearch,b,e[b].bEscapeRegex!==k?!e[b].bEscapeRegex:e[b].bRegex,e[b].bSmart,e[b].bCaseInsensitive);Ab(a)}else f(b);a.bFiltered=!0;s(a,null,"search",[a])}function Ab(a){for(var b=
m.ext.search,c=a.aiDisplay,d,e,f=0,g=b.length;f<g;f++){for(var j=[],i=0,n=c.length;i<n;i++)e=c[i],d=a.aoData[e],b[f](a,d._aFilterData,e,d._aData,i)&&j.push(e);c.length=0;h.merge(c,j)}}function zb(a,b,c,d,e,f){if(""!==b){for(var g=[],j=a.aiDisplay,d=Ra(b,d,e,f),e=0;e<j.length;e++)b=a.aoData[j[e]]._aFilterData[c],d.test(b)&&g.push(j[e]);a.aiDisplay=g}}function yb(a,b,c,d,e,f){var d=Ra(b,d,e,f),f=a.oPreviousSearch.sSearch,g=a.aiDisplayMaster,j,e=[];0!==m.ext.search.length&&(c=!0);j=Bb(a);if(0>=b.length)a.aiDisplay=
g.slice();else{if(j||c||f.length>b.length||0!==b.indexOf(f)||a.bSorted)a.aiDisplay=g.slice();b=a.aiDisplay;for(c=0;c<b.length;c++)d.test(a.aoData[b[c]]._sFilterRow)&&e.push(b[c]);a.aiDisplay=e}}function Ra(a,b,c,d){a=b?a:Sa(a);c&&(a="^(?=.*?"+h.map(a.match(/"[^"]+"|[^ ]+/g)||[""],function(a){if('"'===a.charAt(0))var b=a.match(/^"(.*)"$/),a=b?b[1]:a;return a.replace('"',"")}).join(")(?=.*?")+").*$");return RegExp(a,d?"i":"")}function Bb(a){var b=a.aoColumns,c,d,e,f,g,j,i,h,l=m.ext.type.search;c=!1;
d=0;for(f=a.aoData.length;d<f;d++)if(h=a.aoData[d],!h._aFilterData){j=[];e=0;for(g=b.length;e<g;e++)c=b[e],c.bSearchable?(i=B(a,d,e,"filter"),l[c.sType]&&(i=l[c.sType](i)),null===i&&(i=""),"string"!==typeof i&&i.toString&&(i=i.toString())):i="",i.indexOf&&-1!==i.indexOf("&")&&(xa.innerHTML=i,i=$b?xa.textContent:xa.innerText),i.replace&&(i=i.replace(/[\r\n]/g,"")),j.push(i);h._aFilterData=j;h._sFilterRow=j.join("  ");c=!0}return c}function Cb(a){return{search:a.sSearch,smart:a.bSmart,regex:a.bRegex,
caseInsensitive:a.bCaseInsensitive}}function Db(a){return{sSearch:a.search,bSmart:a.smart,bRegex:a.regex,bCaseInsensitive:a.caseInsensitive}}function ub(a){var b=a.sTableId,c=a.aanFeatures.i,d=h("<div/>",{"class":a.oClasses.sInfo,id:!c?b+"_info":null});c||(a.aoDrawCallback.push({fn:Eb,sName:"information"}),d.attr("role","status").attr("aria-live","polite"),h(a.nTable).attr("aria-describedby",b+"_info"));return d[0]}function Eb(a){var b=a.aanFeatures.i;if(0!==b.length){var c=a.oLanguage,d=a._iDisplayStart+
1,e=a.fnDisplayEnd(),f=a.fnRecordsTotal(),g=a.fnRecordsDisplay(),j=g?c.sInfo:c.sInfoEmpty;g!==f&&(j+=" "+c.sInfoFiltered);j+=c.sInfoPostFix;j=Fb(a,j);c=c.fnInfoCallback;null!==c&&(j=c.call(a.oInstance,a,d,e,f,g,j));h(b).html(j)}}function Fb(a,b){var c=a.fnFormatNumber,d=a._iDisplayStart+1,e=a._iDisplayLength,f=a.fnRecordsDisplay(),g=-1===e;return b.replace(/_START_/g,c.call(a,d)).replace(/_END_/g,c.call(a,a.fnDisplayEnd())).replace(/_MAX_/g,c.call(a,a.fnRecordsTotal())).replace(/_TOTAL_/g,c.call(a,
f)).replace(/_PAGE_/g,c.call(a,g?1:Math.ceil(d/e))).replace(/_PAGES_/g,c.call(a,g?1:Math.ceil(f/e)))}function ha(a){var b,c,d=a.iInitDisplayStart,e=a.aoColumns,f;c=a.oFeatures;var g=a.bDeferLoading;if(a.bInitialised){pb(a);mb(a);fa(a,a.aoHeader);fa(a,a.aoFooter);C(a,!0);c.bAutoWidth&&Ha(a);b=0;for(c=e.length;b<c;b++)f=e[b],f.sWidth&&(f.nTh.style.width=v(f.sWidth));s(a,null,"preInit",[a]);T(a);e=y(a);if("ssp"!=e||g)"ajax"==e?ua(a,[],function(c){var f=va(a,c);for(b=0;b<f.length;b++)N(a,f[b]);a.iInitDisplayStart=
d;T(a);C(a,!1);wa(a,c)},a):(C(a,!1),wa(a))}else setTimeout(function(){ha(a)},200)}function wa(a,b){a._bInitComplete=!0;(b||a.oInit.aaData)&&Z(a);s(a,null,"plugin-init",[a,b]);s(a,"aoInitComplete","init",[a,b])}function Ta(a,b){var c=parseInt(b,10);a._iDisplayLength=c;Ua(a);s(a,null,"length",[a,c])}function qb(a){for(var b=a.oClasses,c=a.sTableId,d=a.aLengthMenu,e=h.isArray(d[0]),f=e?d[0]:d,d=e?d[1]:d,e=h("<select/>",{name:c+"_length","aria-controls":c,"class":b.sLengthSelect}),g=0,j=f.length;g<j;g++)e[0][g]=
new Option(d[g],f[g]);var i=h("<div><label/></div>").addClass(b.sLength);a.aanFeatures.l||(i[0].id=c+"_length");i.children().append(a.oLanguage.sLengthMenu.replace("_MENU_",e[0].outerHTML));h("select",i).val(a._iDisplayLength).on("change.DT",function(){Ta(a,h(this).val());O(a)});h(a.nTable).on("length.dt.DT",function(b,c,d){a===c&&h("select",i).val(d)});return i[0]}function vb(a){var b=a.sPaginationType,c=m.ext.pager[b],d="function"===typeof c,e=function(a){O(a)},b=h("<div/>").addClass(a.oClasses.sPaging+
b)[0],f=a.aanFeatures;d||c.fnInit(a,b,e);f.p||(b.id=a.sTableId+"_paginate",a.aoDrawCallback.push({fn:function(a){if(d){var b=a._iDisplayStart,i=a._iDisplayLength,h=a.fnRecordsDisplay(),l=-1===i,b=l?0:Math.ceil(b/i),i=l?1:Math.ceil(h/i),h=c(b,i),k,l=0;for(k=f.p.length;l<k;l++)Pa(a,"pageButton")(a,f.p[l],l,h,b,i)}else c.fnUpdate(a,e)},sName:"pagination"}));return b}function Va(a,b,c){var d=a._iDisplayStart,e=a._iDisplayLength,f=a.fnRecordsDisplay();0===f||-1===e?d=0:"number"===typeof b?(d=b*e,d>f&&
(d=0)):"first"==b?d=0:"previous"==b?(d=0<=e?d-e:0,0>d&&(d=0)):"next"==b?d+e<f&&(d+=e):"last"==b?d=Math.floor((f-1)/e)*e:K(a,0,"Unknown paging action: "+b,5);b=a._iDisplayStart!==d;a._iDisplayStart=d;b&&(s(a,null,"page",[a]),c&&O(a));return b}function sb(a){return h("<div/>",{id:!a.aanFeatures.r?a.sTableId+"_processing":null,"class":a.oClasses.sProcessing}).html(a.oLanguage.sProcessing).insertBefore(a.nTable)[0]}function C(a,b){a.oFeatures.bProcessing&&h(a.aanFeatures.r).css("display",b?"block":"none");
s(a,null,"processing",[a,b])}function tb(a){var b=h(a.nTable);b.attr("role","grid");var c=a.oScroll;if(""===c.sX&&""===c.sY)return a.nTable;var d=c.sX,e=c.sY,f=a.oClasses,g=b.children("caption"),j=g.length?g[0]._captionSide:null,i=h(b[0].cloneNode(!1)),n=h(b[0].cloneNode(!1)),l=b.children("tfoot");l.length||(l=null);i=h("<div/>",{"class":f.sScrollWrapper}).append(h("<div/>",{"class":f.sScrollHead}).css({overflow:"hidden",position:"relative",border:0,width:d?!d?null:v(d):"100%"}).append(h("<div/>",
{"class":f.sScrollHeadInner}).css({"box-sizing":"content-box",width:c.sXInner||"100%"}).append(i.removeAttr("id").css("margin-left",0).append("top"===j?g:null).append(b.children("thead"))))).append(h("<div/>",{"class":f.sScrollBody}).css({position:"relative",overflow:"auto",width:!d?null:v(d)}).append(b));l&&i.append(h("<div/>",{"class":f.sScrollFoot}).css({overflow:"hidden",border:0,width:d?!d?null:v(d):"100%"}).append(h("<div/>",{"class":f.sScrollFootInner}).append(n.removeAttr("id").css("margin-left",
0).append("bottom"===j?g:null).append(b.children("tfoot")))));var b=i.children(),k=b[0],f=b[1],r=l?b[2]:null;if(d)h(f).on("scroll.DT",function(){var a=this.scrollLeft;k.scrollLeft=a;l&&(r.scrollLeft=a)});h(f).css(e&&c.bCollapse?"max-height":"height",e);a.nScrollHead=k;a.nScrollBody=f;a.nScrollFoot=r;a.aoDrawCallback.push({fn:ma,sName:"scrolling"});return i[0]}function ma(a){var b=a.oScroll,c=b.sX,d=b.sXInner,e=b.sY,b=b.iBarWidth,f=h(a.nScrollHead),g=f[0].style,j=f.children("div"),i=j[0].style,n=j.children("table"),
j=a.nScrollBody,l=h(j),q=j.style,r=h(a.nScrollFoot).children("div"),m=r.children("table"),p=h(a.nTHead),o=h(a.nTable),u=o[0],s=u.style,t=a.nTFoot?h(a.nTFoot):null,x=a.oBrowser,U=x.bScrollOversize,ac=D(a.aoColumns,"nTh"),P,L,Q,w,Wa=[],y=[],z=[],A=[],B,C=function(a){a=a.style;a.paddingTop="0";a.paddingBottom="0";a.borderTopWidth="0";a.borderBottomWidth="0";a.height=0};L=j.scrollHeight>j.clientHeight;if(a.scrollBarVis!==L&&a.scrollBarVis!==k)a.scrollBarVis=L,Z(a);else{a.scrollBarVis=L;o.children("thead, tfoot").remove();
t&&(Q=t.clone().prependTo(o),P=t.find("tr"),Q=Q.find("tr"));w=p.clone().prependTo(o);p=p.find("tr");L=w.find("tr");w.find("th, td").removeAttr("tabindex");c||(q.width="100%",f[0].style.width="100%");h.each(ta(a,w),function(b,c){B=$(a,b);c.style.width=a.aoColumns[B].sWidth});t&&I(function(a){a.style.width=""},Q);f=o.outerWidth();if(""===c){s.width="100%";if(U&&(o.find("tbody").height()>j.offsetHeight||"scroll"==l.css("overflow-y")))s.width=v(o.outerWidth()-b);f=o.outerWidth()}else""!==d&&(s.width=
v(d),f=o.outerWidth());I(C,L);I(function(a){z.push(a.innerHTML);Wa.push(v(h(a).css("width")))},L);I(function(a,b){if(h.inArray(a,ac)!==-1)a.style.width=Wa[b]},p);h(L).height(0);t&&(I(C,Q),I(function(a){A.push(a.innerHTML);y.push(v(h(a).css("width")))},Q),I(function(a,b){a.style.width=y[b]},P),h(Q).height(0));I(function(a,b){a.innerHTML='<div class="dataTables_sizing" style="height:0;overflow:hidden;">'+z[b]+"</div>";a.style.width=Wa[b]},L);t&&I(function(a,b){a.innerHTML='<div class="dataTables_sizing" style="height:0;overflow:hidden;">'+
A[b]+"</div>";a.style.width=y[b]},Q);if(o.outerWidth()<f){P=j.scrollHeight>j.offsetHeight||"scroll"==l.css("overflow-y")?f+b:f;if(U&&(j.scrollHeight>j.offsetHeight||"scroll"==l.css("overflow-y")))s.width=v(P-b);(""===c||""!==d)&&K(a,1,"Possible column misalignment",6)}else P="100%";q.width=v(P);g.width=v(P);t&&(a.nScrollFoot.style.width=v(P));!e&&U&&(q.height=v(u.offsetHeight+b));c=o.outerWidth();n[0].style.width=v(c);i.width=v(c);d=o.height()>j.clientHeight||"scroll"==l.css("overflow-y");e="padding"+
(x.bScrollbarLeft?"Left":"Right");i[e]=d?b+"px":"0px";t&&(m[0].style.width=v(c),r[0].style.width=v(c),r[0].style[e]=d?b+"px":"0px");o.children("colgroup").insertBefore(o.children("thead"));l.scroll();if((a.bSorted||a.bFiltered)&&!a._drawHold)j.scrollTop=0}}function I(a,b,c){for(var d=0,e=0,f=b.length,g,j;e<f;){g=b[e].firstChild;for(j=c?c[e].firstChild:null;g;)1===g.nodeType&&(c?a(g,j,d):a(g,d),d++),g=g.nextSibling,j=c?j.nextSibling:null;e++}}function Ha(a){var b=a.nTable,c=a.aoColumns,d=a.oScroll,
e=d.sY,f=d.sX,g=d.sXInner,j=c.length,i=na(a,"bVisible"),n=h("th",a.nTHead),l=b.getAttribute("width"),k=b.parentNode,r=!1,m,p,o=a.oBrowser,d=o.bScrollOversize;(m=b.style.width)&&-1!==m.indexOf("%")&&(l=m);for(m=0;m<i.length;m++)p=c[i[m]],null!==p.sWidth&&(p.sWidth=Gb(p.sWidthOrig,k),r=!0);if(d||!r&&!f&&!e&&j==ba(a)&&j==n.length)for(m=0;m<j;m++)i=$(a,m),null!==i&&(c[i].sWidth=v(n.eq(m).width()));else{j=h(b).clone().css("visibility","hidden").removeAttr("id");j.find("tbody tr").remove();var u=h("<tr/>").appendTo(j.find("tbody"));
j.find("thead, tfoot").remove();j.append(h(a.nTHead).clone()).append(h(a.nTFoot).clone());j.find("tfoot th, tfoot td").css("width","");n=ta(a,j.find("thead")[0]);for(m=0;m<i.length;m++)p=c[i[m]],n[m].style.width=null!==p.sWidthOrig&&""!==p.sWidthOrig?v(p.sWidthOrig):"",p.sWidthOrig&&f&&h(n[m]).append(h("<div/>").css({width:p.sWidthOrig,margin:0,padding:0,border:0,height:1}));if(a.aoData.length)for(m=0;m<i.length;m++)r=i[m],p=c[r],h(Hb(a,r)).clone(!1).append(p.sContentPadding).appendTo(u);h("[name]",
j).removeAttr("name");p=h("<div/>").css(f||e?{position:"absolute",top:0,left:0,height:1,right:0,overflow:"hidden"}:{}).append(j).appendTo(k);f&&g?j.width(g):f?(j.css("width","auto"),j.removeAttr("width"),j.width()<k.clientWidth&&l&&j.width(k.clientWidth)):e?j.width(k.clientWidth):l&&j.width(l);for(m=e=0;m<i.length;m++)k=h(n[m]),g=k.outerWidth()-k.width(),k=o.bBounding?Math.ceil(n[m].getBoundingClientRect().width):k.outerWidth(),e+=k,c[i[m]].sWidth=v(k-g);b.style.width=v(e);p.remove()}l&&(b.style.width=
v(l));if((l||f)&&!a._reszEvt)b=function(){h(E).on("resize.DT-"+a.sInstance,Qa(function(){Z(a)}))},d?setTimeout(b,1E3):b(),a._reszEvt=!0}function Gb(a,b){if(!a)return 0;var c=h("<div/>").css("width",v(a)).appendTo(b||H.body),d=c[0].offsetWidth;c.remove();return d}function Hb(a,b){var c=Ib(a,b);if(0>c)return null;var d=a.aoData[c];return!d.nTr?h("<td/>").html(B(a,c,b,"display"))[0]:d.anCells[b]}function Ib(a,b){for(var c,d=-1,e=-1,f=0,g=a.aoData.length;f<g;f++)c=B(a,f,b,"display")+"",c=c.replace(bc,
""),c=c.replace(/&nbsp;/g," "),c.length>d&&(d=c.length,e=f);return e}function v(a){return null===a?"0px":"number"==typeof a?0>a?"0px":a+"px":a.match(/\d$/)?a+"px":a}function W(a){var b,c,d=[],e=a.aoColumns,f,g,j,i;b=a.aaSortingFixed;c=h.isPlainObject(b);var n=[];f=function(a){a.length&&!h.isArray(a[0])?n.push(a):h.merge(n,a)};h.isArray(b)&&f(b);c&&b.pre&&f(b.pre);f(a.aaSorting);c&&b.post&&f(b.post);for(a=0;a<n.length;a++){i=n[a][0];f=e[i].aDataSort;b=0;for(c=f.length;b<c;b++)g=f[b],j=e[g].sType||
"string",n[a]._idx===k&&(n[a]._idx=h.inArray(n[a][1],e[g].asSorting)),d.push({src:i,col:g,dir:n[a][1],index:n[a]._idx,type:j,formatter:m.ext.type.order[j+"-pre"]})}return d}function ob(a){var b,c,d=[],e=m.ext.type.order,f=a.aoData,g=0,j,i=a.aiDisplayMaster,h;Ia(a);h=W(a);b=0;for(c=h.length;b<c;b++)j=h[b],j.formatter&&g++,Jb(a,j.col);if("ssp"!=y(a)&&0!==h.length){b=0;for(c=i.length;b<c;b++)d[i[b]]=b;g===h.length?i.sort(function(a,b){var c,e,g,j,i=h.length,k=f[a]._aSortData,m=f[b]._aSortData;for(g=
0;g<i;g++)if(j=h[g],c=k[j.col],e=m[j.col],c=c<e?-1:c>e?1:0,0!==c)return"asc"===j.dir?c:-c;c=d[a];e=d[b];return c<e?-1:c>e?1:0}):i.sort(function(a,b){var c,g,j,i,k=h.length,m=f[a]._aSortData,p=f[b]._aSortData;for(j=0;j<k;j++)if(i=h[j],c=m[i.col],g=p[i.col],i=e[i.type+"-"+i.dir]||e["string-"+i.dir],c=i(c,g),0!==c)return c;c=d[a];g=d[b];return c<g?-1:c>g?1:0})}a.bSorted=!0}function Kb(a){for(var b,c,d=a.aoColumns,e=W(a),a=a.oLanguage.oAria,f=0,g=d.length;f<g;f++){c=d[f];var j=c.asSorting;b=c.sTitle.replace(/<.*?>/g,
"");var i=c.nTh;i.removeAttribute("aria-sort");c.bSortable&&(0<e.length&&e[0].col==f?(i.setAttribute("aria-sort","asc"==e[0].dir?"ascending":"descending"),c=j[e[0].index+1]||j[0]):c=j[0],b+="asc"===c?a.sSortAscending:a.sSortDescending);i.setAttribute("aria-label",b)}}function Xa(a,b,c,d){var e=a.aaSorting,f=a.aoColumns[b].asSorting,g=function(a,b){var c=a._idx;c===k&&(c=h.inArray(a[1],f));return c+1<f.length?c+1:b?null:0};"number"===typeof e[0]&&(e=a.aaSorting=[e]);c&&a.oFeatures.bSortMulti?(c=h.inArray(b,
D(e,"0")),-1!==c?(b=g(e[c],!0),null===b&&1===e.length&&(b=0),null===b?e.splice(c,1):(e[c][1]=f[b],e[c]._idx=b)):(e.push([b,f[0],0]),e[e.length-1]._idx=0)):e.length&&e[0][0]==b?(b=g(e[0]),e.length=1,e[0][1]=f[b],e[0]._idx=b):(e.length=0,e.push([b,f[0]]),e[0]._idx=0);T(a);"function"==typeof d&&d(a)}function Oa(a,b,c,d){var e=a.aoColumns[c];Ya(b,{},function(b){!1!==e.bSortable&&(a.oFeatures.bProcessing?(C(a,!0),setTimeout(function(){Xa(a,c,b.shiftKey,d);"ssp"!==y(a)&&C(a,!1)},0)):Xa(a,c,b.shiftKey,d))})}
function ya(a){var b=a.aLastSort,c=a.oClasses.sSortColumn,d=W(a),e=a.oFeatures,f,g;if(e.bSort&&e.bSortClasses){e=0;for(f=b.length;e<f;e++)g=b[e].src,h(D(a.aoData,"anCells",g)).removeClass(c+(2>e?e+1:3));e=0;for(f=d.length;e<f;e++)g=d[e].src,h(D(a.aoData,"anCells",g)).addClass(c+(2>e?e+1:3))}a.aLastSort=d}function Jb(a,b){var c=a.aoColumns[b],d=m.ext.order[c.sSortDataType],e;d&&(e=d.call(a.oInstance,a,b,aa(a,b)));for(var f,g=m.ext.type.order[c.sType+"-pre"],j=0,i=a.aoData.length;j<i;j++)if(c=a.aoData[j],
c._aSortData||(c._aSortData=[]),!c._aSortData[b]||d)f=d?e[j]:B(a,j,b,"sort"),c._aSortData[b]=g?g(f):f}function za(a){if(a.oFeatures.bStateSave&&!a.bDestroying){var b={time:+new Date,start:a._iDisplayStart,length:a._iDisplayLength,order:h.extend(!0,[],a.aaSorting),search:Cb(a.oPreviousSearch),columns:h.map(a.aoColumns,function(b,d){return{visible:b.bVisible,search:Cb(a.aoPreSearchCols[d])}})};s(a,"aoStateSaveParams","stateSaveParams",[a,b]);a.oSavedState=b;a.fnStateSaveCallback.call(a.oInstance,a,
b)}}function Lb(a,b,c){var d,e,f=a.aoColumns,b=function(b){if(b&&b.time){var i=s(a,"aoStateLoadParams","stateLoadParams",[a,g]);if(-1===h.inArray(!1,i)&&(i=a.iStateDuration,!(0<i&&b.time<+new Date-1E3*i)&&!(b.columns&&f.length!==b.columns.length))){a.oLoadedState=h.extend(!0,{},g);b.start!==k&&(a._iDisplayStart=b.start,a.iInitDisplayStart=b.start);b.length!==k&&(a._iDisplayLength=b.length);b.order!==k&&(a.aaSorting=[],h.each(b.order,function(b,c){a.aaSorting.push(c[0]>=f.length?[0,c[1]]:c)}));b.search!==
k&&h.extend(a.oPreviousSearch,Db(b.search));if(b.columns){d=0;for(e=b.columns.length;d<e;d++)i=b.columns[d],i.visible!==k&&(f[d].bVisible=i.visible),i.search!==k&&h.extend(a.aoPreSearchCols[d],Db(i.search))}s(a,"aoStateLoaded","stateLoaded",[a,g])}}c()};if(a.oFeatures.bStateSave){var g=a.fnStateLoadCallback.call(a.oInstance,a,b);g!==k&&b(g)}else c()}function Aa(a){var b=m.settings,a=h.inArray(a,D(b,"nTable"));return-1!==a?b[a]:null}function K(a,b,c,d){c="DataTables warning: "+(a?"table id="+a.sTableId+
" - ":"")+c;d&&(c+=". For more information about this error, please see http://datatables.net/tn/"+d);if(b)E.console&&console.log&&console.log(c);else if(b=m.ext,b=b.sErrMode||b.errMode,a&&s(a,null,"error",[a,d,c]),"alert"==b)alert(c);else{if("throw"==b)throw Error(c);"function"==typeof b&&b(a,d,c)}}function F(a,b,c,d){h.isArray(c)?h.each(c,function(c,d){h.isArray(d)?F(a,b,d[0],d[1]):F(a,b,d)}):(d===k&&(d=c),b[c]!==k&&(a[d]=b[c]))}function Mb(a,b,c){var d,e;for(e in b)b.hasOwnProperty(e)&&(d=b[e],
h.isPlainObject(d)?(h.isPlainObject(a[e])||(a[e]={}),h.extend(!0,a[e],d)):a[e]=c&&"data"!==e&&"aaData"!==e&&h.isArray(d)?d.slice():d);return a}function Ya(a,b,c){h(a).on("click.DT",b,function(b){a.blur();c(b)}).on("keypress.DT",b,function(a){13===a.which&&(a.preventDefault(),c(a))}).on("selectstart.DT",function(){return!1})}function z(a,b,c,d){c&&a[b].push({fn:c,sName:d})}function s(a,b,c,d){var e=[];b&&(e=h.map(a[b].slice().reverse(),function(b){return b.fn.apply(a.oInstance,d)}));null!==c&&(b=h.Event(c+
".dt"),h(a.nTable).trigger(b,d),e.push(b.result));return e}function Ua(a){var b=a._iDisplayStart,c=a.fnDisplayEnd(),d=a._iDisplayLength;b>=c&&(b=c-d);b-=b%d;if(-1===d||0>b)b=0;a._iDisplayStart=b}function Pa(a,b){var c=a.renderer,d=m.ext.renderer[b];return h.isPlainObject(c)&&c[b]?d[c[b]]||d._:"string"===typeof c?d[c]||d._:d._}function y(a){return a.oFeatures.bServerSide?"ssp":a.ajax||a.sAjaxSource?"ajax":"dom"}function ia(a,b){var c=[],c=Nb.numbers_length,d=Math.floor(c/2);b<=c?c=X(0,b):a<=d?(c=X(0,
c-2),c.push("ellipsis"),c.push(b-1)):(a>=b-1-d?c=X(b-(c-2),b):(c=X(a-d+2,a+d-1),c.push("ellipsis"),c.push(b-1)),c.splice(0,0,"ellipsis"),c.splice(0,0,0));c.DT_el="span";return c}function fb(a){h.each({num:function(b){return Ba(b,a)},"num-fmt":function(b){return Ba(b,a,Za)},"html-num":function(b){return Ba(b,a,Ca)},"html-num-fmt":function(b){return Ba(b,a,Ca,Za)}},function(b,c){x.type.order[b+a+"-pre"]=c;b.match(/^html\-/)&&(x.type.search[b+a]=x.type.search.html)})}function Ob(a){return function(){var b=
[Aa(this[m.ext.iApiIndex])].concat(Array.prototype.slice.call(arguments));return m.ext.internal[a].apply(this,b)}}var m=function(a){this.$=function(a,b){return this.api(!0).$(a,b)};this._=function(a,b){return this.api(!0).rows(a,b).data()};this.api=function(a){return a?new u(Aa(this[x.iApiIndex])):new u(this)};this.fnAddData=function(a,b){var c=this.api(!0),d=h.isArray(a)&&(h.isArray(a[0])||h.isPlainObject(a[0]))?c.rows.add(a):c.row.add(a);(b===k||b)&&c.draw();return d.flatten().toArray()};this.fnAdjustColumnSizing=
function(a){var b=this.api(!0).columns.adjust(),c=b.settings()[0],d=c.oScroll;a===k||a?b.draw(!1):(""!==d.sX||""!==d.sY)&&ma(c)};this.fnClearTable=function(a){var b=this.api(!0).clear();(a===k||a)&&b.draw()};this.fnClose=function(a){this.api(!0).row(a).child.hide()};this.fnDeleteRow=function(a,b,c){var d=this.api(!0),a=d.rows(a),e=a.settings()[0],h=e.aoData[a[0][0]];a.remove();b&&b.call(this,e,h);(c===k||c)&&d.draw();return h};this.fnDestroy=function(a){this.api(!0).destroy(a)};this.fnDraw=function(a){this.api(!0).draw(a)};
this.fnFilter=function(a,b,c,d,e,h){e=this.api(!0);null===b||b===k?e.search(a,c,d,h):e.column(b).search(a,c,d,h);e.draw()};this.fnGetData=function(a,b){var c=this.api(!0);if(a!==k){var d=a.nodeName?a.nodeName.toLowerCase():"";return b!==k||"td"==d||"th"==d?c.cell(a,b).data():c.row(a).data()||null}return c.data().toArray()};this.fnGetNodes=function(a){var b=this.api(!0);return a!==k?b.row(a).node():b.rows().nodes().flatten().toArray()};this.fnGetPosition=function(a){var b=this.api(!0),c=a.nodeName.toUpperCase();
return"TR"==c?b.row(a).index():"TD"==c||"TH"==c?(a=b.cell(a).index(),[a.row,a.columnVisible,a.column]):null};this.fnIsOpen=function(a){return this.api(!0).row(a).child.isShown()};this.fnOpen=function(a,b,c){return this.api(!0).row(a).child(b,c).show().child()[0]};this.fnPageChange=function(a,b){var c=this.api(!0).page(a);(b===k||b)&&c.draw(!1)};this.fnSetColumnVis=function(a,b,c){a=this.api(!0).column(a).visible(b);(c===k||c)&&a.columns.adjust().draw()};this.fnSettings=function(){return Aa(this[x.iApiIndex])};
this.fnSort=function(a){this.api(!0).order(a).draw()};this.fnSortListener=function(a,b,c){this.api(!0).order.listener(a,b,c)};this.fnUpdate=function(a,b,c,d,e){var h=this.api(!0);c===k||null===c?h.row(b).data(a):h.cell(b,c).data(a);(e===k||e)&&h.columns.adjust();(d===k||d)&&h.draw();return 0};this.fnVersionCheck=x.fnVersionCheck;var b=this,c=a===k,d=this.length;c&&(a={});this.oApi=this.internal=x.internal;for(var e in m.ext.internal)e&&(this[e]=Ob(e));this.each(function(){var e={},g=1<d?Mb(e,a,!0):
a,j=0,i,e=this.getAttribute("id"),n=!1,l=m.defaults,q=h(this);if("table"!=this.nodeName.toLowerCase())K(null,0,"Non-table node initialisation ("+this.nodeName+")",2);else{gb(l);hb(l.column);J(l,l,!0);J(l.column,l.column,!0);J(l,h.extend(g,q.data()));var r=m.settings,j=0;for(i=r.length;j<i;j++){var p=r[j];if(p.nTable==this||p.nTHead.parentNode==this||p.nTFoot&&p.nTFoot.parentNode==this){var u=g.bRetrieve!==k?g.bRetrieve:l.bRetrieve;if(c||u)return p.oInstance;if(g.bDestroy!==k?g.bDestroy:l.bDestroy){p.oInstance.fnDestroy();
break}else{K(p,0,"Cannot reinitialise DataTable",3);return}}if(p.sTableId==this.id){r.splice(j,1);break}}if(null===e||""===e)this.id=e="DataTables_Table_"+m.ext._unique++;var o=h.extend(!0,{},m.models.oSettings,{sDestroyWidth:q[0].style.width,sInstance:e,sTableId:e});o.nTable=this;o.oApi=b.internal;o.oInit=g;r.push(o);o.oInstance=1===b.length?b:q.dataTable();gb(g);g.oLanguage&&Fa(g.oLanguage);g.aLengthMenu&&!g.iDisplayLength&&(g.iDisplayLength=h.isArray(g.aLengthMenu[0])?g.aLengthMenu[0][0]:g.aLengthMenu[0]);
g=Mb(h.extend(!0,{},l),g);F(o.oFeatures,g,"bPaginate bLengthChange bFilter bSort bSortMulti bInfo bProcessing bAutoWidth bSortClasses bServerSide bDeferRender".split(" "));F(o,g,["asStripeClasses","ajax","fnServerData","fnFormatNumber","sServerMethod","aaSorting","aaSortingFixed","aLengthMenu","sPaginationType","sAjaxSource","sAjaxDataProp","iStateDuration","sDom","bSortCellsTop","iTabIndex","fnStateLoadCallback","fnStateSaveCallback","renderer","searchDelay","rowId",["iCookieDuration","iStateDuration"],
["oSearch","oPreviousSearch"],["aoSearchCols","aoPreSearchCols"],["iDisplayLength","_iDisplayLength"],["bJQueryUI","bJUI"]]);F(o.oScroll,g,[["sScrollX","sX"],["sScrollXInner","sXInner"],["sScrollY","sY"],["bScrollCollapse","bCollapse"]]);F(o.oLanguage,g,"fnInfoCallback");z(o,"aoDrawCallback",g.fnDrawCallback,"user");z(o,"aoServerParams",g.fnServerParams,"user");z(o,"aoStateSaveParams",g.fnStateSaveParams,"user");z(o,"aoStateLoadParams",g.fnStateLoadParams,"user");z(o,"aoStateLoaded",g.fnStateLoaded,
"user");z(o,"aoRowCallback",g.fnRowCallback,"user");z(o,"aoRowCreatedCallback",g.fnCreatedRow,"user");z(o,"aoHeaderCallback",g.fnHeaderCallback,"user");z(o,"aoFooterCallback",g.fnFooterCallback,"user");z(o,"aoInitComplete",g.fnInitComplete,"user");z(o,"aoPreDrawCallback",g.fnPreDrawCallback,"user");o.rowIdFn=R(g.rowId);ib(o);var t=o.oClasses;g.bJQueryUI?(h.extend(t,m.ext.oJUIClasses,g.oClasses),g.sDom===l.sDom&&"lfrtip"===l.sDom&&(o.sDom='<"H"lfr>t<"F"ip>'),o.renderer)?h.isPlainObject(o.renderer)&&
!o.renderer.header&&(o.renderer.header="jqueryui"):o.renderer="jqueryui":h.extend(t,m.ext.classes,g.oClasses);q.addClass(t.sTable);o.iInitDisplayStart===k&&(o.iInitDisplayStart=g.iDisplayStart,o._iDisplayStart=g.iDisplayStart);null!==g.iDeferLoading&&(o.bDeferLoading=!0,e=h.isArray(g.iDeferLoading),o._iRecordsDisplay=e?g.iDeferLoading[0]:g.iDeferLoading,o._iRecordsTotal=e?g.iDeferLoading[1]:g.iDeferLoading);var v=o.oLanguage;h.extend(!0,v,g.oLanguage);v.sUrl&&(h.ajax({dataType:"json",url:v.sUrl,success:function(a){Fa(a);
J(l.oLanguage,a);h.extend(true,v,a);ha(o)},error:function(){ha(o)}}),n=!0);null===g.asStripeClasses&&(o.asStripeClasses=[t.sStripeOdd,t.sStripeEven]);var e=o.asStripeClasses,x=q.children("tbody").find("tr").eq(0);-1!==h.inArray(!0,h.map(e,function(a){return x.hasClass(a)}))&&(h("tbody tr",this).removeClass(e.join(" ")),o.asDestroyStripes=e.slice());e=[];r=this.getElementsByTagName("thead");0!==r.length&&(ea(o.aoHeader,r[0]),e=ta(o));if(null===g.aoColumns){r=[];j=0;for(i=e.length;j<i;j++)r.push(null)}else r=
g.aoColumns;j=0;for(i=r.length;j<i;j++)Ga(o,e?e[j]:null);kb(o,g.aoColumnDefs,r,function(a,b){la(o,a,b)});if(x.length){var w=function(a,b){return a.getAttribute("data-"+b)!==null?b:null};h(x[0]).children("th, td").each(function(a,b){var c=o.aoColumns[a];if(c.mData===a){var d=w(b,"sort")||w(b,"order"),e=w(b,"filter")||w(b,"search");if(d!==null||e!==null){c.mData={_:a+".display",sort:d!==null?a+".@data-"+d:k,type:d!==null?a+".@data-"+d:k,filter:e!==null?a+".@data-"+e:k};la(o,a)}}})}var U=o.oFeatures,
e=function(){if(g.aaSorting===k){var a=o.aaSorting;j=0;for(i=a.length;j<i;j++)a[j][1]=o.aoColumns[j].asSorting[0]}ya(o);U.bSort&&z(o,"aoDrawCallback",function(){if(o.bSorted){var a=W(o),b={};h.each(a,function(a,c){b[c.src]=c.dir});s(o,null,"order",[o,a,b]);Kb(o)}});z(o,"aoDrawCallback",function(){(o.bSorted||y(o)==="ssp"||U.bDeferRender)&&ya(o)},"sc");var a=q.children("caption").each(function(){this._captionSide=h(this).css("caption-side")}),b=q.children("thead");b.length===0&&(b=h("<thead/>").appendTo(q));
o.nTHead=b[0];b=q.children("tbody");b.length===0&&(b=h("<tbody/>").appendTo(q));o.nTBody=b[0];b=q.children("tfoot");if(b.length===0&&a.length>0&&(o.oScroll.sX!==""||o.oScroll.sY!==""))b=h("<tfoot/>").appendTo(q);if(b.length===0||b.children().length===0)q.addClass(t.sNoFooter);else if(b.length>0){o.nTFoot=b[0];ea(o.aoFooter,o.nTFoot)}if(g.aaData)for(j=0;j<g.aaData.length;j++)N(o,g.aaData[j]);else(o.bDeferLoading||y(o)=="dom")&&oa(o,h(o.nTBody).children("tr"));o.aiDisplay=o.aiDisplayMaster.slice();
o.bInitialised=true;n===false&&ha(o)};g.bStateSave?(U.bStateSave=!0,z(o,"aoDrawCallback",za,"state_save"),Lb(o,g,e)):e()}});b=null;return this},x,u,p,t,$a={},Pb=/[\r\n]/g,Ca=/<.*?>/g,cc=/^\d{2,4}[\.\/\-]\d{1,2}[\.\/\-]\d{1,2}([T ]{1}\d{1,2}[:\.]\d{2}([\.:]\d{2})?)?$/,dc=RegExp("(\\/|\\.|\\*|\\+|\\?|\\||\\(|\\)|\\[|\\]|\\{|\\}|\\\\|\\$|\\^|\\-)","g"),Za=/[',$£€¥%\u2009\u202F\u20BD\u20a9\u20BArfk]/gi,M=function(a){return!a||!0===a||"-"===a?!0:!1},Qb=function(a){var b=parseInt(a,10);return!isNaN(b)&&
isFinite(a)?b:null},Rb=function(a,b){$a[b]||($a[b]=RegExp(Sa(b),"g"));return"string"===typeof a&&"."!==b?a.replace(/\./g,"").replace($a[b],"."):a},ab=function(a,b,c){var d="string"===typeof a;if(M(a))return!0;b&&d&&(a=Rb(a,b));c&&d&&(a=a.replace(Za,""));return!isNaN(parseFloat(a))&&isFinite(a)},Sb=function(a,b,c){return M(a)?!0:!(M(a)||"string"===typeof a)?null:ab(a.replace(Ca,""),b,c)?!0:null},D=function(a,b,c){var d=[],e=0,f=a.length;if(c!==k)for(;e<f;e++)a[e]&&a[e][b]&&d.push(a[e][b][c]);else for(;e<
f;e++)a[e]&&d.push(a[e][b]);return d},ja=function(a,b,c,d){var e=[],f=0,g=b.length;if(d!==k)for(;f<g;f++)a[b[f]][c]&&e.push(a[b[f]][c][d]);else for(;f<g;f++)e.push(a[b[f]][c]);return e},X=function(a,b){var c=[],d;b===k?(b=0,d=a):(d=b,b=a);for(var e=b;e<d;e++)c.push(e);return c},Tb=function(a){for(var b=[],c=0,d=a.length;c<d;c++)a[c]&&b.push(a[c]);return b},sa=function(a){var b=[],c,d,e=a.length,f,g=0;d=0;a:for(;d<e;d++){c=a[d];for(f=0;f<g;f++)if(b[f]===c)continue a;b.push(c);g++}return b};m.util=
{throttle:function(a,b){var c=b!==k?b:200,d,e;return function(){var b=this,g=+new Date,h=arguments;d&&g<d+c?(clearTimeout(e),e=setTimeout(function(){d=k;a.apply(b,h)},c)):(d=g,a.apply(b,h))}},escapeRegex:function(a){return a.replace(dc,"\\$1")}};var A=function(a,b,c){a[b]!==k&&(a[c]=a[b])},ca=/\[.*?\]$/,V=/\(\)$/,Sa=m.util.escapeRegex,xa=h("<div>")[0],$b=xa.textContent!==k,bc=/<.*?>/g,Qa=m.util.throttle,Ub=[],w=Array.prototype,ec=function(a){var b,c,d=m.settings,e=h.map(d,function(a){return a.nTable});
if(a){if(a.nTable&&a.oApi)return[a];if(a.nodeName&&"table"===a.nodeName.toLowerCase())return b=h.inArray(a,e),-1!==b?[d[b]]:null;if(a&&"function"===typeof a.settings)return a.settings().toArray();"string"===typeof a?c=h(a):a instanceof h&&(c=a)}else return[];if(c)return c.map(function(){b=h.inArray(this,e);return-1!==b?d[b]:null}).toArray()};u=function(a,b){if(!(this instanceof u))return new u(a,b);var c=[],d=function(a){(a=ec(a))&&(c=c.concat(a))};if(h.isArray(a))for(var e=0,f=a.length;e<f;e++)d(a[e]);
else d(a);this.context=sa(c);b&&h.merge(this,b);this.selector={rows:null,cols:null,opts:null};u.extend(this,this,Ub)};m.Api=u;h.extend(u.prototype,{any:function(){return 0!==this.count()},concat:w.concat,context:[],count:function(){return this.flatten().length},each:function(a){for(var b=0,c=this.length;b<c;b++)a.call(this,this[b],b,this);return this},eq:function(a){var b=this.context;return b.length>a?new u(b[a],this[a]):null},filter:function(a){var b=[];if(w.filter)b=w.filter.call(this,a,this);
else for(var c=0,d=this.length;c<d;c++)a.call(this,this[c],c,this)&&b.push(this[c]);return new u(this.context,b)},flatten:function(){var a=[];return new u(this.context,a.concat.apply(a,this.toArray()))},join:w.join,indexOf:w.indexOf||function(a,b){for(var c=b||0,d=this.length;c<d;c++)if(this[c]===a)return c;return-1},iterator:function(a,b,c,d){var e=[],f,g,h,i,n,l=this.context,m,p,t=this.selector;"string"===typeof a&&(d=c,c=b,b=a,a=!1);g=0;for(h=l.length;g<h;g++){var s=new u(l[g]);if("table"===b)f=
c.call(s,l[g],g),f!==k&&e.push(f);else if("columns"===b||"rows"===b)f=c.call(s,l[g],this[g],g),f!==k&&e.push(f);else if("column"===b||"column-rows"===b||"row"===b||"cell"===b){p=this[g];"column-rows"===b&&(m=Da(l[g],t.opts));i=0;for(n=p.length;i<n;i++)f=p[i],f="cell"===b?c.call(s,l[g],f.row,f.column,g,i):c.call(s,l[g],f,g,i,m),f!==k&&e.push(f)}}return e.length||d?(a=new u(l,a?e.concat.apply([],e):e),b=a.selector,b.rows=t.rows,b.cols=t.cols,b.opts=t.opts,a):this},lastIndexOf:w.lastIndexOf||function(a,
b){return this.indexOf.apply(this.toArray.reverse(),arguments)},length:0,map:function(a){var b=[];if(w.map)b=w.map.call(this,a,this);else for(var c=0,d=this.length;c<d;c++)b.push(a.call(this,this[c],c));return new u(this.context,b)},pluck:function(a){return this.map(function(b){return b[a]})},pop:w.pop,push:w.push,reduce:w.reduce||function(a,b){return jb(this,a,b,0,this.length,1)},reduceRight:w.reduceRight||function(a,b){return jb(this,a,b,this.length-1,-1,-1)},reverse:w.reverse,selector:null,shift:w.shift,
sort:w.sort,splice:w.splice,toArray:function(){return w.slice.call(this)},to$:function(){return h(this)},toJQuery:function(){return h(this)},unique:function(){return new u(this.context,sa(this))},unshift:w.unshift});u.extend=function(a,b,c){if(c.length&&b&&(b instanceof u||b.__dt_wrapper)){var d,e,f,g=function(a,b,c){return function(){var d=b.apply(a,arguments);u.extend(d,d,c.methodExt);return d}};d=0;for(e=c.length;d<e;d++)f=c[d],b[f.name]="function"===typeof f.val?g(a,f.val,f):h.isPlainObject(f.val)?
{}:f.val,b[f.name].__dt_wrapper=!0,u.extend(a,b[f.name],f.propExt)}};u.register=p=function(a,b){if(h.isArray(a))for(var c=0,d=a.length;c<d;c++)u.register(a[c],b);else for(var e=a.split("."),f=Ub,g,j,c=0,d=e.length;c<d;c++){g=(j=-1!==e[c].indexOf("()"))?e[c].replace("()",""):e[c];var i;a:{i=0;for(var n=f.length;i<n;i++)if(f[i].name===g){i=f[i];break a}i=null}i||(i={name:g,val:{},methodExt:[],propExt:[]},f.push(i));c===d-1?i.val=b:f=j?i.methodExt:i.propExt}};u.registerPlural=t=function(a,b,c){u.register(a,
c);u.register(b,function(){var a=c.apply(this,arguments);return a===this?this:a instanceof u?a.length?h.isArray(a[0])?new u(a.context,a[0]):a[0]:k:a})};p("tables()",function(a){var b;if(a){b=u;var c=this.context;if("number"===typeof a)a=[c[a]];else var d=h.map(c,function(a){return a.nTable}),a=h(d).filter(a).map(function(){var a=h.inArray(this,d);return c[a]}).toArray();b=new b(a)}else b=this;return b});p("table()",function(a){var a=this.tables(a),b=a.context;return b.length?new u(b[0]):a});t("tables().nodes()",
"table().node()",function(){return this.iterator("table",function(a){return a.nTable},1)});t("tables().body()","table().body()",function(){return this.iterator("table",function(a){return a.nTBody},1)});t("tables().header()","table().header()",function(){return this.iterator("table",function(a){return a.nTHead},1)});t("tables().footer()","table().footer()",function(){return this.iterator("table",function(a){return a.nTFoot},1)});t("tables().containers()","table().container()",function(){return this.iterator("table",
function(a){return a.nTableWrapper},1)});p("draw()",function(a){return this.iterator("table",function(b){"page"===a?O(b):("string"===typeof a&&(a="full-hold"===a?!1:!0),T(b,!1===a))})});p("page()",function(a){return a===k?this.page.info().page:this.iterator("table",function(b){Va(b,a)})});p("page.info()",function(){if(0===this.context.length)return k;var a=this.context[0],b=a._iDisplayStart,c=a.oFeatures.bPaginate?a._iDisplayLength:-1,d=a.fnRecordsDisplay(),e=-1===c;return{page:e?0:Math.floor(b/c),
pages:e?1:Math.ceil(d/c),start:b,end:a.fnDisplayEnd(),length:c,recordsTotal:a.fnRecordsTotal(),recordsDisplay:d,serverSide:"ssp"===y(a)}});p("page.len()",function(a){return a===k?0!==this.context.length?this.context[0]._iDisplayLength:k:this.iterator("table",function(b){Ta(b,a)})});var Vb=function(a,b,c){if(c){var d=new u(a);d.one("draw",function(){c(d.ajax.json())})}if("ssp"==y(a))T(a,b);else{C(a,!0);var e=a.jqXHR;e&&4!==e.readyState&&e.abort();ua(a,[],function(c){pa(a);for(var c=va(a,c),d=0,e=c.length;d<
e;d++)N(a,c[d]);T(a,b);C(a,!1)})}};p("ajax.json()",function(){var a=this.context;if(0<a.length)return a[0].json});p("ajax.params()",function(){var a=this.context;if(0<a.length)return a[0].oAjaxData});p("ajax.reload()",function(a,b){return this.iterator("table",function(c){Vb(c,!1===b,a)})});p("ajax.url()",function(a){var b=this.context;if(a===k){if(0===b.length)return k;b=b[0];return b.ajax?h.isPlainObject(b.ajax)?b.ajax.url:b.ajax:b.sAjaxSource}return this.iterator("table",function(b){h.isPlainObject(b.ajax)?
b.ajax.url=a:b.ajax=a})});p("ajax.url().load()",function(a,b){return this.iterator("table",function(c){Vb(c,!1===b,a)})});var bb=function(a,b,c,d,e){var f=[],g,j,i,n,l,m;i=typeof b;if(!b||"string"===i||"function"===i||b.length===k)b=[b];i=0;for(n=b.length;i<n;i++){j=b[i]&&b[i].split&&!b[i].match(/[\[\(:]/)?b[i].split(","):[b[i]];l=0;for(m=j.length;l<m;l++)(g=c("string"===typeof j[l]?h.trim(j[l]):j[l]))&&g.length&&(f=f.concat(g))}a=x.selector[a];if(a.length){i=0;for(n=a.length;i<n;i++)f=a[i](d,e,f)}return sa(f)},
cb=function(a){a||(a={});a.filter&&a.search===k&&(a.search=a.filter);return h.extend({search:"none",order:"current",page:"all"},a)},db=function(a){for(var b=0,c=a.length;b<c;b++)if(0<a[b].length)return a[0]=a[b],a[0].length=1,a.length=1,a.context=[a.context[b]],a;a.length=0;return a},Da=function(a,b){var c,d,e,f=[],g=a.aiDisplay;c=a.aiDisplayMaster;var j=b.search;d=b.order;e=b.page;if("ssp"==y(a))return"removed"===j?[]:X(0,c.length);if("current"==e){c=a._iDisplayStart;for(d=a.fnDisplayEnd();c<d;c++)f.push(g[c])}else if("current"==
d||"applied"==d)f="none"==j?c.slice():"applied"==j?g.slice():h.map(c,function(a){return-1===h.inArray(a,g)?a:null});else if("index"==d||"original"==d){c=0;for(d=a.aoData.length;c<d;c++)"none"==j?f.push(c):(e=h.inArray(c,g),(-1===e&&"removed"==j||0<=e&&"applied"==j)&&f.push(c))}return f};p("rows()",function(a,b){a===k?a="":h.isPlainObject(a)&&(b=a,a="");var b=cb(b),c=this.iterator("table",function(c){var e=b,f;return bb("row",a,function(a){var b=Qb(a);if(b!==null&&!e)return[b];f||(f=Da(c,e));if(b!==
null&&h.inArray(b,f)!==-1)return[b];if(a===null||a===k||a==="")return f;if(typeof a==="function")return h.map(f,function(b){var e=c.aoData[b];return a(b,e._aData,e.nTr)?b:null});b=Tb(ja(c.aoData,f,"nTr"));if(a.nodeName){if(a._DT_RowIndex!==k)return[a._DT_RowIndex];if(a._DT_CellIndex)return[a._DT_CellIndex.row];b=h(a).closest("*[data-dt-row]");return b.length?[b.data("dt-row")]:[]}if(typeof a==="string"&&a.charAt(0)==="#"){var i=c.aIds[a.replace(/^#/,"")];if(i!==k)return[i.idx]}return h(b).filter(a).map(function(){return this._DT_RowIndex}).toArray()},
c,e)},1);c.selector.rows=a;c.selector.opts=b;return c});p("rows().nodes()",function(){return this.iterator("row",function(a,b){return a.aoData[b].nTr||k},1)});p("rows().data()",function(){return this.iterator(!0,"rows",function(a,b){return ja(a.aoData,b,"_aData")},1)});t("rows().cache()","row().cache()",function(a){return this.iterator("row",function(b,c){var d=b.aoData[c];return"search"===a?d._aFilterData:d._aSortData},1)});t("rows().invalidate()","row().invalidate()",function(a){return this.iterator("row",
function(b,c){da(b,c,a)})});t("rows().indexes()","row().index()",function(){return this.iterator("row",function(a,b){return b},1)});t("rows().ids()","row().id()",function(a){for(var b=[],c=this.context,d=0,e=c.length;d<e;d++)for(var f=0,g=this[d].length;f<g;f++){var h=c[d].rowIdFn(c[d].aoData[this[d][f]]._aData);b.push((!0===a?"#":"")+h)}return new u(c,b)});t("rows().remove()","row().remove()",function(){var a=this;this.iterator("row",function(b,c,d){var e=b.aoData,f=e[c],g,h,i,n,l;e.splice(c,1);
g=0;for(h=e.length;g<h;g++)if(i=e[g],l=i.anCells,null!==i.nTr&&(i.nTr._DT_RowIndex=g),null!==l){i=0;for(n=l.length;i<n;i++)l[i]._DT_CellIndex.row=g}qa(b.aiDisplayMaster,c);qa(b.aiDisplay,c);qa(a[d],c,!1);Ua(b);c=b.rowIdFn(f._aData);c!==k&&delete b.aIds[c]});this.iterator("table",function(a){for(var c=0,d=a.aoData.length;c<d;c++)a.aoData[c].idx=c});return this});p("rows.add()",function(a){var b=this.iterator("table",function(b){var c,f,g,h=[];f=0;for(g=a.length;f<g;f++)c=a[f],c.nodeName&&"TR"===c.nodeName.toUpperCase()?
h.push(oa(b,c)[0]):h.push(N(b,c));return h},1),c=this.rows(-1);c.pop();h.merge(c,b);return c});p("row()",function(a,b){return db(this.rows(a,b))});p("row().data()",function(a){var b=this.context;if(a===k)return b.length&&this.length?b[0].aoData[this[0]]._aData:k;b[0].aoData[this[0]]._aData=a;da(b[0],this[0],"data");return this});p("row().node()",function(){var a=this.context;return a.length&&this.length?a[0].aoData[this[0]].nTr||null:null});p("row.add()",function(a){a instanceof h&&a.length&&(a=a[0]);
var b=this.iterator("table",function(b){return a.nodeName&&"TR"===a.nodeName.toUpperCase()?oa(b,a)[0]:N(b,a)});return this.row(b[0])});var eb=function(a,b){var c=a.context;if(c.length&&(c=c[0].aoData[b!==k?b:a[0]])&&c._details)c._details.remove(),c._detailsShow=k,c._details=k},Wb=function(a,b){var c=a.context;if(c.length&&a.length){var d=c[0].aoData[a[0]];if(d._details){(d._detailsShow=b)?d._details.insertAfter(d.nTr):d._details.detach();var e=c[0],f=new u(e),g=e.aoData;f.off("draw.dt.DT_details column-visibility.dt.DT_details destroy.dt.DT_details");
0<D(g,"_details").length&&(f.on("draw.dt.DT_details",function(a,b){e===b&&f.rows({page:"current"}).eq(0).each(function(a){a=g[a];a._detailsShow&&a._details.insertAfter(a.nTr)})}),f.on("column-visibility.dt.DT_details",function(a,b){if(e===b)for(var c,d=ba(b),f=0,h=g.length;f<h;f++)c=g[f],c._details&&c._details.children("td[colspan]").attr("colspan",d)}),f.on("destroy.dt.DT_details",function(a,b){if(e===b)for(var c=0,d=g.length;c<d;c++)g[c]._details&&eb(f,c)}))}}};p("row().child()",function(a,b){var c=
this.context;if(a===k)return c.length&&this.length?c[0].aoData[this[0]]._details:k;if(!0===a)this.child.show();else if(!1===a)eb(this);else if(c.length&&this.length){var d=c[0],c=c[0].aoData[this[0]],e=[],f=function(a,b){if(h.isArray(a)||a instanceof h)for(var c=0,k=a.length;c<k;c++)f(a[c],b);else a.nodeName&&"tr"===a.nodeName.toLowerCase()?e.push(a):(c=h("<tr><td/></tr>").addClass(b),h("td",c).addClass(b).html(a)[0].colSpan=ba(d),e.push(c[0]))};f(a,b);c._details&&c._details.detach();c._details=h(e);
c._detailsShow&&c._details.insertAfter(c.nTr)}return this});p(["row().child.show()","row().child().show()"],function(){Wb(this,!0);return this});p(["row().child.hide()","row().child().hide()"],function(){Wb(this,!1);return this});p(["row().child.remove()","row().child().remove()"],function(){eb(this);return this});p("row().child.isShown()",function(){var a=this.context;return a.length&&this.length?a[0].aoData[this[0]]._detailsShow||!1:!1});var fc=/^([^:]+):(name|visIdx|visible)$/,Xb=function(a,b,
c,d,e){for(var c=[],d=0,f=e.length;d<f;d++)c.push(B(a,e[d],b));return c};p("columns()",function(a,b){a===k?a="":h.isPlainObject(a)&&(b=a,a="");var b=cb(b),c=this.iterator("table",function(c){var e=a,f=b,g=c.aoColumns,j=D(g,"sName"),i=D(g,"nTh");return bb("column",e,function(a){var b=Qb(a);if(a==="")return X(g.length);if(b!==null)return[b>=0?b:g.length+b];if(typeof a==="function"){var e=Da(c,f);return h.map(g,function(b,f){return a(f,Xb(c,f,0,0,e),i[f])?f:null})}var k=typeof a==="string"?a.match(fc):
"";if(k)switch(k[2]){case "visIdx":case "visible":b=parseInt(k[1],10);if(b<0){var m=h.map(g,function(a,b){return a.bVisible?b:null});return[m[m.length+b]]}return[$(c,b)];case "name":return h.map(j,function(a,b){return a===k[1]?b:null});default:return[]}if(a.nodeName&&a._DT_CellIndex)return[a._DT_CellIndex.column];b=h(i).filter(a).map(function(){return h.inArray(this,i)}).toArray();if(b.length||!a.nodeName)return b;b=h(a).closest("*[data-dt-column]");return b.length?[b.data("dt-column")]:[]},c,f)},
1);c.selector.cols=a;c.selector.opts=b;return c});t("columns().header()","column().header()",function(){return this.iterator("column",function(a,b){return a.aoColumns[b].nTh},1)});t("columns().footer()","column().footer()",function(){return this.iterator("column",function(a,b){return a.aoColumns[b].nTf},1)});t("columns().data()","column().data()",function(){return this.iterator("column-rows",Xb,1)});t("columns().dataSrc()","column().dataSrc()",function(){return this.iterator("column",function(a,b){return a.aoColumns[b].mData},
1)});t("columns().cache()","column().cache()",function(a){return this.iterator("column-rows",function(b,c,d,e,f){return ja(b.aoData,f,"search"===a?"_aFilterData":"_aSortData",c)},1)});t("columns().nodes()","column().nodes()",function(){return this.iterator("column-rows",function(a,b,c,d,e){return ja(a.aoData,e,"anCells",b)},1)});t("columns().visible()","column().visible()",function(a,b){var c=this.iterator("column",function(b,c){if(a===k)return b.aoColumns[c].bVisible;var f=b.aoColumns,g=f[c],j=b.aoData,
i,n,l;if(a!==k&&g.bVisible!==a){if(a){var m=h.inArray(!0,D(f,"bVisible"),c+1);i=0;for(n=j.length;i<n;i++)l=j[i].nTr,f=j[i].anCells,l&&l.insertBefore(f[c],f[m]||null)}else h(D(b.aoData,"anCells",c)).detach();g.bVisible=a;fa(b,b.aoHeader);fa(b,b.aoFooter);za(b)}});a!==k&&(this.iterator("column",function(c,e){s(c,null,"column-visibility",[c,e,a,b])}),(b===k||b)&&this.columns.adjust());return c});t("columns().indexes()","column().index()",function(a){return this.iterator("column",function(b,c){return"visible"===
a?aa(b,c):c},1)});p("columns.adjust()",function(){return this.iterator("table",function(a){Z(a)},1)});p("column.index()",function(a,b){if(0!==this.context.length){var c=this.context[0];if("fromVisible"===a||"toData"===a)return $(c,b);if("fromData"===a||"toVisible"===a)return aa(c,b)}});p("column()",function(a,b){return db(this.columns(a,b))});p("cells()",function(a,b,c){h.isPlainObject(a)&&(a.row===k?(c=a,a=null):(c=b,b=null));h.isPlainObject(b)&&(c=b,b=null);if(null===b||b===k)return this.iterator("table",
function(b){var d=a,e=cb(c),f=b.aoData,g=Da(b,e),i=Tb(ja(f,g,"anCells")),j=h([].concat.apply([],i)),l,n=b.aoColumns.length,m,p,t,u,s,v;return bb("cell",d,function(a){var c=typeof a==="function";if(a===null||a===k||c){m=[];p=0;for(t=g.length;p<t;p++){l=g[p];for(u=0;u<n;u++){s={row:l,column:u};if(c){v=f[l];a(s,B(b,l,u),v.anCells?v.anCells[u]:null)&&m.push(s)}else m.push(s)}}return m}if(h.isPlainObject(a))return[a];c=j.filter(a).map(function(a,b){return{row:b._DT_CellIndex.row,column:b._DT_CellIndex.column}}).toArray();
if(c.length||!a.nodeName)return c;v=h(a).closest("*[data-dt-row]");return v.length?[{row:v.data("dt-row"),column:v.data("dt-column")}]:[]},b,e)});var d=this.columns(b,c),e=this.rows(a,c),f,g,j,i,n,l=this.iterator("table",function(a,b){f=[];g=0;for(j=e[b].length;g<j;g++){i=0;for(n=d[b].length;i<n;i++)f.push({row:e[b][g],column:d[b][i]})}return f},1);h.extend(l.selector,{cols:b,rows:a,opts:c});return l});t("cells().nodes()","cell().node()",function(){return this.iterator("cell",function(a,b,c){return(a=
a.aoData[b])&&a.anCells?a.anCells[c]:k},1)});p("cells().data()",function(){return this.iterator("cell",function(a,b,c){return B(a,b,c)},1)});t("cells().cache()","cell().cache()",function(a){a="search"===a?"_aFilterData":"_aSortData";return this.iterator("cell",function(b,c,d){return b.aoData[c][a][d]},1)});t("cells().render()","cell().render()",function(a){return this.iterator("cell",function(b,c,d){return B(b,c,d,a)},1)});t("cells().indexes()","cell().index()",function(){return this.iterator("cell",
function(a,b,c){return{row:b,column:c,columnVisible:aa(a,c)}},1)});t("cells().invalidate()","cell().invalidate()",function(a){return this.iterator("cell",function(b,c,d){da(b,c,a,d)})});p("cell()",function(a,b,c){return db(this.cells(a,b,c))});p("cell().data()",function(a){var b=this.context,c=this[0];if(a===k)return b.length&&c.length?B(b[0],c[0].row,c[0].column):k;lb(b[0],c[0].row,c[0].column,a);da(b[0],c[0].row,"data",c[0].column);return this});p("order()",function(a,b){var c=this.context;if(a===
k)return 0!==c.length?c[0].aaSorting:k;"number"===typeof a?a=[[a,b]]:a.length&&!h.isArray(a[0])&&(a=Array.prototype.slice.call(arguments));return this.iterator("table",function(b){b.aaSorting=a.slice()})});p("order.listener()",function(a,b,c){return this.iterator("table",function(d){Oa(d,a,b,c)})});p("order.fixed()",function(a){if(!a){var b=this.context,b=b.length?b[0].aaSortingFixed:k;return h.isArray(b)?{pre:b}:b}return this.iterator("table",function(b){b.aaSortingFixed=h.extend(!0,{},a)})});p(["columns().order()",
"column().order()"],function(a){var b=this;return this.iterator("table",function(c,d){var e=[];h.each(b[d],function(b,c){e.push([c,a])});c.aaSorting=e})});p("search()",function(a,b,c,d){var e=this.context;return a===k?0!==e.length?e[0].oPreviousSearch.sSearch:k:this.iterator("table",function(e){e.oFeatures.bFilter&&ga(e,h.extend({},e.oPreviousSearch,{sSearch:a+"",bRegex:null===b?!1:b,bSmart:null===c?!0:c,bCaseInsensitive:null===d?!0:d}),1)})});t("columns().search()","column().search()",function(a,
b,c,d){return this.iterator("column",function(e,f){var g=e.aoPreSearchCols;if(a===k)return g[f].sSearch;e.oFeatures.bFilter&&(h.extend(g[f],{sSearch:a+"",bRegex:null===b?!1:b,bSmart:null===c?!0:c,bCaseInsensitive:null===d?!0:d}),ga(e,e.oPreviousSearch,1))})});p("state()",function(){return this.context.length?this.context[0].oSavedState:null});p("state.clear()",function(){return this.iterator("table",function(a){a.fnStateSaveCallback.call(a.oInstance,a,{})})});p("state.loaded()",function(){return this.context.length?
this.context[0].oLoadedState:null});p("state.save()",function(){return this.iterator("table",function(a){za(a)})});m.versionCheck=m.fnVersionCheck=function(a){for(var b=m.version.split("."),a=a.split("."),c,d,e=0,f=a.length;e<f;e++)if(c=parseInt(b[e],10)||0,d=parseInt(a[e],10)||0,c!==d)return c>d;return!0};m.isDataTable=m.fnIsDataTable=function(a){var b=h(a).get(0),c=!1;if(a instanceof m.Api)return!0;h.each(m.settings,function(a,e){var f=e.nScrollHead?h("table",e.nScrollHead)[0]:null,g=e.nScrollFoot?
h("table",e.nScrollFoot)[0]:null;if(e.nTable===b||f===b||g===b)c=!0});return c};m.tables=m.fnTables=function(a){var b=!1;h.isPlainObject(a)&&(b=a.api,a=a.visible);var c=h.map(m.settings,function(b){if(!a||a&&h(b.nTable).is(":visible"))return b.nTable});return b?new u(c):c};m.camelToHungarian=J;p("$()",function(a,b){var c=this.rows(b).nodes(),c=h(c);return h([].concat(c.filter(a).toArray(),c.find(a).toArray()))});h.each(["on","one","off"],function(a,b){p(b+"()",function(){var a=Array.prototype.slice.call(arguments);
a[0]=h.map(a[0].split(/\s/),function(a){return!a.match(/\.dt\b/)?a+".dt":a}).join(" ");var d=h(this.tables().nodes());d[b].apply(d,a);return this})});p("clear()",function(){return this.iterator("table",function(a){pa(a)})});p("settings()",function(){return new u(this.context,this.context)});p("init()",function(){var a=this.context;return a.length?a[0].oInit:null});p("data()",function(){return this.iterator("table",function(a){return D(a.aoData,"_aData")}).flatten()});p("destroy()",function(a){a=a||
!1;return this.iterator("table",function(b){var c=b.nTableWrapper.parentNode,d=b.oClasses,e=b.nTable,f=b.nTBody,g=b.nTHead,j=b.nTFoot,i=h(e),f=h(f),k=h(b.nTableWrapper),l=h.map(b.aoData,function(a){return a.nTr}),p;b.bDestroying=!0;s(b,"aoDestroyCallback","destroy",[b]);a||(new u(b)).columns().visible(!0);k.off(".DT").find(":not(tbody *)").off(".DT");h(E).off(".DT-"+b.sInstance);e!=g.parentNode&&(i.children("thead").detach(),i.append(g));j&&e!=j.parentNode&&(i.children("tfoot").detach(),i.append(j));
b.aaSorting=[];b.aaSortingFixed=[];ya(b);h(l).removeClass(b.asStripeClasses.join(" "));h("th, td",g).removeClass(d.sSortable+" "+d.sSortableAsc+" "+d.sSortableDesc+" "+d.sSortableNone);b.bJUI&&(h("th span."+d.sSortIcon+", td span."+d.sSortIcon,g).detach(),h("th, td",g).each(function(){var a=h("div."+d.sSortJUIWrapper,this);h(this).append(a.contents());a.detach()}));f.children().detach();f.append(l);g=a?"remove":"detach";i[g]();k[g]();!a&&c&&(c.insertBefore(e,b.nTableReinsertBefore),i.css("width",
b.sDestroyWidth).removeClass(d.sTable),(p=b.asDestroyStripes.length)&&f.children().each(function(a){h(this).addClass(b.asDestroyStripes[a%p])}));c=h.inArray(b,m.settings);-1!==c&&m.settings.splice(c,1)})});h.each(["column","row","cell"],function(a,b){p(b+"s().every()",function(a){var d=this.selector.opts,e=this;return this.iterator(b,function(f,g,h,i,m){a.call(e[b](g,"cell"===b?h:d,"cell"===b?d:k),g,h,i,m)})})});p("i18n()",function(a,b,c){var d=this.context[0],a=R(a)(d.oLanguage);a===k&&(a=b);c!==
k&&h.isPlainObject(a)&&(a=a[c]!==k?a[c]:a._);return a.replace("%d",c)});m.version="1.10.13";m.settings=[];m.models={};m.models.oSearch={bCaseInsensitive:!0,sSearch:"",bRegex:!1,bSmart:!0};m.models.oRow={nTr:null,anCells:null,_aData:[],_aSortData:null,_aFilterData:null,_sFilterRow:null,_sRowStripe:"",src:null,idx:-1};m.models.oColumn={idx:null,aDataSort:null,asSorting:null,bSearchable:null,bSortable:null,bVisible:null,_sManualType:null,_bAttrSrc:!1,fnCreatedCell:null,fnGetData:null,fnSetData:null,
mData:null,mRender:null,nTh:null,nTf:null,sClass:null,sContentPadding:null,sDefaultContent:null,sName:null,sSortDataType:"std",sSortingClass:null,sSortingClassJUI:null,sTitle:null,sType:null,sWidth:null,sWidthOrig:null};m.defaults={aaData:null,aaSorting:[[0,"asc"]],aaSortingFixed:[],ajax:null,aLengthMenu:[10,25,50,100],aoColumns:null,aoColumnDefs:null,aoSearchCols:[],asStripeClasses:null,bAutoWidth:!0,bDeferRender:!1,bDestroy:!1,bFilter:!0,bInfo:!0,bJQueryUI:!1,bLengthChange:!0,bPaginate:!0,bProcessing:!1,
bRetrieve:!1,bScrollCollapse:!1,bServerSide:!1,bSort:!0,bSortMulti:!0,bSortCellsTop:!1,bSortClasses:!0,bStateSave:!1,fnCreatedRow:null,fnDrawCallback:null,fnFooterCallback:null,fnFormatNumber:function(a){return a.toString().replace(/\B(?=(\d{3})+(?!\d))/g,this.oLanguage.sThousands)},fnHeaderCallback:null,fnInfoCallback:null,fnInitComplete:null,fnPreDrawCallback:null,fnRowCallback:null,fnServerData:null,fnServerParams:null,fnStateLoadCallback:function(a){try{return JSON.parse((-1===a.iStateDuration?
sessionStorage:localStorage).getItem("DataTables_"+a.sInstance+"_"+location.pathname))}catch(b){}},fnStateLoadParams:null,fnStateLoaded:null,fnStateSaveCallback:function(a,b){try{(-1===a.iStateDuration?sessionStorage:localStorage).setItem("DataTables_"+a.sInstance+"_"+location.pathname,JSON.stringify(b))}catch(c){}},fnStateSaveParams:null,iStateDuration:7200,iDeferLoading:null,iDisplayLength:10,iDisplayStart:0,iTabIndex:0,oClasses:{},oLanguage:{oAria:{sSortAscending:": activate to sort column ascending",
sSortDescending:": activate to sort column descending"},oPaginate:{sFirst:"First",sLast:"Last",sNext:"Next",sPrevious:"Previous"},sEmptyTable:"No data available in table",sInfo:"Showing _START_ to _END_ of _TOTAL_ entries",sInfoEmpty:"Showing 0 to 0 of 0 entries",sInfoFiltered:"(filtered from _MAX_ total entries)",sInfoPostFix:"",sDecimal:"",sThousands:",",sLengthMenu:"Show _MENU_ entries",sLoadingRecords:"Loading...",sProcessing:"Processing...",sSearch:"Search:",sSearchPlaceholder:"",sUrl:"",sZeroRecords:"No matching records found"},
oSearch:h.extend({},m.models.oSearch),sAjaxDataProp:"data",sAjaxSource:null,sDom:"lfrtip",searchDelay:null,sPaginationType:"simple_numbers",sScrollX:"",sScrollXInner:"",sScrollY:"",sServerMethod:"GET",renderer:null,rowId:"DT_RowId"};Y(m.defaults);m.defaults.column={aDataSort:null,iDataSort:-1,asSorting:["asc","desc"],bSearchable:!0,bSortable:!0,bVisible:!0,fnCreatedCell:null,mData:null,mRender:null,sCellType:"td",sClass:"",sContentPadding:"",sDefaultContent:null,sName:"",sSortDataType:"std",sTitle:null,
sType:null,sWidth:null};Y(m.defaults.column);m.models.oSettings={oFeatures:{bAutoWidth:null,bDeferRender:null,bFilter:null,bInfo:null,bLengthChange:null,bPaginate:null,bProcessing:null,bServerSide:null,bSort:null,bSortMulti:null,bSortClasses:null,bStateSave:null},oScroll:{bCollapse:null,iBarWidth:0,sX:null,sXInner:null,sY:null},oLanguage:{fnInfoCallback:null},oBrowser:{bScrollOversize:!1,bScrollbarLeft:!1,bBounding:!1,barWidth:0},ajax:null,aanFeatures:[],aoData:[],aiDisplay:[],aiDisplayMaster:[],
aIds:{},aoColumns:[],aoHeader:[],aoFooter:[],oPreviousSearch:{},aoPreSearchCols:[],aaSorting:null,aaSortingFixed:[],asStripeClasses:null,asDestroyStripes:[],sDestroyWidth:0,aoRowCallback:[],aoHeaderCallback:[],aoFooterCallback:[],aoDrawCallback:[],aoRowCreatedCallback:[],aoPreDrawCallback:[],aoInitComplete:[],aoStateSaveParams:[],aoStateLoadParams:[],aoStateLoaded:[],sTableId:"",nTable:null,nTHead:null,nTFoot:null,nTBody:null,nTableWrapper:null,bDeferLoading:!1,bInitialised:!1,aoOpenRows:[],sDom:null,
searchDelay:null,sPaginationType:"two_button",iStateDuration:0,aoStateSave:[],aoStateLoad:[],oSavedState:null,oLoadedState:null,sAjaxSource:null,sAjaxDataProp:null,bAjaxDataGet:!0,jqXHR:null,json:k,oAjaxData:k,fnServerData:null,aoServerParams:[],sServerMethod:null,fnFormatNumber:null,aLengthMenu:null,iDraw:0,bDrawing:!1,iDrawError:-1,_iDisplayLength:10,_iDisplayStart:0,_iRecordsTotal:0,_iRecordsDisplay:0,bJUI:null,oClasses:{},bFiltered:!1,bSorted:!1,bSortCellsTop:null,oInit:null,aoDestroyCallback:[],
fnRecordsTotal:function(){return"ssp"==y(this)?1*this._iRecordsTotal:this.aiDisplayMaster.length},fnRecordsDisplay:function(){return"ssp"==y(this)?1*this._iRecordsDisplay:this.aiDisplay.length},fnDisplayEnd:function(){var a=this._iDisplayLength,b=this._iDisplayStart,c=b+a,d=this.aiDisplay.length,e=this.oFeatures,f=e.bPaginate;return e.bServerSide?!1===f||-1===a?b+d:Math.min(b+a,this._iRecordsDisplay):!f||c>d||-1===a?d:c},oInstance:null,sInstance:null,iTabIndex:0,nScrollHead:null,nScrollFoot:null,
aLastSort:[],oPlugins:{},rowIdFn:null,rowId:null};m.ext=x={buttons:{},classes:{},builder:"-source-",errMode:"alert",feature:[],search:[],selector:{cell:[],column:[],row:[]},internal:{},legacy:{ajax:null},pager:{},renderer:{pageButton:{},header:{}},order:{},type:{detect:[],search:{},order:{}},_unique:0,fnVersionCheck:m.fnVersionCheck,iApiIndex:0,oJUIClasses:{},sVersion:m.version};h.extend(x,{afnFiltering:x.search,aTypes:x.type.detect,ofnSearch:x.type.search,oSort:x.type.order,afnSortData:x.order,aoFeatures:x.feature,
oApi:x.internal,oStdClasses:x.classes,oPagination:x.pager});h.extend(m.ext.classes,{sTable:"dataTable",sNoFooter:"no-footer",sPageButton:"paginate_button",sPageButtonActive:"current",sPageButtonDisabled:"disabled",sStripeOdd:"odd",sStripeEven:"even",sRowEmpty:"dataTables_empty",sWrapper:"dataTables_wrapper",sFilter:"dataTables_filter",sInfo:"dataTables_info",sPaging:"dataTables_paginate paging_",sLength:"dataTables_length",sProcessing:"dataTables_processing",sSortAsc:"sorting_asc",sSortDesc:"sorting_desc",
sSortable:"sorting",sSortableAsc:"sorting_asc_disabled",sSortableDesc:"sorting_desc_disabled",sSortableNone:"sorting_disabled",sSortColumn:"sorting_",sFilterInput:"",sLengthSelect:"",sScrollWrapper:"dataTables_scroll",sScrollHead:"dataTables_scrollHead",sScrollHeadInner:"dataTables_scrollHeadInner",sScrollBody:"dataTables_scrollBody",sScrollFoot:"dataTables_scrollFoot",sScrollFootInner:"dataTables_scrollFootInner",sHeaderTH:"",sFooterTH:"",sSortJUIAsc:"",sSortJUIDesc:"",sSortJUI:"",sSortJUIAscAllowed:"",
sSortJUIDescAllowed:"",sSortJUIWrapper:"",sSortIcon:"",sJUIHeader:"",sJUIFooter:""});var Ea="",Ea="",G=Ea+"ui-state-default",ka=Ea+"css_right ui-icon ui-icon-",Yb=Ea+"fg-toolbar ui-toolbar ui-widget-header ui-helper-clearfix";h.extend(m.ext.oJUIClasses,m.ext.classes,{sPageButton:"fg-button ui-button "+G,sPageButtonActive:"ui-state-disabled",sPageButtonDisabled:"ui-state-disabled",sPaging:"dataTables_paginate fg-buttonset ui-buttonset fg-buttonset-multi ui-buttonset-multi paging_",sSortAsc:G+" sorting_asc",
sSortDesc:G+" sorting_desc",sSortable:G+" sorting",sSortableAsc:G+" sorting_asc_disabled",sSortableDesc:G+" sorting_desc_disabled",sSortableNone:G+" sorting_disabled",sSortJUIAsc:ka+"triangle-1-n",sSortJUIDesc:ka+"triangle-1-s",sSortJUI:ka+"carat-2-n-s",sSortJUIAscAllowed:ka+"carat-1-n",sSortJUIDescAllowed:ka+"carat-1-s",sSortJUIWrapper:"DataTables_sort_wrapper",sSortIcon:"DataTables_sort_icon",sScrollHead:"dataTables_scrollHead "+G,sScrollFoot:"dataTables_scrollFoot "+G,sHeaderTH:G,sFooterTH:G,sJUIHeader:Yb+
" ui-corner-tl ui-corner-tr",sJUIFooter:Yb+" ui-corner-bl ui-corner-br"});var Nb=m.ext.pager;h.extend(Nb,{simple:function(){return["previous","next"]},full:function(){return["first","previous","next","last"]},numbers:function(a,b){return[ia(a,b)]},simple_numbers:function(a,b){return["previous",ia(a,b),"next"]},full_numbers:function(a,b){return["first","previous",ia(a,b),"next","last"]},first_last_numbers:function(a,b){return["first",ia(a,b),"last"]},_numbers:ia,numbers_length:7});h.extend(!0,m.ext.renderer,
{pageButton:{_:function(a,b,c,d,e,f){var g=a.oClasses,j=a.oLanguage.oPaginate,i=a.oLanguage.oAria.paginate||{},m,l,p=0,r=function(b,d){var k,t,u,s,v=function(b){Va(a,b.data.action,true)};k=0;for(t=d.length;k<t;k++){s=d[k];if(h.isArray(s)){u=h("<"+(s.DT_el||"div")+"/>").appendTo(b);r(u,s)}else{m=null;l="";switch(s){case "ellipsis":b.append('<span class="ellipsis">&#x2026;</span>');break;case "first":m=j.sFirst;l=s+(e>0?"":" "+g.sPageButtonDisabled);break;case "previous":m=j.sPrevious;l=s+(e>0?"":" "+
g.sPageButtonDisabled);break;case "next":m=j.sNext;l=s+(e<f-1?"":" "+g.sPageButtonDisabled);break;case "last":m=j.sLast;l=s+(e<f-1?"":" "+g.sPageButtonDisabled);break;default:m=s+1;l=e===s?g.sPageButtonActive:""}if(m!==null){u=h("<a>",{"class":g.sPageButton+" "+l,"aria-controls":a.sTableId,"aria-label":i[s],"data-dt-idx":p,tabindex:a.iTabIndex,id:c===0&&typeof s==="string"?a.sTableId+"_"+s:null}).html(m).appendTo(b);Ya(u,{action:s},v);p++}}}},t;try{t=h(b).find(H.activeElement).data("dt-idx")}catch(u){}r(h(b).empty(),
d);t!==k&&h(b).find("[data-dt-idx="+t+"]").focus()}}});h.extend(m.ext.type.detect,[function(a,b){var c=b.oLanguage.sDecimal;return ab(a,c)?"num"+c:null},function(a){if(a&&!(a instanceof Date)&&!cc.test(a))return null;var b=Date.parse(a);return null!==b&&!isNaN(b)||M(a)?"date":null},function(a,b){var c=b.oLanguage.sDecimal;return ab(a,c,!0)?"num-fmt"+c:null},function(a,b){var c=b.oLanguage.sDecimal;return Sb(a,c)?"html-num"+c:null},function(a,b){var c=b.oLanguage.sDecimal;return Sb(a,c,!0)?"html-num-fmt"+
c:null},function(a){return M(a)||"string"===typeof a&&-1!==a.indexOf("<")?"html":null}]);h.extend(m.ext.type.search,{html:function(a){return M(a)?a:"string"===typeof a?a.replace(Pb," ").replace(Ca,""):""},string:function(a){return M(a)?a:"string"===typeof a?a.replace(Pb," "):a}});var Ba=function(a,b,c,d){if(0!==a&&(!a||"-"===a))return-Infinity;b&&(a=Rb(a,b));a.replace&&(c&&(a=a.replace(c,"")),d&&(a=a.replace(d,"")));return 1*a};h.extend(x.type.order,{"date-pre":function(a){return Date.parse(a)||-Infinity},
"html-pre":function(a){return M(a)?"":a.replace?a.replace(/<.*?>/g,"").toLowerCase():a+""},"string-pre":function(a){return M(a)?"":"string"===typeof a?a.toLowerCase():!a.toString?"":a.toString()},"string-asc":function(a,b){return a<b?-1:a>b?1:0},"string-desc":function(a,b){return a<b?1:a>b?-1:0}});fb("");h.extend(!0,m.ext.renderer,{header:{_:function(a,b,c,d){h(a.nTable).on("order.dt.DT",function(e,f,g,h){if(a===f){e=c.idx;b.removeClass(c.sSortingClass+" "+d.sSortAsc+" "+d.sSortDesc).addClass(h[e]==
"asc"?d.sSortAsc:h[e]=="desc"?d.sSortDesc:c.sSortingClass)}})},jqueryui:function(a,b,c,d){h("<div/>").addClass(d.sSortJUIWrapper).append(b.contents()).append(h("<span/>").addClass(d.sSortIcon+" "+c.sSortingClassJUI)).appendTo(b);h(a.nTable).on("order.dt.DT",function(e,f,g,h){if(a===f){e=c.idx;b.removeClass(d.sSortAsc+" "+d.sSortDesc).addClass(h[e]=="asc"?d.sSortAsc:h[e]=="desc"?d.sSortDesc:c.sSortingClass);b.find("span."+d.sSortIcon).removeClass(d.sSortJUIAsc+" "+d.sSortJUIDesc+" "+d.sSortJUI+" "+
d.sSortJUIAscAllowed+" "+d.sSortJUIDescAllowed).addClass(h[e]=="asc"?d.sSortJUIAsc:h[e]=="desc"?d.sSortJUIDesc:c.sSortingClassJUI)}})}}});var Zb=function(a){return"string"===typeof a?a.replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"):a};m.render={number:function(a,b,c,d,e){return{display:function(f){if("number"!==typeof f&&"string"!==typeof f)return f;var g=0>f?"-":"",h=parseFloat(f);if(isNaN(h))return Zb(f);h=h.toFixed(c);f=Math.abs(h);h=parseInt(f,10);f=c?b+(f-h).toFixed(c).substring(2):
"";return g+(d||"")+h.toString().replace(/\B(?=(\d{3})+(?!\d))/g,a)+f+(e||"")}}},text:function(){return{display:Zb}}};h.extend(m.ext.internal,{_fnExternApiFunc:Ob,_fnBuildAjax:ua,_fnAjaxUpdate:nb,_fnAjaxParameters:wb,_fnAjaxUpdateDraw:xb,_fnAjaxDataSrc:va,_fnAddColumn:Ga,_fnColumnOptions:la,_fnAdjustColumnSizing:Z,_fnVisibleToColumnIndex:$,_fnColumnIndexToVisible:aa,_fnVisbleColumns:ba,_fnGetColumns:na,_fnColumnTypes:Ia,_fnApplyColumnDefs:kb,_fnHungarianMap:Y,_fnCamelToHungarian:J,_fnLanguageCompat:Fa,
_fnBrowserDetect:ib,_fnAddData:N,_fnAddTr:oa,_fnNodeToDataIndex:function(a,b){return b._DT_RowIndex!==k?b._DT_RowIndex:null},_fnNodeToColumnIndex:function(a,b,c){return h.inArray(c,a.aoData[b].anCells)},_fnGetCellData:B,_fnSetCellData:lb,_fnSplitObjNotation:La,_fnGetObjectDataFn:R,_fnSetObjectDataFn:S,_fnGetDataMaster:Ma,_fnClearTable:pa,_fnDeleteIndex:qa,_fnInvalidate:da,_fnGetRowElements:Ka,_fnCreateTr:Ja,_fnBuildHead:mb,_fnDrawHead:fa,_fnDraw:O,_fnReDraw:T,_fnAddOptionsHtml:pb,_fnDetectHeader:ea,
_fnGetUniqueThs:ta,_fnFeatureHtmlFilter:rb,_fnFilterComplete:ga,_fnFilterCustom:Ab,_fnFilterColumn:zb,_fnFilter:yb,_fnFilterCreateSearch:Ra,_fnEscapeRegex:Sa,_fnFilterData:Bb,_fnFeatureHtmlInfo:ub,_fnUpdateInfo:Eb,_fnInfoMacros:Fb,_fnInitialise:ha,_fnInitComplete:wa,_fnLengthChange:Ta,_fnFeatureHtmlLength:qb,_fnFeatureHtmlPaginate:vb,_fnPageChange:Va,_fnFeatureHtmlProcessing:sb,_fnProcessingDisplay:C,_fnFeatureHtmlTable:tb,_fnScrollDraw:ma,_fnApplyToChildren:I,_fnCalculateColumnWidths:Ha,_fnThrottle:Qa,
_fnConvertToWidth:Gb,_fnGetWidestNode:Hb,_fnGetMaxLenString:Ib,_fnStringToCss:v,_fnSortFlatten:W,_fnSort:ob,_fnSortAria:Kb,_fnSortListener:Xa,_fnSortAttachListener:Oa,_fnSortingClasses:ya,_fnSortData:Jb,_fnSaveState:za,_fnLoadState:Lb,_fnSettingsFromNode:Aa,_fnLog:K,_fnMap:F,_fnBindAction:Ya,_fnCallbackReg:z,_fnCallbackFire:s,_fnLengthOverflow:Ua,_fnRenderer:Pa,_fnDataSource:y,_fnRowAttributes:Na,_fnCalculateEnd:function(){}});h.fn.dataTable=m;m.$=h;h.fn.dataTableSettings=m.settings;h.fn.dataTableExt=
m.ext;h.fn.DataTable=function(a){return h(this).dataTable(a).api()};h.each(m,function(a,b){h.fn.DataTable[a]=b});return h.fn.dataTable});

/*!
 DataTables Bootstrap 3 integration
 ©2011-2015 SpryMedia Ltd - datatables.net/license
*/
(function(b){"function"===typeof define&&define.amd?define(["jquery","datatables.net"],function(a){return b(a,window,document)}):"object"===typeof exports?module.exports=function(a,d){a||(a=window);if(!d||!d.fn.dataTable)d=require("datatables.net")(a,d).$;return b(d,a,a.document)}:b(jQuery,window,document)})(function(b,a,d,m){var f=b.fn.dataTable;b.extend(!0,f.defaults,{dom:"<'row'<'col-sm-6'l><'col-sm-6'f>><'row'<'col-sm-12'tr>><'row'<'col-sm-5'i><'col-sm-7'p>>",renderer:"bootstrap"});b.extend(f.ext.classes,
{sWrapper:"dataTables_wrapper form-inline dt-bootstrap",sFilterInput:"form-control input-sm",sLengthSelect:"form-control input-sm",sProcessing:"dataTables_processing panel panel-default"});f.ext.renderer.pageButton.bootstrap=function(a,h,r,s,j,n){var o=new f.Api(a),t=a.oClasses,k=a.oLanguage.oPaginate,u=a.oLanguage.oAria.paginate||{},e,g,p=0,q=function(d,f){var l,h,i,c,m=function(a){a.preventDefault();!b(a.currentTarget).hasClass("disabled")&&o.page()!=a.data.action&&o.page(a.data.action).draw("page")};
l=0;for(h=f.length;l<h;l++)if(c=f[l],b.isArray(c))q(d,c);else{g=e="";switch(c){case "ellipsis":e="&#x2026;";g="disabled";break;case "first":e=k.sFirst;g=c+(0<j?"":" disabled");break;case "previous":e=k.sPrevious;g=c+(0<j?"":" disabled");break;case "next":e=k.sNext;g=c+(j<n-1?"":" disabled");break;case "last":e=k.sLast;g=c+(j<n-1?"":" disabled");break;default:e=c+1,g=j===c?"active":""}e&&(i=b("<li>",{"class":t.sPageButton+" "+g,id:0===r&&"string"===typeof c?a.sTableId+"_"+c:null}).append(b("<a>",{href:"#",
"aria-controls":a.sTableId,"aria-label":u[c],"data-dt-idx":p,tabindex:a.iTabIndex}).html(e)).appendTo(d),a.oApi._fnBindAction(i,{action:c},m),p++)}},i;try{i=b(h).find(d.activeElement).data("dt-idx")}catch(v){}q(b(h).empty().html('<ul class="pagination"/>').children("ul"),s);i!==m&&b(h).find("[data-dt-idx="+i+"]").focus()};return f});

/*! jquery.tablednd.js 11-12-2014 */
!function(a,b,c,d){var e="ontouchstart"in c.documentElement,f=e?"touchstart":"mousedown",g=e?"touchmove":"mousemove",h=e?"touchend":"mouseup";e&&a.each("touchstart touchmove touchend".split(" "),function(b,c){a.event.fixHooks[c]=a.event.mouseHooks}),a(c).ready(function(){function b(a){for(var b={},c=a.match(/([^;:]+)/g)||[];c.length;)b[c.shift()]=c.shift().trim();return b}a("table").each(function(){"dnd"==a(this).data("table")&&a(this).tableDnD({onDragStyle:a(this).data("ondragstyle")&&b(a(this).data("ondragstyle"))||null,onDropStyle:a(this).data("ondropstyle")&&b(a(this).data("ondropstyle"))||null,onDragClass:a(this).data("ondragclass")==d&&"tDnD_whileDrag"||a(this).data("ondragclass"),onDrop:a(this).data("ondrop")&&new Function("table","row",a(this).data("ondrop")),onDragStart:a(this).data("ondragstart")&&new Function("table","row",a(this).data("ondragstart")),scrollAmount:a(this).data("scrollamount")||5,sensitivity:a(this).data("sensitivity")||10,hierarchyLevel:a(this).data("hierarchylevel")||0,indentArtifact:a(this).data("indentartifact")||'<div class="indent">&nbsp;</div>',autoWidthAdjust:a(this).data("autowidthadjust")||!0,autoCleanRelations:a(this).data("autocleanrelations")||!0,jsonPretifySeparator:a(this).data("jsonpretifyseparator")||"	",serializeRegexp:a(this).data("serializeregexp")&&new RegExp(a(this).data("serializeregexp"))||/[^\-]*$/,serializeParamName:a(this).data("serializeparamname")||!1,dragHandle:a(this).data("draghandle")||null})})}),jQuery.tableDnD={currentTable:null,dragObject:null,mouseOffset:null,oldX:0,oldY:0,build:function(b){return this.each(function(){this.tableDnDConfig=a.extend({onDragStyle:null,onDropStyle:null,onDragClass:"tDnD_whileDrag",onDrop:null,onDragStart:null,scrollAmount:5,sensitivity:10,hierarchyLevel:0,indentArtifact:'<div class="indent">&nbsp;</div>',autoWidthAdjust:!0,autoCleanRelations:!0,jsonPretifySeparator:"	",serializeRegexp:/[^\-]*$/,serializeParamName:!1,dragHandle:null},b||{}),a.tableDnD.makeDraggable(this),this.tableDnDConfig.hierarchyLevel&&a.tableDnD.makeIndented(this)}),this},makeIndented:function(b){var c,d,e=b.tableDnDConfig,f=b.rows,g=a(f).first().find("td:first")[0],h=0,i=0;if(a(b).hasClass("indtd"))return null;d=a(b).addClass("indtd").attr("style"),a(b).css({whiteSpace:"nowrap"});for(var j=0;j<f.length;j++)i<a(f[j]).find("td:first").text().length&&(i=a(f[j]).find("td:first").text().length,c=j);for(a(g).css({width:"auto"}),j=0;j<e.hierarchyLevel;j++)a(f[c]).find("td:first").prepend(e.indentArtifact);for(g&&a(g).css({width:g.offsetWidth}),d&&a(b).css(d),j=0;j<e.hierarchyLevel;j++)a(f[c]).find("td:first").children(":first").remove();return e.hierarchyLevel&&a(f).each(function(){h=a(this).data("level")||0,h<=e.hierarchyLevel&&a(this).data("level",h)||a(this).data("level",0);for(var b=0;b<a(this).data("level");b++)a(this).find("td:first").prepend(e.indentArtifact)}),this},makeDraggable:function(b){var c=b.tableDnDConfig;c.dragHandle&&a(c.dragHandle,b).each(function(){a(this).bind(f,function(d){return a.tableDnD.initialiseDrag(a(this).parents("tr")[0],b,this,d,c),!1})})||a(b.rows).each(function(){a(this).hasClass("nodrag")||a(this).bind(f,function(d){return"TD"==d.target.tagName?(a.tableDnD.initialiseDrag(this,b,this,d,c),!1):void 0}).css("cursor","move")})},currentOrder:function(){var b=this.currentTable.rows;return a.map(b,function(b){return(a(b).data("level")+b.id).replace(/\s/g,"")}).join("")},initialiseDrag:function(b,d,e,f,i){this.dragObject=b,this.currentTable=d,this.mouseOffset=this.getMouseOffset(e,f),this.originalOrder=this.currentOrder(),a(c).bind(g,this.mousemove).bind(h,this.mouseup),i.onDragStart&&i.onDragStart(d,e)},updateTables:function(){this.each(function(){this.tableDnDConfig&&a.tableDnD.makeDraggable(this)})},mouseCoords:function(a){return e?{x:event.changedTouches[0].clientX,y:event.changedTouches[0].clientY}:a.pageX||a.pageY?{x:a.pageX,y:a.pageY}:{x:a.clientX+c.body.scrollLeft-c.body.clientLeft,y:a.clientY+c.body.scrollTop-c.body.clientTop}},getMouseOffset:function(a,c){var d,e;return c=c||b.event,e=this.getPosition(a),d=this.mouseCoords(c),{x:d.x-e.x,y:d.y-e.y}},getPosition:function(a){var b=0,c=0;for(0==a.offsetHeight&&(a=a.firstChild);a.offsetParent;)b+=a.offsetLeft,c+=a.offsetTop,a=a.offsetParent;return b+=a.offsetLeft,c+=a.offsetTop,{x:b,y:c}},autoScroll:function(a){var d=this.currentTable.tableDnDConfig,e=b.pageYOffset,f=b.innerHeight?b.innerHeight:c.documentElement.clientHeight?c.documentElement.clientHeight:c.body.clientHeight;c.all&&("undefined"!=typeof c.compatMode&&"BackCompat"!=c.compatMode?e=c.documentElement.scrollTop:"undefined"!=typeof c.body&&(e=c.body.scrollTop)),a.y-e<d.scrollAmount&&b.scrollBy(0,-d.scrollAmount)||f-(a.y-e)<d.scrollAmount&&b.scrollBy(0,d.scrollAmount)},moveVerticle:function(a,b){0!=a.vertical&&b&&this.dragObject!=b&&this.dragObject.parentNode==b.parentNode&&(0>a.vertical&&this.dragObject.parentNode.insertBefore(this.dragObject,b.nextSibling)||0<a.vertical&&this.dragObject.parentNode.insertBefore(this.dragObject,b))},moveHorizontal:function(b,c){var d,e=this.currentTable.tableDnDConfig;return e.hierarchyLevel&&0!=b.horizontal&&c&&this.dragObject==c?(d=a(c).data("level"),0<b.horizontal&&d>0&&a(c).find("td:first").children(":first").remove()&&a(c).data("level",--d),void(0>b.horizontal&&d<e.hierarchyLevel&&a(c).prev().data("level")>=d&&a(c).children(":first").prepend(e.indentArtifact)&&a(c).data("level",++d))):null},mousemove:function(b){var c,d,e,f,g,h=a(a.tableDnD.dragObject),i=a.tableDnD.currentTable.tableDnDConfig;return b&&b.preventDefault(),a.tableDnD.dragObject?("touchmove"==b.type&&event.preventDefault(),i.onDragClass&&h.addClass(i.onDragClass)||h.css(i.onDragStyle),d=a.tableDnD.mouseCoords(b),f=d.x-a.tableDnD.mouseOffset.x,g=d.y-a.tableDnD.mouseOffset.y,a.tableDnD.autoScroll(d),c=a.tableDnD.findDropTargetRow(h,g),e=a.tableDnD.findDragDirection(f,g),a.tableDnD.moveVerticle(e,c),a.tableDnD.moveHorizontal(e,c),!1):!1},findDragDirection:function(a,b){var c=this.currentTable.tableDnDConfig.sensitivity,d=this.oldX,e=this.oldY,f=d-c,g=d+c,h=e-c,i=e+c,j={horizontal:a>=f&&g>=a?0:a>d?-1:1,vertical:b>=h&&i>=b?0:b>e?-1:1};return 0!=j.horizontal&&(this.oldX=a),0!=j.vertical&&(this.oldY=b),j},findDropTargetRow:function(b,c){for(var d=0,e=this.currentTable.rows,f=this.currentTable.tableDnDConfig,g=0,h=null,i=0;i<e.length;i++)if(h=e[i],g=this.getPosition(h).y,d=parseInt(h.offsetHeight)/2,0==h.offsetHeight&&(g=this.getPosition(h.firstChild).y,d=parseInt(h.firstChild.offsetHeight)/2),c>g-d&&g+d>c)return b.is(h)||f.onAllowDrop&&!f.onAllowDrop(b,h)||a(h).hasClass("nodrop")?null:h;return null},processMouseup:function(){var b=this.currentTable.tableDnDConfig,d=this.dragObject,e=0,f=0;return this.currentTable&&d?(a(c).unbind(g,this.mousemove).unbind(h,this.mouseup),b.hierarchyLevel&&b.autoCleanRelations&&a(this.currentTable.rows).first().find("td:first").children().each(function(){f=a(this).parents("tr:first").data("level"),f&&a(this).parents("tr:first").data("level",--f)&&a(this).remove()})&&b.hierarchyLevel>1&&a(this.currentTable.rows).each(function(){if(f=a(this).data("level"),f>1)for(e=a(this).prev().data("level");f>e+1;)a(this).find("td:first").children(":first").remove(),a(this).data("level",--f)}),b.onDragClass&&a(d).removeClass(b.onDragClass)||a(d).css(b.onDropStyle),this.dragObject=null,b.onDrop&&this.originalOrder!=this.currentOrder()&&a(d).hide().fadeIn("fast")&&b.onDrop(this.currentTable,d),void(this.currentTable=null)):null},mouseup:function(b){return b&&b.preventDefault(),a.tableDnD.processMouseup(),!1},jsonize:function(a){var b=this.currentTable;return a?JSON.stringify(this.tableData(b),null,b.tableDnDConfig.jsonPretifySeparator):JSON.stringify(this.tableData(b))},serialize:function(){return a.param(this.tableData(this.currentTable))},serializeTable:function(a){for(var b="",c=a.tableDnDConfig.serializeParamName||a.id,d=a.rows,e=0;e<d.length;e++){b.length>0&&(b+="&");var f=d[e].id;f&&a.tableDnDConfig&&a.tableDnDConfig.serializeRegexp&&(f=f.match(a.tableDnDConfig.serializeRegexp)[0],b+=c+"[]="+f)}return b},serializeTables:function(){var b=[];return a("table").each(function(){this.id&&b.push(a.param(this.tableData(this)))}),b.join("&")},tableData:function(b){var c,d,e,f,g=b.tableDnDConfig,h=[],i=0,j=0,k=null,l={};if(b||(b=this.currentTable),!(b&&b.id&&b.rows&&b.rows.length))return{error:{code:500,message:"Not a valid table, no serializable unique id provided."}};f=g.autoCleanRelations&&b.rows||a.makeArray(b.rows),d=g.serializeParamName||b.id,e=d,c=function(a){return a&&g&&g.serializeRegexp?a.match(g.serializeRegexp)[0]:a},l[e]=[],!g.autoCleanRelations&&a(f[0]).data("level")&&f.unshift({id:"undefined"});for(var m=0;m<f.length;m++)if(g.hierarchyLevel){if(j=a(f[m]).data("level")||0,0==j)e=d,h=[];else if(j>i)h.push([e,i]),e=c(f[m-1].id);else if(i>j)for(var n=0;n<h.length;n++)h[n][1]==j&&(e=h[n][0]),h[n][1]>=i&&(h[n][1]=0);i=j,a.isArray(l[e])||(l[e]=[]),k=c(f[m].id),k&&l[e].push(k)}else k=c(f[m].id),k&&l[e].push(k);return l}},jQuery.fn.extend({tableDnD:a.tableDnD.build,tableDnDUpdate:a.tableDnD.updateTables,tableDnDSerialize:a.proxy(a.tableDnD.serialize,a.tableDnD),tableDnDSerializeAll:a.tableDnD.serializeTables,tableDnDData:a.proxy(a.tableDnD.tableData,a.tableDnD)})}(jQuery,window,window.document);
!function(e){e(["jquery"],function(e){return function(){function t(e,t,n){return g({type:O.error,iconClass:m().iconClasses.error,message:e,optionsOverride:n,title:t})}function n(t,n){return t||(t=m()),v=e("#"+t.containerId),v.length?v:(n&&(v=d(t)),v)}function o(e,t,n){return g({type:O.info,iconClass:m().iconClasses.info,message:e,optionsOverride:n,title:t})}function s(e){C=e}function i(e,t,n){return g({type:O.success,iconClass:m().iconClasses.success,message:e,optionsOverride:n,title:t})}function a(e,t,n){return g({type:O.warning,iconClass:m().iconClasses.warning,message:e,optionsOverride:n,title:t})}function r(e,t){var o=m();v||n(o),u(e,o,t)||l(o)}function c(t){var o=m();return v||n(o),t&&0===e(":focus",t).length?void h(t):void(v.children().length&&v.remove())}function l(t){for(var n=v.children(),o=n.length-1;o>=0;o--)u(e(n[o]),t)}function u(t,n,o){var s=!(!o||!o.force)&&o.force;return!(!t||!s&&0!==e(":focus",t).length)&&(t[n.hideMethod]({duration:n.hideDuration,easing:n.hideEasing,complete:function(){h(t)}}),!0)}function d(t){return v=e("<div/>").attr("id",t.containerId).addClass(t.positionClass),v.appendTo(e(t.target)),v}function p(){return{tapToDismiss:!0,toastClass:"toast",containerId:"toast-container",debug:!1,showMethod:"fadeIn",showDuration:300,showEasing:"swing",onShown:void 0,hideMethod:"fadeOut",hideDuration:1e3,hideEasing:"swing",onHidden:void 0,closeMethod:!1,closeDuration:!1,closeEasing:!1,closeOnHover:!0,extendedTimeOut:1e3,iconClasses:{error:"toast-error",info:"toast-info",success:"toast-success",warning:"toast-warning"},iconClass:"toast-info",positionClass:"toast-top-right",timeOut:5e3,titleClass:"toast-title",messageClass:"toast-message",escapeHtml:!1,target:"body",closeHtml:'<button type="button">&times;</button>',closeClass:"toast-close-button",newestOnTop:!0,preventDuplicates:!1,progressBar:!1,progressClass:"toast-progress",rtl:!1}}function f(e){C&&C(e)}function g(t){function o(e){return null==e&&(e=""),e.replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/'/g,"&#39;").replace(/</g,"&lt;").replace(/>/g,"&gt;")}function s(){c(),u(),d(),p(),g(),C(),l(),i()}function i(){var e="";switch(t.iconClass){case"toast-success":case"toast-info":e="polite";break;default:e="assertive"}I.attr("aria-live",e)}function a(){E.closeOnHover&&I.hover(H,D),!E.onclick&&E.tapToDismiss&&I.click(b),E.closeButton&&j&&j.click(function(e){e.stopPropagation?e.stopPropagation():void 0!==e.cancelBubble&&e.cancelBubble!==!0&&(e.cancelBubble=!0),E.onCloseClick&&E.onCloseClick(e),b(!0)}),E.onclick&&I.click(function(e){E.onclick(e),b()})}function r(){I.hide(),I[E.showMethod]({duration:E.showDuration,easing:E.showEasing,complete:E.onShown}),E.timeOut>0&&(k=setTimeout(b,E.timeOut),F.maxHideTime=parseFloat(E.timeOut),F.hideEta=(new Date).getTime()+F.maxHideTime,E.progressBar&&(F.intervalId=setInterval(x,10)))}function c(){t.iconClass&&I.addClass(E.toastClass).addClass(y)}function l(){E.newestOnTop?v.prepend(I):v.append(I)}function u(){if(t.title){var e=t.title;E.escapeHtml&&(e=o(t.title)),M.append(e).addClass(E.titleClass),I.append(M)}}function d(){if(t.message){var e=t.message;E.escapeHtml&&(e=o(t.message)),B.append(e).addClass(E.messageClass),I.append(B)}}function p(){E.closeButton&&(j.addClass(E.closeClass).attr("role","button"),I.prepend(j))}function g(){E.progressBar&&(q.addClass(E.progressClass),I.prepend(q))}function C(){E.rtl&&I.addClass("rtl")}function O(e,t){if(e.preventDuplicates){if(t.message===w)return!0;w=t.message}return!1}function b(t){var n=t&&E.closeMethod!==!1?E.closeMethod:E.hideMethod,o=t&&E.closeDuration!==!1?E.closeDuration:E.hideDuration,s=t&&E.closeEasing!==!1?E.closeEasing:E.hideEasing;if(!e(":focus",I).length||t)return clearTimeout(F.intervalId),I[n]({duration:o,easing:s,complete:function(){h(I),clearTimeout(k),E.onHidden&&"hidden"!==P.state&&E.onHidden(),P.state="hidden",P.endTime=new Date,f(P)}})}function D(){(E.timeOut>0||E.extendedTimeOut>0)&&(k=setTimeout(b,E.extendedTimeOut),F.maxHideTime=parseFloat(E.extendedTimeOut),F.hideEta=(new Date).getTime()+F.maxHideTime)}function H(){clearTimeout(k),F.hideEta=0,I.stop(!0,!0)[E.showMethod]({duration:E.showDuration,easing:E.showEasing})}function x(){var e=(F.hideEta-(new Date).getTime())/F.maxHideTime*100;q.width(e+"%")}var E=m(),y=t.iconClass||E.iconClass;if("undefined"!=typeof t.optionsOverride&&(E=e.extend(E,t.optionsOverride),y=t.optionsOverride.iconClass||y),!O(E,t)){T++,v=n(E,!0);var k=null,I=e("<div/>"),M=e("<div/>"),B=e("<div/>"),q=e("<div/>"),j=e(E.closeHtml),F={intervalId:null,hideEta:null,maxHideTime:null},P={toastId:T,state:"visible",startTime:new Date,options:E,map:t};return s(),r(),a(),f(P),E.debug&&console&&console.log(P),I}}function m(){return e.extend({},p(),b.options)}function h(e){v||(v=n()),e.is(":visible")||(e.remove(),e=null,0===v.children().length&&(v.remove(),w=void 0))}var v,C,w,T=0,O={error:"error",info:"info",success:"success",warning:"warning"},b={clear:r,remove:c,error:t,getContainer:n,info:o,options:{},subscribe:s,success:i,version:"2.1.3",warning:a};return b}()})}("function"==typeof define&&define.amd?define:function(e,t){"undefined"!=typeof module&&module.exports?module.exports=t(require("jquery")):window.toastr=t(window.jQuery)});
//# sourceMappingURL=toastr.js.map

/* ===========================================================
 * bootstrap-confirmation.js v1.0.1
 * http://ethaizone.github.io/Bootstrap-Confirmation/
 * ===========================================================
 * Copyright 2013 Nimit Suwannagate <ethaizone@hotmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */


!function ($) {

	"use strict"; // jshint ;_;


 /* CONFIRMATION PUBLIC CLASS DEFINITION
	* =============================== */

	//var for check event at body can have only one.
	var event_body = false;

	var Confirmation = function (element, options) {
		var that = this;

		// remove href attribute of button
		$(element).removeAttr('href')

		this.init('confirmation', element, options)

		$(element).on('show', function(e) {
			var options = that.options;
			var all = options.all_selector;
			if(options.singleton) {
				$(all).not(that.$element).confirmation('hide');
			}
		});

		$(element).on('shown', function(e) {
			var options = that.options;
			var all = options.all_selector;
			$(this).next('.popover').one('click.dismiss.confirmation', '[data-dismiss="confirmation"]', $.proxy(that.hide, that))
			if(that.isPopout()) {
				if(!event_body) {
					event_body = $('body').on('click', function (e) {
						if($(all).is(e.target)) return;
						if($(all).next('div').has(e.target).length) return;

						$(all).confirmation('hide');
						$('body').unbind(e);
						event_body = false;

						return;
					});
				}
			}
		});
	}


	/* NOTE: CONFIRMATION EXTENDS BOOTSTRAP-TOOLTIP.js
		 ========================================== */

	Confirmation.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {

		constructor: Confirmation

		, setContent: function () {
				var $tip = this.tip()
					, title = this.getTitle()
					, href = this.getHref()
					, target = this.getTarget()
					, $e = this.$element
					, btnOkClass = this.getBtnOkClass()
					, btnCancelClass = this.getBtnCancelClass()
					, btnOkLabel = this.getBtnOkLabel()
					, btnCancelLabel = this.getBtnCancelLabel()
					, o = this.options

				$tip.find('.popover-title').text(title);

				var btnOk = $tip.find('.popover-content > div > a:not([data-dismiss="confirmation"])');
				var btnCancel = $tip.find('.popover-content > div > a[data-dismiss="confirmation"]');

				btnOk.addClass(btnOkClass).html(btnOkLabel).attr('href', href).attr('target', target).on('click', o.onConfirm);
				btnCancel.addClass(btnCancelClass).html(btnCancelLabel).on('click', o.onCancel);

				$tip.removeClass('fade top bottom left right in')
			}

		, hasContent: function () {
				return this.getTitle()
			}

		, isPopout: function () {
				var popout
					, $e = this.$element
					, o = this.options

				popout = $e.attr('data-popout') || (typeof o.popout == 'function' ? o.popout.call($e[0]) :	o.popout)

				if(popout == 'false') popout = false;

				return popout
			}


		, getHref: function () {
				var href
					, $e = this.$element
					, o = this.options

				href = $e.attr('data-href') || (typeof o.href == 'function' ? o.href.call($e[0]) :	o.href)

				return href
			}

		, getTarget: function () {
				var target
					, $e = this.$element
					, o = this.options

				target = $e.attr('data-target') || (typeof o.target == 'function' ? o.target.call($e[0]) :	o.target)

				return target
			}

		, getBtnOkClass: function () {
				var btnOkClass
					, $e = this.$element
					, o = this.options

				btnOkClass = $e.attr('data-btnOkClass') || (typeof o.btnOkClass == 'function' ? o.btnOkClass.call($e[0]) :	o.btnOkClass)

				return btnOkClass
			}

		, getBtnCancelClass: function () {
				var btnCancelClass
					, $e = this.$element
					, o = this.options

				btnCancelClass = $e.attr('data-btnCancelClass') || (typeof o.btnCancelClass == 'function' ? o.btnCancelClass.call($e[0]) :	o.btnCancelClass)

				return btnCancelClass
			}

		, getBtnOkLabel: function () {
				var btnOkLabel
					, $e = this.$element
					, o = this.options

				btnOkLabel = $e.attr('data-btnOkLabel') || (typeof o.btnOkLabel == 'function' ? o.btnOkLabel.call($e[0]) :	o.btnOkLabel)

				return btnOkLabel
			}

		, getBtnCancelLabel: function () {
				var btnCancelLabel
					, $e = this.$element
					, o = this.options

				btnCancelLabel = $e.attr('data-btnCancelLabel') || (typeof o.btnCancelLabel == 'function' ? o.btnCancelLabel.call($e[0]) :	o.btnCancelLabel)

				return btnCancelLabel
			}

		, tip: function () {
				this.$tip = this.$tip || $(this.options.template)
				return this.$tip
			}

		, destroy: function () {
				this.hide().$element.off('.' + this.type).removeData(this.type)
			}

	})


 /* CONFIRMATION PLUGIN DEFINITION
	* ======================= */

	var old = $.fn.confirmation

	$.fn.confirmation = function (option) {
		var that = this
		return this.each(function () {
			var $this = $(this)
				, data = $this.data('confirmation')
				, options = typeof option == 'object' && option
			options = options || {}
			options.all_selector = that.selector
			if (!data) $this.data('confirmation', (data = new Confirmation(this, options)))
			if (typeof option == 'string') data[option]()
		})
	}

	$.fn.confirmation.Constructor = Confirmation

	$.fn.confirmation.defaults = $.extend({} , $.fn.tooltip.defaults, {
		placement: 'top'
		, trigger: 'click'
		, target : '_self'
		, href   : '#'
		, title: 'Are you sure?'
		, template: '<div class="popover">' +
				'<div class="arrow"></div>' +
				'<h3 class="popover-title"></h3>' +
				'<div class="popover-content text-center">' +
				'<div class="btn-group">' +
				'<a class="btn btn-small" href="" target=""></a>' +
				'<a class="btn btn-small" data-dismiss="confirmation"></a>' +
				'</div>' +
				'</div>' +
				'</div>'
		, btnOkClass:  'btn-primary'
		, btnCancelClass:  ''
		, btnOkLabel: '<i class="icon-ok-sign icon-white"></i> Yes'
		, btnCancelLabel: '<i class="icon-remove-sign"></i> No'
		, singleton: false
		, popout: false
		, onConfirm: function(){}
		, onCancel: function(){}
	})


 /* POPOVER NO CONFLICT
	* =================== */

	$.fn.confirmation.noConflict = function () {
		$.fn.confirmation = old
		return this
	}

}(window.jQuery);

/*!
 * Nestable jQuery Plugin - Copyright (c) 2012 David Bushell - http://dbushell.com/
 * Dual-licensed under the BSD or MIT licenses
 */
;(function($, window, document, undefined)
{
    var hasTouch = 'ontouchstart' in document;

    /**
     * Detect CSS pointer-events property
     * events are normally disabled on the dragging element to avoid conflicts
     * https://github.com/ausi/Feature-detection-technique-for-pointer-events/blob/master/modernizr-pointerevents.js
     */
    var hasPointerEvents = (function()
    {
        var el    = document.createElement('div'),
            docEl = document.documentElement;
        if (!('pointerEvents' in el.style)) {
            return false;
        }
        el.style.pointerEvents = 'auto';
        el.style.pointerEvents = 'x';
        docEl.appendChild(el);
        var supports = window.getComputedStyle && window.getComputedStyle(el, '').pointerEvents === 'auto';
        docEl.removeChild(el);
        return !!supports;
    })();

    var defaults = {
            listNodeName    : 'ol',
            itemNodeName    : 'li',
            rootClass       : 'dd',
            listClass       : 'dd-list',
            itemClass       : 'dd-item',
            dragClass       : 'dd-dragel',
            handleClass     : 'dd-handle',
            collapsedClass  : 'dd-collapsed',
            placeClass      : 'dd-placeholder',
            noDragClass     : 'dd-nodrag',
            emptyClass      : 'dd-empty',
            expandBtnHTML   : '<button data-action="expand" type="button">Expand</button>',
            collapseBtnHTML : '<button data-action="collapse" type="button">Collapse</button>',
            group           : 0,
            maxDepth        : 5,
            threshold       : 20
        };

    function Plugin(element, options)
    {
        this.w  = $(document);
        this.el = $(element);
        this.options = $.extend({}, defaults, options);
        this.init();
    }

    Plugin.prototype = {

        init: function()
        {
            var list = this;

            list.reset();

            list.el.data('nestable-group', this.options.group);

            list.placeEl = $('<div class="' + list.options.placeClass + '"/>');

            $.each(this.el.find(list.options.itemNodeName), function(k, el) {
                list.setParent($(el));
            });

            list.el.on('click', 'button', function(e) {
                if (list.dragEl) {
                    return;
                }
                var target = $(e.currentTarget),
                    action = target.data('action'),
                    item   = target.parent(list.options.itemNodeName);
                if (action === 'collapse') {
                    list.collapseItem(item);
                }
                if (action === 'expand') {
                    list.expandItem(item);
                }
            });

            var onStartEvent = function(e)
            {
                var handle = $(e.target);
                if (!handle.hasClass(list.options.handleClass)) {
                    if (handle.closest('.' + list.options.noDragClass).length) {
                        return;
                    }
                    handle = handle.closest('.' + list.options.handleClass);
                }

                if (!handle.length || list.dragEl) {
                    return;
                }

                list.isTouch = /^touch/.test(e.type);
                if (list.isTouch && e.touches.length !== 1) {
                    return;
                }

                e.preventDefault();
                list.dragStart(e.touches ? e.touches[0] : e);
            };

            var onMoveEvent = function(e)
            {
                if (list.dragEl) {
                    e.preventDefault();
                    list.dragMove(e.touches ? e.touches[0] : e);
                }
            };

            var onEndEvent = function(e)
            {
                if (list.dragEl) {
                    e.preventDefault();
                    list.dragStop(e.touches ? e.touches[0] : e);
                }
            };

            if (hasTouch) {
                list.el[0].addEventListener('touchstart', onStartEvent, false);
                window.addEventListener('touchmove', onMoveEvent, false);
                window.addEventListener('touchend', onEndEvent, false);
                window.addEventListener('touchcancel', onEndEvent, false);
            }

            list.el.on('mousedown', onStartEvent);
            list.w.on('mousemove', onMoveEvent);
            list.w.on('mouseup', onEndEvent);

        },

        serialize: function()
        {
            var data,
                depth = 0,
                list  = this;
                step  = function(level, depth)
                {
                    var array = [ ],
                        items = level.children(list.options.itemNodeName);
                    items.each(function()
                    {
                        var li   = $(this),
                            item = $.extend({}, li.data()),
                            sub  = li.children(list.options.listNodeName);
                        if (sub.length) {
                            item.children = step(sub, depth + 1);
                        }
                        array.push(item);
                    });
                    return array;
                };
            data = step(list.el.find(list.options.listNodeName).first(), depth);
            return data;
        },

        serialise: function()
        {
            return this.serialize();
        },

        reset: function()
        {
            this.mouse = {
                offsetX   : 0,
                offsetY   : 0,
                startX    : 0,
                startY    : 0,
                lastX     : 0,
                lastY     : 0,
                nowX      : 0,
                nowY      : 0,
                distX     : 0,
                distY     : 0,
                dirAx     : 0,
                dirX      : 0,
                dirY      : 0,
                lastDirX  : 0,
                lastDirY  : 0,
                distAxX   : 0,
                distAxY   : 0
            };
            this.isTouch    = false;
            this.moving     = false;
            this.dragEl     = null;
            this.dragRootEl = null;
            this.dragDepth  = 0;
            this.hasNewRoot = false;
            this.pointEl    = null;
        },

        expandItem: function(li)
        {
            li.removeClass(this.options.collapsedClass);
            li.children('[data-action="expand"]').hide();
            li.children('[data-action="collapse"]').show();
            li.children(this.options.listNodeName).show();
        },

        collapseItem: function(li)
        {
            var lists = li.children(this.options.listNodeName);
            if (lists.length) {
                li.addClass(this.options.collapsedClass);
                li.children('[data-action="collapse"]').hide();
                li.children('[data-action="expand"]').show();
                li.children(this.options.listNodeName).hide();
            }
        },

        expandAll: function()
        {
            var list = this;
            list.el.find(list.options.itemNodeName).each(function() {
                list.expandItem($(this));
            });
        },

        collapseAll: function()
        {
            var list = this;
            list.el.find(list.options.itemNodeName).each(function() {
                list.collapseItem($(this));
            });
        },

        setParent: function(li)
        {
            if (li.children(this.options.listNodeName).length) {
                li.prepend($(this.options.expandBtnHTML));
                li.prepend($(this.options.collapseBtnHTML));
            }
            li.children('[data-action="expand"]').hide();
        },

        unsetParent: function(li)
        {
            li.removeClass(this.options.collapsedClass);
            li.children('[data-action]').remove();
            li.children(this.options.listNodeName).remove();
        },

        dragStart: function(e)
        {
            var mouse    = this.mouse,
                target   = $(e.target),
                dragItem = target.closest(this.options.itemNodeName);

            this.placeEl.css('height', dragItem.height());

            mouse.offsetX = e.offsetX !== undefined ? e.offsetX : e.pageX - target.offset().left;
            mouse.offsetY = e.offsetY !== undefined ? e.offsetY : e.pageY - target.offset().top;
            mouse.startX = mouse.lastX = e.pageX;
            mouse.startY = mouse.lastY = e.pageY;

            this.dragRootEl = this.el;

            this.dragEl = $(document.createElement(this.options.listNodeName)).addClass(this.options.listClass + ' ' + this.options.dragClass);
            this.dragEl.css('width', dragItem.width());

            dragItem.after(this.placeEl);
            dragItem[0].parentNode.removeChild(dragItem[0]);
            dragItem.appendTo(this.dragEl);

            $(document.body).append(this.dragEl);
            this.dragEl.css({
                'left' : e.pageX - mouse.offsetX,
                'top'  : e.pageY - mouse.offsetY
            });
            // total depth of dragging item
            var i, depth,
                items = this.dragEl.find(this.options.itemNodeName);
            for (i = 0; i < items.length; i++) {
                depth = $(items[i]).parents(this.options.listNodeName).length;
                if (depth > this.dragDepth) {
                    this.dragDepth = depth;
                }
            }
        },

        dragStop: function(e)
        {
            var el = this.dragEl.children(this.options.itemNodeName).first();
            el[0].parentNode.removeChild(el[0]);
            this.placeEl.replaceWith(el);

            this.dragEl.remove();
            this.el.trigger('change');
            if (this.hasNewRoot) {
                this.dragRootEl.trigger('change');
            }
            this.reset();
        },

        dragMove: function(e)
        {
            var list, parent, prev, next, depth,
                opt   = this.options,
                mouse = this.mouse;

            this.dragEl.css({
                'left' : e.pageX - mouse.offsetX,
                'top'  : e.pageY - mouse.offsetY
            });

            // mouse position last events
            mouse.lastX = mouse.nowX;
            mouse.lastY = mouse.nowY;
            // mouse position this events
            mouse.nowX  = e.pageX;
            mouse.nowY  = e.pageY;
            // distance mouse moved between events
            mouse.distX = mouse.nowX - mouse.lastX;
            mouse.distY = mouse.nowY - mouse.lastY;
            // direction mouse was moving
            mouse.lastDirX = mouse.dirX;
            mouse.lastDirY = mouse.dirY;
            // direction mouse is now moving (on both axis)
            mouse.dirX = mouse.distX === 0 ? 0 : mouse.distX > 0 ? 1 : -1;
            mouse.dirY = mouse.distY === 0 ? 0 : mouse.distY > 0 ? 1 : -1;
            // axis mouse is now moving on
            var newAx   = Math.abs(mouse.distX) > Math.abs(mouse.distY) ? 1 : 0;

            // do nothing on first move
            if (!mouse.moving) {
                mouse.dirAx  = newAx;
                mouse.moving = true;
                return;
            }

            // calc distance moved on this axis (and direction)
            if (mouse.dirAx !== newAx) {
                mouse.distAxX = 0;
                mouse.distAxY = 0;
            } else {
                mouse.distAxX += Math.abs(mouse.distX);
                if (mouse.dirX !== 0 && mouse.dirX !== mouse.lastDirX) {
                    mouse.distAxX = 0;
                }
                mouse.distAxY += Math.abs(mouse.distY);
                if (mouse.dirY !== 0 && mouse.dirY !== mouse.lastDirY) {
                    mouse.distAxY = 0;
                }
            }
            mouse.dirAx = newAx;

            /**
             * move horizontal
             */
            if (mouse.dirAx && mouse.distAxX >= opt.threshold) {
                // reset move distance on x-axis for new phase
                mouse.distAxX = 0;
                prev = this.placeEl.prev(opt.itemNodeName);
                // increase horizontal level if previous sibling exists and is not collapsed
                if (mouse.distX > 0 && prev.length && !prev.hasClass(opt.collapsedClass)) {
                    // cannot increase level when item above is collapsed
                    list = prev.find(opt.listNodeName).last();
                    // check if depth limit has reached
                    depth = this.placeEl.parents(opt.listNodeName).length;
                    if (depth + this.dragDepth <= opt.maxDepth) {
                        // create new sub-level if one doesn't exist
                        if (!list.length) {
                            list = $('<' + opt.listNodeName + '/>').addClass(opt.listClass);
                            list.append(this.placeEl);
                            prev.append(list);
                            this.setParent(prev);
                        } else {
                            // else append to next level up
                            list = prev.children(opt.listNodeName).last();
                            list.append(this.placeEl);
                        }
                    }
                }
                // decrease horizontal level
                if (mouse.distX < 0) {
                    // we can't decrease a level if an item preceeds the current one
                    next = this.placeEl.next(opt.itemNodeName);
                    if (!next.length) {
                        parent = this.placeEl.parent();
                        this.placeEl.closest(opt.itemNodeName).after(this.placeEl);
                        if (!parent.children().length) {
                            this.unsetParent(parent.parent());
                        }
                    }
                }
            }

            var isEmpty = false;

            // find list item under cursor
            if (!hasPointerEvents) {
                this.dragEl[0].style.visibility = 'hidden';
            }
            this.pointEl = $(document.elementFromPoint(e.pageX - document.body.scrollLeft, e.pageY - (window.pageYOffset || document.documentElement.scrollTop)));
            if (!hasPointerEvents) {
                this.dragEl[0].style.visibility = 'visible';
            }
            if (this.pointEl.hasClass(opt.handleClass)) {
                this.pointEl = this.pointEl.parent(opt.itemNodeName);
            }
            if (this.pointEl.hasClass(opt.emptyClass)) {
                isEmpty = true;
            }
            else if (!this.pointEl.length || !this.pointEl.hasClass(opt.itemClass)) {
                return;
            }

            // find parent list of item under cursor
            var pointElRoot = this.pointEl.closest('.' + opt.rootClass),
                isNewRoot   = this.dragRootEl.data('nestable-id') !== pointElRoot.data('nestable-id');

            /**
             * move vertical
             */
            if (!mouse.dirAx || isNewRoot || isEmpty) {
                // check if groups match if dragging over new root
                if (isNewRoot && opt.group !== pointElRoot.data('nestable-group')) {
                    return;
                }
                // check depth limit
                depth = this.dragDepth - 1 + this.pointEl.parents(opt.listNodeName).length;
                if (depth > opt.maxDepth) {
                    return;
                }
                var before = e.pageY < (this.pointEl.offset().top + this.pointEl.height() / 2);
                    parent = this.placeEl.parent();
                // if empty create new list to replace empty placeholder
                if (isEmpty) {
                    list = $(document.createElement(opt.listNodeName)).addClass(opt.listClass);
                    list.append(this.placeEl);
                    this.pointEl.replaceWith(list);
                }
                else if (before) {
                    this.pointEl.before(this.placeEl);
                }
                else {
                    this.pointEl.after(this.placeEl);
                }
                if (!parent.children().length) {
                    this.unsetParent(parent.parent());
                }
                if (!this.dragRootEl.find(opt.itemNodeName).length) {
                    this.dragRootEl.append('<div class="' + opt.emptyClass + '"/>');
                }
                // parent root list has changed
                if (isNewRoot) {
                    this.dragRootEl = pointElRoot;
                    this.hasNewRoot = this.el[0] !== this.dragRootEl[0];
                }
            }
        }

    };

    $.fn.nestable = function(params)
    {
        var lists  = this,
            retval = this;

        lists.each(function()
        {
            var plugin = $(this).data("nestable");

            if (!plugin) {
                $(this).data("nestable", new Plugin(this, params));
                $(this).data("nestable-id", new Date().getTime());
            } else {
                if (typeof params === 'string' && typeof plugin[params] === 'function') {
                    retval = plugin[params]();
                }
            }
        });

        return retval || lists;
    };

})(window.jQuery || window.Zepto, window, document);

/*
 * jquery.fullscreen v0.6.0
 * https://github.com/private-face/jquery.fullscreen
 *
 * Copyright (c) 2012–2016 Vladimir Zhuravlev
 * Released under the MIT license
 * https://github.com/private-face/jquery.fullscreen/blob/master/LICENSE
 *
 * Date: 2016-08-25
 **/
(function(global, factory) {
	if (typeof define === 'function' && define.amd) {
		// AMD
		define(['jquery'], function (jQuery) {
			return factory(jQuery);
		});
	} else if (typeof exports === 'object') {
		// CommonJS/Browserify
		factory(require('jquery'));
	} else {
		// Global
		factory(global.jQuery);
	}
}(this, function($) {

function defined(a){return"undefined"!=typeof a}function extend(a,b,c){var d=function(){};d.prototype=b.prototype,a.prototype=new d,a.prototype.constructor=a,b.prototype.constructor=b,a._super=b.prototype,c&&$.extend(a.prototype,c)}function native(a,b){var c;"string"==typeof a&&(b=a,a=document);for(var d=0;d<SUBST.length;++d){b=b.replace(SUBST[d][0],SUBST[d][1]);for(var e=0;e<VENDOR_PREFIXES.length;++e)if(c=VENDOR_PREFIXES[e],c+=0===e?b:b.charAt(0).toUpperCase()+b.substr(1),defined(a[c]))return a[c]}}var SUBST=[["",""],["exit","cancel"],["screen","Screen"]],VENDOR_PREFIXES=["","o","ms","moz","webkit","webkitCurrent"],ua=navigator.userAgent,fsEnabled=native("fullscreenEnabled"),parsedChromeUA=ua.match(/Android.*Chrome\/(\d+)\./),IS_ANDROID_CHROME=!!parsedChromeUA,CHROME_VERSION,ANDROID_CHROME_VERSION;IS_ANDROID_CHROME&&(ANDROID_CHROME_VERSION=parseInt(parsedChromeUA[1]));var IS_NATIVELY_SUPPORTED=(!IS_ANDROID_CHROME||ANDROID_CHROME_VERSION>37)&&defined(native("fullscreenElement"))&&(!defined(fsEnabled)||fsEnabled===!0),version=$.fn.jquery.split("."),JQ_LT_17=parseInt(version[0])<2&&parseInt(version[1])<7,FullScreenAbstract=function(){this.__options=null,this._fullScreenElement=null,this.__savedStyles={}};FullScreenAbstract.prototype={native:native,_DEFAULT_OPTIONS:{styles:{boxSizing:"border-box",MozBoxSizing:"border-box",WebkitBoxSizing:"border-box"},toggleClass:null},__documentOverflow:"",__htmlOverflow:"",_preventDocumentScroll:function(){this.__documentOverflow=document.body.style.overflow,this.__htmlOverflow=document.documentElement.style.overflow,$(this._fullScreenElement).is("body, html")||$("body, html").css("overflow","hidden")},_allowDocumentScroll:function(){document.body.style.overflow=this.__documentOverflow,document.documentElement.style.overflow=this.__htmlOverflow},_fullScreenChange:function(){this.__options&&(this.isFullScreen()?(this._preventDocumentScroll(),this._triggerEvents()):(this._allowDocumentScroll(),this._revertStyles(),this._triggerEvents(),this._fullScreenElement=null))},_fullScreenError:function(a){this.__options&&(this._revertStyles(),this._fullScreenElement=null,a&&$(document).trigger("fscreenerror",[a]))},_triggerEvents:function(){$(this._fullScreenElement).trigger(this.isFullScreen()?"fscreenopen":"fscreenclose"),$(document).trigger("fscreenchange",[this.isFullScreen(),this._fullScreenElement])},_saveAndApplyStyles:function(){var a=$(this._fullScreenElement);this.__savedStyles={};for(var b in this.__options.styles)this.__savedStyles[b]=this._fullScreenElement.style[b],this._fullScreenElement.style[b]=this.__options.styles[b];a.is("body")&&(document.documentElement.style.overflow=this.__options.styles.overflow),this.__options.toggleClass&&a.addClass(this.__options.toggleClass)},_revertStyles:function(){var a=$(this._fullScreenElement);for(var b in this.__options.styles)this._fullScreenElement.style[b]=this.__savedStyles[b];a.is("body")&&(document.documentElement.style.overflow=this.__savedStyles.overflow),this.__options.toggleClass&&a.removeClass(this.__options.toggleClass)},open:function(a,b){a!==this._fullScreenElement&&(this.isFullScreen()&&this.exit(),this._fullScreenElement=a,this.__options=$.extend(!0,{},this._DEFAULT_OPTIONS,b),this._saveAndApplyStyles())},exit:null,isFullScreen:null,isNativelySupported:function(){return IS_NATIVELY_SUPPORTED}};var FullScreenNative=function(){FullScreenNative._super.constructor.apply(this,arguments),this.exit=$.proxy(native("exitFullscreen"),document),this._DEFAULT_OPTIONS=$.extend(!0,{},this._DEFAULT_OPTIONS,{styles:{width:"100%",height:"100%"}}),$(document).bind(this._prefixedString("fullscreenchange")+" MSFullscreenChange",$.proxy(this._fullScreenChange,this)).bind(this._prefixedString("fullscreenerror")+" MSFullscreenError",$.proxy(this._fullScreenError,this))};extend(FullScreenNative,FullScreenAbstract,{VENDOR_PREFIXES:["","o","moz","webkit"],_prefixedString:function(a){return $.map(this.VENDOR_PREFIXES,function(b){return b+a}).join(" ")},open:function(a,b){FullScreenNative._super.open.apply(this,arguments);var c=native(a,"requestFullscreen");c.call(a)},exit:$.noop,isFullScreen:function(){return null!==native("fullscreenElement")},element:function(){return native("fullscreenElement")}});var FullScreenFallback=function(){FullScreenFallback._super.constructor.apply(this,arguments),this._DEFAULT_OPTIONS=$.extend({},this._DEFAULT_OPTIONS,{styles:{position:"fixed",zIndex:"2147483647",left:0,top:0,bottom:0,right:0}}),this.__delegateKeydownHandler()};extend(FullScreenFallback,FullScreenAbstract,{__isFullScreen:!1,__delegateKeydownHandler:function(){var a=$(document);a.delegate("*","keydown.fullscreen",$.proxy(this.__keydownHandler,this));var b=JQ_LT_17?a.data("events"):$._data(document).events,c=b.keydown;JQ_LT_17?b.live.unshift(b.live.pop()):c.splice(0,0,c.splice(c.delegateCount-1,1)[0])},__keydownHandler:function(a){return!this.isFullScreen()||27!==a.which||(this.exit(),!1)},_revertStyles:function(){FullScreenFallback._super._revertStyles.apply(this,arguments),this._fullScreenElement.offsetHeight},open:function(a){FullScreenFallback._super.open.apply(this,arguments),this.__isFullScreen=!0,this._fullScreenChange()},exit:function(){this.__isFullScreen&&(this.__isFullScreen=!1,this._fullScreenChange())},isFullScreen:function(){return this.__isFullScreen},element:function(){return this.__isFullScreen?this._fullScreenElement:null}}),$.fullscreen=IS_NATIVELY_SUPPORTED?new FullScreenNative:new FullScreenFallback,$.fn.fullscreen=function(a){var b=this[0];return a=$.extend({toggleClass:null,overflow:"hidden"},a),a.styles={overflow:a.overflow},delete a.overflow,b&&$.fullscreen.open(b,a),this};
//# sourceMappingURL=jquery.fullscreen.min.js.mapreturn $.fullscreen;
}));
/* ===========================================================
 * Bootstrap: fileinput.js v3.1.3
 * http://jasny.github.com/bootstrap/javascript/#fileinput
 * ===========================================================
 * Copyright 2012-2014 Arnold Daniels
 *
 * Licensed under the Apache License, Version 2.0 (the "License" )
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */

+function ($) { "use strict";

  var isIE = window.navigator.appName == 'Microsoft Internet Explorer'

  // FILEUPLOAD PUBLIC CLASS DEFINITION
  // =================================

  var Fileinput = function (element, options) {
    this.$element = $(element)
    
    this.$input = this.$element.find(':file')
    if (this.$input.length === 0) return

    this.name = this.$input.attr('name') || options.name

    this.$hidden = this.$element.find('input[type=hidden][name="' + this.name + '"]')
    if (this.$hidden.length === 0) {
      this.$hidden = $('<input type="hidden">').insertBefore(this.$input)
    }

    this.$preview = this.$element.find('.fileinput-preview')
    var height = this.$preview.css('height')
    if (this.$preview.css('display') !== 'inline' && height !== '0px' && height !== 'none') {
      this.$preview.css('line-height', height)
    }
        
    this.original = {
      exists: this.$element.hasClass('fileinput-exists'),
      preview: this.$preview.html(),
      hiddenVal: this.$hidden.val()
    }
    
    this.listen()
  }
  
  Fileinput.prototype.listen = function() {
    this.$input.on('change.bs.fileinput', $.proxy(this.change, this))
    $(this.$input[0].form).on('reset.bs.fileinput', $.proxy(this.reset, this))
    
    this.$element.find('[data-trigger="fileinput"]').on('click.bs.fileinput', $.proxy(this.trigger, this))
    this.$element.find('[data-dismiss="fileinput"]').on('click.bs.fileinput', $.proxy(this.clear, this))
  },

  Fileinput.prototype.change = function(e) {
    var files = e.target.files === undefined ? (e.target && e.target.value ? [{ name: e.target.value.replace(/^.+\\/, '')}] : []) : e.target.files
    
    e.stopPropagation()

    if (files.length === 0) {
      this.clear()
      return
    }

    this.$hidden.val('')
    this.$hidden.attr('name', '')
    this.$input.attr('name', this.name)

    var file = files[0]

    if (this.$preview.length > 0 && (typeof file.type !== "undefined" ? file.type.match(/^image\/(gif|png|jpeg)$/) : file.name.match(/\.(gif|png|jpe?g)$/i)) && typeof FileReader !== "undefined" ) {
      var reader = new FileReader()
      var preview = this.$preview
      var element = this.$element

      reader.onload = function(re) {
        var $img = $('<img>')
        $img[0].src = re.target.result
        files[0].result = re.target.result
        
        element.find('.fileinput-filename').text(file.name)
        
        // if parent has max-height, using `(max-)height: 100%` on child doesn't take padding and border into account
        if (preview.css('max-height') != 'none') $img.css('max-height', parseInt(preview.css('max-height'), 10) - parseInt(preview.css('padding-top'), 10) - parseInt(preview.css('padding-bottom'), 10)  - parseInt(preview.css('border-top'), 10) - parseInt(preview.css('border-bottom'), 10))
        
        preview.html($img)
        element.addClass('fileinput-exists').removeClass('fileinput-new')

        element.trigger('change.bs.fileinput', files)
      }

      reader.readAsDataURL(file)
    } else {
      this.$element.find('.fileinput-filename').text(file.name)
      this.$preview.text(file.name)
      
      this.$element.addClass('fileinput-exists').removeClass('fileinput-new')
      
      this.$element.trigger('change.bs.fileinput')
    }
  },

  Fileinput.prototype.clear = function(e) {
    if (e) e.preventDefault()
    
    this.$hidden.val('')
    this.$hidden.attr('name', this.name)
    this.$input.attr('name', '')

    //ie8+ doesn't support changing the value of input with type=file so clone instead
    if (isIE) { 
      var inputClone = this.$input.clone(true);
      this.$input.after(inputClone);
      this.$input.remove();
      this.$input = inputClone;
    } else {
      this.$input.val('')
    }

    this.$preview.html('')
    this.$element.find('.fileinput-filename').text('')
    this.$element.addClass('fileinput-new').removeClass('fileinput-exists')
    
    if (e !== undefined) {
      this.$input.trigger('change')
      this.$element.trigger('clear.bs.fileinput')
    }
  },

  Fileinput.prototype.reset = function() {
    this.clear()

    this.$hidden.val(this.original.hiddenVal)
    this.$preview.html(this.original.preview)
    this.$element.find('.fileinput-filename').text('')

    if (this.original.exists) this.$element.addClass('fileinput-exists').removeClass('fileinput-new')
     else this.$element.addClass('fileinput-new').removeClass('fileinput-exists')
    
    this.$element.trigger('reset.bs.fileinput')
  },

  Fileinput.prototype.trigger = function(e) {
    this.$input.trigger('click')
    e.preventDefault()
  }

  
  // FILEUPLOAD PLUGIN DEFINITION
  // ===========================

  var old = $.fn.fileinput
  
  $.fn.fileinput = function (options) {
    return this.each(function () {
      var $this = $(this),
          data = $this.data('bs.fileinput')
      if (!data) $this.data('bs.fileinput', (data = new Fileinput(this, options)))
      if (typeof options == 'string') data[options]()
    } )
  }

  $.fn.fileinput.Constructor = Fileinput


  // FILEINPUT NO CONFLICT
  // ====================

  $.fn.fileinput.noConflict = function () {
    $.fn.fileinput = old
    return this
  }


  // FILEUPLOAD DATA-API
  // ==================

  $(document).on('click.fileinput.data-api', '[data-provides="fileinput"]', function (e) {
    var $this = $(this)
    if ($this.data('bs.fileinput')) return
    $this.fileinput($this.data())
      
    var $target = $(e.target).closest('[data-dismiss="fileinput"],[data-trigger="fileinput"]');
    if ($target.length > 0) {
      e.preventDefault()
      $target.trigger('click.bs.fileinput')
    }
  } )

}(window.jQuery);

jQuery.uiDivFilter=function(jq,phrase,ifHidden,ifShown){if(this.last_phrase===phrase){return false};var phrase_length=phrase.length;var words=phrase.toLowerCase().split( " " );var test="";var search_text=function(){var elem=jQuery(this);if(jQuery.uiDivFilter.has_words(elem.text(),words)){elem.show();if(ifShown){ifShown(elem)}}
else{elem.hide();if(ifHidden){ifHidden(elem)}}}
if((words.length>1)&&(phrase.substr(0,phrase_length-1)===this.last_phrase)){var words=words[words.length-1];this.last_phrase=phrase;jq.filter( ":visible" ).each(search_text);}
else{this.last_phrase=phrase;jq.each(search_text);}
return jq;};jQuery.uiDivFilter.last_phrase=""
jQuery.uiDivFilter.has_words=function(str,words,caseSensitive){var text=caseSensitive?str:str.toLowerCase();for(var i=0;i<words.length;i++){if(text.indexOf(words[i])===-1)return false;}
return true;}
/*
 * Copyright (c) 2008 Greg Weber greg at gregweber.info
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * documentation at http://gregweber.info/projects/uitablefilter
 *
 * allows table rows to be filtered (made invisible)
 * <code>
 * t = $('table')
 * $.uiTableFilter( t, phrase )
 * </code>
 * arguments:
 *   jQuery object containing table rows
 *   phrase to search for
 *   optional arguments:
 *     column to limit search too (the column title in the table header)
 *     ifHidden - callback to execute if one or more elements was hidden
 */
jQuery.uiTableFilter = function(jq, phrase, column, ifHidden){
  var new_hidden = false;
  if( this.last_phrase === phrase ) return false;

  var phrase_length = phrase.length;
  var words = phrase.toLowerCase().split( " " );

  var success = function(elem) { elem.show() }
  var failure = function(elem) { elem.hide() }

  if( column ) {
    var index = null;
    jq.find( "thead > tr:last > th" ).each( function(i){
      if( $(this).text() == column ){
        index = i;
        return false;
      }
    } );
    var iselector = "td:eq( " + index + " )";
  
    var search_text = function( ){
      var elem = jQuery(this);
      jQuery.uiTableFilter.has_words( jQuery(elem.find(iselector)).text(), words ) ?
        success(elem) : failure(elem);
    }
  }
  else {
    var search_text = function(){
        var elem = jQuery(this);
        jQuery.uiTableFilter.has_words( elem.text(), words ) ? elem.show() : elem.hide();
    }
  }

  // if added one letter to last time,
  // just check newest word and only need to hide
  if( (words.size > 1) && (phrase.substr(0, phrase_length - 1) ===
        this.last_phrase) ) {

    if( phrase[-1] === " " )
    { this.last_phrase = phrase; return false; }

    success = function(elem) { elem.hide(); new_hidden = true; }
    failure = function(elem) {;}
    var words = words[-1];
    jq.find( "tbody tr:visible" ).each( search_text )
  }
  else {
    new_hidden = true;
    jq.find( "tbody > tr" ).each( search_text );
  }

  last_phrase = phrase;
  if( ifHidden && new_hidden ) ifHidden();
  return jq;
};
jQuery.uiTableFilter.last_phrase = ""

// not jQuery dependent
// "" [""] -> Boolean
// "" [""] Boolean -> Boolean
jQuery.uiTableFilter.has_words = function( str, words, caseSensitive )
{
  var text = caseSensitive ? str : str.toLowerCase();
  for (var i=0; i < words.length; i++) {
    if (text.indexOf(words[i]) === -1) return false;
  }
  return true;
}
