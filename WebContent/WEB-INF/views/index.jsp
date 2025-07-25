<%@page import="com.secondproject.cooook.model.Staff"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main</title>
</head>
<body>
	<h1>Cook</h1>		
	
	<c:if test="${empty staff.getStaffId()}">
		<ul>
			<li><a href="/login.do">로그인</a>
		</ul>
	</c:if>
	
	<c:if test="${not empty staff.getStaffId()}">
		${staff.firstName} ${staff.lastName}님 환영합니다. <br>
		
		<ul>	
			<c:forEach var="entry" items="${menuMap}">
		        <li><a href="${entry.value}">${entry.key}</a>
		    </c:forEach>
			<li><a href="/logout.do">로그아웃</a>		
		</ul>
	</c:if>
</body>
</html>