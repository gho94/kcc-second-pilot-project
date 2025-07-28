<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <link rel="stylesheet" href="/resources/css/merge.css"/>
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
            <span class="menu-title">주문 <c:if test="${action eq 'insert'}">추가</c:if><c:if test="${action eq 'update'}">수정</c:if></span>
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
                        <label class="form-label">메뉴 <span class="required">*</span></label>
						<div class="custom-dropdown" data-name="menuId">
						        <input type="hidden" name="menuId" value="" data-valid="메뉴를 선택해주세요">
						        <div class="dropdown-trigger" tabindex="0">
						            <span class="dropdown-text">메뉴를 선택해주세요</span>
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
                        <label class="form-label">수량 <span class="required">*</span></label>
                        <input type="number"
                               class="form-input"
                               name="quantity"
                               placeholder="수량을 입력해주세요"
                               data-valid="수량을 입력해주세요"
                               value="${order.quantity}"/>
                    </div>
                </div>

                <div class="page-actions">
                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                    <input type="submit" class="btn btn-primary" value="저장하기">
                    <input type="button" class="btn btn-cancel" onclick="history.back();" value="목록으로">
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