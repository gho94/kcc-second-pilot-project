<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 추가</title>
</head>
<body>
    <h1>메뉴 추가</h1>
    <c:if test="${action eq 'insert'}">
        <c:url var="menu_do" value="/menu/insert.do"/>
    </c:if>
    <c:if test="${action eq 'update'}">
        <c:url var="menu_do" value="/menu/update.do"/>
    </c:if>

    <form action="${menu_do}" method="post">
        <fieldset>
            <legend>메뉴정보</legend>
            <table>
                <tr>
                    <td class="label">메뉴이름</td>
                    <td class="field"><input type="text" name="menuName" value="${menu.menuName}"></td>
                </tr>
                <tr>
                    <td class="label">가격</td>
                    <td class="field"><input type="text" name="price" value="${menu.price}"></td>
                </tr>
            </table>
                <input type="hidden" name="menuId" value="${menu.menuId}" />
                <input type="submit" value="  저 장  "> 
                <input type="reset" value="  취 소  ">
        </fieldset>
    </form>

</body>
</html>