AutoSave = function(editor,pageID,ddMenuID,options){
  if(!Modernizr.localstorage){
    $("#" + ddMenuID).find(".autoSaveBtn").html("Auto Save Unavailable").addClass('disabled');
    return false;
  }

  var defaults = {storeMax: 10,	timeout: 4000};
  var opts = $.extend({}, defaults, options || {});

  var editorID = editor.attr('id');
  var saveStoreKey = 'autosave_' + window.location + "_" + editorID;
  var isCK = (CKEDITOR && CKEDITOR.instances.hasOwnProperty(editorID));
  var timer = 0, savingActive = false;

  //Setup SavesStore
  if(!localStorage.getItem(saveStoreKey)) localStorage.setItem(saveStoreKey,'[]');
  var SaveStore = JSON.parse(localStorage.getItem(saveStoreKey));

  if(isCK) editor = editor.ckeditorGet();

  var removeOldSaves = function(callback){
    var overMax = SaveStore.length - opts.storeMax;
    for(var i = 0; i < overMax; i++){
      localStorage.removeItem(SaveStore[i]);
      SaveStore.splice(i,1);
    }
    if(callback) callback();
  }

  var addToStore = function(saveKey){
    SaveStore.push(saveKey);
    if(SaveStore.length > opts.storeMax){
      removeOldSaves(updateAutoSaveMenu);
    } else {
      updateAutoSaveMenu();
    }
  }

  var updateAutoSaveMenu = function(){
    localStorage.setItem(saveStoreKey,JSON.stringify(SaveStore));
    var ulList = '';
    for(var i = SaveStore.length; i--; ){
      var newItemDate = moment(SaveStore[i].replace(editorID + '_',''),'x');
      var dateTitle = moment().diff(newItemDate,"hours") < 1 ? newItemDate.fromNow() : newItemDate.format("MM/DD/YYYY h:mm a");
      ulList += '<li><a href="javascript:void(0)" data-id="' + SaveStore[i] + '">' + dateTitle +'</a></li>';
    }
    $("#" + ddMenuID).find(".autoSaveMenu").html(ulList);
  };

  var startTimer = function(event) {
      if (timer) clearTimeout(timer);
      timer = setTimeout(onTimer, opts.timeout, event);
  };

  var onTimer = function(event) {
      if (savingActive) {
          startTimer(event);
      } else {
        savingActive = true;
        var autoSaveKey = editorID + "_" + Date.now();
        if(isCK){
          localStorage.setItem(autoSaveKey,LZString.compressToUTF16(editor.getData()));
        } else {
          localStorage.setItem(autoSaveKey,LZString.compressToUTF16(editor.val()));
        }
        addToStore(autoSaveKey);
        savingActive = false;
      }
  };

  var loadContent = function(contentID){
    var content = localStorage.getItem(contentID);
    if(isCK){
      editor.setData(LZString.decompressFromUTF16(content),function(){
        if (timer) clearTimeout(timer);
      });
    } else {
      editor.val(LZString.decompressFromUTF16(content));
      if (timer) clearTimeout(timer);
    }
  };


  //Run Init Code
  editor.on(isCK ? 'change' : 'keyup', startTimer); //Run Auto Save
   // Load Previous AutoLoad when selected from the Dropdown menu
  $('#' + ddMenuID).on('click','li > a',function(evt){
    loadContent($(evt.currentTarget).data('id'));
  });
  updateAutoSaveMenu();
}
