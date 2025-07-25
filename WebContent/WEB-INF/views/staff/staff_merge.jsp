<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK</title>

    <!-- 구글 웹폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
            rel="stylesheet"/>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/normalize.css@8.0.1/"/>
    <!-- 슬라이드 api -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link rel="stylesheet" href="/resources/css/reset.css"/>
    <link rel="stylesheet" href="/resources/css/header_footer.css"/>
    <link rel="stylesheet" href="/resources/css/common.css"/>
    <link rel="stylesheet" href="/resources/css/merge.css"/>
    <script src="script/jquery-3.7.1.min.js"></script>
    <script
            src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script
            src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp"%>
<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
            <span class="menu-title">작업자 <c:if test="${action eq 'insert'}">추가</c:if><c:if test="${action eq 'update'}">수정</c:if></span>
        </div>
        <c:if test="${action eq 'insert'}">
            <c:url var="staff_do" value="/staff/insert.do"/>
        </c:if>
        <c:if test="${action eq 'update'}">
            <c:url var="staff_do" value="/staff/update.do"/>
        </c:if>
<div class="form-con">
        <form action="${staff_do}" method="post">
			
			<div class="form-row">
			                        <div class="form-group">
			                            <label class="form-label">메뉴 선택 <span class="required">*</span></label>
			                            <button type="button" class="select-input" onclick="openMenuModal()">
			                                <span id="selectedMenuText" class="select-text">메뉴를 선택해주세요</span>
			                                <span class="select-arrow">▼</span>
			                            </button>
			                        </div>
			                    </div>
			<!--
            <fieldset>
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
                                    <c:if test="${role.roleId == staff.roleId}">selected</c:if>
                                    >${role.roleName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="staffId" value="${staff.staffId}"/>
                <input type="submit" value="  저 장  ">
                <input type="reset" value="  취 소  ">
            </fieldset>
			
			-->
			
			
			<div class="page-actions">
				<input type="hidden" name="staffId" value="${staff.staffId}"/>
				<input type="submit" class="btn btn-primary" value="저장하기">
				<input type="button" class="btn btn-cancel" onclick="goBack()" value="목록으로">
			</div>
        </form>
		</div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>