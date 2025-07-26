<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Category" %>
<%
    List<Category> list = (List<Category>) request.getAttribute("categoryList");
%>
<html>
<head>
    <title>카테고리 목록</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="/resources/css/category_list.css" />
        
</head>
<body>
    <div class="container">
        <!-- 헤더 -->
        <div class="header">
            <h1>카테고리 목록</h1>
            <div class="header-actions">
                <a href="insert.do" class="btn btn-primary">카테고리 추가</a>
                <button type="button" class="btn btn-secondary" onclick="refreshList()">새로고침</button>
            </div>
        </div>

        <!-- 선택된 카테고리 정보 -->
        

        <!-- 카테고리 리스트 -->
        <div class="category-list-container">
            <div class="list-header">
                <span>카테고리 구조 (클릭하여 선택)</span>
                <div class="expand-controls">
                    <button type="button" class="expand-btn" onclick="expandAll()">모두 펼치기</button>
                    <button type="button" class="expand-btn" onclick="collapseAll()">모두 접기</button>
                </div>
            </div>
            
            <div class="category-tree" id="categoryTree">
                <% if (list != null && !list.isEmpty()) { %>
                    <% 
                    // 각 레벨별로 하위 카테고리가 있는지 미리 계산
                    java.util.Map<Integer, Boolean> hasChildren = new java.util.HashMap<>();
                    for (Category c : list) {
                        for (Category potential : list) {
                            if (potential.getParentId() != null && potential.getParentId().equals(c.getCategoryId())) {
                                hasChildren.put(c.getCategoryId(), true);
                                break;
                            }
                        }
                        if (!hasChildren.containsKey(c.getCategoryId())) {
                            hasChildren.put(c.getCategoryId(), false);
                        }
                    }
                    
                    for (Category c : list) {
                        String parentName = "";
                        if (c.getParentId() != null) {
                            for (Category p : list) {
                                if (p.getCategoryId() == c.getParentId()) {
                                    parentName = p.getCategoryName();
                                    break;
                                }
                            }
                        }
                        
                        String depthClass = c.getLevel() == 1 ? "depth-0" : "depth-sub";
                        String displayStyle = c.getLevel() > 1 ? "style=\"display: none;\"" : "";
                        boolean hasChild = hasChildren.get(c.getCategoryId());
                    %>
                        <div class="category-item <%= depthClass %>" 
                             data-category-id="<%= c.getCategoryId() %>" 
                             data-level="<%= c.getLevel() %>"
                             data-parent-id="<%= c.getParentId() != null ? c.getParentId() : "null" %>"
                             data-category-name="<%= c.getCategoryName() %>"
                             onclick=""
                             <%= displayStyle %>>
                            
                            <!-- 들여쓰기 (1뎁스 이상만) -->
                            <% if (c.getLevel() > 1) { %>
                                <% for (int i = 1; i < c.getLevel(); i++) { %>
                                    <span class="category-indent"></span>
                                <% } %>
                            <% } %>
                            
                            <!-- 토글 아이콘 (하위 카테고리가 있는 경우만) -->
                            <% if (hasChild) { %>
                                <span class="toggle-icon" onclick="toggleCategory(event, <%= c.getCategoryId() %>)">▶</span>
                            <% } else { %>
                                <span class="toggle-icon"></span>
                            <% } %>
                            
                            <!-- 카테고리 정보 -->
                            <div class="category-info">
                                <div class="category-name"><%= c.getCategoryName() %></div>
                                <div class="category-meta">
                                    <div class="meta-item">
                                        <span class="meta-label">ID:</span>
                                        <span class="meta-value"><%= c.getCategoryId() %></span>
                                    </div>
                                    <% if (c.getParentId() != null) { %>
                                        <div class="meta-item">
                                            <span class="meta-label">상위:</span>
                                            <span class="meta-value"><%= parentName %></span>
                                        </div>
                                    <% } %>
                                    <div class="meta-item">
                                        <span class="meta-label">레벨:</span>
                                        <span class="meta-value"><%= c.getLevel() %></span>
                                    </div>
                                </div>
                            </div>

                            <!-- 액션 버튼들 -->
                            <div class="category-actions">
                                <button type="button" class="action-btn edit-btn" onclick="editCategory(<%= c.getCategoryId() %>)" title="수정">
                                    수정
                                </button>
                                <button type="button" class="action-btn delete-btn" onclick="deleteCategory(<%= c.getCategoryId() %>, '<%= c.getCategoryName().replace("'", "\\'") %>')" title="삭제">
                                    삭제
                                </button>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-icon">📁</div>
                        <div class="empty-text">등록된 카테고리가 없습니다.</div>
                        <a href="insert.do" class="btn btn-primary">첫 번째 카테고리 추가하기</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    	<script src="/resources/js/category_list.js"></script>

</body>
</html>
