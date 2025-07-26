<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Recipe" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<Recipe> recipeList = (List<Recipe>) request.getAttribute("recipeList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK - 레시피 목록</title>
    <style>
        /* 전체 페이지 스타일 초기화 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        /* 상단 헤더 스타일 */
        .top-header {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            height: 60px;
        }

        .logo h1 {
            font-size: 24px;
            font-weight: bold;
            color: white;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .main-nav {
            display: flex;
            gap: 30px;
            flex: 1;
            justify-content: center;
        }

        .nav-item {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 14px;
        }

        .nav-item:hover,
        .nav-item.active {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
        }

        .user-profile {
            display: flex;
            align-items: center;
        }

        .profile-icon {
            width: 36px;
            height: 36px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .profile-icon:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        /* 메인 컨테이너 */
        .main-container {
            margin-top: 60px;
            padding: 30px;
            min-height: calc(100vh - 60px);
        }

        /* 페이지 헤더 */
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        .page-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        /* 검색 영역 */
        .search-container {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            max-width: 400px;
        }

        .search-input {
            flex: 1;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #9dc3e6;
            box-shadow: 0 0 0 3px rgba(157, 195, 230, 0.1);
        }

        .search-btn {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            border: none;
            padding: 12px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .search-btn:hover {
            background: linear-gradient(135deg, #7ba7d1, #6b94c0);
            transform: translateY(-1px);
        }

        .cancel-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 14px;
        }

        .cancel-btn:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        /* 등록 버튼 */
        .register-btn {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 2px 4px rgba(157, 195, 230, 0.3);
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            white-space: nowrap;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(157, 195, 230, 0.4);
            background: linear-gradient(135deg, #7ba7d1, #6b94c0);
            text-decoration: none;
            color: white;
        }

        /* 테이블 컨테이너 */
        .table-container {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
        }

        .recipe-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .recipe-table th {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 16px 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            font-size: 14px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        /* 테이블 컬럼 너비 조정 */
        .recipe-table th:nth-child(1),
        .recipe-table td:nth-child(1) { width: 8%; }  /* 번호 */
        .recipe-table th:nth-child(2),
        .recipe-table td:nth-child(2) { width: 20%; } /* 메뉴명 */
        .recipe-table th:nth-child(3),
        .recipe-table td:nth-child(3) { width: 18%; } /* 재료명 */
        .recipe-table th:nth-child(4),
        .recipe-table td:nth-child(4) { width: 15%; } /* 수량 */
        .recipe-table th:nth-child(5),
        .recipe-table td:nth-child(5) { width: 30%; } /* 설명 */
        .recipe-table th:nth-child(6),
        .recipe-table td:nth-child(6) { width: 9%; }  /* 관리 */

        .recipe-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #f1f3f4;
            font-size: 14px;
            vertical-align: middle;
        }

        .recipe-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .recipe-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .recipe-table tbody tr:nth-child(even) {
            background-color: #fafbfc;
        }

        .recipe-table tbody tr:nth-child(even):hover {
            background-color: #f0f2f5;
        }

        /* ID 배지 */
        .recipe-id {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 6px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            min-width: 35px;
            text-align: center;
        }

        /* 메뉴명 스타일 */
        .menu-name {
            font-weight: 600;
            color: #2c3e50;
        }

        /* 재료명 스타일 */
        .ingredient-name {
            color: #495057;
            font-weight: 500;
        }

        /* 수량+단위 배지 */
        .quantity-unit {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 6px 12px;
            border-radius: 16px;
            font-size: 13px;
            font-weight: 500;
            letter-spacing: -0.3px;
            display: inline-block;
            white-space: nowrap;
        }

        /* 설명 텍스트 */
        .description-text {
            color: #6c757d;
            font-style: italic;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            line-height: 1.4;
        }

        .description-text:empty::before {
            content: "-";
            color: #adb5bd;
        }

        /* 관리 버튼들 */
        .action-buttons {
            display: flex;
            gap: 6px;
            justify-content: center;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-edit {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            box-shadow: 0 2px 4px rgba(40, 167, 69, 0.3);
        }

        .btn-edit:hover {
            background: linear-gradient(135deg, #218838, #1ea085);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.4);
            text-decoration: none;
            color: white;
        }

        .btn-delete {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        }

        .btn-delete:hover {
            background: linear-gradient(135deg, #c82333, #dc2626);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.4);
            text-decoration: none;
            color: white;
        }

        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #6c757d;
        }

        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-message {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .empty-submessage {
            font-size: 14px;
            color: #adb5bd;
        }

        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .page-btn {
            background: white;
            color: #9dc3e6;
            border: 2px solid #9dc3e6;
            padding: 8px 12px;
            margin: 0 2px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .page-btn:hover,
        .page-btn.active {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            transform: translateY(-1px);
        }

        /* 반응형 */
        @media (max-width: 1024px) {
            .main-nav {
                gap: 20px;
            }

            .nav-item {
                font-size: 13px;
                padding: 6px 12px;
            }
        }

        @media (max-width: 768px) {
            .header-content {
                padding: 0 15px;
            }

            .main-nav {
                display: none;
            }

            .main-container {
                padding: 20px 15px;
            }

            .page-header {
                padding: 20px;
            }

            .page-controls {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }

            .search-container {
                max-width: none;
            }

            .recipe-table {
                font-size: 12px;
            }

            .recipe-table th,
            .recipe-table td {
                padding: 12px 8px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 4px;
            }

            .btn-action {
                font-size: 11px;
                padding: 4px 8px;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 24px;
            }

            .recipe-table th,
            .recipe-table td {
                padding: 10px 6px;
            }

            .quantity-unit {
                font-size: 11px;
                padding: 4px 8px;
            }

            .recipe-id {
                font-size: 11px;
                padding: 4px 8px;
                min-width: 30px;
            }
        }
    </style>
</head>
<body>
    <!-- 상단 헤더 -->
    <header class="top-header">
        <div class="header-content">
            <div class="logo">
                <h1>COOKCOOK</h1>
            </div>
            <nav class="main-nav">
                <a href="#" class="nav-item active">레시피 관리</a>
                <a href="#" class="nav-item">카테고리 관리</a>
                <a href="#" class="nav-item">권한 관리</a>
                <a href="#" class="nav-item">주문 관리</a>
                <a href="#" class="nav-item">메뉴 관리</a>
                <a href="#" class="nav-item">메뉴 카테고리 관리</a>
                <a href="#" class="nav-item">작업자 관리</a>
            </nav>
            <div class="user-profile">
                <div class="profile-icon">👤</div>
            </div>
        </div>
    </header>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">레시피 목록</h1>
            <div class="page-controls">
                <!-- 검색 영역 -->
                <div class="search-container">
                    <form method="get" style="display: flex; gap: 10px; width: 100%;">
                        <input type="text" 
                               name="menuName" 
                               class="search-input" 
                               placeholder="메뉴명으로 검색..."
                               value="<%= request.getParameter("menuName") != null ? request.getParameter("menuName") : "" %>">
                        <button type="submit" class="search-btn">🔍</button>
                        <% if (request.getParameter("menuName") != null && !request.getParameter("menuName").isEmpty()) { %>
                        <button type="button" class="cancel-btn" onclick="cancelSearch()">취소</button>
                        <% } %>
                    </form>
                </div>
                
                <!-- 등록 버튼 -->
                <a href="insert.do" class="register-btn">등록</a>
            </div>
        </div>

        <!-- 테이블 -->
        <div class="table-container">
            <%
                if (recipeList != null && !recipeList.isEmpty()) {
            %>
            <table class="recipe-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>메뉴명</th>
                        <th>재료명</th>
                        <th>수량</th>
                        <th>설명</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${recipeList}" varStatus="st">
                    <tr>
                        <td><span class="recipe-id">${r.recipeId}</span></td>
                        <td><span class="menu-name">${r.menuName}</span></td>
                        <td><span class="ingredient-name">${r.ingredientName}</span></td>
                        <td><span class="quantity-unit">${r.quantity}${r.unit}</span></td>
                        <td><span class="description-text"><c:out value="${r.description}" default=""/></span></td>
                        <td>
                            <div class="action-buttons">
                                <a href="update.do?recipeId=${r.recipeId}" class="btn-action btn-edit">수정</a>
                                <a href="delete.do?recipeId=${r.recipeId}" 
                                   class="btn-action btn-delete"
                                   onclick="return confirm('이 레시피를 삭제하시겠습니까?');">삭제</a>
                            </div>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
            <%
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
            <a href="#" class="page-btn">1</a>
        </div>
    </div>

    <script>
        function cancelSearch() {
            window.location.href = window.location.pathname;
        }
    </script>
</body>
</html>
