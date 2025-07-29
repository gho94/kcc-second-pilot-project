<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="order" />

<!-- 검색 placeholder 메시지를 변수에 담기 -->
<c:set var="searchPlaceholder">
	<fmt:message key="검색플레이스홀더" />
</c:set>
<fmt:message var="menuTitle" key="주문목록" />
<fmt:message var="colNo" key="번호" />
<fmt:message var="colMenuName" key="메뉴명" />
<fmt:message var="colQuantity" key="수량" />
<fmt:message var="colTotalPrice" key="총액" />
<fmt:message var="colStaffName" key="직원명" />
<fmt:message var="colOrderDate" key="주문일" />
<fmt:message var="colManage" key="관리" />
<fmt:message var="add" key="등록"/>
<fmt:message var="editText"    key="수정"/>                 <!-- 수정 -->
<fmt:message var="deleteText"  key="삭제"/>                 <!-- 삭제 -->
<fmt:message var="confirmMsg"  key="정말삭제하시겠습니까?"/> <!-- 정말로 삭제하시겠습니까? -->
<!DOCTYPE html>
<html>
<%@ page import="java.util.List"%>
<%
request.setAttribute("pageStyles", List.of("/resources/css/list.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="content list-content">
		<div class="container">
			<div class="menu-title-con">
				<span class="menu-title">${menuTitle}</span>
			</div>
			<div class="controls">
				<div class="search-container">
					<input type="text" class="search-input" id="searchInput"
						placeholder="${searchPlaceholder}" />
					<div class="search-btn-con">
						<button class="search-btn" onclick="searchData()"></button>
					</div>
				</div>
				<button
    class="add-btn"
    onclick="location.href='${pageContext.request.contextPath}/order/insert.do'"
>
     ${add}
</button>
			</div>
			<div class="table-container">
				<table border="1">
					<thead>
						<tr>
							<td>${colNo}</td>
							<!-- 번호 -->
							<td>${colMenuName}</td>
							<!-- 메뉴명 -->
							<td>${colQuantity}</td>
							<!-- 수량 -->
							<td>${colTotalPrice}</td>
							<!-- 총액 -->
							<td>${colStaffName}</td>
							<!-- 직원명 -->
							<td>${colOrderDate}</td>
							<!-- 주문일 -->
							<td>${colManage}</td>
							<!-- 관리 -->
						</tr>
					</thead>
					<tbody id="listTable">
						<c:forEach var="order" items="${orders}">
							<tr>
								<td>${order.orderId}</td>
								<td>${order.menuName}</td>
								<td><fmt:formatNumber value="${order.quantity}"
										type="number" /></td>
								<td>₩<fmt:formatNumber value="${order.totalPrice}"
										type="number" /></td>
								<td>${order.staffName}</td>
								<td>${order.createdAt}</td>
								<td class="row">
									<form action="/order/update.do" class="manage-btn-con col-lg-6">
										<input type="hidden" name="orderId" value="${order.orderId}" />
										<span class="manage-btn update-btn"><input
											type="submit"  value="${editText}"  /></span>
									</form>
									<form action="/order/delete.do" method="post"
										class="manage-btn-con col-lg-6"
										onsubmit="return confirm(i18n.confirmDelete);">
										<input type="hidden" name="orderId" value="${order.orderId}" />
										<span class="manage-btn delete-btn"><input
											type="submit"  value="${deleteText}" /></span>
									</form>
								</td>
							</tr>
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
    window.menuName = 'order';
    window.saveData = [
        <c:forEach var="order" items="${orders}" varStatus="status">
            {
                id: ${order.orderId},
                name: '${order.menuName}',
                staffName: '${order.staffName}',
                quantity: '${order.quantity}',
                totalPrice: '${order.totalPrice}',
                createdAt: '${order.createdAt}'
            }
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
	<script src="/resources/js/list.js"></script>
</body>
</html>
