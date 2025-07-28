<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 관리</title>
</head>
<body>
    <table>
        <tr>
            <td><h1>주문 관리</h1></td>
            <td>
                <form action="/order/insert.do">>
                    <input type="submit" name="action" value="등록">
                </form>
            </td>
        </tr>
    </table>
    <table border="1">
        <tr>
            <td>번호</td>
            <td>직원명</td>
            <td>메뉴명</td>
            <td>수량</td>
            <td>총액</td>
            <td>주문일</td>
        </tr>
        <c:forEach var="order" items="${orders}">
            <tr>
                <td>${order.orderId}</td>
                <td>${order.staffName}</td>
                <td>${order.menuName}</td>
                <td>${order.quantity}</td>
                <td>${order.totalPrice}</td>
                <td>${order.createdAt}</td>
                <td>
                    <form action="/order/update.do">
                        <input type="hidden" name="orderId" value="${order.orderId}" />
                        <input type="submit" value="수정" />
                    </form>
                </td>
                <td>
                    <form action="/order/delete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="orderId" value="${order.orderId}" />
                        <input type="submit" value="삭제" />
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html> 