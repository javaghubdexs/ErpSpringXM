    <%--
      Created by IntelliJ IDEA.
      User: 86199
      Date: 2019/11/25
      Time: 15:49
      To change this template use File | Settings | File Templates.
    --%>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en" xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <link rel="stylesheet" type="text/css" href="ui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="ui/themes/icon.css">
        <script type="text/javascript" src="ui/jquery.min.js"></script>
        <script type="text/javascript" src="ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="ui/locale/easyui-lang-zh_CN.js"></script>
        <script type="text/javascript" src="ui/jquery.serializejson.min.js"></script>
        <script type="text/javascript" th:inline="none">
            $(function(){
                var method = "";
                $('#deptList').datagrid({
                    url:'/queryDeps.do',
                    columns:[[
                        {field:'id',title:'ID',width:100},
                        {field:'name',title:'部门名称',width:100},
                        {field:'tele',title:'部门电话',width:100,align:'right'},
                        {field:'-',title:'操作',formatter: function(value,row,index){
                                var oper = "<a href=\"javascript:void(0)\" onclick=\"edit(" + row.id + ')">修改</a>';
                                oper += ' <a href="javascript:void(0)" onclick="del(' + row.id + ')">删除</a>';
                                return oper;
                            }}
                    ]],
                    singleSelect: true,
                    pagination: true,
                    toolbar: [{
                        text: '新增',
                        iconCls: 'icon-add',
                        handler: function(){
                            method = "add";
                            $('#editDlg').dialog('open');
                        }
                    }]
                });
                $("#btnSearch").bind("click",function(){
                    var formDataStr = $("#searchForm").serializeJSON();
                    $("#deptList").datagrid("load",formDataStr);
                })
                $('#editDlg').dialog({
                    title: '部门编辑',
                    width: 300,
                    height: 200,
                    closed: true,//窗口是是否为关闭状态, true：表示关闭
                    modal: true//模式窗口
                });
                //保存
                $('#btnSave').bind('click',function(){
                    var formData = $('#editForm').serializeJSON();
                    $.ajax({
                        url: 'saveDep.do',
                        data: formData,
                        dataType: 'json',
                        type: 'post',
                        success:function(rtn){
                            $.messager.alert("提示",rtn.message,'info',function(){
                                //成功的话，我们要关闭窗口
                                $('#editDlg').dialog('close');
                                //刷新表格数据
                                $('#deptList').datagrid('reload');
                            });
                        }
                    });
                });
            })
            /**
             * 删除部门
             */
            function del(id){
                $.messager.confirm("确认","确认要删除吗？",function(yes){
                    if(yes){
                        $.ajax({
                            url: 'delDep.do?id=' + id,
                            dataType: 'json',
                            type: 'post',
                            success:function(rtn){
                                $.messager.alert("提示",rtn.message,'info',function(){
                                    //刷新表格数据
                                    $('#deptList').datagrid('reload');
                                });
                            }
                        });
                    }
                });
            }
            /**
             * 修改部门
             */
            function edit(id){
                //弹出窗口
                $('#editDlg').dialog('open');

                //清空表单内容
                $('#editForm').form('clear');
                method = "update";
                //加载数据
                $('#editForm').form('load','queryDepById.do?id=' + id);
            }

        </script>
    </head>
    <body>
    <div class="easyui-panel" style="padding-left:4px;border-bottom:0px;">
        <div style="height:2px;"></div>
        <form id="searchForm">
            <table>
                <tr>
                    <td>部门名称</td>
                    <td><input type="text" name="name"></td>
                </tr>
                <tr>
                    <td>部门电话</td>
                    <td><input type="text" name="tele"></td>
                </tr>
            </table>
            <button id="btnSearch" type="button">查询</button>
        </form>
        <div style="height:2px;"></div>
    </div>
    <table id="deptList"></table>
    <div id="editDlg">
        <form id="editForm">
            <table>
                <tr>
                    <td>部门名称</td>
                    <td><input name="name"><input type="hidden" name="id" /></td>
                </tr>
                <tr>
                    <td>部门电话</td>
                    <td><input name="tele"></td>
                </tr>
            </table>
            <button id="btnSave" type="button">保存</button>
        </form>
    </div>

    </body>
    </html>
