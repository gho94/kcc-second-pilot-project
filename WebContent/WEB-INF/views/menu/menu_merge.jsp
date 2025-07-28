<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of( "https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/themes/default/style.min.css","/resources/css/merge.css"));
request.setAttribute("pageScripts", List.of(
       "https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/jstree.min.js"
   ));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>

<%@ include file="/WEB-INF/views/header.jsp"%>
<div class="content list-content">
    <div class="container">
        <div class="menu-title-con">
            <span class="menu-title">메뉴 <c:if test="${action eq 'insert'}">추가</c:if><c:if test="${action eq 'update'}">수정</c:if></span>
        </div>
        <c:if test="${action eq 'insert'}">
            <c:url var="menu_do" value="/menu/insert.do"/>
        </c:if>
        <c:if test="${action eq 'update'}">
            <c:url var="menu_do" value="/menu/update.do"/>
        </c:if>
        <div class="form-con">
            <form action="${menu_do}" method="post">
				<div class="form-row">
				                   <div class="form-group full-width">
				                       <label class="form-label">카테고리 <span class="required">*</span></label>
									   <div id="categoryTree"></div>
									   <input type="hidden" name="categoryId" value="${menu.categoryId == 0 ? '' : menu.categoryId}" data-valid="카테고리를 선택해주세요"/>
				                   </div>
				               </div>
				
				
                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">메뉴명 <span class="required">*</span></label>
                        <input type="text"
                               class="form-input"
                               name="menuName"
                               placeholder="메뉴명을 입력해주세요"
                               data-valid="메뉴명을 입력해주세요"
                               value="${menu.menuName}"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group full-width">
                        <label class="form-label">가격 <span class="required">*</span></label>
                        <input type="number"
                               class="form-input"
                               name="price"
                               placeholder="가격을 입력해주세요"
                               data-valid="가격을 입력해주세요"
							   data-valid-nozero="false"
                               value="${menu.price}"/>
                    </div>
                </div>
                <div class="page-actions">
                    <input type="hidden" name="menuId" value="${menu.menuId}"/>
                    <input type="submit" class="btn btn-primary" value="저장하기">
                    <input type="button" class="btn btn-cancel" onclick="window.location.href = window.location.href.replace(/\/(insert|update)\.do/, '.do')" value="목록으로">
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<script src="/resources/js/merge.js"></script>
<script src="/resources/js/category.js"></script>
<script>
	window.treeData = <%= request.getAttribute("categoryTree") %>;
	window.isContextMenuEnabled = false;
	window.selectedCategoryId = ${menu.categoryId};
</script>
</body>
</html>