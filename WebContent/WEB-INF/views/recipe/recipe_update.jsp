<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Recipe" />
<fmt:message var="editRecipe" key="레시피수정" />
<fmt:message var="menu" key="메뉴" />
<fmt:message var="ingredientList" key="재료목록" />
<fmt:message var="addIngredient" key="재료추가" />
<fmt:message var="ingredientName" key="재료명" />
<fmt:message var="quantity" key="수량" />
<fmt:message var="unit" key="단위" />
<fmt:message var="description" key="설명" />
<fmt:message var="delete" key="삭제" />
<fmt:message var="save" key="저장" />
<fmt:message var="backList" key="목록으로" />\
<c:set var="placeholder">
	<fmt:message key="검색홀더" />
</c:set>
<%
request.setAttribute("pageStyles", List.of("/resources/css/merge.css","/resources/css/recipe_merge.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="content list-content">	
    <div class="container">
		<div class="menu-title-con">
		    <span class="menu-title">${editRecipe}</span>
		</div>
        <!-- 폼 컨테이너 -->
        <div class="form-con">
			

			<div class="form-row">
			    <div class="form-group full-width">
			        <label class="form-label">${menu} <span class="required">*</span></label>
			        
					<div class="form-input readonly">${menuName}</div>
			    </div>
			</div>
			
            <form method="post" action="/recipe/update.do" id="recipeForm">
                <input type="hidden" name="menuId" value="${menuId}" />

				<div class="form-row">
					<div class="form-group full-width">
						
						<div class="section-header">
						                        <label class="form-label">${ingredientList} <span class="required">*</span></label>
						                        <button type="button" class="add-ingredient-btn" onclick="addIngredientRow()">
						                            + ${addIngredient}
						                        </button>
						                    </div>
											<div class="ingredients-table">
						
												<div class="table-header">
												                     <div class="header-cell ingredient-col">${ingredientName}</div>
												                     <div class="header-cell quantity-col">${quantity}</div>
												                     <div class="header-cell unit-col">${unit}</div>
												                     <div class="header-cell description-col">${description}</div>
												                     <div class="header-cell action-col">${delete}</div>
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
                                           class="field-input" placeholder="${placeholder}" />
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
				    <input type="submit" class="btn btn-primary" value="${save}">
				    <input type="button" class="btn btn-cancel" onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')" value="${backList}">
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
