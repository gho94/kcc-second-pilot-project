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
	<c:if test="${empty staff.getStaffId()}">
		<%@ include file="login.jsp"%>
	</c:if>
	
	<c:if test="${not empty staff.getStaffId()}">
		<%@ include file="dashboard.jsp"%>
	</c:if>
</body>
</html>