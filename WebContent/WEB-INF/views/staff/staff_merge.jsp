<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    // CSS 설정
    request.setAttribute("pageStyles", List.of("/resources/css/merge.css"));
%>
<fmt:setLocale value="${sessionScope.locale != null 
    ? sessionScope.locale 
    : pageContext.request.locale}" />
<fmt:setBundle basename="Staff" />

<%-- i18n 메시지 변수 선언 --%>
<fmt:message var="msgStaff"               key="작업자" />
<fmt:message var="msgAdd"                 key="추가" />
<fmt:message var="msgUpdate"              key="수정" />

<fmt:message var="firstNameLabel"         key="성" />
<fmt:message var="firstNamePlaceholder"   key="성을입력해주세요" />
<fmt:message var="lastNameLabel"          key="이름" />
<fmt:message var="lastNamePlaceholder"    key="이름을입력해주세요" />

<fmt:message var="emailLabel"             key="이메일" />
<fmt:message var="emailPlaceholder"       key="이메일을입력해주세요" />

<fmt:message var="passwordLabel"          key="비밀번호" />
<fmt:message var="passwordPlaceholder"    key="비밀번호를입력해주세요" />
<fmt:message var="changePasswordLabel"    key="비밀번호변경" />
<fmt:message var="newPasswordPlaceholder" key="새비밀번호를입력해주세요" />
<fmt:message var="passwordHelpText"       key="비밀번호변경안내" />

<fmt:message var="phoneLabel"             key="전화번호" />
<fmt:message var="phonePlaceholder"       key="전화번호를입력해주세요" />

<fmt:message var="roleSelectLabel"        key="권한선택" />
<fmt:message var="roleSelectPrompt"       key="권한을선택해주세요" />
<fmt:message key="저장하기" var="saveText" />
<fmt:message key="목록으로" var="backToListText" />
<fmt:message var="modalTitle"             key="권한선택" />
<fmt:message var="modalConfirm"           key="확인" />
<fmt:message var="modalCancel"            key="취소" />

