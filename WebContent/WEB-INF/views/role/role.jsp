<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK</title>

    <!-- 구글 웹폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
            rel="stylesheet"/>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/normalize.css@8.0.1/"/>
    <!-- 슬라이드 api -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link rel="stylesheet" href="/resources/css/reset.css"/>
    <link rel="stylesheet" href="/resources/css/header_footer.css"/>
    <link rel="stylesheet" href="/resources/css/common.css"/>
    <link rel="stylesheet" href="/resources/css/list.css"/>
    <script src="script/jquery-3.7.1.min.js"></script>
    <script
            src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script
            src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>

<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
            <span class="menu-title">권한 목록</span>
        </div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="이름, 설명, 권한으로 검색..." id="searchInput">
                <div class="search-btn-con">
                    <button class="search-btn" onclick="searchData()"></button>
                </div>
            </div>
            <button class="add-btn" onclick="location.href='/role/insert.do'">+ 등록</button>
        </div>

        <div class="table-container">
            <table border="1">
                <thead>
                <tr>
                    <td>번호</td>
                    <td>이름</td>
                    <td>설명</td>
                    <td>권한</td>
                    <td>관리</td>
                <tr>
                </thead>
                <tbody id="listTable">
                <c:forEach var="role" items="${roles}">
                    <tr>
                        <td>${role.roleId}</td>
                        <td>${role.roleName}</td>
                        <td>${role.description}</td>
                        <td>${role.featureNames}</td>
                        <td class="row">
                            <form action="/role/update.do" class="manage-btn-con col-lg-6">
                                <input type="hidden" name="roleId" value="${role.roleId}"/>
                                <span class="manage-btn update-btn"><input type="submit" value="수정"/></span>
                            </form>
                            <form action="/role/delete.do" method="post" class="manage-btn-con col-lg-6"
                                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <input type="hidden" name="roleId" value="${role.roleId}"/>
                                <span class="manage-btn delete-btn"><input type="submit" value="삭제"/></span>
                            </form>
                        </td>
                    <tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="pagination">
            <button class="nav-btn" onclick="previousPage()" id="prevBtn">‹</button>
            <button class="page-btn active" onclick="goToPage(1)">1</button>
            <button class="nav-btn" onclick="nextPage()" id="nextBtn">›</button>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<script>
    // JSP 데이터를 JavaScript 전역 변수로 전달
    window.menuName = 'role';
    window.saveData = [
        <c:forEach var="role" items="${roles}" varStatus="status">
            {
                id: ${role.roleId},
                name: '${role.roleName}',
                description: '${role.description}',
                featureCodes: '${role.featureCodes}',
                featureNames: '${role.featureNames}'
            }
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
<script src="/resources/js/list.js"></script>
</body>
</html>