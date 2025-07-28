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
            <span class="menu-title">권한 <c:if test="${action eq 'insert'}">추가</c:if><c:if test="${action eq 'update'}">수정</c:if></span>
        </div>
        <c:if test="${action eq 'insert'}">
            <c:url var="role_do" value="/role/insert.do"/>
        </c:if>
        <c:if test="${action eq 'update'}">
            <c:url var="role_do" value="/role/update.do"/>
        </c:if>
        <div class="form-con">
            <form action="${role_do}" method="post">

                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">이름 <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="roleName"
                               placeholder="이름을 입력해주세요"
                               data-valid="이름을 입력해주세요"
                               value="${role.roleName}"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">설명</label>
                        <input type="text"
                               class="form-input"
                               name="description"
                               placeholder="설명을 입력해주세요"
                               value="${role.description}"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">권한 선택 <span class="required">*</span></label>
                        <button type="button" class="select-input" onclick="ModalManager.open('roleFeatureModal', {
								        onOpen: renderRoleFeatureList  
								    });">
				                      <span id="selectedRoleFeatureText" class="select-text">
										<c:if test="${action eq 'insert'}">
										권한을 선택해주세요
										</c:if>
										<c:if test="${action eq 'update' }">
										${role.featureNames}
										</c:if>
									</span>
                            <span class="select-arrow">▼</span>
                        </button>
                        <input type="hidden" data-valid="권한을 선택해주세요" name="featureCodes" id="featureCodes"
                               value="${role.featureCodes}"/>
                    </div>
                </div>


                <div class="page-actions">
                    <input type="hidden" name="roleId" value="${role.roleId}"/>
                    <input type="submit" class="btn btn-primary" value="저장하기">
                    <input type="button" class="btn btn-cancel" onclick="history.back();" value="목록으로">
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>

<!-- 권한 선택 모달 -->
<div class="modal-overlay" id="roleFeatureModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">권한 선택</h3>
            <button type="button" class="modal-close" onclick="ModalManager.close('roleFeatureModal')">×</button>
        </div>

        <div class="modal-content" id="roleFeatureList">
            <!-- JavaScript로 동적으로 생성됨 -->
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-primary" onclick="confirmRoleFeatureModalSelection()">확인</button>
            <button type="button" class="btn btn-cancel" onclick="ModalManager.close('roleFeatureModal')">취소</button>
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