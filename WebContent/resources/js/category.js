var searchTimeout = null;

$(function () {
    $('#categoryTree').jstree({
        'core': {
			'data': treeData,
			'check_callback': true
        },
        'plugins': ['wholerow', 'contextmenu', 'search'],
        'search': {
            'case_insensitive': true,      // 대소문자 구분 안함
            'show_only_matches': false,    // 매칭되지 않는 노드도 보이게 (부모 노드 표시용)
            'show_only_matches_children': false,
            'search_leaves_only': false,   // 잎 노드뿐만 아니라 모든 노드 검색
            'fuzzy': false                 // 정확한 매칭
        },
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
					},
					'add': {
					    'label': '추가',
					    'action': () => addCategory(node)
					},
					'edit': {
					    'label': '수정',
					    'action': () => editCategory(node)
					},
					'delete': {
					    'label': '삭제',
					    'action': () => deleteNode(node)
					}
                };
            }
        },
        'dnd': {
            'is_draggable': (node) => true,
            'is_droppable': (node) => true                    
        }
    });
    
    // 트리 초기화 후 모든 노드 펼치기
    $('#categoryTree').on('ready.jstree', function () {
        $('#categoryTree').jstree('open_all');
    });
    
    // 검색 입력 이벤트 연결
    $('#searchInput').on('input', function() {
        var searchString = $(this).val();
        
        // 기존 타이머 클리어
        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }
        
        // 300ms 지연 후 검색 (타이핑 완료 후 검색)
        searchTimeout = setTimeout(function() {
            $('#categoryTree').jstree('search', searchString);
        }, 300);
    });
    
    // 엔터키로도 검색
    $('#searchInput').on('keypress', function(e) {
        if (e.which === 13) {
            searchData();
        }
    });
    
    // 검색 결과 처리
    $('#categoryTree').on('search.jstree', function (nodes, str, res) {
        if (str.length > 0) {
            console.log('검색 결과:', res.length + '개 항목 발견');
        }
    });

	$('#categoryTree').on('move_node.jstree', function (e, data) {
	    var newParent = $('#categoryTree').jstree('get_node', data.parent);
	    submitCategoryMoveForm(data.node.id, newParent.id);
	});
});

// 검색 함수
function searchData() {
    var searchString = $('#searchInput').val().trim();
    $('#categoryTree').jstree('search', searchString);
    
    // 검색 후 매칭된 노드들이 있는 부모 노드들 펼치기
    if (searchString.length > 0) {
        setTimeout(function() {
            $('#categoryTree').jstree('open_all');
        }, 100);
    }
}

// 검색 초기화 함수
function clearSearch() {
    $('#searchInput').val('');
    $('#categoryTree').jstree('clear_search');
    $('#categoryTree').jstree('open_all');
}

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

function addCategory(parentNode) {
    var newCategoryName = prompt("새 카테고리 이름을 입력하세요:");
    if (newCategoryName) {
        var newNode = {
            "text": newCategoryName,
            "parent": parentNode.id === '#' ? '#' : parentNode.id
        };

        $('#categoryTree').jstree('create_node', parentNode, newNode, 'last', function (newNode) {
            submitCategoryForm(newNode);
        });
    }
}

function submitCategoryForm(node) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '/category/insert.do';            

    var parentIdInput = document.createElement('input');
    parentIdInput.type = 'hidden';
    parentIdInput.name = 'parentId';
    parentIdInput.value = node.parent;

    var categoryNameInput = document.createElement('input');
    categoryNameInput.type = 'hidden';
    categoryNameInput.name = 'categoryName';
    categoryNameInput.value = node.text;

    form.appendChild(parentIdInput);
    form.appendChild(categoryNameInput);

    document.body.appendChild(form);
    form.submit();
}

function editCategory(node) {
    var newCategoryName = prompt("새 카테고리 이름을 입력하세요:", node.text);
    if (newCategoryName && newCategoryName !== node.text) {
        node.text = newCategoryName;
        $('#categoryTree').jstree('rename_node', node, newCategoryName);

        submitCategoryUpdateForm(node);
    }
}

function submitCategoryUpdateForm(node) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '/category/update.do';            

    var categoryIdInput = document.createElement('input');
    categoryIdInput.type = 'hidden';
    categoryIdInput.name = 'categoryId';
    categoryIdInput.value = node.id;

    var categoryNameInput = document.createElement('input');
    categoryNameInput.type = 'hidden';
    categoryNameInput.name = 'categoryName';
    categoryNameInput.value = node.text;

    form.appendChild(categoryIdInput);
    form.appendChild(categoryNameInput);

    document.body.appendChild(form);
    form.submit();
}

function submitCategoryMoveForm(nodeId, parentId) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '/category/update.do';
    
    var actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'move';

    var categoryIdInput = document.createElement('input');
    categoryIdInput.type = 'hidden';
    categoryIdInput.name = 'categoryId';
    categoryIdInput.value = nodeId;

    var parentIdInput = document.createElement('input');
    parentIdInput.type = 'hidden';
    parentIdInput.name = 'parentId';
    parentIdInput.value = parentId;

    form.appendChild(actionInput);
    form.appendChild(categoryIdInput);
    form.appendChild(parentIdInput);

    document.body.appendChild(form);
    form.submit();
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