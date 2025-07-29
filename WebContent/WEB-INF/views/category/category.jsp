<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />

<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Main"  />
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<%
request.setAttribute("pageStyles", List
		.of("https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/themes/default/style.min.css", "/resources/css/list.css"));
request.setAttribute("pageScripts", List.of("https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/jstree.min.js"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="content list-content">
		<div class="container">
			<div class="menu-title-con">
				<span class="menu-title"><fmt:message key="카테고리 목록" /></span>
			</div>
			<div class="controls">
				<div class="search-container">
					<input type="text" class="search-input"
						placeholder="<fmt:message key="카테고리명으로 검색" />..." id="searchInput">
					<div class="search-btn-con">
						<button class="search-btn" onclick="searchData()"></button>
					</div>
				</div>
			</div>
			<div class="help-text">
				<fmt:message key="카테고리 더블클릭 설명" />
				<br>
				<fmt:message key="카테고리 우클릭 설명" />
			</div>
			<div id="categoryTree"></div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
<script>
const i18n = {
	    add:           '<fmt:message key="추가"/>',
	    edit:          '<fmt:message key="수정"/>',
	    delete:        '<fmt:message key="삭제"/>',
	    expand:        '<fmt:message key="펼치기"/>',
	    collapse:      '<fmt:message key="접기"/>',
	    promptAdd:     '<fmt:message key="새카테고리이름을입력하세요"/>',
	    promptEdit:    '<fmt:message key="수정할카테고리이름을입력하세요"/>',
	    confirmDelete: '<fmt:message key="정말로이카테고리를삭제하시겠습니까?"/>'
	  };

window.treeData = <%= request.getAttribute("categoryTree") %>;
</script>
	<script src="/resources/js/category.js"></script>

</body>
</html>