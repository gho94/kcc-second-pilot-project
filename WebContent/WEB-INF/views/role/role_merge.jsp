<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fmt:setLocale
	value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Role" />
<fmt:message key="이름을 입력해주세요" var="namePlaceholder" />
<fmt:message key='설명을 입력해주세요' var="descriptionPlaceholder" />
<fmt:message key="권한을 선택해주세요" var="selectRoleFeatureMsg" />
<fmt:message key="권한 선택" var="roleFeatureLabel" />
<fmt:message key="확인" var="confirmText" />
<fmt:message key="취소" var="cancelText" />
<fmt:message key="저장하기" var="saveText" />
<fmt:message key="목록으로" var="backToListText" />
<%@ page import="java.util.List"%>
<%
request.setAttribute("pageStyles", List.of("/resources/css/merge.css"));
%>
<!DOCTYPE html>
<html>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/views/header.jsp"%>
	<div class="content list-content">
		<div class="container">
			<div class="menu-title-con">
				<span class="menu-title"> <fmt:message key="권한" /> <c:if
						test="${action eq 'insert'}">
						<fmt:message key="추가" />
					</c:if> <c:if test="${action eq 'update'}">
						<fmt:message key="수정" />
					</c:if>
				</span>
			</div>

			<c:if test="${action eq 'insert'}">
				<c:url var="role_do" value="/role/insert.do" />
			</c:if>
			<c:if test="${action eq 'update'}">
				<c:url var="role_do" value="/role/update.do" />
			</c:if>

			<div class="form-con">
				<form action="${role_do}" method="post">
					<div class="form-row">
						<div class="form-group full-width">
							<label class="form-label"> <fmt:message key="이름" /> <span
								class="required">*</span>
							</label> <input type="text" class="form-input" name="roleName"
								placeholder="${namePlaceholder}"
								data-valid="<fmt:message key='이름을 입력해주세요' />"
								value="${role.roleName}" />
						</div>
					</div>

					<div class="form-row">
						<div class="form-group full-width">
							<label class="form-label"><fmt:message key="설명" /></label> <input
								type="text" class="form-input" name="description"
								placeholder="${descriptionPlaceholder}"
								value="${role.description}" />
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label class="form-label"> ${roleFeatureLabel} <span
								class="required">*</span>
							</label>
							<button type="button" class="select-input"
								onclick="ModalManager.open('roleFeatureModal', {
                                    onOpen: renderRoleFeatureList  
                                });">
								<span id="selectedRoleFeatureText" class="select-text"> <c:if
										test="${action eq 'insert'}">
				    ${selectRoleFeatureMsg}
				  </c:if> <c:if test="${action eq 'update'}">
				    ${role.featureNames}
				  </c:if>
								</span> <span class="select-arrow">▼</span>
							</button>
							<input type="hidden" data-valid="${selectRoleFeatureMsg}"
								name="featureCodes" id="featureCodes"
								value="${role.featureCodes}" />

						</div>
					</div>

					<div class="page-actions">
	<input type="hidden" name="roleId" value="${role.roleId}" />
	<input type="submit" class="btn btn-primary" value="${saveText}" />
	<input type="button" class="btn btn-cancel"
		onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')"
		value="${backToListText}" />
</div>

				</form>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
<fmt:message key="확인" var="confirmTextJSTL" />
<fmt:message key="취소" var="cancelTextJSTL" />
<c:set var="msg_confirm" value="${confirmTextJSTL}" />
<c:set var="msg_cancel" value="${cancelTextJSTL}" />
	<!-- 권한 선택 모달 -->
	<div class="modal-overlay" id="roleFeatureModal">
		<div class="modal">
			<div class="modal-header">
				<h3 class="modal-title">${roleFeatureLabel}</h3>

				<button type="button" class="modal-close"
					onclick="ModalManager.close('roleFeatureModal')">×</button>
			</div>

			<div class="modal-content" id="roleFeatureList">
				<!-- JavaScript로 동적으로 생성됨 -->
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-primary"
	onclick="confirmRoleFeatureModalSelection()">
	${confirmText}
</button>
				<button type="button" class="btn btn-cancel"
					onclick="ModalManager.close('roleFeatureModal')">
					${cancelText}
				</button>
			</div>
		</div>
	</div>

	<script>
    window.currentValueId = "${role.featureCodes}".split(", ");
    window.roleNameMap = [
        <c:forEach var="role" items="${roleList}" varStatus="status">
        {
            id: "${role.key}",
            name: "${role.value}"
        }
        <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>
	<script src="/resources/js/merge.js"></script>
</body>
</html>
