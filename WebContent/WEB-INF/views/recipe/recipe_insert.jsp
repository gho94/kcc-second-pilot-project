<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Menu" %>
<%@ page import="com.secondproject.cooook.model.Ingredient" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    List<Ingredient> ingList = (List<Ingredient>) request.getAttribute("ingList");
        request.setAttribute("pageStyles", List.of("/resources/css/merge.css","/resources/css/recipe_merge.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div class="content list-content">
    <div class="container">

        <div class="menu-title-con">
            <span class="menu-title">레시피 추가</span>
        </div>
        <!-- 폼 컨테이너 -->
        <div class="form-con">
            <form action="/recipe/insert.do" method="post" class="recipe-form">
                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">메뉴 <span class="required">*</span></label>
                        <div class="custom-dropdown" data-name="menuId">
                            <input type="hidden" id="menuId" name="menuId" data-valid="메뉴를 선택해주세요" value="">
                            <div class="dropdown-trigger" tabindex="0">
                                <span class="dropdown-text">메뉴를 선택해주세요</span>
                                <span class="dropdown-arrow">▼</span>
                            </div>

                            <div class="dropdown-list">
                                <ul>
                                    <c:forEach var="m" items="${menuList}">
                                        <li data-value="${m.menuId}">
                                            [${m.menuName}]
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 재료 목록 -->
                <div class="form-row">
					<div class="form-group full-width">
                    <div class="section-header">
                        <label class="form-label">재료 목록 <span class="required">*</span></label>
                        <button type="button" class="add-ingredient-btn" id="addIngredientBtn">
                            + 재료 추가
                        </button>
                    </div>
                    <div class="ingredients-table">
                        <div class="table-header">
                            <div class="header-cell ingredient-col">재료명</div>
                            <div class="header-cell quantity-col">수량</div>
                            <div class="header-cell unit-col">단위</div>
                            <div class="header-cell description-col">설명 (선택사항)</div>
                            <div class="header-cell action-col">삭제</div>
                        </div>

                        <div class="table-body" id="ingredientsTable">
                            <!-- 동적으로 추가되는 재료들 -->
                        </div>
                    </div>
                    </div>
                </div>


                <div class="page-actions">
                    <input type="hidden" name="roleId" value="${role.roleId}"/>
                    <input type="submit" class="btn btn-primary" value="저장하기">
                    <input type="button" class="btn btn-cancel" onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')" value="목록으로">
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<!-- 재료 데이터 설정 -->
<script>
    window.allIngredients = [
        <c:forEach var="ing" items="${ingList}" varStatus="status">
            {
                id: '${ing.ingredientId}',
                name: '${ing.ingredientName}',
                unit: '${ing.unitDefault}'
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

</script>

<script src="/resources/js/recipe_insert.js"></script>


<script src="/resources/js/dropdown.js"></script>
<script src="/resources/js/merge.js"></script>
</body>
</html>
