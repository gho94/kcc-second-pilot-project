<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="Staff" />
<fmt:message var="staffList" key="작업자목록" />
<c:set var="searchPlaceholder">
	<fmt:message key="검색플레이스홀더" />
</c:set>
<fmt:message var="colNo" key="번호" />
<fmt:message var="colName" key="본명" />
<fmt:message var="colRole" key="권한" />
<fmt:message var="colEmail" key="이메일" />
<fmt:message var="colPhone" key="전화번호" />
<fmt:message var="colCreate" key="생성일" />
<fmt:message var="colManage" key="관리" />
<fmt:message var="add" key="등록"/>
<fmt:message var="editText"    key="수정"/>                 <!-- 수정 -->
<fmt:message var="deleteText"  key="삭제"/>                 <!-- 삭제 -->
<fmt:message key="정말로삭제하시겠습니까" var="confirmMsg" />
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of("/resources/css/list.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
			<span class="menu-title">${staffList}</span>
		</div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="${searchPlaceholder}" id="searchInput">
				<div class="search-btn-con"><button class="search-btn" onclick="searchEmployees()"></button></div>
            </div>
            <button class="add-btn" onclick="location.href='/staff/insert.do'">${add}</button>
        </div>

        <div class="table-container">
            <table border="1">
                <thead>
                <tr>
               		 <td>${colNo}</td>
                    <td>${colName}</td>
                    <td>${colRole}</td>
                    <td>${colEmail}</td>
                    <td>${colPhone}</td>
                    <td>${colCreate}</td>
                    <td>${colManage}</td>
                    
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
                                <span class="manage-btn update-btn"><input type="submit" value="${editText}"/></span>
                            </form>
							<form action="/staff/delete.do"  class="manage-btn-con col-lg-6" method="post" onsubmit="return confirm('${confirmMsg}');">
							                             <input type="hidden" name="staffId" value="${staff.staffId}"/>
							                             <span class="manage-btn delete-btn"><input
											type="submit" value="${deleteText}" /></span>
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
const i18n = {
		edit: '${editText}',                 // 수정
		delete: '${deleteText}',             // 삭제
		confirmDelete: '${confirmMsg}'       // 정말로 삭제하시겠습니까
	};	
    // JSP 데이터를 JavaScript 전역 변수로 전달
	window.menuName = 'staff';
    window.saveData = [
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