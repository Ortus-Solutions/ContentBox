/*! Copyright 2016 - Ortus Solutions (Compiled: 11-04-2016) */
$(document).ready(function() {
    $confirmIt = $("#confirmIt");
    $remoteModal = $("#modal");
    attachModalListeners();
    toolTipSettings = {
        animation: "slide",
        delay: {
            show: 100,
            hide: 100
        }
    };
    activateContentSearch();
    activateConfirmations();
    activateTooltips();
    activateNavbarState();
    $.validator.setDefaults({
        ignore: [],
        highlight: function(element) {
            $(element).closest(".form-group").removeClass("success").addClass("error");
        },
        success: function(element) {
            element.text("Field is valid").addClass("valid").closest(".form-group").removeClass("error").addClass("success");
            element.remove();
        },
        errorPlacement: function(error, element) {
            if ($(element).is(":hidden")) {
                return false;
            } else {
                error.appendTo(element.closest("div.controls"));
            }
        }
    });
    $.fn.resetValidations = function() {
        var form = this[0].currentForm;
        $(form).find(".form-group").each(function() {
            $(this).removeClass("error").removeClass("success");
        });
        $(form).find(":input").each(function() {
            $(this).removeClass("error").removeClass("valid");
        });
        return this;
    };
    $.fn.clearForm = function() {
        if (this.data("validator") === undefined) {
            return;
        }
        this.data("validator").resetForm();
        this.find(":input").each(function() {
            switch (this.type) {
              case "password":
              case "hidden":
              case "select-multiple":
              case "select-one":
              case "text":
              case "textarea":
                $(this).val("");
                break;

              case "checkbox":
              case "radio":
                this.checked = false;
            }
        });
        $(this.data("validator")).resetValidations();
        return this;
    };
    $.fn.collect = function() {
        var serializedArrayData = this.serializeArray();
        var data = {};
        $.each(serializedArrayData, function(index, obj) {
            data[obj.name] = obj.value;
        });
        return data;
    };
    var t = setTimeout(toggleFlickers(), 5e3);
    $(function() {
        var activeTab = $('[href="' + location.hash + '"]');
        if (activeTab) {
            activeTab.tab("show");
        }
    });
    jwerty.key("ctrl+shift+s/\\", function() {
        $("#nav-search").focus();
        return false;
    });
    $("[data-keybinding]").each(function() {
        var boundItem = $(this);
        jwerty.key(boundItem.data("keybinding"), function() {
            if (boundItem.attr("onclick")) {
                boundItem.click();
            } else {
                to(boundItem.attr("href"));
            }
        });
    });
    $("#main-navbar li.nav-dropdown").each(function() {
        if (!$(this).find("ul.nav-sub li").length) {
            $(this).hide();
        }
    });
    $(".accordion[data-stateful]").each(function() {
        var accordion = $(this), data = accordion.data("stateful"), match;
        if (data) {
            match = $.cookie(data);
            if (match !== null) {
                accordion.find(".collapse").removeClass("in");
                $("#" + match).addClass("in");
            }
        }
        accordion.bind("shown.bs.collapse", function() {
            var active = accordion.find(".in").attr("id");
            $.cookie(data, active);
        });
    });
});

function activateNavbarState() {
    var container = $("#container");
    $("#toggle-left").bind("click", function(e) {
        if ($(window).width() > 768) {
            state = container.hasClass("sidebar-mini");
        } else {
            state = container.hasClass("sidebar-opened");
        }
        $.cookie("sidemenu-collapse", state);
    });
}

function isSidebarOpen() {
    var sidebar = $("#main-sidebar");
    return sidebar.attr("id") !== undefined && sidebar.css("display") === "block" ? true : false;
}

