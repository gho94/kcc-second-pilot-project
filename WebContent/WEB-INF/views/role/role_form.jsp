<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>권한 추가</title>
</head>
<body>
	<h1>권한 추가</h1>
	<c:if test="${action eq 'insert'}">
		<c:url var="role_do" value="/role/insert.do"/>
	</c:if>
	<c:if test="${action eq 'update'}">
		<c:url var="role_do" value="/role/update.do"/>
	</c:if>
	
	<form action="${role_do}" method="post">		
		<fieldset>
		<legend>작업자정보</legend>
		<table>
		<tr>
			<td class="label">이름</td>
			<td class="field"><input type="text" name="roleName" value="${role.roleName}"></td>
		</tr>
		<tr>
			<td class="label">설명</td>
			<td class="field"><input type="text" name="description" value="${role.description}"></td>
		</tr>
		<tr>
			<td class="label">권한</td>
			<td class="field"><input type="text" name="featureCodes" value="${role.featureCodes}"></td>
		</tr>
		 <tr>
			<td class="label">권한</td>
			<td class="field">
				<select name="roleList" multiple >
					<c:forEach var="role" items="${roleList}">
						<option value="${role.key}">${role.value} 관리
						</option>
					</c:forEach>
				</select>			
			</td>
		</tr>
		</table>			
			<input type="hidden" name="roleId" value="${role.roleId}" />
			<input type="submit" value="  저 장  "> 
			<input type="reset" value="  취 소  ">
		</fieldset>
	</form>
</body>
</html>