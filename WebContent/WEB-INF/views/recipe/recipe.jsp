<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Recipe" />
<c:set var="searchPlaceholder">
	<fmt:message key="검색플레이스홀더" />
</c:set>
<fmt:message key="삭제"           var="delete"/>
<fmt:message key="삭제확인"    var="deleteConfirm"/>
<fmt:message var="editText"              key="수정"/>
<fmt:message var="ingredientCountText"   key="재료"/>
<fmt:message var="text"   key="개"/>
<fmt:message var="noRecipesText"         key="레시피없음"/>
<fmt:message var="headerIngredientText"  key="재료명"/>
<fmt:message var="headerQuantityText"    key="수량"/>
<fmt:message var="headerDescriptionText" key="설명"/>
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
	    edit:              '${editText}',           // 예: '수정'
	    delete: '${delete}',                    // '삭제'
	    deleteConfirmation: '${deleteConfirm}'	 ,   
	    ingredientCount:   '${ingredientCountText}',
	    noRecipes:         '${noRecipesText}',
	    texts:         '${text}',
	    headerIngredientName: '${headerIngredientText}',
	    headerQuantity:      '${headerQuantityText}',
	    headerDescription:   '${headerDescriptionText}'

	  };
console.log("i18n messages:", window.msg);

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