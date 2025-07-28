<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<table>
        <tr>
          <td><h1>카테고리 관리</h1></td>
          <td>
            <form action="/category/insert.do">
              <input type="submit" name="action" value="등록">
            </form>
            <form action="/category/update.do">
              <input type="submit" name="action" value="수정">
            </form>
          </td>
        </tr>
     </table>
    <div id="categoryTree"></div>
    <script>
        var treeData = <%= request.getAttribute("categoryTree") %>;
        $(function () {
            $('#categoryTree').jstree({
                'core': {
                    'data': treeData
                },
                'plugins': ['wholerow', 'contextmenu'],
                'contextmenu': {
                    'items': function (node) {
                        return {
                            'expand': {
                                'label': '펼치기',
                                'action': function () {
                                    expandChildren(node);
                                }
                            },
                            'collapse': {
                                'label': '접기',
                                'action': function () {
                                    collapseChildren(node);
                                }
                            },
                            'delete': {
                                'label': '삭제',
                                'action': function () {
                                    deleteNode(node);
                                }
                            }
                        };
                    }
                }
            });
        });

        $('#categoryTree').on('ready.jstree', function () {
            $('#categoryTree').jstree('open_all');
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

        function deleteNode(node) {
            if (confirm('정말로 이 카테고리를 삭제하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '/category/delete.do';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'categoryId';
                input.value = node.id;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>