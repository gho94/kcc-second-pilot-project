<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of("/resources/css/merge.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
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
                    <div class="form-group full-width">
                        <label class="form-label">성 (first name) <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="firstName"
                               placeholder="성(first name)을 입력해주세요"
							   data-valid="성(first name)을 입력해주세요"
                               value="${staff.firstName}"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">이름 (last name) <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="lastName"
                               placeholder="이름(last name)을 입력해주세요"
							   data-valid="이름(last name)을 입력해주세요"
                               value="${staff.lastName}"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">이메일 <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="email"
                               placeholder="이메일을 입력해주세요"
							   data-valid="이메일을 입력해주세요"
							   data-valid-type="email"
                               value="${staff.email}"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group full-width">


                        <c:if test="${action eq 'insert'}">
                            <label class="form-label">비밀번호 <span class="required">*</span></label>
                            <input type="password"
                                   class="form-input"
                                   name="password"
                                   placeholder="비밀번호를 입력해주세요"
								   data-valid="비밀번호를 입력해주세요"
                                   value="${staff.password}"/>
                        </c:if>
                        <c:if test="${action eq 'update'}">
                            <div class="password-section form-input">
                                <div class="checkbox-container">
                                    <input type="checkbox" class="checkbox-input" id="changePassword"
                                           onchange="togglePasswordField()">
                                    <label class="checkbox-label" for="changePassword">비밀번호 변경</label>
                                </div>

                                <label class="form-label">비밀번호</label>
                                <input type="password" class="form-input" name="password" id="passwordField"
                                       placeholder="새 비밀번호를 입력해주세요"  data-valid="새 비밀번호를 입력해주세요" data-valid-condition="changePassword" disabled>

                                <div class="help-text">
                                    비밀번호를 변경하지 않으려면 체크박스를 해제하세요.
                                    체크하지 않으면 기존 비밀번호가 유지됩니다.
                                </div>
                            </div>
                        </c:if>

                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">전화번호 <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="phone"
                               placeholder="전화번호를 입력해주세요"
							   data-valid="전화번호를 입력해주세요"
                               value="${staff.phone}"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">권한 선택 <span class="required">*</span></label>
                        <button type="button" class="select-input" onclick="ModalManager.open('roleModal', {
						        onOpen: renderRoleList  
						    });">
                            <span id="selectedRoleText" class="select-text">
								<c:if test="${action eq 'insert'}">
								권한을 선택해주세요
								</c:if>
								<c:if test="${action eq 'update'}">
								    ${staff.roleName}
								</c:if>
							</span>
                            <span class="select-arrow">▼</span>
                        </button>
                        <input type="hidden" data-valid="권한을 선택해주세요" name="roleId" id="roleId" value="${staff.roleId}"/>
                    </div>
                </div>
                <div class="page-actions">
					<input type="hidden" name="changePasswordFlag" id="changePasswordFlag" value="false">
                    <input type="hidden" name="staffId" value="${staff.staffId}"/>
                    <input type="submit" class="btn btn-primary" value="저장하기">
                    <input type="button" class="btn btn-cancel" onclick="history.back();" value="목록으로">
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>

<!-- 권한 선택 모달 -->
<div class="modal-overlay" id="roleModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">권한 선택</h3>
            <button type="button" class="modal-close" onclick="ModalManager.close('roleModal')">×</button>
        </div>

        <div class="modal-content" id="roleList">
            <!-- JavaScript로 동적으로 생성됨 -->
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-primary" onclick="confirmRoleSelection()">확인</button>
            <button type="button" class="btn btn-cancel" onclick="ModalManager.close('roleModal')">취소</button>
        </div>
    </div>
</div>
<script>
    window.currentValueId = [${staff.roleId}];
    window.roleData = [
        <c:forEach var="role" items="${roleList}" varStatus="status">
            {
                id: "${role.roleId}",
                name: "${role.roleName}"
            }
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

</script>
<script src="/resources/js/merge.js"></script>

</body>
</html>