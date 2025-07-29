<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Recipe" />
<c:set var="searchPlaceholder">
	<fmt:message key="검색플레이스홀더" />
</c:set>
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of(
    "/resources/css/recipe_list.css",
    "/resources/css/list.css"
));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
            <span class="menu-title"><fmt:message key="레시피목록" /></span>
        </div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="${searchPlaceholder}" id="searchInput">
                <div class="search-btn-con">
                    <button class="search-btn" onclick="searchData()"></button>
                </div>
            </div>
            <button class="add-btn" onclick="location.href='/recipe/insert.do'">+
					<fmt:message key="등록" /></button>
        </div>

		<div class="table-container">
        <!-- 메뉴 목록 -->
        <div class="menu-container" id="listTable">
        </div>
		</div>
        <div class="pagination">
            <button class="nav-btn" onclick="previousPage()" id="prevBtn">‹</button>
            <button class="page-btn active" onclick="goToPage(1)">1</button>
            <button class="nav-btn" onclick="nextPage()" id="nextBtn">›</button>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<script>
window.msg = {
	    edit: '<fmt:message key="수정"/>',                 // → '수정'
	    delete: '<fmt:message key="삭제"/>',             // → '삭제'
	    ingredientCount: '<fmt:message key="재료수"/>',
	    noRecipes: '<fmt:message key="레시피없음"/>',
	    deleteConfirmation: '<fmt:message key="삭제확인"/>',
	    headerIngredientName: '<fmt:message key="재료명"/>',
	    headerQuantity: '<fmt:message key="수량"/>',
	    headerDescription: '<fmt:message key="설명"/>'
	  };
    // JSP 데이터를 JavaScript 전역 변수로 전달
    window.menuName = 'recipe';
    window.saveData = [
        <c:forEach var="recipe" items="${recipeList}" varStatus="status">
        {
            recipeId: ${recipe.recipeId},
            menuId: ${recipe.menuId},
            menuName: '${recipe.menuName}',
            categoryId: ${recipe.categoryId},
            categoryName: '${recipe.categoryName}',
            quantity: ${recipe.quantity},
            unit: '${recipe.unit}',
            description: '${recipe.description}',
            ingredientName: '${recipe.ingredientName}',
            ingredientId: ${recipe.ingredientId}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
<script src="/resources/js/list.js"></script>
<script src="/resources/js/recipe.js"></script>
</body>
</html>