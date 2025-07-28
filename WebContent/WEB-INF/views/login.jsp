<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Menu" />
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of("/resources/css/login.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
 <div class="login-container">
        <div class="logo"></div>

        <form action="/login.do" method="post" id="loginForm">
            <div class="form-floating">
                <input type="text" name="email" class="form-control" id="userId" placeholder=" " required>
                <label for="userId"><fmt:message key="아이디" /></label>
            </div>

            <div class="form-floating">
                <input type="password" name="password" class="form-control" id="userPassword" placeholder=" " required>
                <label for="userPassword"><fmt:message key="비밀번호" /></label>
            </div>

            <button type="submit" class="login-btn">
                <span class="kimbap-icon"></span>
                <fmt:message key="로그인" />
            </button>
        </form>
    </div>
	<script src="/resources/js/login.js"></script>
</body>
</html>
