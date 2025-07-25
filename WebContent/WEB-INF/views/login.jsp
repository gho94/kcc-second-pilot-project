<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
</head>
<body>	
	<c:if test="${empty staff.staffId}">
		<h1>로그인 폼</h1>
		
		<form action="/login.do" method="post">
			아이디(이메일): <input type="text" name="email"><br>
			비밀번호: <input type="password" name="password"><br>
			<input type="submit" value="로그인">
			<input type="reset" value="취  소">
		</form>
	</c:if>
</body>
</html>