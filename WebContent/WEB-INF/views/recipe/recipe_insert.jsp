<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Menu" %>
<%@ page import="com.secondproject.cooook.model.Ingredient" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    List<Ingredient> ingList = (List<Ingredient>) request.getAttribute("ingList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 레시피 등록 - COOKCOOK</title>
    <link rel="stylesheet" href="/resources/css/recipe_insert.css">
</head>
<body>
    <div class="container">
        <!-- 헤더 -->
        <div class="header">
            <div class="header-left">
                <span class="header-icon">✏️</span>
                <h1 class="page-title">새 레시피 등록</h1>
            </div>
            <a href="/recipe/list.do" class="back-btn">
                <span class="btn-icon">←</span>
                목록으로
            </a>
        </div>

        <!-- 폼 컨테이너 -->
        <div class="form-container">
            <form action="/recipe/insert.do" method="post" class="recipe-form">
                
                <!-- 메뉴 선택 -->
                <div class="form-section">
                    <h2 class="section-title">메뉴 선택</h2>
                    <div class="section-divider"></div>
                    
                    <div class="menu-info">
                        <span class="menu-label">메뉴:</span>
                        <select name="menuId" id="menuId" class="menu-select" required>
                            <option value="">-- 레시피 미등록 메뉴 선택 --</option>
                            <c:forEach var="m" items="${menuList}">
                                <option value="${m.menuId}">${m.menuName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- 재료 목록 -->
                <div class="form-section">
                    <div class="section-header">
                        <h2 class="section-title">재료 목록</h2>
                        <button type="button" class="add-ingredient-btn" id="addIngredientBtn">
                            + 재료 추가
                        </button>
                    </div>
                    <div class="section-divider"></div>

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

                <!-- 제출 버튼 -->
                <div class="submit-section">
                    <button type="submit" class="submit-btn">
                        <span class="btn-icon">✓</span>
                        레시피 등록
                    </button>
                    <button type="button" class="cancel-btn" id="cancelBtn">
                        <span class="btn-icon">✗</span>
                        취소
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 토스트 메시지 -->
    <div id="toast" class="toast"></div>

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
    
    console.log("재료 데이터 로드됨:", window.allIngredients);
</script>

    <script src="/resources/js/recipe_insert.js"></script>
</body>
</html>
