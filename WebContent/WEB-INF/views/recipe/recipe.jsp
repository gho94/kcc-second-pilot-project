<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            <span class="menu-title">레시피 목록</span>
        </div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="메뉴명, 재료명으로 검색..." id="searchInput">
                <div class="search-btn-con">
                    <button class="search-btn" onclick="searchData()"></button>
                </div>
            </div>
            <button class="add-btn" onclick="location.href='/recipe/insert.do'">+ 등록</button>
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
<script src="/resources/js/recipe.js"></script>
<script src="/resources/js/list.js"></script>
</body>
</html>