<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/views/head.jsp" %>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="content list-content">
  <div class="container">
    <!-- 페이지 타이틀 -->
    <div class="menu-title-con">
      <span class="menu-title">
        ${msgStaff}
        <c:if test="${action eq 'insert'}">${msgAdd}</c:if>
        <c:if test="${action eq 'update'}">${msgUpdate}</c:if>
      </span>
    </div>

    <!-- 폼 action 설정 -->
    <c:if test="${action eq 'insert'}">
      <c:url var="staff_do" value="/staff/insert.do"/>
    </c:if>
    <c:if test="${action eq 'update'}">
      <c:url var="staff_do" value="/staff/update.do"/>
    </c:if>

    <div class="form-con">
      <form action="${staff_do}" method="post">

        <!-- 성 -->
        <div class="form-row">
          <div class="form-group full-width">
            <label class="form-label">
              ${firstNameLabel} <span class="required">*</span>
            </label>
            <input
              type="text"
              class="form-input"
              name="firstName"
              placeholder="${firstNamePlaceholder}"
              data-valid="${firstNamePlaceholder}"
              value="${staff.firstName}"
            />
          </div>
        </div>

        <!-- 이름 -->
        <div class="form-row">
          <div class="form-group full-width">
            <label class="form-label">
              ${lastNameLabel} <span class="required">*</span>
            </label>
            <input
              type="text"
              class="form-input"
              name="lastName"
              placeholder="${lastNamePlaceholder}"
              data-valid="${lastNamePlaceholder}"
              value="${staff.lastName}"
            />
          </div>
        </div>

        <!-- 이메일 -->
        <div class="form-row">
          <div class="form-group full-width">
            <label class="form-label">
              ${emailLabel} <span class="required">*</span>
            </label>
            <input
              type="text"
              class="form-input"
              name="email"
              placeholder="${emailPlaceholder}"
              data-valid="${emailPlaceholder}"
              data-valid-type="email"
              value="${staff.email}"
            />
          </div>
        </div>

        <!-- 비밀번호 -->
        <div class="form-row">
          <div class="form-group full-width">
            <c:if test="${action eq 'insert'}">
              <label class="form-label">
                ${passwordLabel} <span class="required">*</span>
              </label>
              <input
                type="password"
                class="form-input"
                name="password"
                placeholder="${passwordPlaceholder}"
                data-valid="${passwordPlaceholder}"
                value="${staff.password}"
              />
            </c:if>
            <c:if test="${action eq 'update'}">
              <div class="password-section form-input">
                <div class="checkbox-container">
                  <input
                    type="checkbox"
                    class="checkbox-input"
                    id="changePassword"
                    onchange="togglePasswordField()"
                  />
                  <label class="checkbox-label" for="changePassword">
                    ${changePasswordLabel}
                  </label>
                </div>

                <label class="form-label">${passwordLabel}</label>
                <input
                  type="password"
                  class="form-input"
                  name="password"
                  id="passwordField"
                  placeholder="${newPasswordPlaceholder}"
                  data-valid="${newPasswordPlaceholder}"
                  data-valid-condition="changePassword"
                  disabled
                />

                <div class="help-text">
                  ${passwordHelpText}
                </div>
              </div>
            </c:if>
          </div>
        </div>

        <!-- 전화번호 -->
        <div class="form-row">
          <div class="form-group full-width">
            <label class="form-label">
              ${phoneLabel} <span class="required">*</span>
            </label>
            <input
              type="text"
              class="form-input"
              name="phone"
              placeholder="${phonePlaceholder}"
              data-valid="${phonePlaceholder}"
              value="${staff.phone}"
            />
          </div>
        </div>

        <!-- 권한 선택 -->
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">
              ${roleSelectLabel} <span class="required">*</span>
            </label>
            <button
              type="button"
              class="select-input"
              onclick="ModalManager.open('roleModal', { onOpen: renderRoleList });"
            >
              <span id="selectedRoleText" class="select-text">
                <c:choose>
                  <c:when test="${action eq 'insert'}">
                    ${roleSelectPrompt}
                  </c:when>
                  <c:otherwise>
                    ${staff.roleName}
                  </c:otherwise>
                </c:choose>
              </span>
              <span class="select-arrow">▼</span>
            </button>
            <input
              type="hidden"
              name="roleId"
              id="roleId"
              data-valid="${roleSelectPrompt}"
              data-valid-nozero="true"
              value="${staff.roleId}"
            />
          </div>
        </div>

        <!-- 버튼 -->
        <div class="page-actions">
          <input type="hidden" name="changePasswordFlag" id="changePasswordFlag" value="false"/>
          <input type="hidden" name="staffId" value="${confirmTextJSTL}"/>
          <input type="submit" class="btn btn-primary" value="${saveText}"/>
          <input
            type="button"
            class="btn btn-cancel"
            onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')"
            value="${backToListText}"
          />
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<!-- 권한 선택 모달 -->
<div class="modal-overlay" id="roleModal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">${modalTitle}</h3>
      <button type="button" class="modal-close" onclick="ModalManager.close('roleModal')">×</button>
    </div>

    <div class="modal-content" id="roleList">
      <!-- JavaScript로 동적 생성 -->
    </div>

    <div class="modal-footer">
      <button type="button" class="btn btn-primary" onclick="confirmRoleSelection()">
        ${modalConfirm}
      </button>
      <button type="button" class="btn btn-cancel" onclick="ModalManager.close('roleModal')">
        ${modalCancel}
      </button>
    </div>
  </div>
</div>

<script>
  window.currentValueId = [${staff.roleId}];
  window.roleData = [
    <c:forEach var="role" items="${roleList}" varStatus="status">
      { id: "${role.roleId}", name: "${role.roleName}" }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
  ];
</script>
<script src="${pageContext.request.contextPath}/resources/js/merge.js"></script>
