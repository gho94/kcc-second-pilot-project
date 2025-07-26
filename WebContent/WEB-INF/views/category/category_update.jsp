<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.secondproject.cooook.model.Category" %>

<%
    Category category = (Category) request.getAttribute("category");
    List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 수정</title>
            <link rel="stylesheet" href="/resources/css/category_update.css" />
            	<script src="/resources/js/category_update.js"></script>
        
    <script>
        let selectedCategoryId = <%= category.getParentId() != null ? category.getParentId() : "null" %>;
        let categoryMap = new Map();
        let currentCategoryId = <%= category.getCategoryId() %>;

        // 페이지 로드 시 카테고리 맵 생성
        document.addEventListener('DOMContentLoaded', function() {
            // 카테고리 데이터를 JavaScript 맵으로 변환
            <%
                if (categoryList != null) {
                    for (Category c : categoryList) {
            %>
                        categoryMap.set(<%= c.getCategoryId() %>, {
                            id: <%= c.getCategoryId() %>,
                            name: '<%= c.getCategoryName().replace("'", "\\'") %>',
                            parentId: <%= c.getParentId() != null ? c.getParentId() : "null" %>,
                            level: <%= c.getLevel() %>
                        });
            <%
                    }
                }
            %>

            // 현재 선택된 상위 카테고리 표시
            updateSelectedPath();

            // 입력 필드 포커스 이벤트
            const input = document.querySelector('input[name="categoryName"]');
            const inputBox = input.closest('.input-box');
            
            input.addEventListener('focus', function() {
                inputBox.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                inputBox.classList.remove('focused');
            });

            // 현재 선택된 카테고리 하이라이트
            if (selectedCategoryId) {
                const selectedLink = document.querySelector(`a[onclick*="${selectedCategoryId}"]`);
                if (selectedLink) {
                    selectedLink.classList.add('selected');
                }
            }
        });

        
    </script>
</head>
<body>
    <div class="container">
        <h2>카테고리 수정</h2>

        <!-- 현재 카테고리 정보 -->
        <div class="current-category-info">
            <div class="current-category-title">
                ✏️ 수정 중인 카테고리
            </div>
            <div class="current-category-name">
                <%= category.getCategoryName() %>
            </div>
        </div>

        <div class="tree-section">
            <h3>📂 상위 카테고리 선택 (선택사항)</h3>
            <div class="tree-container">
                <ul class="tree">
                    <%
                        if (categoryList != null && !categoryList.isEmpty()) {
                            for (Category c1 : categoryList) {
                                if (c1.getLevel() == 1 && c1.getCategoryId() != category.getCategoryId()) {
                    %>
                        <li>
                            <span class="toggle" onclick="toggleChildren(<%=c1.getCategoryId()%>)">📁</span>
                            <a href="#" onclick="selectCategory(<%=c1.getCategoryId()%>, '<%=c1.getCategoryName().replace("'", "\\'")%>')">
                                <%=c1.getCategoryName()%>
                            </a>
                            <ul class="tree hidden" id="child-<%=c1.getCategoryId()%>">
                                <%
                                    for (Category c2 : categoryList) {
                                        if (Objects.equals(c2.getParentId(), c1.getCategoryId()) && c2.getCategoryId() != category.getCategoryId()) {
                                %>
                                    <li>
                                        <a href="#" onclick="selectCategory(<%=c2.getCategoryId()%>, '<%=c2.getCategoryName().replace("'", "\\'")%>')">
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
                            다른 카테고리가 없습니다.
                        </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>

        <hr>

        <div class="form-section">
            <h3>📝 카테고리 정보 수정</h3>
            
            <div class="input-layout">
                <!-- 왼쪽: 선택된 카테고리 경로 -->
                <div class="input-box">
                    <label class="input-label">선택된 상위 카테고리</label>
                    <div class="selected-path" id="selectedCategoryPath">
                        <%
                            if (category.getParentId() != null) {
                                String parentPath = "";
                                List<String> pathList = new ArrayList<>();
                                Integer currentParentId = category.getParentId();
                                
                                while (currentParentId != null) {
                                    for (Category c : categoryList) {
                                        if (c.getCategoryId() == currentParentId) {
                                            pathList.add(0, c.getCategoryName());
                                            currentParentId = c.getParentId();
                                            break;
                                        }
                                    }
                                    if (currentParentId != null) {
                                        boolean found = false;
                                        for (Category c : categoryList) {
                                            if (c.getCategoryId() == currentParentId) {
                                                found = true;
                                                break;
                                            }
                                        }
                                        if (!found) break;
                                    }
                                }
                                
                                parentPath = String.join(" > ", pathList);
                                out.print(parentPath);
                            } else {
                                out.print("최상위");
                            }
                        %>
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
                    <label class="input-label" for="categoryName">카테고리명</label>
                    <input type="text" 
                           id="categoryName"
                           name="categoryName" 
                           class="form-input"
                           value="<%= category.getCategoryName() %>"
                           placeholder="카테고리명을 입력하세요" 
                           maxlength="50" 
                           required>
                    <div style="margin-top: 8px; font-size: 12px; color: #6c757d;">
                        * 최대 50자까지 입력 가능합니다
                    </div>
                </div>
            </div>

            <form method="post" action="update.do" onsubmit="return submitForm()">
                <input type="hidden" name="categoryId" value="<%= category.getCategoryId() %>">
                <input type="hidden" name="parentId" id="selectedParentId" value="<%= category.getParentId() != null ? category.getParentId() : "" %>">
                <input type="hidden" name="categoryName" id="hiddenCategoryName" value="">
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">수정 완료</button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='list.do'">취소</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
