<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
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
			

			<div class="form-row">
			    <div class="form-group full-width">
			        <label class="form-label">메뉴 <span class="required">*</span></label>
			        
					<div class="form-input readonly">${menuName}</div>
			    </div>
			</div>
			
            <form method="post" action="/recipe/update.do" id="recipeForm">
                <input type="hidden" name="menuId" value="${menuId}" />

				<div class="form-row">
					<div class="form-group full-width">
						
						<div class="section-header">
						                        <label class="form-label">재료 목록 <span class="required">*</span></label>
						                        <button type="button" class="add-ingredient-btn" onclick="addIngredientRow()">
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
                    <div class="table-body" id="ingredientTableBody">
                        <!-- 기존 재료 출력 -->
                        <c:forEach var="item" items="${recipeList}">
                            <div class="table-row ingredient-row">
                                <div class="table-cell ingredient-col">
                                    <span class="ingredient-name">${item.ingredientName}</span>
                                    <input type="hidden" name="ingredientId" value="${item.ingredientId}" />
                                </div>
                                <div class="table-cell quantity-col">
                                    <input type="text" name="quantity" value="${item.quantity}" 
                                           step="0.1" min="0.1" class="field-input" required />
                                </div>
                                <div class="table-cell unit-col">
                                    <input type="text" name="unit" value="${item.unit}" 
                                           class="field-input " />
                                </div>
                                <div class="table-cell description-col">
                                    <input type="text" name="description" value="${item.description}" 
                                           class="field-input" placeholder="예: 잘게 다져서" />
                                </div>
                                <div class="table-cell action-col">
                                    <input type="checkbox" name="delete" value="${item.ingredientId}" 
                                           class="delete-checkbox" />
                                </div>
                            </div>
                        </c:forEach>
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
