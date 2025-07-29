let currentPage = 1;

const numPerPage = 10;

// 다국어 처리용 객체
const i18n = {
  edit: "<fmt:message key='수정' />",
  delete: "<fmt:message key='삭제' />",
  confirmDelete: "<fmt:message key='정말\\ 삭제하시겠습니까?' />"
};

function generateRows(dataList) {
  if (menuName === "staff") {
    return dataList.map(employee => `
      <tr>
        <td>${employee.id}</td>
        <td>${employee.name}</td>
        <td>${employee.role}</td>
        <td>${employee.email}</td>
        <td>${employee.phone}</td>
        <td>${employee.createdAt}</td>
        <td class="row">
          <form action="/staff/update.do" class="manage-btn-con col-lg-6">
            <input type="hidden" name="staffId" value="${employee.staffId}" />
            <span class="manage-btn update-btn">
              <input type="submit" value="${i18n.edit}" />
            </span>
          </form>
          <form action="/staff/delete.do" class="manage-btn-con col-lg-6" method="post" onsubmit="return confirm('${i18n.confirmDelete}');">
            <input type="hidden" name="staffId" value="${employee.staffId}" />
            <span class="manage-btn delete-btn">
              <input type="submit" value="${i18n.delete}" />
            </span>
          </form>
        </td>
      </tr>
    `).join('');
  } else if (menuName === "role") {
    return dataList.map(role => `
      <tr>
        <td>${role.id}</td>
        <td>${role.name}</td>
        <td>${role.description}</td>
        <td>${role.featureNames}</td>
        <td class="row">
          <form action="/role/update.do" class="manage-btn-con col-lg-6">
            <input type="hidden" name="roleId" value="${role.id}" />
            <span class="manage-btn update-btn"><input type="submit" value="${i18n.edit}" /></span>
          </form>
          <form action="/role/delete.do" method="post" class="manage-btn-con col-lg-6" onsubmit="return confirm('${i18n.confirmDelete}');">
            <input type="hidden" name="roleId" value="${role.id}" />
            <span class="manage-btn delete-btn"><input type="submit" value="${i18n.delete}" /></span>
          </form>
        </td>
      </tr>
    `).join('');
  } else if (menuName === "order") {
    return dataList.map(order => `
      <tr>
        <td>${order.id}</td>
        <td>${order.name}</td>
        <td>${(+order.quantity).toLocaleString()}</td>
        <td>₩${(+order.totalPrice).toLocaleString()}</td>
        <td>${order.staffName}</td>
        <td>${order.createdAt}</td>
        <td class="row">
          <form action="/order/update.do" class="manage-btn-con col-lg-6">
            <input type="hidden" name="orderId" value="${order.id}" />
            <span class="manage-btn update-btn"><input type="submit" value="${i18n.edit}" /></span>
          </form>
          <form action="/order/delete.do" method="post" class="manage-btn-con col-lg-6" onsubmit="return confirm('${i18n.confirmDelete}');">
            <input type="hidden" name="orderId" value="${order.id}" />
            <span class="manage-btn delete-btn"><input type="submit" value="${i18n.delete}" /></span>
          </form>
        </td>
      </tr>
    `).join('');
  } else if (menuName === "menu") {
    return dataList.map(menu => `
      <tr>
        <td>${menu.id}</td>
        <td>${menu.name}</td>
        <td>₩${(+menu.price).toLocaleString()}</td>
        <td class="row">
          <form action="/menu/update.do" class="manage-btn-con col-lg-6">
            <input type="hidden" name="menuId" value="${menu.id}" />
            <span class="manage-btn update-btn"><input type="submit" value="${i18n.edit}" /></span>
          </form>
          <form action="/menu/delete.do" method="post" class="manage-btn-con col-lg-6" onsubmit="return confirm('${i18n.confirmDelete}');">
            <input type="hidden" name="menuId" value="${menu.id}" />
            <span class="manage-btn delete-btn"><input type="submit" value="${i18n.delete}" /></span>
          </form>
        </td>
      </tr>
    `).join('');
  } else {
    return '';
  }

}

function filterData(allData, searchTerm) {
  const term = searchTerm.toLowerCase();

  return allData.filter(item => {
    if (menuName === "staff") {
      return item.name.toLowerCase().includes(term) ||
             item.email.toLowerCase().includes(term) ||
             item.phone.includes(term);
    } else if (menuName === "role") {
      return item.name.toLowerCase().includes(term) ||
             item.description.toLowerCase().includes(term) ||
             item.featureNames.toLowerCase().includes(term);
    } else if (menuName === "order") {
      return item.name.toLowerCase().includes(term) ||
             item.staffName.toLowerCase().includes(term) ||
             item.totalPrice.toLowerCase().includes(term);
    } else if (menuName === "menu") {
      return item.name.toLowerCase().includes(term) ||
             item.price.toLowerCase().includes(term);
    }
    return false;
  });
}

// ====================== 공통 처리 ======================
const allData = window.saveData || [];
let filteredData = [...allData];

function searchData() {
  const searchTerm = document.getElementById('searchInput').value;
  filteredData = searchTerm === '' ? [...allData] : filterData(allData, searchTerm);
  updateTable();
  updatePagination();
}

function updateTable() {
  const tbody = document.getElementById('listTable');
  const startIndex = (currentPage - 1) * numPerPage;
  const endIndex = startIndex + numPerPage;
  const pageData = filteredData.slice(startIndex, endIndex);

  tbody.innerHTML = generateRows(pageData);
}

function updatePagination() {
  const totalPages = Math.ceil(filteredData.length / numPerPage);
  const pagination = document.querySelector('.pagination');

  pagination.innerHTML = '<button class="nav-btn" onclick="previousPage()" id="prevBtn">‹</button>';

  for (let i = 1; i <= totalPages; i++) {
    const activeClass = i === currentPage ? 'active' : '';
    pagination.innerHTML += `<button class="page-btn ${activeClass}" onclick="goToPage(${i})">${i}</button>`;
  }

  pagination.innerHTML += '<button class="nav-btn" onclick="nextPage()" id="nextBtn">›</button>';

  document.getElementById('prevBtn').disabled = currentPage === 1;
  document.getElementById('nextBtn').disabled = currentPage === totalPages || totalPages === 0;
}

function goToPage(page) {
  const totalPages = Math.ceil(filteredData.length / numPerPage);
  if (page >= 1 && page <= totalPages) {
    currentPage = page;
    updateTable();
    updatePagination();
  }
}

function previousPage() {
  if (currentPage > 1) goToPage(currentPage - 1);
}

function nextPage() {
  const totalPages = Math.ceil(filteredData.length / numPerPage);
  if (currentPage < totalPages) goToPage(currentPage + 1);
}

// 이벤트 바인딩
document.addEventListener('DOMContentLoaded', function () {
  updateTable();
  updatePagination();

  document.getElementById('searchInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') searchData();
  });

  document.getElementById('searchInput').addEventListener('input', searchData);
});
