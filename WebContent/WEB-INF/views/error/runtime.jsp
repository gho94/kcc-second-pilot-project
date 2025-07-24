<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Runtime Exception</title>
</head>
<body>
	<h1>런타임 오류가 발생했습니다.</h1>
	<h2>메시지 : <%= exception.getMessage() %></h2>
</body>
</html>