function toggleSidebar() {
    var sidebar = $("#main-sidebar");
    var type = sidebar.css("display");
    var sidebarState = false;
    if (type === undefined) {
        return;
    }
    if (type === "block") {
        sidebar.fadeOut();
        $("#sidebar_trigger").removeClass("icon-collapse-alt").addClass("icon-expand-alt");
        $("#main-content").removeClass("span9").addClass("span12");
    } else {
        $("#sidebar_trigger").removeClass("icon-expand-alt").addClass("icon-collapse-alt");
        sidebar.fadeIn();
        $("#main-content").removeClass("span12").addClass("span9");
        sidebarState = true;
    }
    $.ajax({
        url: $("#sidebar-toggle").attr("data-stateurl"),
        data: {
            sidebarState: sidebarState
        },
        async: true
    });
}

function adminAction(action, actionURL) {
    if (action != "null") {
        $("#adminActionsIcon").addClass("icon-spin textOrange");
        $.post(actionURL, {
            targetModule: action
        }, function(data) {
            if (data.ERROR) {
                adminNotifier("error", "<i class='icon-exclamation-sign'></i> <strong>Error running action, check logs!</strong>");
            } else {
                adminNotifier("info", "<i class='icon-exclamation-sign'></i> <strong>Action Ran, Booya!</strong>");
            }
            $("#adminActionsIcon").removeClass("icon-spin textOrange");
        });
    }
}

function adminNotifier(type, message, delay) {
    toastr.options = {
        closeButton: true,
        preventDuplicates: true,
        progressBar: true,
        showDuration: "300",
        timeOut: "2000",
        positionClass: "toast-top-center"
    };
    switch (type) {
      case "info":
        {
            toastr.info(message);
            break;
        }

      case "error":
        {
            toastr.error(message);
            break;
        }

      case "success":
        {
            toastr.success(message);
            break;
        }

      case "warning":
        {
            toastr.warning(message);
            break;
        }

      default:
        {
            toastr.info(message);
            break;
        }
    }
}

function activateContentSearch() {
    $nav_search = $("#nav-search");
    $nav_search_results = $("#div-search-results");
    $nav_search.css("opacity", "0.8");
    $nav_search.focusin(function() {
        $(this).animate({
            opacity: 1,
            width: "+=250"
        }, 500, function() {});
    }).blur(function() {
        $(this).animate({
            opacity: .5,
            width: "-=250"
        }, 500, function() {});
    });
    $nav_search.keyup(function() {
        var $this = $(this);
        if ($this.val().length > 1) {
            $nav_search_results.load($("#nav-search-url").val(), {
                search: $this.val()
            }, function(data) {
                if ($nav_search_results.css("display") === "none") {
                    $nav_search_results.fadeIn().slideDown();
                }
            });
        }
    });
    $("body").click(function(e) {
        var target = $(e.target), ipTarget = target.closest("#div-search");
        if (!ipTarget.length) {
            closeSearchBox();
        }
    });
}

function closeSearchBox() {
    $("#div-search-results").slideUp();
    $("#nav-search").val("");
}

function quickLinks(inURL) {
    if (inURL != "null") {
        window.location = inURL;
    }
}

function activateTooltips() {
    $("[title]").tooltip(toolTipSettings);
}

function hideAllTooltips() {
    $(".tooltip").hide();
}

function toggleFlickers() {
    $(".flickerMessages").slideToggle();
    $(".flickers").fadeOut(3e3);
}

function closeRemoteModal() {
    $remoteModal.modal("hide");
}

function resetContainerForms(container) {
    var frm = container.find("form");
    if (frm.length) {
        $(frm[0]).clearForm();
    }
}

function closeModal(div) {
    div.modal("hide");
}

function openModal(div, w, h) {
    div.modal();
    $(div).on("hidden.bs.modal", function() {
        resetContainerForms($(this));
    });
}

function openRemoteModal(url, params, w, h, delay) {
    if (!url) {
        console.log("URL needed");
        return;
    }
    var modal = $remoteModal;
    var args = {};
    var maxHeight = $(window).height() - 200;
    var maxWidth = $(window).width() * .85;
    modal.data("url", url);
    modal.data("params", params);
    modal.data("width", w !== undefined ? w : maxWidth);
    modal.data("height", h !== undefined ? h : maxHeight);
    var height = modal.data("height");
    if (height.search && height.search("%") !== -1) {
        height = height.replace("%", "") / 100;
        height = $(window).height() * height;
    }
    if (height > maxHeight) {
        height = maxHeight;
    }
    modal.data("height", height);
    if (delay) {
        modal.data("delay", true);
        modal.modal();
    } else {
        modal.load(url, params, function() {
            modal.modal();
        });
    }
    return;
}

