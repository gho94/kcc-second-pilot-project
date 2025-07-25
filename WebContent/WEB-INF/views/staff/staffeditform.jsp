<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작업자 추가</title>
</head>
<body>
	<h1>작업자 추가</h1>
	<c:if test="${action eq 'insert'}">
		<c:url var="staff_do" value="/staff/insert.do"/>
	</c:if>
	<c:if test="${action eq 'update'}">
		<c:url var="staff_do" value="/staff/update.do"/>
	</c:if>
	
	<form action="${staff_do}" method="post">		
		<fieldset>
		<legend>작업자정보</legend>
		<table>
		<tr>
			<td class="label">성 (first name)</td>
			<td class="field"><input type="text" name="firstName" value="${staff.firstName}"></td>
		</tr>
				<tr>
			<td class="label">이름 (last name)</td>
			<td class="field"><input type="text" name="lastName" value="${staff.lastName}"></td>
		</tr>
		<tr>
			<td class="label">이메일</td>
			<td class="field"><input type="text" name="email" value="${staff.email}"></td>
		</tr>
		<tr>
			<td class="label">비밀번호</td>
			<td class="field"><input type="text" name="password" value="${staff.password}"></td>
		</tr>
		<tr>
			<td class="label">전화번호</td>
			<td class="field"><input type="text" name="phone" value="${staff.phone}"></td>
		</tr>
		<tr>
			<td class="label">권한</td>
			<td class="field">
				<select name="roleId">
					<c:forEach var="role" items="${roleList}">
						<option value="${role.roleId}"
							<c:if test="${role.roleId == staff.roleId}">selected</c:if>>${role.roleName}
						</option>
					</c:forEach>
				</select>			
			</td>
		</tr>
		</table>			
			<input type="hidden" name="staffId" value="${staff.staffId}" />
			<input type="submit" value="  저 장  "> 
			<input type="reset" value="  취 소  ">
		</fieldset>
	</form>
</body>
</html>