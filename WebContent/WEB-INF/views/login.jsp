<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>COOKCOOK</title>
 <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/resources/css/login.css" />
</head>
<body>
 <div class="login-container">
        <div class="logo"></div>
        
        <form action="/login.do" method="post" id="loginForm">
            <div class="form-floating">
                <input type="text" name="email" class="form-control" id="userId" placeholder=" " required>
                <label for="userId">아이디를 입력하세요.</label>
            </div>
            
            <div class="form-floating">
                <input type="password" name="password" class="form-control" id="userPassword" placeholder=" " required>
                <label for="userPassword">비밀번호를 입력하세요.</label>
            </div>
            
            <button type="submit" class="login-btn">
                <span class="kimbap-icon"></span>
                로그인
            </button>
        </form>
    </div>
	<script src="/resources/js/login.js"></script>
</body>
</html>