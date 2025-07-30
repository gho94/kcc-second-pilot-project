let currentPage = 1;
const numPerPage = menuName === "recipe" ? 30 : 10;
let row = "";
if (menuName == "staff") {
	function generateRows(employees) {
		return employees.map(employee => `
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
               <input type="submit" value="${window.msg.edit}"/>
             </span>
           </form>
           <form action="/staff/delete.do" class="manage-btn-con col-lg-6" method="post" onsubmit="return confirm(window.msg.deleteConfirmation);">
             <input type="hidden" name="staffId" value="${employee.staffId}" />
             <span class="manage-btn delete-btn">
               <input type="submit" value="${window.msg.delete}" />
             </span>
           </form>
         </td>
       </tr>
     `).join('');
	}

	function filterData(allData, searchTerm) {
		return allData.filter(employee =>
			employee.name.toLowerCase().includes(searchTerm) ||
			employee.email.toLowerCase().includes(searchTerm) ||
			employee.phone.includes(searchTerm)
		);
	}
} else if (menuName == "role") {
	function generateRows(roles) {
		return roles.map(role => `
      <tr>
         <td>${role.id}</td>
         <td>${role.name}</td>
         <td>${role.description}</td>
         <td>${role.featureNames}</td>
         <td class="row">
            <form action="/role/update.do" class="manage-btn-con col-lg-6">
               <input type="hidden" name="roleId" value="${role.id}" />
               <span class="manage-btn update-btn"><input type="submit" value="${window.msg.edit}"/></span>
            </form>
            <form action="/role/delete.do" method="post" class="manage-btn-con col-lg-6" onsubmit="return confirm(window.msg.deleteConfirmation);">
               <input type="hidden" name="roleId" value="${role.id}" />
               <span class="manage-btn delete-btn"><input type="submit" value="${window.msg.delete}"/></span>
            </form>
         </td>                    
            <tr>
     `).join('');
	}

	function filterData(allData, searchTerm) {
		return allData.filter(role =>
			role.name.toLowerCase().includes(searchTerm) ||
			role.description.toLowerCase().includes(searchTerm) ||
			role.featureNames.toLowerCase().includes(searchTerm)
		);
	}
} else if (menuName == "order") {
	function generateRows(orders) {
		return orders.map(order => `
         <tr>
             <td>${order.id}</td>
             <td>${order.name}</td>
             <td>${(+order.quantity).toLocaleString()}</td>
             <td>₩${(+order.totalPrice).toLocaleString()}</td>
            <td>${order.staffName}</td>
             <td>${order.createdAt}</td>
             <td class="row">
                 <form action="/order/update.do" class="manage-btn-con col-lg-6">
                     <input type="hidden" name="orderId" value="${order.id}"/>
                     <span class="manage-btn update-btn"><input type="submit" value="${window.msg.edit}"/></span>
                 </form>
                 <form action="/order/delete.do" method="post" class="manage-btn-con col-lg-6"
                       onsubmit="return confirm(window.msg.deleteConfirmation);">
                     <input type="hidden" name="orderId" value="${order.id}"/>
                     <span class="manage-btn delete-btn"><input type="submit" value="${window.msg.delete}"/></span>
                 </form>
             </td>
         </tr>
     `).join('');
	}

	function filterData(allData, searchTerm) {
		return allData.filter(order =>
			order.name.toLowerCase().includes(searchTerm) ||
			order.staffName.toLowerCase().includes(searchTerm) ||
			order.totalPrice.toLowerCase().includes(searchTerm)
		);
	}
} else if (menuName == "menu") {
	function generateRows(menus) {
		return menus.map(menu => `
            <tr>
                <td>${menu.id}</td>
                <td>${menu.name}</td>
                <td>₩${(+menu.price).toLocaleString()}</td>
                <td class="row">
                    <form action="/menu/update.do" class="manage-btn-con col-lg-6">
                        <input type="hidden" name="menuId" value="${menu.id}"/>
                        <span class="manage-btn update-btn"><input type="submit" value="${window.msg.edit}"/></span>
                    </form>
                    <form action="/menu/delete.do" method="post" class="manage-btn-con col-lg-6"
                          onsubmit="return confirm(window.msg.deleteConfirmation);">
                        <input type="hidden" name="menuId" value="${menu.id}"/>
                        <span class="manage-btn delete-btn"><input type="submit" value="${window.msg.delete}"/></span>
                    </form>
                </td>
            <tr>
           `).join('');
	}

	function filterData(allData, searchTerm) {
		return allData.filter(menu =>
			menu.name.toLowerCase().includes(searchTerm) ||
			menu.price.toLowerCase().includes(searchTerm)
		);
	}
} else if (menuName == "recipe") {
	function generateRows(recipes) {
		if (!recipes || recipes.length === 0) {
			return '<div class="empty-state"><div class="empty-message">등록된 레시피가 없습니다</div></div>';
		}

		// 메뉴별로 그룹화 (전체 데이터가 아닌 현재 페이지 데이터만)
		const menuGroups = groupRecipesByMenu(recipes);

		return menuGroups.map(group => `
           <div class="menu-card">
               <div class="menu-header">
                   <div class="menu-info">
                       <button class="toggle-btn" onclick="toggleRecipes(${group.menuId})">
                           <span class="toggle-icon" id="icon-${group.menuId}">▶</span>
                       </button>
                       <div class="menu-details">
                           <h3 class="menu-name">${group.menuName}</h3>
                           <p class="ingredient-count mb-0">${window.msg.ingredientCount} ${group.recipes.length}${window.msg.texts}</p>
                       </div>
                   </div>
                   <div class="action-buttons">
                       <form action="/recipe/update.do" class="manage-btn-con col-lg-6">
                           <input type="hidden" name="menuId" value="${group.menuId}"/>
                           <span class="manage-btn update-btn"><input type="submit" value="${window.msg.edit}"/></span>
                       </form>
                       <form action="/recipe/delete.do" method="post" class="manage-btn-con col-lg-6"
							onsubmit="return confirm(window.msg.deleteConfirmation);"                           
							<input type="hidden" name="menuId" value="${group.menuId}"/>
                           <span class="manage-btn delete-btn"><input type="submit" value="${window.msg.delete}"/></span>
                       </form>
                   </div>
               </div>
               
               <div class="recipe-details" id="recipes-${group.menuId}" style="display: none;">
                   <table class="recipe-table">
                       <thead>
                           <tr>
                               <th>${window.msg.headerIngredientName}</th>
                               <th>${window.msg.headerQuantity}</th>
                               <th>${window.msg.headerDescription}</th>
                           </tr>
                       </thead>
                       <tbody>
                           ${group.recipes.map(recipe => `
                               <tr>
                                   <td class="ingredient-name">${recipe.ingredientName}</td>
                                   <td class="quantity-badge">${recipe.quantity}${recipe.unit}</td>
                                   <td class="description">${recipe.description || '-'}</td>
                               </tr>
                           `).join('')}
                       </tbody>
                   </table>
               </div>
           </div>
       `).join('');
	}

	function filterData(allData, searchTerm) {
		if (!searchTerm) return allData;

		const lowerSearchTerm = searchTerm.toLowerCase();

		return allData.filter(recipe =>
			recipe.menuName.toLowerCase().includes(lowerSearchTerm) ||
			recipe.ingredientName.toLowerCase().includes(lowerSearchTerm) ||
			recipe.categoryName.toLowerCase().includes(lowerSearchTerm)
		);
	}
}
// JSP에서 전달받은 데이터 사용
const allData = window.saveData || [];
let filteredData = [...allData];

