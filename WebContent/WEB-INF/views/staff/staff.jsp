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
			<span class="menu-title">작업자 목록</span>
		</div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="이름, 이메일, 전화번호로 검색..." id="searchInput">
				<div class="search-btn-con"><button class="search-btn" onclick="searchEmployees()"></button></div>
            </div>
            <button class="add-btn" onclick="location.href='/staff/insert.do'">+ 등록</button>
        </div>

        <div class="table-container">
            <table border="1">
                <thead>
                <tr>
                    <th>번호</th>
                    <th>이름</th>
                    <th>권한</th>
                    <th>이메일</th>
                    <th>전화번호</th>
                    <th>생성일</th>
                    <th>관리</th>
                <tr>
                </thead>
                <tbody id="listTable">
                <c:forEach var="staff" items="${staffs}">
                    <tr>
                        <td>${staff.staffId}</td>
                        <td>${staff.firstName}${staff.lastName}</td>
                        <td>${staff.roleName}</td>
                        <td>${staff.email}</td>
                        <td>${staff.phone}</td>
                        <td>${staff.createdAt}</td>
                        <td class="row">
                            <form action="/staff/update.do" class="manage-btn-con col-lg-6">
                                <input type="hidden" name="staffId" value="${staff.staffId}"/>
                                <span class="manage-btn update-btn"><input type="submit" value="수정"/></span>
                            </form>
							<form action="/staff/delete.do"  class="manage-btn-con col-lg-6" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
							                             <input type="hidden" name="staffId" value="${staff.staffId}"/>
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
    window.staffData = [
        <c:forEach var="staff" items="${staffs}" varStatus="status">
        {
            id: ${staff.staffId},
            name: '${staff.firstName}${staff.lastName}',
            email: '${staff.email}',
            phone: '${staff.phone}',
            role: '${staff.roleName}',
            createdAt: '${staff.createdAt}',
            staffId: ${staff.staffId}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
<script src="/resources/js/list.js"></script>
</body>
</html>