function setPreviewSize(activeBtn, w) {
    var modalDialog = $remoteModal.find(".modal-dialog"), frame = $("#previewFrame").length ? $("#previewFrame") : modalDialog, orig = {
        width: $remoteModal.data("width")
    }, modalSize = {
        width: w
    };
    if (!w || modalSize.width > orig.width) {
        modalSize = {
            width: orig.width
        };
    }
    $remoteModal.find(".header-title").toggle(modalSize.width > 600);
    $(activeBtn).siblings(".btn-primary").removeClass("btn-primary").addClass("btn-info");
    $(activeBtn).removeClass("btn-info").addClass("btn-primary");
    modalDialog.animate(modalSize, 500);
}

function attachModalListeners() {
    $remoteModal.on("show.bs.modal", function() {
        var modal = $remoteModal;
        modal.find(".modal-dialog").css({
            width: modal.data("width"),
            height: modal.data("height")
        });
    });
    $remoteModal.on("shown.bs.modal", function() {
        var modal = $remoteModal;
        if (modal.data("delay")) {
            modal.load(modal.data("url"), modal.data("params"), function() {
                modal.find(".modal-dialog").css({
                    width: modal.data("width"),
                    height: modal.data("height")
                });
            });
        }
    });
    $remoteModal.on("hidden.bs.modal", function() {
        var modal = $remoteModal;
        modal.html('<div class="modal-header"><h3>Loading...</h3></div><div class="modal-body" id="removeModelContent"><i class="fa fa-spinner fa-spin fa-lg fa-4x"></i></div>');
        resetContainerForms(modal);
    });
}

function closeConfirmations() {
    $confirmIt.modal("hide");
}

function activateConfirmations() {
    $confirmIt.find("button").click(function(e) {
        if ($(this).attr("data-action") === "confirm") {
            $confirmIt.find("#confirmItButtons").hide();
            $confirmIt.find("#confirmItLoader").fadeIn();
            window.location = $confirmIt.data("confirmSrc");
        }
    });
    $(".confirmIt").click(function(e) {
        $confirmIt.data("confirmSrc", $(this).attr("href"));
        var dataMessage = $(this).attr("data-message") ? $(this).attr("data-message") : "Are you sure you want to perform this action?";
        var dataTitle = $(this).attr("data-title") ? $(this).attr("data-title") : "Are you sure?";
        $confirmIt.find("#confirmItMessage").html(dataMessage);
        $confirmIt.find("#confirmItTitle").html(dataTitle);
        $confirmIt.modal();
        e.preventDefault();
    });
}

function popup(url, w, h) {
    var winWidth = 1e3;
    var winHeight = 750;
    if (w) {
        minWidth = w;
    }
    if (h) {
        winHeight = h;
    }
    var xPosition = screen.width / 2 - winWidth / 2;
    var yPosition = screen.height / 2 - winHeight / 2;
    window.open(url, "layoutPreview", "resizable=yes,status=yes,location=no,menubar=no,toolbar=no,scrollbars=yes,width=" + winWidth + ",height=" + winHeight + ",left=" + xPosition + ",top=" + yPosition + ",screenX=" + xPosition + ",screenY=" + yPosition);
}

function to(link) {
    window.location = link;
    return false;
}

function checkAll(checked, id) {
    $("input[name='" + id + "']").each(function() {
        this.checked = checked;
    });
}

function checkByValue(id, recordID) {
    $("input[name='" + id + "']").each(function() {
        if (this.value === recordID) {
            this.checked = true;
        } else {
            this.checked = false;
        }
    });
}

function getToday(us) {
    us = us == null ? true : us;
    if (us) {
        return moment().format("YYYY-MM-DD");
    } else {
        return moment().format("DD-MM-YYYY");
    }
}