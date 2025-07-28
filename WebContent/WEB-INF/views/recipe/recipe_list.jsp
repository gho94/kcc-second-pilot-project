<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.secondproject.cooook.model.Recipe"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
List<Recipe> recipeList = (List<Recipe>) request.getAttribute("recipeList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>COOKCOOK - 레시피 목록</title>

<link rel="stylesheet" href="/resources/css/recipe_list.css">
</head>
<body>
	<!-- 메인 컨테이너 -->
	<div class="main-container">
		<!-- 페이지 헤더 -->
		<div class="page-header">
			<h1 class="page-title">레시피 목록</h1>
			<div class="page-controls">
				<!-- 검색 영역 -->
				<div class="search-container">
					<form method="get" style="display: flex; gap: 10px; width: 100%;">
						<input type="text" name="menuName" class="search-input"
							placeholder="메뉴명으로 검색..."
							value="<%=request.getParameter("menuName") != null ? request.getParameter("menuName") : ""%>">
						<button type="submit" class="search-btn">🔍</button>
						<%
						if (request.getParameter("menuName") != null && !request.getParameter("menuName").isEmpty()) {
						%>
						<button type="button" class="cancel-btn" onclick="cancelSearch()">취소</button>
						<%
						}
						%>
					</form>
				</div>

				<!-- 등록 버튼 -->
				<a href="insert.do" class="register-btn">등록</a>
			</div>
		</div>

		<!-- 메뉴 목록 -->
		<div class="menu-container">
			<%
			if (recipeList != null && !recipeList.isEmpty()) {
				// 메뉴별로 그룹화
				java.util.Map<Integer, java.util.List<Recipe>> menuGroups = new java.util.HashMap<>();
				java.util.Map<Integer, String> menuNames = new java.util.HashMap<>();
				
				for (Recipe recipe : recipeList) {
					if (!menuGroups.containsKey(recipe.getMenuId())) {
						menuGroups.put(recipe.getMenuId(), new java.util.ArrayList<>());
						menuNames.put(recipe.getMenuId(), recipe.getMenuName());
					}
					menuGroups.get(recipe.getMenuId()).add(recipe);
				}
				
				for (java.util.Map.Entry<Integer, java.util.List<Recipe>> entry : menuGroups.entrySet()) {
					Integer menuId = entry.getKey();
					java.util.List<Recipe> recipes = entry.getValue();
					String menuName = menuNames.get(menuId);
			%>
			<div class="menu-card">
				<div class="menu-header">
					<div class="menu-info">
						<button class="toggle-btn" onclick="toggleRecipes(<%=menuId%>)">
							<span class="toggle-icon" id="icon-<%=menuId%>">▶</span>
						</button>
						<div class="menu-details">
							<h3 class="menu-name"><%=menuName%></h3>
							<p class="ingredient-count">재료 <%=recipes.size()%>개</p>
						</div>
					</div>
					<div class="action-buttons">
						<button class="btn-edit" onclick="updateRecipe(<%=menuId%>)">수정</button>
						<button class="btn-delete" onclick="deleteRecipe(<%=menuId%>)">삭제</button>
					</div>
				</div>
				
				<!-- 레시피 상세 (토글) -->
				<div class="recipe-details" id="recipes-<%=menuId%>" style="display: none;">
					<table class="recipe-table">
						<thead>
							<tr>
								<th>재료명</th>
								<th>수량</th>
								<th>설명</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Recipe recipe : recipes) {
							%>
							<tr>
								<td class="ingredient-name"><%=recipe.getIngredientName()%></td>
								<td class="quantity-badge"><%=recipe.getQuantity()%><%=recipe.getUnit()%></td>
								<td class="description"><%=recipe.getDescription() != null ? recipe.getDescription() : "-"%></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<%
				}
			} else {
			%>
			<div class="empty-state">
				<div class="empty-icon">📝</div>
				<div class="empty-message">등록된 레시피가 없습니다</div>
				<div class="empty-submessage">새로운 레시피를 등록해보세요</div>
			</div>
			<%
			}
			%>
		</div>

		<!-- 페이지네이션 -->
		<div class="pagination">
			<a href="#" class="page-btn active">1</a>
		</div>
	</div>

	<script src="/resources/js/recipe_list.js"></script>
</body>
</html>
