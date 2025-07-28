<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<%
    request.setAttribute("pageStyles", List.of(
        "https://cdn.jsdelivr.net/npm/jstree@3.3.12/dist/themes/default/style.min.css",
        "/resources/css/list.css"
    ));
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
            <span class="menu-title">카테고리 목록</span>
        </div>
        <div class="controls">
            <div class="search-container">
                <input type="text" class="search-input" placeholder="카테고리명으로 검색..." id="searchInput">
                <div class="search-btn-con">
                    <button class="search-btn" onclick="searchData()"></button>
                </div>
            </div>
        </div>
        <div class="help-text">
             더블 클릭 시 카테고리의 자식 카테고리를 볼 수 있습니다.<br>
             우클릭 시 펼치기, 접기, 삭제 기능을 이용할 수 있습니다. 
        </div>
        <div id="categoryTree"></div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp"%>
<script src="/resources/js/category.js"></script>
<script>
	window.treeData = <%= request.getAttribute("categoryTree") %>;
</script>
</body>
</html>