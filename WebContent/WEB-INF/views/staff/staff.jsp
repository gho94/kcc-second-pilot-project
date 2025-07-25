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
	    <td><h1>작업자 관리</h1></td>
	    <td>
	      <form action="/staff/insert.do">
	        <input type="submit" name="action" value="등록">
	      </form>
	    </td>
	  </tr>
	</table>
	
	<!-- <h1>작업자 조회</h1> -->
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>권한</td>
			<td>이메일</td>
			<td>전화번호</td>
			<td>생성일</td>
		<tr>
	<c:forEach var="staff" items="${staffs}">
		<tr>
			<td>${staff.staffId}</td>
			<td>${staff.firstName}${staff.lastName}</td>
			<td>${staff.roleName}</td>
			<td>${staff.email}</td>
			<td>${staff.phone}</td>
			<td>${staff.createdAt}</td>
			<td>
				<form action="/staff/update.do">
					<input type="hidden" name="staffId" value="${staff.staffId}" />
					<input type="submit" value="수정" />
				</form>
			</td>
			<td>
				<form action="/staff/delete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
					<input type="hidden" name="staffId" value="${staff.staffId}" />
					<input type="submit" value="삭제" />
				</form>
			</td>					     
		<tr>
	</c:forEach>
	</table>
</body>
</html>