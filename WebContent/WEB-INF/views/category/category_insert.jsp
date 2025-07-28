<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Menu" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.secondproject.cooook.model.Category" %>

<%
    List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 <fmt:message key="등록" /></title>
    <link rel="stylesheet" href="/resources/css/category_insert.css" />

    <script>
        let selectedCategoryId = null;
        let categoryMap = new Map();

        // 페이지 로드 시 카테고리 맵 생성
        document.addEventListener('DOMContentLoaded', function() {
            // 카테고리 데이터를 JavaScript 맵으로 변환
            <%
                if (categoryList != null) {
                    for (Category category : categoryList) {
            %>
                        categoryMap.set(<%= category.getCategoryId() %>, {
                            id: <%= category.getCategoryId() %>,
                            name: '<%= category.getCategoryName().replace("'", "\\'") %>',
                            parentId: <%= category.getParentId() != null ? category.getParentId() : "null" %>,
                            level: <%= category.getLevel() %>
                        });
            <%
                    }
                }
            %>

  
    </script>
</head>
<body>
    <div class="container">
        <h2>카테고리 <fmt:message key="등록" /></h2>

        <div class="tree-section">
            <h3>📂 카테고리 트리 (상위 카테고리 선택)</h3>
            <div class="tree-container">
                <ul class="tree">
                    <%
                        if (categoryList != null && !categoryList.isEmpty()) {
                            for (Category c1 : categoryList) {
                                if (c1.getLevel() == 1) {
                    %>
                        <li>
                            <span class="toggle" onclick="toggleChildren(<%=c1.getCategoryId()%>)">📁</span>
                            <a href="#" onclick="selectCategory(<%=c1.getCategoryId()%>, '<%=c1.getCategoryName()%>')">
                                <%=c1.getCategoryName()%>
                            </a>
                            <ul class="tree hidden" id="child-<%=c1.getCategoryId()%>">
                                <%
                                    for (Category c2 : categoryList) {
                                        if (Objects.equals(c2.getParentId(), c1.getCategoryId())) {
                                %>
                                    <li>
                                        <a href="#" onclick="selectCategory(<%=c2.getCategoryId()%>, '<%=c2.getCategoryName()%>')">
                                            └ <%=c2.getCategoryName()%>
                                        </a>
                                    </li>
                                <%
                                        }
                                    }
                                %>
                            </ul>
                        </li>
                    <%
                                }
                            }
                        } else {
                    %>
                        <li class="empty-tree">
                            <fmt:message key="등록" />된 카테고리가 없습니다.<br>
                            첫 번째 카테고리를 <fmt:message key="등록" />해보세요!
                        </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>

        <hr>

        <div class="form-section">
            <h3>📝 새 카테고리 입력</h3>
            
            <div class="input-layout">
                <!-- 왼쪽: 선택된 카테고리 경로 -->
                <div class="input-box">
                    <label class="input-label">선택된 상위 카테고리</label>
                    <div class="selected-path empty" id="selectedCategoryPath">
                        최상위 카테고리로 <fmt:message key="등록" />됩니다
                    </div>
                    <div style="margin-top: 10px; text-align: center;">
                        <button type="button" onclick="clearSelection()" 
                                style="background: none; border: 1px solid #9dc3e6; color: #9dc3e6; padding: 6px 12px; border-radius: 4px; font-size: 12px; cursor: pointer;">
                            선택 초기화
                        </button>
                    </div>
                </div>
                
                <!-- 오른쪽: 카테고리명 입력 -->
                <div class="input-box">
                    <label class="input-label" for="categoryName">새 카테고리명</label>
                    <input type="text" 
                           id="categoryName"
                           name="categoryName" 
                           class="form-input"
                           placeholder="<fmt:message key="등록" />할 카테고리명을 입력하세요" 
                           maxlength="50" 
                           required>
                    <div style="margin-top: 8px; font-size: 12px; color: #6c757d;">
                        * 최대 50자까지 입력 가능합니다
                    </div>
                </div>
            </div>

            <form method="post" action="insert.do">
                <input type="hidden" name="parentId" id="selectedParentId" value="">
                <input type="hidden" name="categoryName" id="hiddenCategoryName" value="">
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary" onclick="syncFormData()"><fmt:message key="등록" /></button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='category.do'"><fmt:message key="취소" /></button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 폼 제출 시 데이터 동기화
        function syncFormData() {
            const categoryName = document.getElementById('categoryName').value;
            document.getElementById('hiddenCategoryName').value = categoryName;
        }
    </script>
    	<script src="/resources/js/category_insert.js"></script>
    
</body>
</html>
