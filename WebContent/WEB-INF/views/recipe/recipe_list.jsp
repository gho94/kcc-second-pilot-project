<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Recipe" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK - 레시피 목록</title>
    <style>
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

        /* 상단 헤더 */
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
            display: flex;
            margin-top: 60px;
            min-height: calc(100vh - 60px);
        }

        /* 사이드바 */
        .sidebar {
            width: 250px;
            background-color: white;
            border-right: 1px solid #e9ecef;
            box-shadow: 2px 0 4px rgba(0, 0, 0, 0.05);
        }

        .sidebar-content {
            padding: 30px 20px;
        }

        .sidebar-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        /* 메인 콘텐츠 */
        .main-content {
            flex: 1;
            padding: 30px;
            background-color: #f8f9fa;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #2c3e50;
        }

        .register-btn {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 2px 4px rgba(157, 195, 230, 0.3);
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(157, 195, 230, 0.4);
            background: linear-gradient(135deg, #7ba7d1, #6b94c0);
        }

        /* 검색 영역 */
        .search-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .search-input:focus {
            outline: none;
            border-color: #9dc3e6;
            box-shadow: 0 0 0 2px rgba(157, 195, 230, 0.2);
        }

        .search-btn {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: linear-gradient(135deg, #7ba7d1, #6b94c0);
        }

        /* 테이블 컨테이너 */
        .table-container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .recipe-table {
            width: 100%;
            border-collapse: collapse;
        }

        .recipe-table th {
            background-color: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 1px solid #dee2e6;
            font-size: 14px;
        }

        .recipe-table td {
            padding: 15px 12px;
            border-bottom: 1px solid #f1f3f4;
            font-size: 14px;
            vertical-align: middle;
        }

        .recipe-table tbody tr {
            transition: background-color 0.2s ease;
            cursor: pointer;
        }

        .recipe-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .menu-row {
            background-color: #fff;
            font-weight: 600;
        }

        .menu-row td {
            background-color: #f0f8ff;
            border-left: 4px solid #9dc3e6;
        }

        .ingredient-row {
            display: none;
        }

        .ingredient-row.show {
            display: table-row;
        }

        .toggle-icon {
            display: inline-block;
            margin-right: 8px;
            transition: transform 0.3s ease;
            color: #9dc3e6;
            font-weight: bold;
        }

        .menu-row.expanded .toggle-icon {
            transform: rotate(90deg);
        }

        .menu-id {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 8px;
        }

        .quantity-badge {
            background: linear-gradient(135deg, #9dc3e6, #7ba7d1);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .description-text {
            color: #6c757d;
            font-style: italic;
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #e9ecef;
            }

            .main-content {
                padding: 20px;
            }

            .content-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }

            .search-form {
                flex-direction: column;
            }

            .recipe-table {
                font-size: 12px;
            }

            .recipe-table th,
            .recipe-table td {
                padding: 10px 8px;
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
        <!-- 사이드바 -->
        <aside class="sidebar">
            <div class="sidebar-content">
                <h2 class="sidebar-title">레시피 목록</h2>
            </div>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="main-content">
            <div class="content-header">
                <h1 class="page-title">레시피 목록</h1>
                <a href="insert.do" class="register-btn">등록</a>
            </div>

            <!-- 검색 영역 -->
            <div class="search-container">
                <form class="search-form" method="get">
                    <input type="text" 
                           name="menuName" 
                           class="search-input" 
                           placeholder="메뉴명으로 검색..."
                           value="<%= request.getParameter("menuName") != null ? request.getParameter("menuName") : "" %>">
                    <button type="submit" class="search-btn">🔍</button>
                </form>
            </div>

            <!-- 테이블 -->
            <div class="table-container">
                <%
                    List<Recipe> recipeList = (List<Recipe>) request.getAttribute("recipeList");
                    if (recipeList != null && !recipeList.isEmpty()) {
                %>
                <table class="recipe-table">
                    <thead>
                        <tr>
                            <th>메뉴</th>
                            <th>재료명</th>
                            <th>수량</th>
                            <th>설명</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int prevMenuId = -1;
                            for (Recipe r : recipeList) {
                                int menuId = r.getMenuId();
                                if (menuId != prevMenuId) {
                        %>
                        <tr class="menu-row" data-menuid="<%=menuId%>" onclick="toggleMenu(this)">
                            <td colspan="4">
                                <span class="toggle-icon">▶</span>
                                <span class="menu-id"><%=menuId%></span>
                                <%=r.getMenuName()%>
                            </td>
                        </tr>
                        <%
                                    prevMenuId = menuId;
                                }
                        %>
                        <tr class="ingredient-row menu-<%=menuId%>">
                            <td></td>
                            <td><%=r.getIngredientName()%></td>
                            <td><span class="quantity-badge"><%=r.getQuantity()%><%=r.getUnit()%></span></td>
                            <td><span class="description-text"><%=r.getDescription()%></span></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <%
                    } else {
                %>
                <div class="empty-state">
                    <div class="empty-icon">📝</div>
                    <div>등록된 레시피가 없습니다.</div>
                </div>
                <%
                    }
                %>
            </div>
        </main>
    </div>

    <script>
        function toggleMenu(row) {
            const menuId = row.getAttribute('data-menuid');
            const ingredientRows = document.querySelectorAll('.ingredient-row.menu-' + menuId);
            const toggleIcon = row.querySelector('.toggle-icon');
            const isExpanded = row.classList.contains('expanded');
            
            if (isExpanded) {
                // 접기
                ingredientRows.forEach(r => r.classList.remove('show'));
                row.classList.remove('expanded');
                toggleIcon.textContent = '▶';
            } else {
                // 펼치기
                ingredientRows.forEach(r => r.classList.add('show'));
                row.classList.add('expanded');
                toggleIcon.textContent = '▼';
            }
        }

        // 페이지 로드 시 첫 번째 메뉴 자동 열기
        document.addEventListener('DOMContentLoaded', function() {
            const firstMenuRow = document.querySelector('.menu-row');
            if (firstMenuRow) {
                toggleMenu(firstMenuRow);
            }
        });
    </script>
</body>
</html>
