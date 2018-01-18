//处理1.9版本兼容性问题
$.browser = {};
$.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());
$.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
$.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
$.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
var nothClose = false;

$(document).ready(function () {
    $("#homelink").hover(function () {
        $('body>div.menu-top:visible').menu('hide');
    });
    $.post("/pms_aspx/Invoke.aspx",
    {
        _c: "com.sdjxd.pms.platform.organize.Menu",
        _m: "getFirstMenu"
    },
    function (data, status) {
        //debugger;
        var jto = eval("(" + data + ")");
        if (jto.success) {
            $.each(jto.value, function (index, item) {
                var testbutton = $('<a href="#" id="' + item.id + '">' + item.text + '</a>').appendTo("#menutools");
                testbutton.menubutton({
                    plain: true
                });
                var menu = $("<div id=\"m" + item.id + "\" style=\"width:150px;\"></div>").appendTo("body");
                testbutton.menubutton({
                    menu: '#m' + item.id
                });
                menu.menu({
                    onClick: function (item) {
                        doAction(item);
                    }
                });
                $.post("/pms_aspx/Invoke.aspx",
                {
                    _c: "com.sdjxd.pms.platform.form.service.cell.Tree",
                    _m: "getChildNodeArray",
                    _p0: "FE80692A-B806-4E42-89C9-7D6F432DC1E3",
                    _p1: "6F350BC3-146F-49F3-8A02-DDDCA8E523CD",
                    _p2: "",
                    _p3: item.id,
                    _p4: item.id,
                    _p5: 8,
                    _p6: "\"0\"",
                    _p7: "\"\""
                    //treeRootNodeFilter: "PARENTMENUID='" + item.id + "'"
                },
                function (data, status) {
                    var sumMenuInfo = eval("(" + data + ")");
                    if (sumMenuInfo.success) {
                        $.each(sumMenuInfo.value, function (index, item) {
                            //debugger;
                            menu.menu("appendItem", { id: item.id, text: item.text });
                            $("#" + item.id).data("data", item);
                            if (item.childs) {
                                //debugger;
                                //var curitem = menu.menu("getItem",$("#" + item.id));
                                addChildMenu($("#" + item.id)[0], item, menu);
                            }
                        });
                    }
                });
            });
            var aa = $('<A id="a11" onclick="isOut()" class="easyui-linkbutton l-btn l-btn-plain" href="#" data-options="plain:true"><SPAN class=l-btn-left><SPAN class=l-btn-text>退出</SPAN></SPAN></A>').appendTo("#menutools");
            $("#a11").hover(function () {
                $('body>div.menu-top:visible').menu('hide');
            });
            var aa = $('<A id="a12" onclick="$(\'body\').layout(\'collapse\', \'north\');" title = "折叠顶部"class="easyui-linkbutton l-btn l-btn-plain" href="#" data-options="plain:true"><SPAN class=l-btn-left><SPAN class="l-btn-text collapse_btn" style="width:18px;">  </SPAN></SPAN></A>').appendTo("#menutools");
        }
    });
    tabClose();
    tabCloseEven();
    $('#main-tabs').tabs({
        onSelect: function (title) {
            //debugger;
            var tab = $('#main-tabs').tabs("getTab", title);
            if (tab.openType && tab.openType == 2) {
                if (!nothClose) {
                    $('body').layout('collapse', "north");
                }
            } else {
                if (nothClose) {
                    $('body').layout('expand', "north");
                }
            }
        },
        onBeforeClose: function (title) {
            //debugger;
            var tab = $('#main-tabs').tabs("getTab", title);
            $("#i" + tab.objectId).attr("src", "about:blank")
            $("#i" + tab.objectId).remove();
            return true;
        }
    });
    var panel = $('body').layout('panel', "north");
    panel.panel({
        onCollapse: function () {
            nothClose = true;
        }, onExpand: function () {
            nothClose = false;
        }
    })
});
function addChildMenu(parentitem, nodedata, menu) {
    $.post("/pms_aspx/Invoke.aspx",
                {
                    _c: "com.sdjxd.pms.platform.form.service.cell.Tree",
                    _m: "getChildNodeArray",
                    _p0: "FE80692A-B806-4E42-89C9-7D6F432DC1E3",
                    _p1: "6F350BC3-146F-49F3-8A02-DDDCA8E523CD",
                    _p2: "",
                    _p3: nodedata.objectId,
                    _p4: nodedata.id,
                    _p5: 8,
                    _p6: "\"0\"",
                    _p7: "\"\""
                    //treeRootNodeFilter: "PARENTMENUID='" + item.id + "'"
                },
                function (data, status) {
                    //debugger;
                    var sumMenuInfo = eval("(" + data + ")");
                    if (sumMenuInfo.success) {
                        $.each(sumMenuInfo.value, function (index, item) {
                            //debugger;
                            menu.menu("appendItem", { id: item.id, text: item.text, parent: parentitem });
                            $("#" + item.id).data("data", item);
                            if (item.childs) {
                                //debugger;
                                //var curitem = menu.menu("getItem", $("#" + item.id));
                                addChildMenu($("#" + item.id)[0], item, menu);
                            }
                        });
                    }
                });
}
function addTab(id, tabName, url,openType) {
    if (!$('#main-tabs').tabs('exists', tabName)) {
        $('#main-tabs').tabs('add', {
            title: tabName,
            content: '<iframe id="i' + id + '" name="i' + id + '"  style="width:100%; height:99%;" src="' + url + '"  frameborder="0"  border="0" ></iframe>',
            closable: true,
            fit: true
        });
        var iframe = document.getElementById("i" + id);
        if (iframe.attachEvent) {
            iframe.attachEvent("onload", function () {
                //以下操作必须在iframe加载完后才可进行
                $(window.frames["i" + id].document.body).click(function () {
                    parent.$('body>div.menu-top:visible').menu('hide');
                });
                //$("body").click(function () { alert(123);});
            });
        } else {
            iframe.onload = function () {
                //以下操作必须在iframe加载完后才可进行
                $(window.frames["i" + id].document.body).click(function () {
                    parent.$('body>div.menu-top:visible').menu('hide');
                });
            };
        }
    } else {
        $('#main-tabs').tabs('select', tabName);
        //刷新
        $('#mm-tabupdate').click();
    }
    tabClose();
}
// 菜单点击事件
function doAction(node) {
    //debugger;
    var item = $("#" + node.id).data("data");
    var url = "";
    if (item.attachField.OPENTYPEID && item.attachField.OPENTYPEID == "2") {
        if (!nothClose) {
            $('body').layout('collapse', "north");
        }
    } else {
        if (nothClose) {
            $('body').layout('expand', "north");
        }
    }
    if (item.attachField.URL == "") {
        url = item.attachField.ARGUMENT
    } else if (item.attachField.URL.indexOf("?") != -1) {
        url = item.attachField.URL;
    } else {
        url = item.attachField.URL + "?p=" + item.attachField.PATTERNID;
        if (item.attachField.APPID) {
            url += "&appID=" + item.attachField.APPID
        }
        if (item.attachField.ARGUMENT) {
            url += "&" + item.attachField.ARGUMENT
        }
    }
    if (url == "") {
        return;
    }
    if (!$('#main-tabs').tabs('exists', item.text)) {
        $('#main-tabs').tabs('add', {
            title: item.text,
            content: '<iframe id="i' + item.id + '" name="i' + item.id + '"  style="width:100%; height:99%;" src="' + url + '"  frameborder="0"  border="0" ></iframe>',
            closable: true,
            fit: true
        });
        var iframe = document.getElementById("i" + item.id);
        if (iframe.attachEvent) {
            iframe.attachEvent("onload", function () {
                //以下操作必须在iframe加载完后才可进行
                if ($ && window.frames["i" + item.id]) {
                    $(window.frames["i" + item.id].document.body).click(function () {
                        parent.$('body>div.menu-top:visible').menu('hide');
                    });
                }
                //$("body").click(function () { alert(123);});
            });
        } else {
            iframe.onload = function () {
                //以下操作必须在iframe加载完后才可进行
                $(window.frames["i" + item.id].document.body).click(function () {
                    parent.$('body>div.menu-top:visible').menu('hide');
                });
            };
        }
    } else {
        $('#main-tabs').tabs('select', item.text);
        //刷新
        $('#mm-tabupdate').click();
    }
    var tab = $('#main-tabs').tabs("getTab", item.text);
    tab.openType = item.attachField.OPENTYPEID;
    tab.objectId = item.id;
    tabClose();
}
//绑定标签关闭
function tabClose() {
    /* 双击关闭TAB选项卡 */
    $(".tabs-inner").dblclick(function () {
        var subtitle = $(this).children(".tabs-closable").text();
        $('#main-tabs').tabs('close', subtitle);
    });
    /* 为选项卡绑定右键 */
    $(".tabs-inner").bind('contextmenu', function (e) {
        $('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        });

        var subtitle = $(this).children(".tabs-closable").text();

        $('#mm').data("currtab", subtitle);
        $('#main-tabs').tabs('select', subtitle);
        return false;
    });
}

function createFrame(url) {
    var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:99%;"></iframe>';
    return s;
}
// 绑定右键菜单事件
function tabCloseEven() {
    // 刷新
    $('#mm-tabupdate').click(function () {
        var currTab = $('#main-tabs').tabs('getSelected');
        var url = $(currTab.panel('options').content).attr('src');
        $('#main-tabs').tabs('update', {
            tab: currTab,
            options: {
                content: createFrame(url)
            }
        });
    });
    // 关闭当前
    $('#mm-tabclose').click(function () {
        var currtab_title = $('#mm').data("currtab");
        $('#main-tabs').tabs('close', currtab_title);
    });
    // 全部关闭
    $('#mm-tabcloseall').click(function () {
        $('.tabs-inner span').each(function (i, n) {
            var t = $(n).text();
            $('#main-tabs').tabs('close', t);
        });
    });
    // 关闭除当前之外的TAB
    $('#mm-tabcloseother').click(function () {
        //$('#mm-tabcloseright').click();
        //$('#mm-tabcloseleft').click();
        var currtab_title = $('#mm').data("currtab");
        $('.tabs-inner span').each(function (i, n) {
            var t = $(n).text();
            if (t != currtab_title) {
                $('#main-tabs').tabs('close', t);
            }
        });
    });
    // 关闭当前右侧的TAB
    $('#mm-tabcloseright').click(function () {
        var nextall = $('.tabs-selected').nextAll();
        if (nextall.length == 0) {
            $.messager.alert('系统提示', '后边没有啦~~', 'error');
            //alert('后边没有啦~~');
            return false;
        }
        nextall.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $('#main-tabs').tabs('close', t);
        });
        return false;
    });
    // 关闭当前左侧的TAB
    $('#mm-tabcloseleft').click(function () {
        var prevall = $('.tabs-selected').prevAll();
        if (prevall.length == 0) {
            //alert('到头了，前边没有啦~~');
            $.messager.alert('系统提示', '到头了，前边没有啦~~', 'error');
            return false;
        }
        prevall.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $('#main-tabs').tabs('close', t);
        });
        return false;
    });

    // 退出
    $("#mm-exit").click(function () {
        $('#mm').menu('hide');
    });
}

function isOut() {
    if (confirm("确定要退出系统？")) {
        $.ajax({
            url: "/code/aspx/index/logout.aspx",
            success: function () {
                window.top.location.href = "/code/aspx/hazop/nm/login/login.aspx";
            }
        })
        
    }
}

window.onerror = function () { return true; };