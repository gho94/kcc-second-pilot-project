<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>카테고리 관리</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/themes/default/style.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/jstree.min.js"></script>
</head>
<body>        
    <h2>카테고리 트리</h2>
    <div id="categoryTree"></div>
    <h2>카테고리 추가</h2>
    <c:if test="${action eq 'insert'}">
        <c:url var="category_do" value="/category/insert.do"/>
    </c:if>
    <c:if test="${action eq 'update'}">
        <c:url var="category_do" value="/category/update.do"/>
    </c:if>

    <form action="${category_do}" method="post">
        <fieldset>
            <legend>카테고리정보</legend>
            <table>                
                <tr>
                    <td class="label">상위카테고리</td>                    
                    <td class="field"><input type="text" name="parentName" value="${parentName}" readonly></td>
                    <td class="field"><input type="hidden" name="parentId" value="${category.parentId}"></td>
                </tr>
                <tr>
                    <td class="label">카테고리이름</td>
                    <td class="field"><input type="text" name="categoryName" value="${category.categoryName}"></td>
                </tr>
            </table>
                <input type="submit" value="  저 장  "> 
                <input type="reset" value="  취 소  ">
        </fieldset>
    </form>

    <form action="${category_do}" method="post">
        <fieldset>
            <legend>카테고리이동정보</legend>
            <table>                
                <tr>
                    <td class="label">이동된 노드</td>                    
                    <td class="field"><input type="text" name="moveNode" value="${moveNode}" readonly></td>
                    <td class="field"><input type="text" name="moveNodeId" value="${moveNodeId}" readonly></td>
                </tr>
                <tr>
                    <td class="label">이전부모</td>                    
                    <td class="field"><input type="text" name="moveParentName" value="${parentName}" readonly></td>
                    <td class="field"><input type="text" name="moveParentId" value="${parentId}" readonly></td>
                </tr>
                <tr>
                    <td class="label">새부모</td>                    
                    <td class="field"><input type="text" name="newParentName" value="${newParentName}" readonly></td>
                    <td class="field"><input type="text" name="newParentId" value="${newParentId}" readonly></td>
                </tr>
            </table>
                <input type="hidden" name="action" value="merge">
                <input type="submit" value="  저 장  "> 
                <input type="reset" value="  취 소  ">
        </fieldset>
    </form>


    <script>
        var treeData = <%= request.getAttribute("categoryTree") %>;
        $(function () {
            $('#categoryTree').jstree({
                'core': {
                    'data': treeData,
                    'check_callback': true
                },
                'plugins': ['wholerow', 'contextmenu', 'dnd'],
                'contextmenu': {
                    'items': function (node) {
                        return {
                            'expand': {
                                'label': '펼치기',
                                'action': () => expandChildren(node)
                            },
                            'collapse': {
                                'label': '접기',
                                'action': () => collapseChildren(node)
                            }
                        };
                    }
                },
                'dnd': {
                    'is_draggable': (node) => true,
                    'is_droppable': (node) => true                    
                }
            });
        });

        $('#categoryTree').on('ready.jstree', function () {
            $('#categoryTree').jstree('open_all');
        });

        
        $('#categoryTree').on('select_node.jstree', function (e, data) {
            $('form').find('input[name="parentId"]').val(data.node.id);
            $('form').find('input[name="parentName"]').val(data.node.text);      
        });

        $('#categoryTree').on('move_node.jstree', function (e, data) {
            var oldParent = $('#categoryTree').jstree('get_node', data.old_parent);
            var newParent = $('#categoryTree').jstree('get_node', data.parent);

            var oldParentName = oldParent.id === '#' ? '루트' : oldParent.text;
            var newParentName = newParent.id === '#' ? '루트' : newParent.text;

            $('form').find('input[name="moveNode"]').val(data.node.text);
            $('form').find('input[name="moveNodeId"]').val(data.node.id);
            $('form').find('input[name="moveParentName"]').val(oldParentName);
            $('form').find('input[name="moveParentId"]').val(oldParent.id);
            $('form').find('input[name="newParentName"]').val(newParentName);
            $('form').find('input[name="newParentId"]').val(newParent.id);
        });

        function expandChildren(node) {
            if (node.children && node.children.length > 0) {                
                $('#categoryTree').jstree('open_node', node);

                node.children.forEach(child => {
                    var childNode = $('#categoryTree').jstree('get_node', child);
                    if (childNode) {
                        expandChildren(childNode);
                    }
                });               
            }
        }

        function collapseChildren(node) {
            if (node.children && node.children.length > 0) {
                node.children.forEach(child => {
                    var childNode = $('#categoryTree').jstree('get_node', child);
                    if (childNode) {
                        collapseChildren(childNode);
                    }
                });
                
                $('#categoryTree').jstree('close_node', node);
            }
        }
    </script>
</body>
</html>