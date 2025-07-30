<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="Role" />
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:message key="수정" var="editText" />
<fmt:message key="삭제" var="deleteText" />
<fmt:message key="정말로삭제하시겠습니까" var="confirmMsg" />
<!DOCTYPE html>
<html>
<%@ page import="java.util.List"%>

<%
request.setAttribute("pageStyles", List.of("/resources/css/list.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>

	<div class="content list-content role-list-content">
		<div class="container">
			<div class="menu-title-con">
				<span class="menu-title"><fmt:message key="권한 목록" /></span>
			</div>
			<div class="controls">
				<div class="search-container">
					<input type="text" class="search-input"
						placeholder="<fmt:message key='검색 플레이스홀더' />" id="searchInput">
					<div class="search-btn-con">
						<button class="search-btn" onclick="searchData()"></button>
					</div>
				</div>
				<button class="add-btn" onclick="location.href='/role/insert.do'">
					+
					<fmt:message key="등록" />
				</button>
			</div>

			<div class="table-container">
				<table border="1">
					<thead>
						<tr>
							<td><fmt:message key="번호" /></td>
							<td><fmt:message key="이름" /></td>
							<td><fmt:message key="설명" /></td>
							<td><fmt:message key="권한" /></td>
							<td><fmt:message key="관리" /></td>
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
										<input type="hidden" name="roleId" value="${role.roleId}" />
										<input type="submit" class="manage-btn update-btn" value="${editText}" />
									</form>
									<form action="/role/delete.do" method="post"
										class="manage-btn-con col-lg-6"
										onsubmit="return confirm('${confirmMsg}');">
										<input type="hidden" name="roleId" value="${role.roleId}" />
										<input type="submit" class="manage-btn delete-btn"value="${deleteText}" />
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
