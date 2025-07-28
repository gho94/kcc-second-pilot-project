<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 수정 - ${menuName}</title>
    <link rel="stylesheet" href="/resources/css/recipe_update.css">
</head>
<body>
    <div class="container">
        <!-- 헤더 -->
        <div class="header">
            <div class="header-left">
                <span class="header-icon">✏️</span>
                <h1 class="page-title">레시피 수정</h1>
            </div>

        </div>

        <!-- 폼 컨테이너 -->
        <div class="form-container">
            <!-- 메뉴 정보 -->
            <div class="menu-info">
                <span class="menu-label">메뉴:</span>
                <span class="menu-name">${menuName}</span>
            </div>

            <form method="post" action="/recipe/update.do" id="recipeForm">
                <input type="hidden" name="menuId" value="${menuId}" />

                <table class="recipe-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">재료명</th>
                            <th style="width: 15%;">수량</th>
                            <th style="width: 10%;">단위</th>
                            <th style="width: 40%;">설명</th>
                            <th style="width: 10%;">삭제</th>
                        </tr>
                    </thead>
                    <tbody id="ingredientTableBody">
                        <!-- 기존 재료 출력 -->
                        <c:forEach var="item" items="${recipeList}">
                            <tr>
                                <td>
                                    <span class="ingredient-name">${item.ingredientName}</span>
                                    <input type="hidden" name="ingredientId" value="${item.ingredientId}" />
                                </td>
                                <td>
                                    <input type="text" name="quantity" value="${item.quantity}" 
                                           step="0.1" min="0.1" class="field-input" required />
                                </td>
                                <td>
                                    <input type="text" name="unit" value="${item.unit}" 
                                           class="field-input " />
                                </td>
                                <td>
                                    <input type="text" name="description" value="${item.description}" 
                                           class="field-input" placeholder="예: 잘게 다져서" />
                                </td>
                                <td>
                                    <input type="checkbox" name="delete" value="${item.ingredientId}" 
                                           class="delete-checkbox" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- 재료 추가 버튼 -->
                <button type="button" class="add-ingredient-btn" onclick="addIngredientRow()">
                    재료 추가
                </button>

                <!-- 제출 버튼 -->
                <div class="submit-section">
                    <button type="submit" class="submit-btn">
                        <span class="btn-icon">✓</span>
                        수정 완료
                    </button>
                    <a href="/recipe/list.do" class="cancel-btn">
                        <span class="btn-icon">✗</span>
                        취소
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- 토스트 메시지 -->
    <div id="toast" class="toast"></div>

    <!-- JavaScript 파일 로드 -->
    <script src="/resources/js/recipe_update.js"></script>
    
    <!-- 재료 데이터 설정 -->
    <script>
        // 재료 목록을 JavaScript로 전달
        const ingredientsData = [
            <c:forEach var="ing" items="${allIngredients}" varStatus="loop">
            {
                id: "${ing.ingredientId}",
                name: "${ing.ingredientName}",
                unit: "${ing.unitDefault}"
            }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        
        // JavaScript 파일의 함수 호출
        setAllIngredients(ingredientsData);
    </script>
</body>
</html>
