<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Menu" />
<fmt:message var="menuList" key="메뉴 목록" />
<c:set var="searchPlaceholder">
	<fmt:message key="검색플레이스홀더" />
</c:set>
<fmt:message var="colNo" key="번호" />
<fmt:message var="colMenuName" key="메뉴명" />
<fmt:message var="colPrice" key="가격" />
<fmt:message var="colManage" key="관리" />
<fmt:message var="add" key="등록"/>
<fmt:message var="editText"    key="수정"/>                 <!-- 수정 -->
<fmt:message var="deleteText"  key="삭제"/>                 <!-- 삭제 -->
<fmt:message var="confirmMsg"  key="정말삭제하시겠습니까"/> <!-- 정말로 삭제하시겠습니까? -->
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
            <span class="menu-title">${menuList}</span>
        </div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="${searchPlaceholder}" id="searchInput">
                <div class="search-btn-con">
                    <button class="search-btn" onclick="searchData()"></button>
                </div>
            </div>
            <button class="add-btn" onclick="location.href='/menu/insert.do'">${add}</button>
        </div>
        <div class="table-container">
            <table border="1">
                <thead>
                <tr>
                    <td>${colNo}</td>
                    <td>${colMenuName}</td>
                    <td>${colPrice}</td>
                    <td>${colManage}</td>
                <tr>
                </thead>
                <tbody id="listTable">
                <c:forEach var="menu" items="${menus}">
                    <tr>
                        <td>${menu.menuId}</td>
                        <td>${menu.menuName}</td>
                        <td>₩<fmt:formatNumber value="${menu.price}" type="number" /></td>
                        <td class="row">
                            <form action="/menu/update.do" class="manage-btn-con col-lg-6">
                                <input type="hidden" name="menuId" value="${menu.menuId}"/>
                                <span class="manage-btn update-btn"><input type="submit" value="${editText}"/></span>
                            </form>
                            <form action="/menu/delete.do" method="post" class="manage-btn-con col-lg-6"
                                  onsubmit="return confirm(i18n.confirmDelete);">
                                <input type="hidden" name="menuId" value="${menu.menuId}"/>
                                <span class="manage-btn delete-btn"><input type="submit" value="${deleteText}"/></span>
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
    window.menuName = 'menu';
    window.saveData = [
        <c:forEach var="menu" items="${menus}" varStatus="status">
            {
                id: ${menu.menuId},
                name: '${menu.menuName}',
                price: '${menu.price}'
            }
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
<script src="/resources/js/list.js"></script>
</body>
</html>