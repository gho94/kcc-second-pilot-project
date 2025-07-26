<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴관리</title>
</head>
<body>
	<table>
	  <tr>
	    <td><h1>메뉴 관리</h1></td>
	    <td>
	      <form action="/menu/insert.do">
	        <input type="submit" name="action" value="등록">
	      </form>
	    </td>
	  </tr>
	</table>
	
	<table border="1">
		<tr>
			<td>번호</td>
			<td>메뉴</td>
			<td>가격</td>
		<tr>
		<c:forEach var="menu" items="${menus}">
			<tr>
				<td>${menu.menuId}</td>
				<td>${menu.menuName}</td>
				<td>${menu.price}</td>
				<td>
					<form action="/menu/update.do">
						<input type="hidden" name="menuId" value="${menu.menuId}" />
						<input type="submit" value="수정" />
					</form>
				</td>
				<td>
					<form action="/menu/delete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
						<input type="hidden" name="menuId" value="${menu.menuId}" />
						<input type="submit" value="삭제" />
					</form>
				</td>					     
			<tr>
		</c:forEach>
	</table>
</body>
</html>