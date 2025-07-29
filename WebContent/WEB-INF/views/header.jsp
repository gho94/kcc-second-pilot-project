<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="${sessionScope.locale != null ? sessionScope.locale : pageContext.request.locale}" />
<fmt:setBundle basename="Main"/>

<c:set var="originalURI" value="${requestScope['javax.servlet.forward.request_uri']}"/>
<header>
    <div class="header-container">
        <div class="logo-menu">
            <div class="burger" id="burgerBtn">
                <div></div>
                <div></div>
                <div></div>
            </div>
            <div class="logo">
                <div onclick="location.href='/'"></div>
            </div>
            <div class="nav">
                <c:forEach var="entry" items="${menuMap}">
                    <c:set var="menuPath" value="${fn:toLowerCase(entry.value)}"/>
                    <c:set var="insertPath" value="${menuPath.replace('.do', '/insert.do')}"/>
                    <c:set var="isListActive" value="${originalURI eq menuPath}"/>
                    <c:set var="isInsertActive" value="${originalURI eq insertPath}"/>
                    <c:set var="isMenuActive" value="${isListActive or isInsertActive}"/>
                    <div class="menu-wrap ${isMenuActive ? 'active-menu' : ''}">
                        <div class="menu-title"><fmt:message key="${entry.key}" /> <fmt:message key="관리" /></div>
                        <div class="submenu">
                            <a href="${menuPath}" class="${isListActive ? 'active' : ''}">
                                <fmt:message key="${entry.key}" /> <fmt:message key="목록" />
                            </a>
                            <a href="${insertPath}" class="${isInsertActive ? 'active' : ''}">
                                <fmt:message key="${entry.key}" /> <fmt:message key="등록" />
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="profile_icon_con">
            <div id="profileIcon" class="profile-icon">
                <div class="user_icon"></div>
                <div id="profileModal" class="profile-modal">
                    <div>
                        <span class="profile-name">${staff.firstName}${staff.lastName}님</span>
                        <button class="logout-btn" onclick="location.href='/logout.do'">
                            <fmt:message key="로그아웃" />
                        </button>
                    </div>
                    <div class="row">
                        <div class="col-12 mt-2 profile-desc">
                            <fmt:message key="이메일" /> : <%= session.getAttribute("userEmail") %>
                        </div>
                        <div class="col-12 mt-1 profile-desc">
                            <fmt:message key="권한명" /> : <%= session.getAttribute("userRole") %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<nav class="mobile-nav" id="mobileNav">
    <div style="overflow: visible; text-align: right; margin-bottom: 20px">
        <button id="closeMobileNav" style="border: 0; background-color: white; font-size: 18px">
            ✕
        </button>
    </div>
    <c:forEach var="entry" items="${menuMap}">
        <c:set var="menuPath" value="${fn:toLowerCase(entry.value)}"/>
        <c:set var="insertPath" value="${menuPath.replace('.do', '/insert.do')}"/>
        <c:set var="isListActive" value="${originalURI eq menuPath}"/>
        <c:set var="isInsertActive" value="${originalURI eq insertPath}"/>
        <c:set var="isMenuActive" value="${isListActive or isInsertActive}"/>
        <div class="menu-section ${isMenuActive ? 'active' : ''}">
            <div class="menu-title"><fmt:message key="${entry.key}" /> <fmt:message key="관리" /></div>
            <div class="submenu">
                <a href="${menuPath}" class="${isListActive ? 'active' : ''}">
                    <fmt:message key="${entry.key}" /> <fmt:message key="목록" />
                </a>
                <a href="${insertPath}" class="${isInsertActive ? 'active' : ''}">
                    <fmt:message key="${entry.key}" /> <fmt:message key="등록" />
                </a>
            </div>
        </div>
    </c:forEach>
</nav>

<script src="/resources/js/header.js"></script>
