let selectedCategoryId = null;
let categoryMap = new Map();

// 페이지 로드 시 카테고리 맵 생성

    // 입력 필드 포커스 이벤트
    const input = document.querySelector('input[name="categoryName"]');
    const inputBox = input.closest('.input-box');
    
    input.addEventListener('focus', function() {
        inputBox.classList.add('focused');
    });
    
    input.addEventListener('blur', function() {
        inputBox.classList.remove('focused');
    });

    // 폼 제출 시 검증
    const form = document.querySelector('form');
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
        }
    });


// 트리 토글 기능
function toggleChildren(id) {
    const childList = document.getElementById('child-' + id);
    const toggle = event.target;
    
    if (childList) {
        childList.classList.toggle('hidden');
        
        // 토글 아이콘 변경
        if (childList.classList.contains('hidden')) {
            toggle.textContent = '📁';
        } else {
            toggle.textContent = '📂';
        }
    }
}

// 카테고리 경로 생성
function getCategoryPath(categoryId) {
    if (!categoryId || categoryId === 'null') {
        return '최상위';
    }

    const path = [];
    let currentId = parseInt(categoryId);
    
    while (currentId && categoryMap.has(currentId)) {
        const category = categoryMap.get(currentId);
        path.unshift(category.name);
        currentId = category.parentId;
    }
    
    return path.join(' > ');
}

// 선택된 상위 카테고리 표시
function selectCategory(id, name) {
    // 이전 선택 해제
    document.querySelectorAll('ul.tree a').forEach(link => {
        link.classList.remove('selected');
    });
    
    // 현재 선택 표시
    event.target.classList.add('selected');
    
    selectedCategoryId = id;
    document.getElementById('selectedParentId').value = id;
    
    // 경로 업데이트
    const pathElement = document.getElementById('selectedCategoryPath');
    const categoryPath = getCategoryPath(id);
    
    pathElement.textContent = categoryPath;
    pathElement.classList.remove('empty');
    pathElement.classList.add('has-selection', 'updating');
    
    // 애니메이션 완료 후 클래스 제거
    setTimeout(() => {
        pathElement.classList.remove('updating');
    }, 500);
}

// 선택 초기화
function clearSelection() {
    selectedCategoryId = null;
    document.getElementById('selectedParentId').value = '';
    
    // 선택 표시 해제
    document.querySelectorAll('ul.tree a').forEach(link => {
        link.classList.remove('selected');
    });
    
    // 경로 초기화
    const pathElement = document.getElementById('selectedCategoryPath');
    pathElement.textContent = '최상위 카테고리로 등록됩니다';
    pathElement.classList.add('empty');
    pathElement.classList.remove('has-selection');
}

// 폼 검증
function validateForm() {
    const categoryName = document.querySelector('input[name="categoryName"]').value.trim();
    
    if (!categoryName) {
        alert('카테고리명을 입력해주세요.');
        return false;
    }
    
    if (categoryName.length > 50) {
        alert('카테고리명은 50자 이내로 입력해주세요.');
        return false;
    }
    
    // 중복 검사 (같은 부모 하위에서)
    const parentId = selectedCategoryId || null;
    const isDuplicate = Array.from(categoryMap.values()).some(category => {
        return category.parentId === parentId && 
               category.name.toLowerCase() === categoryName.toLowerCase();
    });
    
    if (isDuplicate) {
        alert('같은 레벨에 동일한 이름의 카테고리가 이미 존재합니다.');
        return false;
    }
    
    return true;
}