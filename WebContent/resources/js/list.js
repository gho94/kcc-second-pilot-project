let currentPage = 1;
let row = "";
if(menuName  =="staff")
 row = '<tr>' +
    '<td>' + employee.id + '</td>' +
    '<td>' + employee.name + '</td>' +
    '<td>' + employee.role + '</td>' +
    '<td>' + employee.email + '</td>' +
    '<td>' + employee.phone + '</td>' +
    '<td>' + employee.createdAt + '</td>' +
    '<td class="row">' +
        '<form action="/staff/update.do" class="manage-btn-con col-lg-6">' +
            '<input type="hidden" name="staffId" value="' + employee.staffId + '"/>' +
            '<span class="manage-btn update-btn"><input type="submit" value="수정"/></span>' +
        '</form>' +
        '<form action="/staff/delete.do" class="manage-btn-con col-lg-6" method="post" onsubmit="return confirm(\'정말 삭제하시겠습니까?\');">' +
            '<input type="hidden" name="staffId" value="' + employee.staffId + '"/>' +
            '<span class="manage-btn delete-btn"><input type="submit" value="삭제"/></span>' +
        '</form>' +
    '</td>' +
'</tr>';
}else if(){
	
}
// JSP에서 전달받은 데이터 사용
const allEmployees = window.staffData || [];
let filteredEmployees = [...allEmployees];

function searchEmployees() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();

    if (searchTerm === '') {
        filteredEmployees = [...allEmployees];
    } else {
        filteredEmployees = allEmployees.filter(employee =>
            employee.name.toLowerCase().includes(searchTerm) ||
            employee.email.toLowerCase().includes(searchTerm) ||
            employee.phone.includes(searchTerm)
        );
    }

    updateTable();
    updatePagination();
}

function updateTable() {
    const tbody = document.getElementById('listTable');
    const startIndex = (currentPage - 1) * 5;
    const endIndex = startIndex + 5;
    const pageEmployees = filteredEmployees.slice(startIndex, endIndex);

    tbody.innerHTML = '';

    pageEmployees.forEach(employee => {
        tbody.innerHTML += row;
    });
}

function updatePagination() {
    const totalPages = Math.ceil(filteredEmployees.length / 5);
    const pagination = document.querySelector('.pagination');

    // 페이지 버튼들 다시 생성
    pagination.innerHTML = '<button class="nav-btn" onclick="previousPage()" id="prevBtn">‹</button>';

    for (let i = 1; i <= totalPages; i++) {
        const activeClass = i === currentPage ? 'active' : '';
        pagination.innerHTML += '<button class="page-btn ' + activeClass + '" onclick="goToPage(' + i + ')">' + i + '</button>';
    }

    pagination.innerHTML += '<button class="nav-btn" onclick="nextPage()" id="nextBtn">›</button>';

    // 이전/다음 버튼 상태 업데이트
    document.getElementById('prevBtn').disabled = currentPage === 1;
    document.getElementById('nextBtn').disabled = currentPage === totalPages || totalPages === 0;
}

function goToPage(page) {
    const totalPages = Math.ceil(filteredEmployees.length / 5);
    if (page >= 1 && page <= totalPages) {
        currentPage = page;
        updateTable();
        updatePagination();
    }
}

function previousPage() {
    if (currentPage > 1) {
        goToPage(currentPage - 1);
    }
}

function nextPage() {
    const totalPages = Math.ceil(filteredEmployees.length / 5);
    if (currentPage < totalPages) {
        goToPage(currentPage + 1);
    }
}

// 엔터키로 검색
document.getElementById('searchInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        searchEmployees();
    }
});

// 실시간 검색
document.getElementById('searchInput').addEventListener('input', function () {
    searchEmployees();
});

// DOM이 로드된 후 초기화
document.addEventListener('DOMContentLoaded', function() {
    updateTable();
    updatePagination();
});