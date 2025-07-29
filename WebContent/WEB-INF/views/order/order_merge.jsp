<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="order" />
<fmt:message var="dropdownMenuText" key="메뉴선택"/>  <%-- "메뉴" 텍스트를 가져와 변수에 저장 --%>
<fmt:message var="quantityText" key="수량"/>  <%-- "메뉴" 텍스트를 가져와 변수에 저장 --%>
<fmt:message key='수량을 입력해주세요' var="quantityPlaceholder" />
<fmt:message key="저장하기" var="saveText" />
<fmt:message key="목록으로" var="backToListText" />
<fmt:message key="메뉴선택" var="selectMenu" />
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of("/resources/css/merge.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
            <span class="menu-title"><fmt:message key="주문" /> <c:if test="${action eq 'insert'}"><fmt:message key="추가" /></c:if><c:if test="${action eq 'update'}"><fmt:message key="수정" /></c:if></span>
        </div>
        <c:if test="${action eq 'insert'}">
            <c:url var="order_do" value="/order/insert.do"/>
        </c:if>
        <c:if test="${action eq 'update'}">
            <c:url var="order_do" value="/order/update.do"/>
        </c:if>
        <div class="form-con">

            <form action="${order_do}" method="post">

                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label"><fmt:message key="메뉴" /> <span class="required">*</span></label>
						<div class="custom-dropdown" data-name="menuId">
						        <input type="hidden" name="menuId" value="" data-valid="${selectMenu}">
						        <div class="dropdown-trigger" tabindex="0">
    <span class="dropdown-text">${dropdownMenuText}</span>
						            <span class="dropdown-arrow">▼</span>
						        </div>
						        
						        <div class="dropdown-list">
						            <ul>
						                <c:forEach var="menu" items="${menus}">
						                    <li data-value="${menu.menuId}:${menu.price}" 
						                        <c:if test="${menu.menuId == order.menuId}">class="selected"</c:if>>
						                        [${menu.menuName}] : ₩<fmt:formatNumber value="${menu.price}" type="number" />
						                    </li>
						                </c:forEach>
						            </ul>
						        </div>
						    </div>
                    </div>
                </div>


                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">${quantityText} <span class="required">*</span></label>
                        <input type="number"
                               class="form-input"
                               name="quantity"
                               placeholder="${quantityPlaceholder}"
                               data-valid="${quantityPlaceholder}"
                               value="${order.quantity}"/>
                    </div>
                </div>

                <div class="page-actions">
                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                    <input type="submit" class="btn btn-primary" value="${saveText}">
                    <input type="button" class="btn btn-cancel" onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')" value="${backToListText}">
                </div>
            </form>
		</div>
	</div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<script src="/resources/js/dropdown.js"></script>
<script src="/resources/js/merge.js"></script>
</body>
</html>