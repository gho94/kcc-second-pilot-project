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
                               placeholder="이름을 입력해주세요"
                               data-valid="이름을 입력해주세요"
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