function searchData() {
	const searchTerm = document.getElementById('searchInput').value.toLowerCase();

	if (searchTerm === '') {
		filteredData = [...allData];
	} else {
		filteredData = filterData(allData, searchTerm);
	}

	updateTable();
	updatePagination();
}

function updateTable() {
	const tbody = document.getElementById('listTable');
	const startIndex = (currentPage - 1) * numPerPage;
	const endIndex = startIndex + numPerPage;
	const pageData = filteredData.slice(startIndex, endIndex);

	tbody.innerHTML = '';
	tbody.innerHTML = generateRows(pageData);
}

function updatePagination() {
	const totalPages = Math.ceil(filteredData.length / numPerPage);
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
	const totalPages = Math.ceil(filteredData.length / numPerPage);
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
	const totalPages = Math.ceil(filteredData.length / numPerPage);
	if (currentPage < totalPages) {
		goToPage(currentPage + 1);
	}
}

// 엔터키로 검색
document.getElementById('searchInput').addEventListener('keypress', function(e) {
	if (e.key === 'Enter') {
		searchData();
	}
});

// 실시간 검색
document.getElementById('searchInput').addEventListener('input', function() {
	searchData();
});

// DOM이 로드된 후 초기화
document.addEventListener('DOMContentLoaded', function() {
	updateTable();
	updatePagination();
});