<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 추가</title>
</head>
<body>
    <h1>주문 추가</h1>
    <c:if test="${action eq 'insert'}">
        <c:url var="order_do" value="/order/insert.do"/>
    </c:if>
    <c:if test="${action eq 'update'}">
        <c:url var="order_do" value="/order/update.do"/>
    </c:if>
    
    <form action="${order_do}" method="post">
        <fieldset>
            <legend>주문정보</legend>
            <table>
                <tr>
                    <td class="label">메뉴명</td>
                    <td class="field">
                        <select name="menuId">
                            <c:forEach var="menu" items="${menus}">
                                <option value="${menu.menuId}:${menu.price}"
                                    <c:if test="${menu.menuId == order.menuId}">selected</c:if>>${menu.menuName} : ${menu.price}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="label">수량</td>
                    <td class="field"><input type="text" name="quantity" value="${order.quantity}"></td>
                </tr>
            </table>
                <input type="hidden" name="orderId" value="${order.orderId}" />
                <input type="submit" value="  저 장  "> 
                <input type="reset" value="  취 소  ">
        </fieldset>
    </form>
</body>
</html>