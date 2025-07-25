<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
	  <tr>
	    <td><h1>권한 관리</h1></td>
	    <td>
	      <form action="/role/insert.do">
	        <input type="submit" name="action" value="등록">
	      </form>
	    </td>
	  </tr>
	</table>
	
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>설명</td>
			<td>권한</td>
		<tr>
	<c:forEach var="role" items="${roles}">
		<tr>
			<td>${role.roleId}</td>
			<td>${role.roleName}</td>
			<td>${role.description}</td>
			<td>${role.featureNames}</td>
			<td>
				<form action="/role/update.do">
					<input type="hidden" name="roleId" value="${role.roleId}" />
					<input type="submit" value="수정" />
				</form>
			</td>
			<td>
				<form action="/role/delete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
					<input type="hidden" name="roleId" value="${role.roleId}" />
					<input type="submit" value="삭제" />
				</form>
			</td>					     
		<tr>
	</c:forEach>
	</table>
</body>
</html>