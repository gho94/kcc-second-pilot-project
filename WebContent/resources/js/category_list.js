// 전역 변수
        const expandedCategories = new Set();

        // 페이지 로드 시 초기화
        document.addEventListener("DOMContentLoaded", () => {
            console.log("카테고리 리스트가 초기화되었습니다.");
        });

        // 카테고리 토글
        function toggleCategory(event, categoryId) {
            event.stopPropagation();
            
            const toggleIcon = event.target;
            const isExpanded = expandedCategories.has(categoryId);
            
            if (isExpanded) {
                // 축소
                expandedCategories.delete(categoryId);
                toggleIcon.textContent = "▶";
                toggleIcon.classList.remove("expanded");
                hideChildren(categoryId);
            } else {
                // 확장
                expandedCategories.add(categoryId);
                toggleIcon.textContent = "▼";
                toggleIcon.classList.add("expanded");
                showChildren(categoryId);
            }
        }

        // 하위 카테고리 숨기기
        function hideChildren(parentId) {
            const allItems = document.querySelectorAll('.category-item');
            
            allItems.forEach(item => {
                const itemParentId = item.dataset.parentId;
                const itemId = item.dataset.categoryId;
                
                if (itemParentId == parentId) {
                    item.style.display = 'none';
                    
                    // 하위의 하위도 모두 숨기기 (재귀적)
                    if (expandedCategories.has(parseInt(itemId))) {
                        expandedCategories.delete(parseInt(itemId));
                        const toggleIcon = item.querySelector('.toggle-icon');
                        if (toggleIcon && toggleIcon.textContent === "▼") {
                            toggleIcon.textContent = "▶";
                            toggleIcon.classList.remove("expanded");
                        }
                        hideChildren(itemId);
                    }
                }
            });
        }

        // 하위 카테고리 보이기
        function showChildren(parentId) {
            const allItems = document.querySelectorAll('.category-item');
            
            allItems.forEach(item => {
                const itemParentId = item.dataset.parentId;
                
                if (itemParentId == parentId) {
                    item.style.display = 'flex';
                }
            });
        }

        // 모든 카테고리 펼치기
        function expandAll() {
            const allItems = document.querySelectorAll('.category-item');
            const allToggleIcons = document.querySelectorAll('.toggle-icon');
            
            // 모든 아이템 표시
            allItems.forEach(item => {
                item.style.display = 'flex';
                const categoryId = parseInt(item.dataset.categoryId);
                expandedCategories.add(categoryId);
            });
            
            // 모든 토글 아이콘을 확장 상태로
            allToggleIcons.forEach(icon => {
                if (icon.textContent === "▶") {
                    icon.textContent = "▼";
                    icon.classList.add("expanded");
                }
            });
        }

        // 모든 카테고리 접기
        function collapseAll() {
            const allItems = document.querySelectorAll('.category-item');
            const allToggleIcons = document.querySelectorAll('.toggle-icon');
            
            // 확장 상태 초기화
            expandedCategories.clear();
            
            // 0뎁스(레벨 1)만 보이게 하고 나머지는 숨기기
            allItems.forEach(item => {
                const level = parseInt(item.dataset.level);
                if (level === 1) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
            
            // 모든 토글 아이콘을 접힌 상태로
            allToggleIcons.forEach(icon => {
                if (icon.textContent === "▼") {
                    icon.textContent = "▶";
                    icon.classList.remove("expanded");
                }
            });
        }

        // 리스트 새로고침
        function refreshList() {
            window.location.reload();
        }

        // 키보드 단축키
        document.addEventListener("keydown", (event) => {
            // Ctrl + E: 모두 펼치기
            if (event.ctrlKey && event.key === "e") {
                event.preventDefault();
                expandAll();
            }
            
            // Ctrl + C: 모두 접기
            if (event.ctrlKey && event.key === "c") {
                event.preventDefault();
                collapseAll();
            }
        });

        // 카테고리 수정
        function editCategory(categoryId) {
            window.location.href = 'update.do?id=' + categoryId;
        }

        // 카테고리 삭제
        function deleteCategory(categoryId, categoryName) {
            // 하위 카테고리 개수 확인을 위한 AJAX 호출 (선택사항)
            const confirmMessage = `'${categoryName}' 카테고리를 삭제하시겠습니까?\n\n※ 하위 카테고리가 있는 경우 함께 삭제됩니다.\n※ 관련된 메뉴 연결도 모두 해제됩니다.`;
            
            if (confirm(confirmMessage)) {
                // 삭제 요청을 위한 폼 생성 및 제출
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.do';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'categoryId';
                input.value = categoryId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }